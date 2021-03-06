/*
truncate table dd.factProgramDetailSurvey
drop proc spPopulate_factProgramDetailSurvey
SELECT * FROM dd.factProgramDetailSurvey
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramDetailSurvey] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.ProgramGroupKey,
			A.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.Association,
			A.Program,
			A.Grouping,
			A.CategoryType,
			A.Category,
			A.CategoryPosition,
			CASE WHEN A.ReportType = 'wellbeing' THEN A.Category +': ' + A.Question
				ELSE A.Question
			END Question,
			A.QuestionPosition,
			A.Response,	 
			A.ResponsePosition,
			A.CrtPercentage,
			A.PrevPercentage,
			A.NationalPercentage,
			A.CrtAssociationPercentage  AssociationPercentage,
			A.ReportType
			
	INTO	#PDS

	FROM	(
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
					A.CrtPercentage,
					A.PrevPercentage,
					A.NationalPercentage,
					A.CrtAssociationPercentage,
					A.PrevAssociationPercentage,
					A.ReportType,
					A.ResponseCount
					
			FROM	[dd].[vwProgramDetailSurveyData] A
			
			UNION ALL
			
			SELECT	B.AssociationKey,
					B.ProgramGroupKey,
					B.batch_key,
					B.current_indicator,
					B.Association,
					B.Program,
					B.Grouping,
					B.CategoryType,
					B.Category,
					B.CategoryPosition,
					B.Question,
					B.QuestionPosition,
					B.Response,	 
					B.ResponsePosition,
					B.CrtPercentage,
					B.PrevPercentage,
					B.NationalPercentage,
					B.CrtAssociationPercentage,
					B.PrevAssociationPercentage,
					B.ReportType,
					B.ResponseCount
					
			FROM	[dd].[vwProgramDetailSurveyData_WellBeing] B
			
			) A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
			
	WHERE	A.ProgramGroupKey IS NOT NULL
			AND A.Category <> 'Dosage and Classification'
			AND B.module = 'Program'
			AND B.aggregate_type = 'Association'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramDetailSurvey AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
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
					A.CrtPercentage,
					A.PrevPercentage,
					A.NationalPercentage,
					A.AssociationPercentage,
					A.ReportType
					
			FROM	#PDS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
				AND target.Response = source.Response
				AND target.ReportType = source.ReportType
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[Association] <> source.[Association]
								OR target.[Program] <> source.[Program]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[ResponsePosition] <> source.[ResponsePosition]
								OR target.[CrtPercentage] <> source.[CrtPercentage]
								OR target.[PrevPercentage] <> source.[PrevPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
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
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[NationalPercentage],
					[AssociationPercentage],
					[ReportType]
					)
			VALUES ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[NationalPercentage],
					[AssociationPercentage],
					[ReportType]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramDetailSurvey AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
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
					A.CrtPercentage,
					A.PrevPercentage,
					A.NationalPercentage,
					A.AssociationPercentage,
					A.ReportType
					
			FROM	#PDS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.Question = source.Question
				AND target.Response = source.Response
				AND target.ReportType = source.ReportType
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[NationalPercentage],
					[AssociationPercentage],
					[ReportType]
					)
			VALUES ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[NationalPercentage],
					[AssociationPercentage],
					[ReportType]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #PDS;
	
COMMIT TRAN
	
END








