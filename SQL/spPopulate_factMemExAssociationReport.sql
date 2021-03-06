/*
truncate table dd.factMemExAssociationReport
drop proc spPopulate_factMemExAssociationReport
SELECT * FROM dd.factMemExAssociationReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExAssociationReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.batch_key,
			A.current_indicator,
			A.AssociationNumber,
			A.AssociationName,
			A.Association,
			CASE WHEN A.[Category] = 'Support' and CategoryType = 'Pyramid' THEN 'Service'
				WHEN A.[Category] = 'Well Being' THEN 'Health & Wellness'
				WHEN A.[Category] = 'Net Outcome - Individual' THEN 'RPI Individual'
				WHEN A.[Category] = 'Net Outcome - Community'	THEN 'RPI Community'
				WHEN A.[Category] = 'Perception' THEN 'Support'
				ELSE A.[Category]
			END	[Category],
			A.CategoryType,
			A.CategoryPosition,
			A.SurveyYear,
			CASE WHEN A.[Category] in ('Overall Satisfaction', 'Intent to Renew for Loyalists', 'Net Promoter', 'RPI Community', 'RPI Individual') THEN A.[Category]
				WHEN A.[Question] = 'The Y is an important community resource for nurturing the potential of every child' THEN 'The Y is a resource for nurturing the potential of children'
				WHEN A.[Question] = 'The Y is an important resource for improving the health and well-being of the community' THEN 'The Y is a community resource for improving health & well-being'
				WHEN A.[Question] = 'When you come to the Y, do you mainly engage in group activities or in individual exercise activities?' THEN 'Do you engage in group exercise activities?'
				ELSE A.[Question]
			END [Question],
			A.QuestionPosition,
			A.AssociationCount,
			A.CrtAssociationPercentage,
			CASE WHEN A.[CrtAssociationPercentageYrDelta] is null THEN 99999
				ELSE A.[CrtAssociationPercentageYrDelta]
			END [CrtAssociationPercentageYrDelta],
			A.NationalPercentage,
			CASE WHEN A.[CrtAssociationPercentageNtnlDelta] is null THEN 99999
				ELSE A.[CrtAssociationPercentageNtnlDelta]
			END [CrtAssociationPercentageNtnlDelta],
			A.PrevAssociationPercentage,
			A.PeerGroupPercentage,
			A.PreviousSurveyYear,
			A.CurrentNumericYear,
			A.PreviousNumericYear,
			A.QuestionCode,
			CASE WHEN A.[ShortQuestion] = 'Net Outcome - Community' THEN 'RPI Community'
				WHEN A.[ShortQuestion] = 'Net Outcome - Individual' THEN 'RPI Individual'
				WHEN A.[Question] like '%provides financial assistance%' THEN 'Y provides financial assistance'
				WHEN A.[Question] like '%likely%volunteer%' THEN 'Likelihood to volunteer'
				WHEN A.[Question] = 'The Y provides people an opportunity to give back and support their neighbors' THEN 'Opportunity to give back'
				WHEN A.[Question] = 'I have found opportunities to help others' THEN 'Opportunity to help others'
				WHEN A.[Category] = 'Impact' and A.[ShortQuestion] = 'health seekers' THEN 'Group participation improves well-being'
				ELSE A.[ShortQuestion]
			END [ShortQuestion]
			
	INTO	#MEAR

	FROM	[dd].[vwMemExAssociationReport] A
			
	WHERE	A.AssociationKey IS NOT NULL
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExAssociationReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.Category,
					A.CategoryType,
					A.CategoryPosition,
					A.SurveyYear,
					A.Question,
					A.QuestionPosition,
					A.AssociationCount,
					A.CrtAssociationPercentage,
					A.CrtAssociationPercentageYrDelta,
					A.NationalPercentage,
					A.CrtAssociationPercentageNtnlDelta,
					A.PrevAssociationPercentage,
					A.PeerGroupPercentage,
					A.PreviousSurveyYear,
					A.CurrentNumericYear,
					A.PreviousNumericYear,
					A.QuestionCode,
					A.ShortQuestion
					
			FROM	#MEAR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
				
			WHEN MATCHED AND (target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[AssociationCount] <> source.[AssociationCount]
								OR target.[CrtAssociationPercentage] <> source.[CrtAssociationPercentage]
								OR target.[CrtAssociationPercentageYrDelta] <> source.[CrtAssociationPercentageYrDelta]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[CrtAssociationPercentageNtnlDelta] <> source.[CrtAssociationPercentageNtnlDelta]
								OR target.[PrevAssociationPercentage] <> source.[PrevAssociationPercentage]
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
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[AssociationCount],
					[CrtAssociationPercentage],
					[CrtAssociationPercentageYrDelta],
					[NationalPercentage],
					[CrtAssociationPercentageNtnlDelta],
					[PrevAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[AssociationCount],
					[CrtAssociationPercentage],
					[CrtAssociationPercentageYrDelta],
					[NationalPercentage],
					[CrtAssociationPercentageNtnlDelta],
					[PrevAssociationPercentage],
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
	MERGE	Seer_ODS.dd.factMemExAssociationReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.Category,
					A.CategoryType,
					A.CategoryPosition,
					A.SurveyYear,
					A.Question,
					A.QuestionPosition,
					A.AssociationCount,
					A.CrtAssociationPercentage,
					A.CrtAssociationPercentageYrDelta,
					A.NationalPercentage,
					A.CrtAssociationPercentageNtnlDelta,
					A.PrevAssociationPercentage,
					A.PeerGroupPercentage,
					A.PreviousSurveyYear,
					A.CurrentNumericYear,
					A.PreviousNumericYear,
					A.QuestionCode,
					A.ShortQuestion
					
			FROM	#MEAR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[AssociationCount],
					[CrtAssociationPercentage],
					[CrtAssociationPercentageYrDelta],
					[NationalPercentage],
					[CrtAssociationPercentageNtnlDelta],
					[PrevAssociationPercentage],
					[PeerGroupPercentage],
					[PreviousSurveyYear],
					[CurrentNumericYear],
					[PreviousNumericYear],
					[QuestionCode],
					[ShortQuestion]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Category],
					[CategoryType],
					[CategoryPosition],
					[SurveyYear],
					[Question],
					[QuestionPosition],
					[AssociationCount],
					[CrtAssociationPercentage],
					[CrtAssociationPercentageYrDelta],
					[NationalPercentage],
					[CrtAssociationPercentageNtnlDelta],
					[PrevAssociationPercentage],
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

	DROP TABLE #MEAR;
	
COMMIT TRAN
	
END








