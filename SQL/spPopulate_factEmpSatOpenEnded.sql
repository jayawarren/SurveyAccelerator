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
	
	WHERE	A.Category <> 'Questionable'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatOpenEnded AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
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
				
			WHEN MATCHED AND (target.[Association] <> source.[Association]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[CategoryTypePosition] <> source.[CategoryTypePosition]
								 OR target.[CategoryPercentage] <> source.[CategoryPercentage]
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
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
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
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
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
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
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








