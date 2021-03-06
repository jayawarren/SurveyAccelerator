/*
truncate table dd.factEmpSatBranchReport
drop proc spPopulate_factEmpSatBranchReport
SELECT * FROM dd.factEmpSatBranchReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatBranchReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			A.GivenDateKey,
			A.PrevGivenDateKey,
			A.current_indicator,
			A.Association,
			A.Branch,
			CASE WHEN A.CategoryType = 'KPI' THEN 'Key Indicators'
				ELSE A.CategoryType
			END AS CategoryType,
			CASE WHEN A.Category = 'Effectiveness' THEN 'Staff Effectiveness'
				WHEN A.Category = 'Satisfaction' THEN 'Staff Satisfaction'
				WHEN A.Category = 'Engagement' THEN 'Staff Engagement'
				ELSE A.Category
			END AS Category,
			A.CategoryPosition,
			A.Question,
			A.QuestionPosition,
			CASE WHEN A.ShortQuestion = 'Opportunities for training for professional growth'
					AND A.Association = 'YMCA of Northwest North Carolina'	
					AND A.GivenDateKey = '20120507' THEN 51
				ELSE A.AssociationValue
			END AS AssociationValue,	 
			A.PrvAssociationValue,	 
			CASE WHEN A.ShortQuestion = 'Opportunities for training for professional growth'
					AND A.Association = 'YMCA of Northwest North Carolina'	
					AND A.GivenDateKey = '20120507' THEN 31
				ELSE A.NationalValue
			END AS NationalValue,
			A.CrtBranchValue,
			A.PrvBranchValue,
			CASE WHEN A.ShortQuestion = 'Have informaion and resources needed to do my job' THEN 'Have information and resources needed to do my job'
				ELSE A.ShortQuestion
			END AS ShortQuestion,
			A.QuestionCode
			
	INTO	#ESBR

	FROM	[dd].[vwEmpSatBranchReport] A
			
	WHERE	A.BranchKey IS NOT NULL
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatBranchReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.AssociationValue,	 
					A.PrvAssociationValue,	 
					A.NationalValue,
					A.CrtBranchValue,
					A.PrvBranchValue,
					A.ShortQuestion,
					A.QuestionCode
					
			FROM	#ESBR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND COALESCE(target.Category, '') = COALESCE(source.Category, '')
				AND target.CategoryPosition = source.CategoryPosition
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
				AND target.QuestionPosition = source.QuestionPosition		
				AND COALESCE(target.ShortQuestion, '') = COALESCE(source.ShortQuestion, '')
				AND target.QuestionCode = source.QuestionCode
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								OR target.[PrevGivenDateKey] <> source.[PrevGivenDateKey]
								OR target.[AssociationValue] <> source.[AssociationValue]
								OR target.[PrvAssociationValue] <> source.[PrvAssociationValue]
								OR target.[NationalValue] <> source.[NationalValue]
								OR target.[CrtBranchValue] <> source.[CrtBranchValue]
								OR target.[PrvBranchValue] <> source.[PrvBranchValue]
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
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtBranchValue],
					[PrvBranchValue],
					[ShortQuestion],
					[QuestionCode]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtBranchValue],
					[PrvBranchValue],
					[ShortQuestion],
					[QuestionCode]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factEmpSatBranchReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryPosition,
					A.Question,
					A.QuestionPosition,
					A.AssociationValue,	 
					A.PrvAssociationValue,	 
					A.NationalValue,
					A.CrtBranchValue,
					A.PrvBranchValue,
					A.ShortQuestion,
					A.QuestionCode
					
			FROM	#ESBR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.CategoryType = source.CategoryType
				AND COALESCE(target.Category, '') = COALESCE(source.Category, '')
				AND target.CategoryPosition = source.CategoryPosition
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
				AND target.QuestionPosition = source.QuestionPosition		
				AND COALESCE(target.ShortQuestion, '') = COALESCE(source.ShortQuestion, '')
				AND target.QuestionCode = source.QuestionCode
				
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtBranchValue],
					[PrvBranchValue],
					[ShortQuestion],
					[QuestionCode]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],
					[Category],
					[CategoryPosition],
					[Question],
					[QuestionPosition],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtBranchValue],
					[PrvBranchValue],
					[ShortQuestion],
					[QuestionCode]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #ESBR;
	
COMMIT TRAN
	
END








