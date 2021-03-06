/*
truncate table dbo.factMemSatPyramid
drop proc spPopulate_factMemSatPyramid
SELECT * FROM dbo.factMemSatPyramid
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemSatPyramid] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN

	SELECT	A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.PyramidCategory,
			A.AvgZScore,
			A.Percentile,
			A.HistoricalChangeIndex,
			A.HistoricalChangePercentile
			
	INTO	#MSP
	
	FROM	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	[dbo].[vwfactMemSatPyramid] A
					INNER JOIN Seer_MDM.dbo.Batch_Map B
						ON A.batch_key = B.batch_key
							AND A.BranchKey = B.organization_key
						
			WHERE	B.module = 'Member'
					AND B.aggregate_type = 'Branch'
					AND A.current_indicator = 1

			UNION
			
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	[dbo].[vwfactMemSatPyramid] A
					INNER JOIN Seer_MDM.dbo.Batch_Map B
						ON A.batch_key = B.batch_key
							AND A.AssociationKey = B.organization_key
						
			WHERE	B.module = 'Member'
					AND B.aggregate_type = 'Association'
					AND A.current_indicator = 1
			) A		
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factMemSatPyramid AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	#MSP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.PyramidCategory = source.PyramidCategory
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[GivenDateKey] <> source.[GivenDateKey]
								OR target.[AvgZScore] <> source.[AvgZScore]
								OR target.[Percentile] <> source.[Percentile]
								OR target.[HistoricalChangeIndex] <> source.[HistoricalChangeIndex]
								OR target.[HistoricalChangePercentile] <> source.[HistoricalChangePercentile]
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
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factMemSatPyramid AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	#MSP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.PyramidCategory = source.PyramidCategory
				
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MSP;
	
COMMIT TRAN
	
END








