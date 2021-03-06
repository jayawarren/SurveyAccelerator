/*
truncate table dd.factMemExBranchReportEx
drop proc spPopulate_factMemExBranchReportEx
SELECT * FROM dd.factMemExBranchReportEx
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchReportEx] AS
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
			A.AssociationName,
			A.Branch,
			CASE WHEN A.[Category] = 'Perception' THEN 'Support'
				ELSE A.[Category]
			END	[Category],
			A.CategoryPosition,
			CASE WHEN A.[Question] = 'Support' and Category = 'Pyramid' THEN 'Service'
				WHEN A.[Question] = 'Well Being' THEN 'Health & Wellness'
				WHEN A.[Question] = 'Net Outcome - Community' THEN 'RPI Community'
				WHEN A.[Question] = 'Net Outcome - Individual' THEN 'RPI Individual'
				ELSE A.[Question]
			END [Question],
			A.QuestionCode,
			CASE WHEN A.[Question] = 'Support' and Category = 'Pyramid' THEN 'Service'
				WHEN A.[Question] = 'Well Being' THEN 'Health & Wellness'
				WHEN A.[Question] = 'Net Outcome - Community' THEN 'RPI Community'
				WHEN A.[Question] = 'Net Outcome - Individual' THEN 'RPI Individual'
				WHEN [Question] like '%provides financial assistance%' THEN 'Y provides financial assistance'
				WHEN [Question] like '%likely%volunteer%' THEN 'Likelihood to volunteer'
				WHEN [Question] = 'The Y provides people an opportunity to give back and support their neighbors' THEN 'Opportunity to give back'
				WHEN [Question] = 'I have found opportunities to help others' THEN 'Opportunity to help others'
				WHEN Category = 'Impact' and ShortQuestion = 'health seekers' THEN 'Group participation improves well-being'
				ELSE A.[ShortQuestion]
			END [ShortQuestion],
			A.QuestionPosition,
			A.CrtBranchPercentage,
			A.NationalPercentage,
			A.PrevBranchPercentage,
			A.CrtAssociationPercentage
			
	INTO	#MEBRE

	FROM	[dd].[vwMemExBranchReportEx] A
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

	MERGE	Seer_ODS.dd.factMemExBranchReportEx AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionCode,
					A.ShortQuestion,
					A.QuestionPosition,
					A.CrtBranchPercentage,
					A.NationalPercentage,
					A.PrevBranchPercentage,
					A.CrtAssociationPercentage
					
			FROM	#MEBRE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Category = source.Category
				AND target.Question = source.Question
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[CrtBranchPercentage] <> source.[CrtBranchPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PrevBranchPercentage] <> source.[PrevBranchPercentage]
								OR target.[CrtAssociationPercentage] <> source.[CrtAssociationPercentage]
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
					[AssociationName],
					[Branch],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionCode],
					[ShortQuestion],
					[QuestionPosition],
					[CrtBranchPercentage],
					[NationalPercentage],
					[PrevBranchPercentage],
					[CrtAssociationPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[Branch],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionCode],
					[ShortQuestion],
					[QuestionPosition],
					[CrtBranchPercentage],
					[NationalPercentage],
					[PrevBranchPercentage],
					[CrtAssociationPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchReportEx AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionCode,
					A.ShortQuestion,
					A.QuestionPosition,
					A.CrtBranchPercentage,
					A.NationalPercentage,
					A.PrevBranchPercentage,
					A.CrtAssociationPercentage
					
			FROM	#MEBRE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
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
					[AssociationName],
					[Branch],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionCode],
					[ShortQuestion],
					[QuestionPosition],
					[CrtBranchPercentage],
					[NationalPercentage],
					[PrevBranchPercentage],
					[CrtAssociationPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationName],
					[Branch],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionCode],
					[ShortQuestion],
					[QuestionPosition],
					[CrtBranchPercentage],
					[NationalPercentage],
					[PrevBranchPercentage],
					[CrtAssociationPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBRE;
	
COMMIT TRAN
	
END








