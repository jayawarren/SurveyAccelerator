/*
truncate table dd.factMemExBranchOpenEnded
drop proc spPopulate_factMemExBranchOpenEnded
SELECT * FROM dd.factMemExBranchOpenEnded
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchOpenEnded] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	db.AssociationName,
			db.BranchNameShort as Branch,
			db.batch_key,
			db.current_indicator,
			sq.Question,
			CASE WHEN qr.Category = 'Support' then 'Service'
				WHEN qr.Category = 'Impact' then 'Health & Wellness'
				WHEN qr.Category = 'Facilities' then 'Facility'
				ELSE qr.Category
			END as Category,
			qr.ResponseText as Subcategory,
			msr.GivenDateKey,
			qr.ResponseCode,	
			oer.OpenEndResponse,		
			msr.ResponseCount,		
			CASE WHEN Question like '%if you could change%' then 'What would members change'
				WHEN Question like '%do you like %most%' then 'What do members like the most'
				WHEN Question like '%you believe%real positive impact in your life%' then 'RPI Individual - Promoter'
				WHEN Question like '%less than sure%real positive impact in your life%' then 'RPI Individual - Detractor'
				WHEN Question like '%you believe%real positive impact in your community%' then 'RPI Community - Promoter'			
				WHEN Question like '%less than sure%real positive impact in your community%' then 'RPI Community - Detractor'			
				else 'Other'
			 END AS OpenEndedGroup
		 
	INTO	#alla
	
	FROM	dbo.factMemberSurveyResponse msr
			INNER JOIN dd.factMemExDashboardBase db
				ON msr.BranchKey = db.BranchKey
					AND db.GivenDateKey = msr.GivenDateKey
					AND msr.OpenEndResponseKey <> -1
			INNER JOIN dimSurveyQuestion sq
				ON msr.SurveyQuestionKey = sq.SurveyQuestionKey
			INNER JOIN dimQuestionResponse qr
				ON msr.QuestionResponseKey = qr.QuestionResponseKey
					AND qr.ResponseCode <> '-1'
			INNER JOIN dimOpenEndResponse oer
				ON msr.OpenEndResponseKey = oer.OpenEndResponseKey	
	
	WHERE	LTRIM(RTRIM(oer.OpenEndResponse)) <> ''	
	;
		
	SELECT	alla.AssociationName,
			alla.Branch,
			alla.batch_key,
			alla.current_indicator,								
			alla.GivenDateKey,
			alla.OpenEndedGroup,
			SUM(alla.ResponseCount) as CategoryResponseCount
			
	INTO	#allt
						
	FROM	#alla alla
	
	GROUP BY alla.AssociationName,
			alla.Branch,
			alla.batch_key,
			alla.current_indicator,							
			alla.GivenDateKey,
			alla.OpenEndedGroup 
	;
	SELECT	distinct
			alla.AssociationName,
			alla.Branch,
			alla.batch_key,
			alla.current_indicator,
			cast(SUBSTRING(cast(alla.GivenDateKey as varchar), 1, 4) as int) as SurveyYear,		
			alla.OpenEndedGroup,
			alla.Category,		
			alla.Subcategory,
			alla.OpenEndResponse,
			alla.ResponseCount,
			CASE WHEN allt.CategoryResponseCount <> 0 THEN 100.00 * alla.ResponseCount / allt.CategoryResponseCount
				ELSE 0
			END AS CategoryPercentage
			
	INTO	#MEBOE
	
	FROM	#alla alla 
			INNER JOIN #allt allt
				ON alla.AssociationName = allt.AssociationName 
					AND alla.Branch = allt.Branch
					AND alla.OpenEndedGroup = allt.OpenEndedGroup
					AND alla.GivenDateKey = allt.GivenDateKey 
	
	WHERE	alla.Category <> 'Questionable'
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchOpenEnded AS target
	USING	(
			SELECT	A.AssociationName,
					A.Branch,
					A.batch_key,
					A.current_indicator,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.Subcategory,
					A.OpenEndResponse,
					A.ResponseCount,
					A.CategoryPercentage
					
			FROM	#MEBOE A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.Branch = source.Branch
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.SubCategory = source.SubCategory
				AND target.OpenEndResponse = source.OpenEndResponse
				
			WHEN MATCHED AND (target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[OpenEndedGroup] <> source.[OpenEndedGroup]
								 OR target.[Category] <> source.[Category]
								 OR target.[ResponseCount] <> source.[ResponseCount]
								 OR target.[CategoryPercentage] <> source.[CategoryPercentage]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationName],
					[Branch],
					[batch_key],
					[current_indicator],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount],
					[CategoryPercentage]
					)
			VALUES ([AssociationName],
					[Branch],
					[batch_key],
					[current_indicator],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount],
					[CategoryPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchOpenEnded AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationName,
					A.Branch,
					A.batch_key,
					A.current_indicator,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.Subcategory,
					A.OpenEndResponse,
					A.ResponseCount,
					A.CategoryPercentage
					
			FROM	#MEBOE A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.Branch = source.Branch
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.SubCategory = source.SubCategory
				AND target.OpenEndResponse = source.OpenEndResponse
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationName],
					[Branch],
					[batch_key],
					[current_indicator],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount],
					[CategoryPercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationName],
					[Branch],
					[batch_key],
					[current_indicator],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount],
					[CategoryPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBOE;
	
COMMIT TRAN
	
END








