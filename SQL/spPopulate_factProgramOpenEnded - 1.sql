/*
truncate table dd.factProgramOpenEnded
drop proc spPopulate_factProgramOpenEnded
SELECT * FROM dd.factProgramOpenEnded
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramOpenEnded] AS
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
			A.Grouping,
			A.Program,
			CASE WHEN A.OpenEndedGroup = 'Change one thing' THEN 'What would members change'
				ELSE A.OpenEndedGroup
			END OpenEndedGroup,
			A.Category,
			A.Subcategory,
			A.Response,	
			A.CategoryPercentage
		 
	INTO	#POE
	
	FROM	dd.vwProgramOpenEnded A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
					
	WHERE	A.Category <> 'Questionable'
			AND B.module = 'Program'
			AND B.aggregate_type = 'Association'
	
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Grouping,
					A.Program,
					A.OpenEndedGroup,
					A.Category,
					A.Subcategory,
					A.Response,	
					A.CategoryPercentage
					
			FROM	#POE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.OpenEndedGroup = source.OpenEndedGroup
				AND target.Category = source.Category
				AND target.SubCategory = source.SubCategory
				AND target.Response = source.Response
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[Association] <> source.[Association]
								OR target.[Program] <> source.[Program]
								OR target.[CategoryPercentage] <> source.[CategoryPercentage]
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
					[OpenEndedGroup],		
					[Category],
					[Subcategory],
					[Response],
					[CategoryPercentage]
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
					[OpenEndedGroup],		
					[Category],
					[Subcategory],
					[Response],
					[CategoryPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Grouping,
					A.Program,
					A.OpenEndedGroup,
					A.Category,
					A.Subcategory,
					A.Response,	
					A.CategoryPercentage
					
			FROM	#POE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				AND target.OpenEndedGroup = source.OpenEndedGroup
				AND target.Category = source.Category
				AND target.SubCategory = source.SubCategory
				AND target.Response = source.Response
						
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
					[OpenEndedGroup],		
					[Category],
					[Subcategory],
					[Response],
					[CategoryPercentage]
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
					[OpenEndedGroup],		
					[Category],
					[Subcategory],
					[Response],
					[CategoryPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #POE;
	
COMMIT TRAN
	
END








