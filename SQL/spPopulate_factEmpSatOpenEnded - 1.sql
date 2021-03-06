/*
truncate table dd.factEmpSatOpenEnded
drop proc spPopulate_factEmpSatOpenEnded
SELECT * FROM dd.factEmpSatOpenEnded
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatOpenEnded] AS
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
			A.Association,
			A.Branch,
			A.CategoryType,
			CASE WHEN A.Category IS NULL OR A.Category = 'NULL' THEN 'Unknown'
				ELSE A.Category
			END Category,
			A.CategoryTypePosition,
			A.Subcategory,
			A.Response,	
			A.CategoryPercentage
		 
	INTO	#ESOE
	
	FROM	dd.vwEmpSatOpenEnded A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.BranchKey = B.organization_key
					AND A.batch_key = B.batch_key
					
	WHERE	B.module = 'Staff'
			AND B.aggregate_type = 'Branch'
			AND A.current_indicator = 1
			AND A.Category <> 'Questionable'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryTypePosition,
					A.Subcategory,
					A.Response,	
					A.CategoryPercentage
					
			FROM	#ESOE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
				AND target.SubCategory = source.SubCategory
				AND target.Response = source.Response
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[Association] <> source.[Association]
								OR target.[Branch] <> source.[Branch]
								OR target.[CategoryTypePosition] <> source.[CategoryTypePosition]
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
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Branch],
					[CategoryType],		
					[Category],
					[CategoryTypePosition],	
					[Subcategory],
					[Response],
					[CategoryPercentage]
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
					[CategoryTypePosition],	
					[Subcategory],
					[Response],
					[CategoryPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factEmpSatOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.CategoryType,
					A.Category,
					A.CategoryTypePosition,
					A.Subcategory,
					A.Response,	
					A.CategoryPercentage
					
			FROM	#ESOE A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
				AND target.SubCategory = source.SubCategory
				AND target.Response = source.Response
						
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
					[CategoryTypePosition],	
					[Subcategory],
					[Response],
					[CategoryPercentage]
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
					[CategoryTypePosition],	
					[Subcategory],
					[Response],
					[CategoryPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #ESOE;
	
COMMIT TRAN
	
END








