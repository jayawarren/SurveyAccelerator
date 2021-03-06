/*
truncate table dd.factNewMemBranchOpenEnded
drop proc spPopulate_factNewMemBranchOpenEnded
SELECT * FROM dd.factNewMemBranchOpenEnded
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemBranchOpenEnded] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	db.AssociationKey,
			db.BranchKey,
			db.batch_key,
			db.current_indicator,
			db.AssociationName,
			db.OfficialBranchName,
			db.BranchNameShort as Branch,
			sq.Question,
			qr.Category,
			qr.ResponseText as Subcategory,
			msr.GivenDateKey,
			qr.ResponseCode,	
			oer.OpenEndResponse,		
			msr.ResponseCount,		
			sq.Question OpenEndedGroup
		 
	INTO	#alla
	--select *
	FROM	dbo.factMemberSurveyResponse msr
			INNER JOIN dd.factNewMemDashboardBase db
				ON msr.BranchKey = db.BranchKey
					AND msr.batch_key = db.batch_key
					AND msr.GivenDateKey = db.GivenDateKey
					AND msr.OpenEndResponseKey <> -1
			INNER JOIN dimSurveyQuestion sq
				ON msr.SurveyQuestionKey = sq.SurveyQuestionKey
			INNER JOIN dimQuestionResponse qr
				ON msr.QuestionResponseKey = qr.QuestionResponseKey
					AND qr.ResponseCode <> '-1'
			INNER JOIN dimOpenEndResponse oer
				ON msr.OpenEndResponseKey = oer.OpenEndResponseKey	
	
	WHERE	LTRIM(RTRIM(oer.OpenEndResponse)) <> ''
			AND msr.current_indicator = 1
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
			alla.AssociationKey,
			alla.BranchKey,
			alla.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			alla.current_indicator,
			alla.AssociationName,
			alla.OfficialBranchName,
			alla.Branch,
			cast(SUBSTRING(cast(alla.GivenDateKey as varchar), 1, 4) as int) as SurveyYear,		
			CASE WHEN alla.OpenEndedGroup = 'Please write any additional comments below' THEN 'Please write any additional comments'
				ELSE alla.OpenEndedGroup
			END OpenEndedGroup,
			CASE WHEN alla.Category = 'NULL' THEN 'Comments'
				ELSE alla.Category
			END Category,		
			CASE WHEN alla.SubCategory = 'No Answer' THEN 'Answer'
				ELSE alla.SubCategory
			END SubCategory,
			alla.OpenEndResponse,
			alla.ResponseCount
			
	INTO	#NMBOE
	
	FROM	#alla alla 
			INNER JOIN #allt allt
				ON alla.AssociationName = allt.AssociationName 
					AND alla.Branch = allt.Branch
					AND alla.OpenEndedGroup = allt.OpenEndedGroup
					AND alla.GivenDateKey = allt.GivenDateKey
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON alla.batch_key = B.batch_key
					AND alla.BranchKey = B.organization_key
					
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), alla.GivenDateKey))) < GETDATE()
			AND alla.Category <> 'Questionable'
			AND B.module = 'New Member'
			AND B.aggregate_type = 'Branch'
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemBranchOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName,
					A.OfficialBranchName,
					A.Branch,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.Subcategory,
					A.OpenEndResponse,
					A.ResponseCount
					
			FROM	#NMBOE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.SubCategory = source.SubCategory
				AND target.OpenEndResponse = source.OpenEndResponse
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[OfficialBranchName] < source.[OfficialBranchName]
								OR target.[Branch] <> source.[Branch]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[OpenEndedGroup] <> source.[OpenEndedGroup]
								OR target.[Category] <> source.[Category]
								OR target.[ResponseCount] <> source.[ResponseCount]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[OfficialBranchName],
					[Branch],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[OfficialBranchName],
					[Branch],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemBranchOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName,
					A.OfficialBranchName,
					A.Branch,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.Subcategory,
					A.OpenEndResponse,
					A.ResponseCount
					
			FROM	#NMBOE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.SubCategory = source.SubCategory
				AND target.OpenEndResponse = source.OpenEndResponse
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[OfficialBranchName],
					[Branch],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[OfficialBranchName],
					[Branch],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[Subcategory],
					[OpenEndResponse],
					[ResponseCount]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMBOE;
	
COMMIT TRAN
	
END








