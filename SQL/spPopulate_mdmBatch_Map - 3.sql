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

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Batch_Map AS target
	USING	(
			SELECT	A.organization_key,
					A.survey_form_key,
					A.batch_key,
					COALESCE(B.batch_key, 0) previous_batch_key,
					A.date_given_key,
					B.date_given_key previous_date_given_key,
					CASE WHEN A.rank <> 1 THEN @change_datetime
						ELSE @next_change_datetime
					END change_datetime,
					CASE WHEN A.rank <> 1 THEN @next_change_datetime
						ELSE DATEADD(YY, 100, @change_datetime)
					END next_change_datetime,
					CASE WHEN A.rank <> 1 THEN 0
						ELSE A.rank
					END current_indicator,
					A.module,
					A.aggregate_type,
					A.rank

			FROM	(
					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Association' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) AS rank

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
							'Branch' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) AS rank
							
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
							'Association' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) - 1 AS rank

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
							'Branch' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) - 1 AS rank
							
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
						AND A.rank = B.rank

			GROUP BY A.organization_key,
					A.survey_form_key,
					A.batch_key,
					A.date_given_key,
					COALESCE(B.batch_key, 0),
					B.date_given_key,
					A.module,
					A.aggregate_type,
					A.rank
							
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
					date_given_key,
					previous_date_given_key,
					change_datetime,
					next_change_datetime,
					current_indicator,
					module,
					aggregate_type)
			VALUES (organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					date_given_key,
					previous_date_given_key,
					change_datetime,
					next_change_datetime,
					current_indicator,
					module,
					aggregate_type)
					
	;
COMMIT TRAN
	
BEGIN TRAN
	MERGE	Seer_MDM.dbo.Batch_Map AS target
	USING	(
			SELECT	CASE WHEN A.rank <> 1 THEN @change_datetime
						ELSE @next_change_datetime
					END change_datetime,
					CASE WHEN A.rank <> 1 THEN @next_change_datetime
						ELSE DATEADD(YY, 100, @change_datetime)
					END next_change_datetime,
					A.organization_key,
					A.survey_form_key,
					A.batch_key,
					COALESCE(B.batch_key, 0) previous_batch_key,
					A.date_given_key,
					B.date_given_key previous_date_given_key,
					CASE WHEN A.rank <> 1 THEN 0
						ELSE A.rank
					END current_indicator,
					A.module,
					A.aggregate_type,
					A.rank

			FROM	(
					SELECT	B.organization_key,
							C.survey_form_key,
							D.batch_key,
							D.date_given_key,
							A.module,
							'Association' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) AS rank

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
							'Branch' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) AS rank
							
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
							'Association' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) - 1 AS rank

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
							'Branch' aggregate_type,
							RANK() OVER 
							(PARTITION BY B.organization_key,
											C.survey_form_key
							ORDER BY D.date_given_key DESC) - 1 AS rank
							
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
						AND A.rank = B.rank

			GROUP BY A.organization_key,
					A.survey_form_key,
					A.batch_key,
					A.date_given_key,
					COALESCE(B.batch_key, 0),
					B.date_given_key,
					A.module,
					A.aggregate_type,
					A.rank
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
					date_given_key,
					previous_date_given_key,
					module,
					aggregate_type)
			VALUES ([change_datetime],
					[next_change_datetime],
					organization_key,
					survey_form_key,
					batch_key,
					previous_batch_key,
					date_given_key,
					previous_date_given_key,
					module,
					aggregate_type)
		;
COMMIT TRAN
END