/*
truncate table dd.factMemExBranchKPIs
drop proc spPopulate_factMemExBranchKPIs
SELECT * FROM dd.factMemExBranchKPIs where MemExBranchKPIsKey IN (1, 6004)
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchKPIs] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			1 current_indicator,
			A.AssociationName,
			A.Branch,
			A.SurveyYear,
			A.CategoryType,	
			A.Category,
			A.CategoryPosition,
			A.Question,
			A.SortOrder,
			A.BranchPercentage,
			A.AssociationPercentage,
			A.NationalPercentage,
			A.PreviousBranchPercentage,
			A.PeerGroupPercentage
			
	INTO	#MEBK

	FROM	dd.vwMemExBranchKPIs A
			
	WHERE	A.BranchKey IS NOT NULL
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchKPIs AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.SurveyYear,
					A.CategoryType,	
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.SortOrder,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousBranchPercentage,
					A.PeerGroupPercentage
					
			FROM	#MEBK A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND COALESCE(target.SurveyYear, 1900) = COALESCE(source.SurveyYear, 1900)
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
				
			WHEN MATCHED AND (target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[SortOrder] <> source.[SortOrder]
								OR target.[BranchPercentage] <> source.[BranchPercentage]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PeergroupPercentage] <> source.[PeerGroupPercentage]
								OR target.[PreviousBranchPercentage] <> source.[PreviousBranchPercentage]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[SurveyYear],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[SortOrder],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[SurveyYear],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[SortOrder],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchKPIs AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.SurveyYear,
					A.CategoryType,	
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.SortOrder,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousBranchPercentage,
					A.PeerGroupPercentage
					
			FROM	#MEBK A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.current_indicator = source.current_indicator
				AND COALESCE(target.SurveyYear, 1900) = COALESCE(source.SurveyYear, 1900)
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[SurveyYear],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[SortOrder],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[SurveyYear],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[SortOrder],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBK;
	
COMMIT TRAN
	
END








