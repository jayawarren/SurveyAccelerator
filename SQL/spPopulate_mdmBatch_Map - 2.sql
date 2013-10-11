/*
truncate table dbo.Batch_Map
drop procedure spPopulate_mdmBatch_Map
select * from dbo.Batch_Map
*/
CREATE PROCEDURE spPopulate_mdmBatch_Map AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
DECLARE @batch_map_record_count INT
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)
SELECT @batch_map_record_count = COUNT(*) FROM Seer_MDM.dbo.Batch_Map

BEGIN TRAN
--This section of code applies to the first run of the procedure for the historial load of Batch_Map table
IF @batch_map_record_count = 0
	BEGIN
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
										INNER JOIN Seer_MDM.dbo.Member_Map E
											ON A.member_key = E.member_key
										INNER JOIN Seer_MDM.dbo.Organization B
											ON E.organization_key = B.organization_key
												AND B.association_number = B.official_branch_number
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
										INNER JOIN Seer_MDM.dbo.Member_Map E
											ON A.member_key = E.member_key
										INNER JOIN Seer_MDM.dbo.Organization B
											ON E.organization_key = B.organization_key
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
										INNER JOIN Seer_MDM.dbo.Member_Map E
											ON A.member_key = E.member_key
										INNER JOIN Seer_MDM.dbo.Organization B
											ON E.organization_key = B.organization_key
												AND B.association_number = B.official_branch_number
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
										INNER JOIN Seer_MDM.dbo.Member_Map E
											ON A.member_key = E.member_key
										INNER JOIN Seer_MDM.dbo.Organization B
											ON E.organization_key = B.organization_key
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
								INNER JOIN Seer_MDM.dbo.Member_Map E
									ON A.member_key = E.member_key
								INNER JOIN Seer_MDM.dbo.Organization B
									ON E.organization_key = B.organization_key
										AND B.association_number = B.official_branch_number
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
								INNER JOIN Seer_MDM.dbo.Member_Map E
									ON A.member_key = E.member_key
								INNER JOIN Seer_MDM.dbo.Organization B
									ON E.organization_key = B.organization_key
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
	END
COMMIT TRAN
	
BEGIN TRAN
	MERGE	Seer_MDM.dbo.Batch_Map AS target
	USING	(
			SELECT	C.organization_key,
					C.survey_form_key,
					C.batch_key,
					COALESCE(D.batch_key, 0) previous_batch_key,
					CASE WHEN C.batch_key <> COALESCE(E.batch_key, C.batch_key) THEN 0
						ELSE 1
					END current_indicator,
					C.date_given_key,
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
									'Association' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
											AND B.association_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
											ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module
							) A
							LEFT JOIN
							(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
											AND B.association_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module
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
							'Association' aggregate_type
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Member_Map E
								ON A.member_key = E.member_key
							INNER JOIN Seer_MDM.dbo.Organization B
								ON E.organization_key = B.organization_key
									AND B.association_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code
									
					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)
							AND A.current_indicator = 1

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module

					UNION ALL

					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Branch' aggregate_type
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Member_Map E
								ON A.member_key = E.member_key
							INNER JOIN Seer_MDM.dbo.Organization B
								ON E.organization_key = B.organization_key
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code

					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)
							AND A.current_indicator = 1

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module
					) D
					ON C.organization_key = D.organization_key
						AND C.survey_form_key = D.survey_form_key
						AND C.module = D.module
						AND C.aggregate_type = D.aggregate_type
						AND C.previous_date_given_key = D.date_given_key
					LEFT JOIN
					(
					SELECT	A.organization_key,
							A.survey_form_key,
							B.batch_key,
							A.module,
							A.aggregate_type
							
					FROM	(
							SELECT	A.organization_key,
									A.survey_form_key,
									C.survey_form_code,
									MAX(B.date_given_key) current_date_given_key,
									A.module,
									A.aggregate_type
									
							FROM	Seer_MDM.dbo.Batch_Map A
									INNER JOIN Seer_MDM.dbo.Batch B
									ON A.batch_key = B.batch_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
									ON A.survey_form_key = C.survey_form_key
									
							WHERE	A.current_indicator = 1
									
							GROUP BY A.organization_key,
									A.survey_form_key,
									C.survey_form_code,
									A.module,
									A.aggregate_type
							) A
							INNER JOIN Seer_MDM.dbo.Batch B
							ON A.survey_form_code = B.form_code
							AND A.current_date_given_key = B.date_given_key
					) E
					ON C.organization_key = E.organization_key
						AND C.survey_form_key = E.survey_form_key
						AND C.module = E.module
						AND C.aggregate_type = E.aggregate_type
			) AS source
			ON target.organization_key = source.organization_key
				AND target.survey_form_key = source.survey_form_key
				AND target.batch_key = source.batch_key
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
			
	WHEN MATCHED AND (target.current_indicator <> source.current_indicator
						OR target.previous_batch_key <> source.previous_batch_key)
				
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
					COALESCE(D.batch_key, 0) previous_batch_key,
					CASE WHEN C.batch_key <> COALESCE(E.batch_key, C.batch_key) THEN 0
						ELSE 1
					END current_indicator,
					C.date_given_key,
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
									'Association' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
											AND B.association_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module
							) A
							LEFT JOIN
							(
							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Association' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
											AND B.association_number = B.official_branch_number
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code
											
							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module

							UNION ALL

							SELECT	B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module,
									'Branch' aggregate_type
									
							FROM	Seer_ODS.dbo.Close_Ends A
									INNER JOIN Seer_MDM.dbo.Member_Map E
										ON A.member_key = E.member_key
									INNER JOIN Seer_MDM.dbo.Organization B
										ON E.organization_key = B.organization_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
										ON A.form_code = C.survey_form_code
									INNER JOIN Seer_MDM.dbo.Batch D
										ON A.batch_number = D.batch_number
											AND A.form_code = D.form_code

							--Filter Condition added for Performance		
							WHERE	C.survey_form_key IN   (SELECT	survey_form_key
															FROM	Seer_MDM.dbo.Survey_Form
															)
									AND A.current_indicator = 1

							GROUP BY B.organization_key,
									C.survey_form_key,
									D.batch_key,
									D.date_given_key,
									A.module
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
							'Association' aggregate_type
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Member_Map E
								ON A.member_key = E.member_key
							INNER JOIN Seer_MDM.dbo.Organization B
								ON E.organization_key = B.organization_key
									AND B.association_number = B.official_branch_number
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code
									
					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)
							AND A.current_indicator = 1

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module

					UNION ALL

					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Branch' aggregate_type
							
					FROM	Seer_ODS.dbo.Close_Ends A
							INNER JOIN Seer_MDM.dbo.Member_Map E
								ON A.member_key = E.member_key
							INNER JOIN Seer_MDM.dbo.Organization B
								ON E.organization_key = B.organization_key
							INNER JOIN Seer_MDM.dbo.Survey_Form C
								ON A.form_code = C.survey_form_code
							INNER JOIN Seer_MDM.dbo.Batch D
								ON A.batch_number = D.batch_number
									AND A.form_code = D.form_code

					--Filter Condition added for Performance		
					WHERE	C.survey_form_key IN   (SELECT	survey_form_key
													FROM	Seer_MDM.dbo.Survey_Form
													)
							AND A.current_indicator = 1

					GROUP BY B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module
					) D
					ON C.organization_key = D.organization_key
						AND C.survey_form_key = D.survey_form_key
						AND C.module = D.module
						AND C.aggregate_type = D.aggregate_type
						AND C.previous_date_given_key = D.date_given_key
					LEFT JOIN
					(
					SELECT	A.organization_key,
							A.survey_form_key,
							B.batch_key,
							A.module,
							A.aggregate_type
							
					FROM	(
							SELECT	A.organization_key,
									A.survey_form_key,
									C.survey_form_code,
									MAX(B.date_given_key) current_date_given_key,
									A.module,
									A.aggregate_type
									
							FROM	Seer_MDM.dbo.Batch_Map A
									INNER JOIN Seer_MDM.dbo.Batch B
									ON A.batch_key = B.batch_key
									INNER JOIN Seer_MDM.dbo.Survey_Form C
									ON A.survey_form_key = C.survey_form_key
									
							WHERE	A.current_indicator = 1
									
							GROUP BY A.organization_key,
									A.survey_form_key,
									C.survey_form_code,
									A.module,
									A.aggregate_type
							) A
							INNER JOIN Seer_MDM.dbo.Batch B
							ON A.survey_form_code = B.form_code
							AND A.current_date_given_key = B.date_given_key
					) E
					ON C.organization_key = E.organization_key
						AND C.survey_form_key = E.survey_form_key
						AND C.module = E.module
						AND C.aggregate_type = E.aggregate_type
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