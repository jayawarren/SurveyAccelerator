/*
truncate table dd.factProgramGroupingReport
drop proc spPopulate_factProgramGroupingReport
SELECT * FROM dd.factProgramGroupingReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramGroupingReport] AS
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
			A.Question,
			A.QuestionPosition,
			A.QuestionCode,
			CASE WHEN A.CategoryType = 'key indicators' THEN A.Category
				WHEN A.ShortQuestion = 'Discover what he/she can achievement' THEN 'Discover what he/she can achieve'
				WHEN A.ShortQuestion like '%nurturing the potential of every child%' THEN 'Nurturing the potential of every child'
				WHEN A.ShortQuestion like '%improving the health and wellbeing of the community.' THEN 'Improving the health and wellbeing of the community'
				ELSE A.ShortQuestion
			END ShortQuestion,
			A.AssociationValue,	 
			A.PrvAssociationValue,	 
			A.NationalValue,
			A.CrtGroupingValue,
			A.PrvGroupingValue
			
	INTO	#PGR

	FROM	[dd].[vwProgramGroupingReport] A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
			
	WHERE	A.ProgramGroupKey IS NOT NULL
			AND B.module = 'Program'
			AND B.aggregate_type = 'Association'
	
	ORDER BY A.AssociationKey,
			A.ProgramGroupKey,
			A.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.Grouping,
			A.CategoryPosition,
			A.CategoryType,
			A.Category,
			A.Question,
			A.ShortQuestion
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramGroupingReport AS target
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
					A.QuestionCode,
					A.ShortQuestion,
					A.AssociationValue,	 
					A.PrvAssociationValue,	 
					A.NationalValue,
					A.CrtGroupingValue,
					A.PrvGroupingValue
					
			FROM	#PGR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.CategoryType = source.CategoryType
				AND COALESCE(target.Category, '') = COALESCE(source.Category, '')
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
				AND COALESCE(target.ShortQuestion, '') = COALESCE(source.ShortQuestion, '')
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[Program] <> source.[Program]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[QuestionCode] <> source.[QuestionCode]
								OR target.[AssociationValue] <> source.[AssociationValue]
								OR target.[PrvAssociationValue] <> source.[PrvAssociationValue]
								OR target.[NationalValue] <> source.[NationalValue]
								OR target.[CrtGroupingValue] <> source.[CrtGroupingValue]
								OR target.[PrvGroupingValue] <> source.[PrvGroupingValue]
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
					[QuestionCode],
					[ShortQuestion],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtGroupingValue],
					[PrvGroupingValue]
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
					[QuestionCode],
					[ShortQuestion],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtGroupingValue],
					[PrvGroupingValue]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramGroupingReport AS target
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
					A.QuestionCode,
					A.ShortQuestion,
					A.AssociationValue,	 
					A.PrvAssociationValue,	 
					A.NationalValue,
					A.CrtGroupingValue,
					A.PrvGroupingValue
					
			FROM	#PGR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.CategoryType = source.CategoryType
				AND COALESCE(target.Category, '') = COALESCE(source.Category, '')
				AND COALESCE(target.Question, '') = COALESCE(source.Question, '')
				AND COALESCE(target.ShortQuestion, '') = COALESCE(source.ShortQuestion, '')
				
						
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
					[QuestionCode],
					[ShortQuestion],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtGroupingValue],
					[PrvGroupingValue]
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
					[QuestionCode],
					[ShortQuestion],
					[AssociationValue],	 
					[PrvAssociationValue],	 
					[NationalValue],
					[CrtGroupingValue],
					[PrvGroupingValue]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #PGR;
	
COMMIT TRAN
	
END








