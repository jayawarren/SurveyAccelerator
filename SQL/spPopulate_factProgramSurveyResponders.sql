/*
truncate table dd.factProgramSurveyResponders
drop proc spPopulate_factProgramSurveyResponders
SELECT * FROM dd.factProgramSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.ProgramGroupKey,
			A.batch_key,
			A.current_indicator,
			A.Association,
			A.Program,
			A.Grouping,
			A.CategoryType,
			A.Category,
			A.CategoryPosition,
			A.Question,
			A.QuestionPosition,
			A.Response,	 
			A.ResponsePosition,
			A.CrtPercentage CurrentResponsePercentage,
			A.PrevPercentage PreviousResponsePercentage,
			A.CrtAssociationPercentage CrtAssocResponsePercentage,
			A.PrevAssociationPercentage PrvAssocResponsePercentage,
			A.ResponseCount
			
	INTO	#PSR

	FROM	[dd].[vwProgramDetailSurveyData] A
			
	WHERE	A.ProgramGroupKey IS NOT NULL
	
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Program,
					A.Grouping,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.Response,	 
					A.ResponsePosition,
					A.CurrentResponsePercentage,
					A.PreviousResponsePercentage,
					A.CrtAssocResponsePercentage,
					A.PrvAssocResponsePercentage,
					A.ResponseCount
					
			FROM	#PSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.Question = source.Question
				AND target.Response = source.Response
				
			WHEN MATCHED AND (target.[Association] <> source.[Association]
								OR target.[Program] <> source.[Program]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[ResponsePosition] <> source.[ResponsePosition]
								OR target.[CurrentResponsePercentage] <> source.[CurrentResponsePercentage]
								OR target.[PreviousResponsePercentage] <> source.[PreviousResponsePercentage]
								OR target.[CrtAssocResponsePercentage] <> source.[CrtAssocResponsePercentage]
								OR target.[PrvAssocResponsePercentage] <> source.[PrvAssocResponsePercentage]
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
					[ProgramGroupKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CrtAssocResponsePercentage],
					[PrvAssocResponsePercentage],
					[ResponseCount]
					)
			VALUES ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CrtAssocResponsePercentage],
					[PrvAssocResponsePercentage],
					[ResponseCount]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramSurveyResponders AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Program,
					A.Grouping,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.Response,	 
					A.ResponsePosition,
					A.CurrentResponsePercentage,
					A.PreviousResponsePercentage,
					A.CrtAssocResponsePercentage,
					A.PrvAssocResponsePercentage,
					A.ResponseCount
					
			FROM	#PSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.Question = source.Question
				AND target.Response = source.Response
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CrtAssocResponsePercentage],
					[PrvAssocResponsePercentage],
					[ResponseCount]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CrtAssocResponsePercentage],
					[PrvAssocResponsePercentage],
					[ResponseCount]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #PSR;
	
COMMIT TRAN
	
END








