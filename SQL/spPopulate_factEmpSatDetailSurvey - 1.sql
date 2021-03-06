/*
truncate table dd.factEmpSatDetailSurvey
drop proc spPopulate_factEmpSatDetailSurvey
SELECT * FROM dd.factEmpSatDetailSurvey
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatDetailSurvey] AS
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
			A.AssociationPercentage,
			A.NationalPercentage,
			A.ReportType
			
	INTO	#ESDS

	FROM	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.Response,	 
					A.ResponsePosition,
					A.CrtPercentage,
					A.PrevPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.ReportType
					
			FROM	[dd].[vwEmpSatBranchDetailSurveyQuestions] A
			
			UNION ALL
			
			SELECT	B.AssociationKey,
					B.BranchKey,
					B.batch_key,
					B.current_indicator,
					B.AssociationName,
					B.Branch,
					B.CategoryType,
					B.Category,
					B.CategoryPosition,
					B.Question,
					B.QuestionPosition,
					B.Response,	 
					B.ResponsePosition,
					B.CrtPercentage,
					B.PrevPercentage,
					B.AssociationPercentage,
					B.NationalPercentage,
					B.ReportType
					
			FROM	[dd].[vwEmpSatBranchDetailSurveyQuestions_WellBeing] B
			
			) A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.BranchKey = B.organization_key
					AND A.batch_key = B.batch_key
					
	WHERE	B.module = 'Staff'
			AND B.aggregate_type = 'Branch'
			AND A.current_indicator = 1
			AND A.BranchKey IS NOT NULL
			AND A.question NOT LIKE 'custom%'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatDetailSurvey AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.Response,	 
					A.ResponsePosition,
					A.CrtPercentage,
					A.PrevPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.ReportType
					
			FROM	#ESDS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.CategoryPosition = source.CategoryPosition
				AND target.Question = source.Question
				AND target.QuestionPosition = source.QuestionPosition		
				AND target.Response = source.Response
				AND target.ResponsePosition = source.ResponsePosition			
				AND target.ReportType = source.ReportType
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[CrtPercentage] <> source.[CrtPercentage]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PrevPercentage] <> source.[PrevPercentage]
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
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[ReportType]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[ReportType]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factEmpSatDetailSurvey AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationName Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.Response,	 
					A.ResponsePosition,
					A.CrtPercentage,
					A.PrevPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.ReportType
					
			FROM	#ESDS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND target.Category = source.Category
				AND target.CategoryPosition = source.CategoryPosition
				AND target.Question = source.Question
				AND target.QuestionPosition = source.QuestionPosition		
				AND target.Response = source.Response
				AND target.ResponsePosition = source.ResponsePosition			
				AND target.ReportType = source.ReportType
						
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
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[ReportType]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[Response],	 
					[ResponsePosition],	 
					[CrtPercentage],
					[PrevPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[ReportType]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #ESDS;
	
COMMIT TRAN
	
END








