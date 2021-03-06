/*
truncate table dbo.factMemSatPyramid
drop proc spPopulate_factMemSatPyramid
SELECT * FROM dbo.factMemSatPyramid where batch_key = 129 and AssociationKey = 236 order by BranchKey
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemSatPyramid] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN

	SELECT	A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.PyramidCategory,
			A.AvgZScore,
			A.Percentile,
			A.HistoricalChangeIndex,
			A.HistoricalChangePercentile
	
	INTO	#MSPRSTL
	
	FROM	(SELECT	distinct
					A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					CASE WHEN A.BranchKey = COALESCE(B.BranchKey, A.BranchKey) THEN A.AvgZScore
						ELSE B.AvgZScore
					END AvgZScore,
					CASE WHEN A.BranchKey = COALESCE(B.BranchKey, A.BranchKey) THEN A.Percentile
						ELSE B.Percentile
					END Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
			
			FROM	(
					SELECT	A.AssociationKey,
							A.BranchKey,
							A.SurveyFormKey,
							A.batch_key,
							A.GivenDateKey,
							B.change_datetime,
							B.next_change_datetime,
							A.current_indicator,
							A.PyramidCategory,
							A.AvgZScore,
							A.Percentile,
							A.HistoricalChangeIndex,
							A.HistoricalChangePercentile
							
					FROM	[dbo].[vwfactMemSatPyramid] A
							INNER JOIN Seer_MDM.dbo.Batch_Map B
								ON A.batch_key = B.batch_key
									AND A.BranchKey = B.organization_key
								
					WHERE	B.module = 'Member'
							AND B.aggregate_type = 'Branch'
							AND A.current_indicator = 1
							
					UNION
					
					--Below query ensures value for case when Assocation Key equal Branch Key but no data provided
					SELECT	A.AssociationKey,
							A.BranchKey,
							A.SurveyFormKey,
							A.batch_key,
							A.GivenDateKey,
							B.change_datetime,
							B.next_change_datetime,
							A.current_indicator,
							A.PyramidCategory,
							A.AvgZScore,
							A.Percentile,
							A.HistoricalChangeIndex,
							A.HistoricalChangePercentile
							
					FROM	[dbo].[vwfactMemSatPyramid] A
							INNER JOIN Seer_MDM.dbo.Batch_Map B
								ON A.batch_key = B.batch_key
									AND A.AssociationKey = B.organization_key
								
					WHERE	B.module = 'Member'
							AND B.aggregate_type = 'Association'
							AND A.current_indicator = 1
							AND A.AssociationKey = A.BranchKey
					) A
					LEFT JOIN
					(
					SELECT	A.AssociationKey,
							A.BranchKey,
							A.SurveyFormKey,
							A.batch_key,
							A.GivenDateKey,
							B.change_datetime,
							B.next_change_datetime,
							A.current_indicator,
							A.PyramidCategory,
							A.AvgZScore,
							A.Percentile,
							A.HistoricalChangeIndex,
							A.HistoricalChangePercentile
							
					FROM	[dbo].[vwfactMemSatPyramid] A
							INNER JOIN Seer_MDM.dbo.Batch_Map B
								ON A.batch_key = B.batch_key
									AND A.AssociationKey = B.organization_key
								
					WHERE	B.module = 'Member'
							AND B.aggregate_type = 'Association'
							AND A.current_indicator = 1
					) B
					ON A.AssociationKey = B.AssociationKey
						AND A.BranchKey = B.BranchKey
						AND A.SurveyFormKey = B.SurveyFormKey
						AND A.batch_key = B.batch_key
						AND A.PyramidCategory = B.PyramidCategory
			) A
				
	ORDER BY A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.PyramidCategory;
			
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			A.PyramidCategory,
			A.Percentile
			
	INTO	#MSPPCT
	
	FROM	(SELECT	distinct
					A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.survey_year,
					A.PyramidCategory,
					CASE WHEN A.BranchKey = COALESCE(B.BranchKey, A.BranchKey) THEN A.Percentile
						ELSE B.Percentile
					END Percentile
			--select	*		
			FROM	(
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							A.survey_year,
							REPLACE(REPLACE(REPLACE(A.measure_type, '_percentile', ''), '_and_', ' & '), 'facilities', 'facility') PyramidCategory,
							CONVERT(INT, (ROUND(A.measure_value * 100.00, 0))) Percentile

					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%percentile%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Branch'
							AND LEFT(E.date_given_key, 4) = A.survey_year
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
							
					UNION
					
					--Below query ensures value for case when Assocation Key equal Branch Key but no data provided
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							A.survey_year,
							REPLACE(REPLACE(REPLACE(A.measure_type, '_percentile', ''), '_and_', ' & '), 'facilities', 'facility') PyramidCategory,
							CONVERT(INT, (ROUND(A.measure_value * 100.00, 0))) Percentile

					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%percentile%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Association'
							AND LEFT(E.date_given_key, 4) = A.survey_year
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
					) A	
					LEFT JOIN
					(
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							A.survey_year,
							REPLACE(REPLACE(REPLACE(A.measure_type, '_percentile', ''), '_and_', ' & '), 'facilities', 'facility') PyramidCategory,
							CONVERT(INT, (ROUND(A.measure_value * 100.00, 0))) Percentile
					
					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%percentile%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Association'
							AND LEFT(E.date_given_key, 4) = A.survey_year
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
					) B
					ON A.AssociationKey = B.AssociationKey
						AND A.SurveyFormKey = B.SurveyFormKey
						AND A.batch_key = B.batch_key
						AND A.PyramidCategory = B.PyramidCategory
						AND LEFT(A.GivenDateKey, 4) = B.survey_year
			) A
				
	ORDER BY A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.PyramidCategory;
			
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			A.PyramidCategory,
			A.AvgZScore
	
	INTO	#MSPZ
	
	FROM	(
			SELECT	distinct
					A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.PyramidCategory,
					CASE WHEN A.BranchKey = COALESCE(B.BranchKey, A.BranchKey) THEN A.AvgZScore
						ELSE B.AvgZScore
					END AvgZScore
					
			FROM	(
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							REPLACE(REPLACE(A.measure_type, '_z-score', ''), '_', ' ') PyramidCategory,
							A.measure_value AvgZScore

					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%z-score%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Branch'
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
							
					UNION
					
					--Below query ensures value for case when Assocation Key equal Branch Key but no data provided
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							REPLACE(REPLACE(A.measure_type, '_z-score', ''), '_', ' ') PyramidCategory,
							A.measure_value AvgZScore

					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%z-score%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Association'
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
					) A
					LEFT JOIN
					(
					SELECT	C.organization_key AssociationKey,
							B.organization_key BranchKey,
							D.survey_form_key SurveyFormKey,
							E.batch_key,
							E.date_given_key GivenDateKey,
							A.current_indicator,
							A.module,
							A.form_code,
							REPLACE(REPLACE(A.measure_type, '_z-score', ''), '_', ' ') PyramidCategory,
							A.measure_value AvgZScore

					FROM	dbo.Top_Box A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Organization C
								ON A.official_association_number = C.association_number
									AND A.official_association_number = C.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form D
								ON A.form_code = D.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch E
								ON A.form_code = E.form_code

					WHERE	A.calculation = 'base'
							AND A.measure_type LIKE '%z-score%'
							AND A.module = 'Member'
							AND A.aggregate_type = 'Association'
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
					) B
					ON A.AssociationKey = B.AssociationKey
						AND A.SurveyFormKey = B.SurveyFormKey
						AND A.batch_key = B.batch_key
						AND A.PyramidCategory = B.PyramidCategory
			) A
				
	ORDER BY A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.PyramidCategory;
			
	SELECT	distinct
			A.AssociationKey,
			A.BranchKey,
			A.SurveyFormKey,
			A.batch_key,
			A.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.PyramidCategory,
			COALESCE(C.AvgZScore, A.AvgZScore) AvgZScore,
			CASE WHEN A.AssociationKey = A.BranchKey AND COALESCE(B.Percentile, A.Percentile) = 0 THEN 50
				ELSE COALESCE(B.Percentile, A.Percentile)
			END Percentile,
			A.HistoricalChangeIndex,
			A.HistoricalChangePercentile
			
	INTO	#MSP

	FROM	#MSPRSTL A	
			LEFT JOIN #MSPPCT B
			ON A.AssociationKey = B.AssociationKey
				AND A.BranchKey = B.BranchKey
				AND A.SurveyFormKey = B.SurveyFormKey
				AND A.batch_key = B.batch_key
				AND A.GivenDateKey = B.GivenDateKey
				AND LOWER(A.PyramidCategory) = B.PyramidCategory
			LEFT JOIN #MSPZ C
			ON A.AssociationKey = C.AssociationKey
				AND A.BranchKey = C.BranchKey
				AND A.SurveyFormKey = C.SurveyFormKey
				AND A.batch_key = C.batch_key
				AND A.GivenDateKey = C.GivenDateKey
				AND LOWER(A.PyramidCategory) = C.PyramidCategory
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factMemSatPyramid AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	#MSP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.PyramidCategory = source.PyramidCategory
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[GivenDateKey] <> source.[GivenDateKey]
								OR target.[AvgZScore] <> source.[AvgZScore]
								OR target.[Percentile] <> source.[Percentile]
								OR target.[HistoricalChangeIndex] <> source.[HistoricalChangeIndex]
								OR target.[HistoricalChangePercentile] <> source.[HistoricalChangePercentile]
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
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factMemSatPyramid AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.SurveyFormKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.PyramidCategory,
					A.AvgZScore,
					A.Percentile,
					A.HistoricalChangeIndex,
					A.HistoricalChangePercentile
					
			FROM	#MSP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.PyramidCategory = source.PyramidCategory
				
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[SurveyFormKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[PyramidCategory],
					[AvgZScore],
					[Percentile],
					[HistoricalChangeIndex],
					[HistoricalChangePercentile]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MSP;
	DROP TABLE #MSPPCT;
	DROP TABLE #MSPRSTL;
	DROP TABLE #MSPZ;
	
COMMIT TRAN
	
END