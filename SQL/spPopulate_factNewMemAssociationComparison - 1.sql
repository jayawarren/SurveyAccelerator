/*
truncate table dd.factNewMemAssociationComparison
drop proc spPopulate_factNewMemAssociationComparison
SELECT * FROM dd.factNewMemAssociationComparison where AssociationKey = 153 And BranchKey = 153 and batch_key = 111 and shortquestion = 'Feel welcome'
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemAssociationComparison] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	distinct
			A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			A.GivenDateKey,
			A.PreviousGivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.AssociationNumber, 
			A.AssociationName,
			A.Association,
			A.OfficialBranchNumber,
			A.OfficialBranchName,
			A.Branch,
			A.SurveyYear,
			A.Question,
			A.ShortQuestion,
			A.CategoryType,
			CASE WHEN A.Category = 'Perceptions' THEN 'Support'
				ELSE A.Category
			END Category,
			A.CategoryPosition,
			A.QuestionPosition,
			A.BranchPercentage AS BranchValue,
			A.PreviousPercentage AS PreviousValue,
			A.BranchPercentage - A.PreviousPercentage AS BranchValueDelta

	INTO	#NMAC
	
	FROM	[dd].factNewMemBranchExperienceReport A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
				
	WHERE	B.module = 'New Member'
			AND B.aggregate_type = 'Association'
			AND A.BranchPercentage IS NOT NULL
			AND A.current_indicator = 1
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemAssociationComparison AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Question,
					A.ShortQuestion,
					A.QuestionPosition,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.SurveyYear,
					A.BranchValue,
					A.PreviousValue,
					A.BranchValueDelta
					
			FROM	#NMAC A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
				AND target.[GivenDateKey] = source.[GivenDateKey]
				AND COALESCE(target.[PreviousGivenDateKey], '19000101') = COALESCE(source.[PreviousGivenDateKey], '19000101')
							
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[Association] <> source.[Association]
								OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								OR target.[Branch] <> source.[Branch]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[ShortQuestion] <> source.[ShortQuestion]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR COALESCE(target.[BranchValue], 0) <> COALESCE(source.[BranchValue], 0)
								OR COALESCE(target.[PreviousValue], 0) <> COALESCE(source.[PreviousValue], 0)
								OR COALESCE(target.[BranchValueDelta], 0) <> COALESCE(source.[BranchValueDelta], 0)
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
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber], 
					[AssociationName],
					[Association],
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Question],
					[ShortQuestion],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[SurveyYear],
					[BranchValue],
					[PreviousValue],
					[BranchValueDelta]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber], 
					[AssociationName],
					[Association],
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Question],
					[ShortQuestion],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[SurveyYear],
					[BranchValue],
					[PreviousValue],
					[BranchValueDelta]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemAssociationComparison AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Question,
					A.ShortQuestion,
					A.QuestionPosition,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.SurveyYear,
					A.BranchValue,
					A.PreviousValue,
					A.BranchValueDelta
					
			FROM	#NMAC A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
				AND target.[GivenDateKey] = source.[GivenDateKey]
				AND COALESCE(target.[PreviousGivenDateKey], '19000101') = COALESCE(source.[PreviousGivenDateKey], '19000101')
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber], 
					[AssociationName],
					[Association],
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Question],
					[ShortQuestion],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[SurveyYear],
					[BranchValue],
					[PreviousValue],
					[BranchValueDelta]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber], 
					[AssociationName],
					[Association],
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Question],
					[ShortQuestion],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[SurveyYear],
					[BranchValue],
					[PreviousValue],
					[BranchValueDelta]
					)
	;
COMMIT TRAN

BEGIN TRAN

	drOP TABLE #NMAC;
	
COMMIT TRAN
	
END








