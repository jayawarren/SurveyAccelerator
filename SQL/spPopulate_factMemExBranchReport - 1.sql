/*
truncate table dd.factMemExBranchReport
drop proc spPopulate_factMemExBranchReport
SELECT * FROM dd.factMemExBranchReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.AssociationNumber,
			A.AssociationName,
			A.Association,
			A.OfficialBranchNumber,
			A.OfficialBranchName,
			A.Branch,
			CASE WHEN A.[Category] = 'Net Outcome - Individual' THEN 'RPI Individual'
				WHEN A.[Category] = 'Net Outcome - Community' THEN 'RPI Community'
				WHEN A.[Category] = 'Support' and A.[CategoryType] = 'Pyramid' THEN 'Service'
				WHEN A.[Category] = 'Well Being' THEN 'Health & Wellness'
				WHEN A.[Category] = 'Perception' THEN 'Support'
				ELSE A.[Category]
			END	[Category],
			A.CategoryType,
			A.CategoryPosition,
			A.SurveyYear,
			CASE WHEN A.[Category] IN ('Overall Satisfaction', 'Intent to Renew for Loyalists', 'Net Promoter', 'RPI Community', 'RPI Individual') THEN A.[Category]
				WHEN A.[Question] = 'The Y is an important community resource for nurturing the potential of every child' THEN 'The Y is a resource for nurturing the potential of children'
				WHEN A.[Question] = 'The Y is an important resource for improving the health and well-being of the community' THEN 'The Y is a community resource for improving health & well-being'
				WHEN A.[Question] = 'When you come to the Y, do you mainly engage in group activities or in individual exercise activities?' THEN 'Do you engage in group exercise activities?'
				ELSE A.[Question]
			END [Question],
			A.QuestionPosition,
			A.BranchCount,
			A.CrtBranchPercentage,
			CASE WHEN A.[CrtBranchPercentageYrDelta] is null THEN 99999
				ELSE A.[CrtBranchPercentageYrDelta]
			END [CrtBranchPercentageYrDelta],
			A.NationalPercentage,
			CASE WHEN A.[CrtBranchPercentageNtnlDelta] is null THEN 99999
				ELSE A.[CrtBranchPercentageNtnlDelta]
			END [CrtBranchPercentageNtnlDelta],
			A.PrevBranchPercentage,
			A.CrtAssociationPercentage,
			A.PeerGroupPercentage,
			A.PreviousSurveyYear,
			A.CurrentNumericYear,
			A.PreviousNumericYear,
			A.QuestionCode,
			CASE WHEN A.[Category] = 'net promoter' or A.[Category] like 'rpi%' THEN A.[Category]
				WHEN A.[Question] like '%provides financial assistance%' THEN 'Y provides financial assistance'
				WHEN A.[Question] like '%likely%volunteer%' THEN 'Likelihood to volunteer'
				WHEN A.[Category] = 'Impact' and A.[ShortQuestion] = 'health seekers' THEN 'Group participation improves well-being'
				ELSE A.[ShortQuestion]
			END [ShortQuestion]
			
	INTO	#MEBR

	FROM	[dd].[vwMemExBranchReport] A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.BranchKey = B.organization_key
				
	WHERE	B.module = 'Member'
			AND B.aggregate_type = 'Branch'
			AND A.current_indicator = 1
			AND A.BranchKey IS NOT NULL
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Category,
					A.CategoryType,
					A.CategoryPosition,
					A.SurveyYear,
					A.Question,
					A.QuestionPosition,
					A.BranchCount,
					A.CrtBranchPercentage,
					A.CrtBranchPercentageYrDelta,
					A.NationalPercentage,
					A.CrtBranchPercentageNtnlDelta,
					A.PrevBranchPercentage,
					A.CrtAssociationPercentage,
					A.PeerGroupPercentage,
					A.PreviousSurveyYear,
					A.CurrentNumericYear,
					A.PreviousNumericYear,
					A.QuestionCode,
					A.ShortQuestion
					
			FROM	#MEBR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[BranchCount] <> source.[BranchCount]
								OR target.[CrtBranchPercentage] <> source.[CrtBranchPercentage]
								OR target.[CrtBranchPercentageYrDelta] <> source.[CrtBranchPercentageYrDelta]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[CrtBranchPercentageNtnlDelta] <> source.[CrtBranchPercentageNtnlDelta]
								OR target.[PrevBranchPercentage] <> source.[PrevBranchPercentage]
								OR target.[CrtAssociationPercentage] <> source.[CrtAssociationPercentage]
								OR target.[PeerGroupPercentage] <> source.[PeerGroupPercentage]
								OR target.[PreviousSurveyYear] <> source.[PreviousSurveyYear]
								OR target.[CurrentNumericYear] <> source.[CurrentNumericYear]
								OR target.[PreviousNumericYear] <> source.[PreviousNumericYear]
								OR target.[QuestionCode] <> source.[QuestionCode]
								OR target.[ShortQuestion] <> source.[ShortQuestion]
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
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[BranchCount],
					[CrtBranchPercentage],
					[CrtBranchPercentageYrDelta],
					[NationalPercentage],
					[CrtBranchPercentageNtnlDelta],
					[PrevBranchPercentage],
					[CrtAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[BranchCount],
					[CrtBranchPercentage],
					[CrtBranchPercentageYrDelta],
					[NationalPercentage],
					[CrtBranchPercentageNtnlDelta],
					[PrevBranchPercentage],
					[CrtAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Category,
					A.CategoryType,
					A.CategoryPosition,
					A.SurveyYear,
					A.Question,
					A.QuestionPosition,
					A.BranchCount,
					A.CrtBranchPercentage,
					A.CrtBranchPercentageYrDelta,
					A.NationalPercentage,
					A.CrtBranchPercentageNtnlDelta,
					A.PrevBranchPercentage,
					A.CrtAssociationPercentage,
					A.PeerGroupPercentage,
					A.PreviousSurveyYear,
					A.CurrentNumericYear,
					A.PreviousNumericYear,
					A.QuestionCode,
					A.ShortQuestion
					
			FROM	#MEBR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
						
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
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[BranchCount],
					[CrtBranchPercentage],
					[CrtBranchPercentageYrDelta],
					[NationalPercentage],
					[CrtBranchPercentageNtnlDelta],
					[PrevBranchPercentage],
					[CrtAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[BranchCount],
					[CrtBranchPercentage],
					[CrtBranchPercentageYrDelta],
					[NationalPercentage],
					[CrtBranchPercentageNtnlDelta],
					[PrevBranchPercentage],
					[CrtAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBR;
	
COMMIT TRAN
	
END








