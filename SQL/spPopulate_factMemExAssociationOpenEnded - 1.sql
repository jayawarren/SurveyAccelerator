/*
truncate table dd.factMemExAssociationOpenEnded
drop proc spPopulate_factMemExAssociationOpenEnded
SELECT * FROM dd.factMemExAssociationOpenEnded
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExAssociationOpenEnded] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	alla.AssociationName,
			alla.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			alla.current_indicator,
			alla.SurveyYear,
			alla.OpenEndedGroup,
			alla.Category,
			alla.CategoryCount,
			ROW_NUMBER() over (partition by alla.AssociationName, alla.SurveyYear, alla.OpenEndedGroup order by alla.CategoryCount desc) AS RowNumber,
			CASE WHEN allt.CategoryCount<> 0 THEN 100.00 * alla.CategoryCount / allt.CategoryCount
				ELSE 0
			END AS CategoryPercentage
			
	INTO	#MEAOE
			
	FROM	(
			SELECT	mostrec.AssociationKey,
					db.AssociationName,
					db.batch_key,
					db.current_indicator,
					db.SurveyYear,
					db.OpenEndedGroup,
					CASE WHEN db.Category = 'Support' THEN 'Service'
						WHEN db.Category = 'Impact' THEN 'Health & Wellness'
						WHEN db.Category = 'Facilities' THEN 'Facility'
						ELSE db.Category
					END AS Category,
					SUM(db.ResponseCount) AS CategoryCount
					
			FROM	[dd].[factMemExBranchOpenEnded]	db		
					INNER JOIN
					(
					SELECT	msp.AssociationKey,
							msp.AssociationName,
							MAX(SurveyYear) AS SurveyYear
					
					FROM	dd.factMemExDashboardBase msp
					
					WHERE	msp.current_indicator = 1
							
					GROUP BY msp.AssociationKey,
							msp.AssociationName
					) mostrec 
						ON mostrec.AssociationName = db.AssociationName
							AND db.SurveyYear = mostrec.SurveyYear	
						
			GROUP BY mostrec.AssociationKey,
					db.AssociationName,
					db.batch_key,
					db.current_indicator,
					db.SurveyYear,
					db.OpenEndedGroup,
					db.Category
			) alla	
			INNER JOIN
			(
			SELECT	mostrec.AssociationKey,
					db.AssociationName,
					db.SurveyYear,
					OpenEndedGroup,
					SUM(ResponseCount) AS CategoryCount	
			
			FROM 	[dd].[factMemExBranchOpenEnded]	db		
					INNER JOIN 
					(
					SELECT	msp.AssociationKey,
							msp.AssociationName,
							MAX(SurveyYear) AS SurveyYear
					
					FROM	dd.factMemExDashboardBase msp
					
					WHERE	msp.current_indicator = 1
							
					GROUP BY msp.AssociationKey,
							msp.AssociationName
					)mostrec 
						ON mostrec.AssociationName = db.AssociationName
							AND db.SurveyYear = mostrec.SurveyYear
			
			GROUP BY mostrec.AssociationKey,
					db.AssociationName,
					db.SurveyYear,
					OpenEndedGroup
			) allt
				ON alla.AssociationKey = allt.AssociationKey
				AND alla.OpenEndedGroup = allt.OpenEndedGroup
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON alla.AssociationKey = B.organization_key
					AND alla.batch_key = B.batch_key
					
	WHERE	B.module = 'Member'
			AND B.aggregate_type = 'Association'
			AND alla.current_indicator = 1
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExAssociationOpenEnded AS target
	USING	(
			SELECT	A.AssociationName,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.RowNumber,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.CategoryCount,
					A.CategoryPercentage
					
			FROM	#MEAOE A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.OpenEndedGroup = source.OpenEndedGroup
				AND target.Category = source.Category
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[RowNumber] <> source.[RowNumber]
								OR target.[CategoryCount] <> source.[CategoryCount]
								OR target.[CategoryPercentage] <> source.[CategoryPercentage]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationName],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[RowNumber],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[CategoryCount],
					[CategoryPercentage]
					)
			VALUES ([AssociationName],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[RowNumber],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[CategoryCount],
					[CategoryPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExAssociationOpenEnded AS target
	USING	(
			SELECT	A.AssociationName,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.RowNumber,
					A.SurveyYear,		
					A.OpenEndedGroup,
					A.Category,		
					A.CategoryCount,
					A.CategoryPercentage
					
			FROM	#MEAOE A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.OpenEndedGroup = source.OpenEndedGroup
				AND target.Category = source.Category
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationName],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[RowNumber],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[CategoryCount],
					[CategoryPercentage]
					)
			VALUES ([AssociationName],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[RowNumber],
					[SurveyYear],		
					[OpenEndedGroup],
					[Category],		
					[CategoryCount],
					[CategoryPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEAOE;
	
COMMIT TRAN
	
END








