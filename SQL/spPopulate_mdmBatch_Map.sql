/*
truncate table dbo.Batch_Map
drop procedure spPopulate_mdmBatch_Map
select * from dbo.Batch_Map
*/
CREATE PROCEDURE spPopulate_mdmBatch_Map AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Batch_Map AS target
	USING	(
			SELECT	C.organization_key,
					C.survey_form_key,
					C.batch_key,
					C.date_given_key,
					1 current_indicator,
					COALESCE(D.batch_key, 0) previous_batch_key,
					C.previous_date_given_key,
					C.module,
					C.aggregate_type
					
			FROM	(
					SELECT	A.organization_key,
							A.survey_form_key,
							A.batch_key,
							A.date_given_key,
							COALESCE(MAX(B.date_given_key), 19000101) previous_date_given_key,
							A.module,
							A.aggregate_type

					FROM	(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.association_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
							) A
							LEFT JOIN
							(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.association_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
							) B
							ON A.organization_key = B.organization_key
								AND A.survey_form_key = B.survey_form_key
								AND A.module = B.module
								AND A.aggregate_type = B.aggregate_type
								AND A.date_given_key > B.date_given_key

					GROUP BY A.organization_key,
							A.survey_form_key,
							A.batch_key,
							A.date_given_key,
							A.module,
							A.aggregate_type
					) C
					LEFT JOIN
					(
					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Association' aggregate_type--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.association_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code
									
					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/

					UNION ALL

					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Branch' aggregate_type--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code

					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
					) D
					ON C.organization_key = D.organization_key
						AND C.survey_form_key = D.survey_form_key
						AND C.module = D.module
						AND C.aggregate_type = D.aggregate_type
						AND C.previous_date_given_key = D.date_given_key
			) AS source
			ON target.organization_key = source.organization_key
				AND target.survey_form_key = source.survey_form_key
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
			
	WHEN MATCHED AND (target.previous_batch_key <> source.previous_batch_key)
				
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(
		1 = 1
		)
		THEN 
			INSERT (organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					module,
					aggregate_type)
			VALUES (organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					module,
					aggregate_type)
					
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Batch_Map AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					C.organization_key,
					C.survey_form_key,
					C.batch_key,
					C.date_given_key,
					1 current_indicator,
					COALESCE(D.batch_key, 0) previous_batch_key,
					C.previous_date_given_key,
					C.module,
					C.aggregate_type
					
			FROM	(
					SELECT	A.organization_key,
							A.survey_form_key,
							A.batch_key,
							A.date_given_key,
							COALESCE(MAX(B.date_given_key), 19000101) previous_date_given_key,
							A.module,
							A.aggregate_type

					FROM	(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.association_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
							) A
							LEFT JOIN
							(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.association_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Organization B
										ON A.official_association_number = B.association_number
											AND A.official_branch_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module--,
									/*
									A.batch_number,
									A.official_association_number,
									A.official_branch_number,
									A.form_code
									*/
							) B
							ON A.organization_key = B.organization_key
								AND A.survey_form_key = B.survey_form_key
								AND A.module = B.module
								AND A.aggregate_type = B.aggregate_type
								AND A.date_given_key > B.date_given_key

					GROUP BY A.organization_key,
							A.survey_form_key,
							A.batch_key,
							A.date_given_key,
							A.module,
							A.aggregate_type
					) C
					LEFT JOIN
					(
					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Association' aggregate_type--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.association_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code
									
					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/

					UNION ALL

					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Branch' aggregate_type--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Organization B
								ON A.official_association_number = B.association_number
									AND A.official_branch_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code

					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module--,
							/*
							A.batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code
							*/
					) D
					ON C.organization_key = D.organization_key
						AND C.survey_form_key = D.survey_form_key
						AND C.module = D.module
						AND C.aggregate_type = D.aggregate_type
						AND C.previous_date_given_key = D.date_given_key
			) AS source
			ON target.organization_key = source.organization_key
				AND target.survey_form_key = source.survey_form_key
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type

	WHEN NOT MATCHED BY target AND
		(
		1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					module,
					aggregate_type)
			VALUES ([change_datetime],
					[next_change_datetime],
					organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					module,
					aggregate_type)
		;
COMMIT TRAN
END