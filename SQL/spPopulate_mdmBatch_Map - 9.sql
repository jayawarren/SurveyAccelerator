/*
truncate table dbo.Batch_Map
drop procedure spPopulate_mdmBatch_Map
select * from dbo.Batch_Map where survey_form_key = 25 and organization_key = 245 and aggregate_type = 'Branch'
select * from #BMP where organization_key = 1307
select * from Seer_MDM.dbo.Batch_Map where organization_key = 1307
*/
CREATE PROCEDURE spPopulate_mdmBatch_Map AS
BEGIN

	DECLARE @change_datetime datetime
	DECLARE @next_change_datetime datetime
	DECLARE @batch_map_record_count INT
	SET @change_datetime = getdate()
	SET @next_change_datetime = dateadd(YY, 100, @change_datetime)

		BEGIN TRAN
		SELECT	A.organization_key,
				A.survey_form_key,
				A.survey_year_begin,
				A.current_form_flag,
				A.batch_key,
				A.date_given_key,
				A.module,
				A.aggregate_type,
				A.rank
				
		INTO	#BCUR
			
		FROM	(
				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Association' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) AS rank
						
				FROM	Seer_ODS.dbo.Close_Ends A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_association_number = B.official_branch_number
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
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1			
						
				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module

				UNION ALL

				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Branch' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) AS rank
						
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
						AND A.current_indicator = 1
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1

				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module
				) A
		ORDER BY A.survey_form_key,
				A.organization_key;
				
		SELECT	A.organization_key,
				A.survey_form_key,
				A.survey_year_begin,
				A.current_form_flag,
				A.batch_key,
				A.date_given_key,
				A.module,
				A.aggregate_type,
				A.rank
				
		INTO	#BPRVNM
			
		FROM	(
				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Association' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) - 2 AS rank
						
				FROM	Seer_ODS.dbo.Close_Ends A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_association_number = B.official_branch_number
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
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1			
						
				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module

				UNION ALL

				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Branch' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) - 2 AS rank
						
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
						AND A.current_indicator = 1
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1

				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module
				) A
		ORDER BY A.survey_form_key,
				A.organization_key;

				
		SELECT	A.organization_key,
				A.survey_form_key,
				A.survey_year_begin,
				A.current_form_flag,
				A.batch_key,
				A.date_given_key,
				A.module,
				A.aggregate_type,
				A.rank
				
		INTO	#BPRV
			
		FROM	(
				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Association' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) - 1 AS rank
						
				FROM	Seer_ODS.dbo.Close_Ends A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_association_number = B.official_branch_number
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
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1			
						
				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module

				UNION ALL

				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Branch' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) - 1 AS rank
						
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
						AND A.current_indicator = 1
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1

				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module
				) A
		ORDER BY A.survey_form_key,
				A.organization_key;

		SELECT	A.organization_key,
				A.survey_form_key,
				A.survey_year_begin,
				A.current_form_flag,
				A.batch_key,
				A.date_given_key,
				A.module,
				A.aggregate_type,
				A.rank
				
		INTO	#BFTR
			
		FROM	(
				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Association' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) + 1 AS rank
						
				FROM	Seer_ODS.dbo.Close_Ends A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_association_number = B.official_branch_number
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
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1			
						
				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module

				UNION ALL

				SELECT	B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END survey_year_begin,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						CONVERT(INT, CONVERT(VARCHAR(10), LEFT(D.date_given_key, 4) + 101) + '0101') end_date_key,
						A.module,
						'Branch' aggregate_type,
						ROW_NUMBER() OVER 
						(PARTITION BY B.organization_key,
										C.survey_form_key
						ORDER BY D.report_date DESC) + 1 AS rank
						
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
						AND A.current_indicator = 1
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1

				GROUP BY B.organization_key,
						C.survey_form_key,
						CASE WHEN ISNUMERIC(LEFT(C.description, 4)) = 1 THEN LEFT(C.description, 4)
							ELSE 2001
						END,
						C.current_form_flag,
						D.batch_key,
						D.date_given_key,
						D.report_date,
						A.module
				) A
		ORDER BY A.survey_form_key,
				A.organization_key;
	COMMIT TRAN

	BEGIN TRAN
		SELECT	A.organization_key,
				A.survey_form_key,
				A.batch_key,
				COALESCE(B.batch_key, 0) previous_batch_key,
				A.date_given_key,
				CASE WHEN A.date_given_key = B.date_given_key THEN C.date_given_key
					ELSE B.date_given_key
				END previous_date_given_key,
				CONVERT(DATETIME, CONVERT(VARCHAR(20), A.date_given_key)) change_datetime,
				CASE WHEN A.rank <> 1 AND DATEDIFF(MM, CONVERT(VARCHAR(20), A.date_given_key), CONVERT(VARCHAR(20), COALESCE(B.date_given_key, CONVERT(INT, CONVERT(VARCHAR(10), LEFT(A.date_given_key, 4) + 101) + '0101')))) > 2 THEN DATEADD(SS, -1, CONVERT(DATETIME, CONVERT(VARCHAR(20), D.date_given_key)))
					 WHEN A.rank = 1 AND A.current_form_flag = 'N' THEN DATEADD(SS, 86399, CONVERT(DATETIME, LEFT(A.date_given_key, 4) + '1231'))
					 WHEN A.rank = 1 AND LEFT(A.date_given_key, 4) < A.survey_year_begin THEN DATEADD(SS, 86399, CONVERT(DATETIME, LEFT(A.date_given_key, 4) + '1231'))
					 ELSE DATEADD(YY, 100, CONVERT(DATETIME, CONVERT(VARCHAR(20), COALESCE(A.date_given_key, 20010101))))
				END next_change_datetime,
				CASE WHEN A.rank <> 1 THEN 0
					ELSE A.rank
				END current_indicator,
				A.module,
				A.aggregate_type,
				A.rank

		INTO	#BMPRSLT

		FROM	#BCUR A
				LEFT JOIN #BPRV B
				ON A.organization_key = B.organization_key
					AND A.survey_form_key = B.survey_form_key
					AND A.module = B.module
					AND A.aggregate_type = B.aggregate_type
					AND A.rank = B.rank
				LEFT JOIN #BPRVNM C
				ON A.organization_key = C.organization_key
					AND A.survey_form_key = C.survey_form_key
					AND A.module = C.module
					AND A.aggregate_type = C.aggregate_type
					AND A.rank = C.rank
				LEFT JOIN #BFTR D
				ON A.organization_key = D.organization_key
					AND A.survey_form_key = D.survey_form_key
					AND A.module = D.module
					AND A.aggregate_type = D.aggregate_type
					AND A.rank = D.rank
					
		GROUP BY A.organization_key,
				A.survey_form_key,
				A.batch_key,
				COALESCE(B.batch_key, 0),
				A.date_given_key,
				CASE WHEN A.date_given_key = B.date_given_key THEN C.date_given_key
					ELSE B.date_given_key
				END,
				CONVERT(DATETIME, CONVERT(VARCHAR(20), A.date_given_key)),
				CASE WHEN A.rank <> 1 AND DATEDIFF(MM, CONVERT(VARCHAR(20), A.date_given_key), CONVERT(VARCHAR(20), COALESCE(B.date_given_key, CONVERT(INT, CONVERT(VARCHAR(10), LEFT(A.date_given_key, 4) + 101) + '0101')))) > 2 THEN DATEADD(SS, -1, CONVERT(DATETIME, CONVERT(VARCHAR(20), D.date_given_key)))
					 WHEN A.rank = 1 AND A.current_form_flag = 'N' THEN DATEADD(SS, 86399, CONVERT(DATETIME, LEFT(A.date_given_key, 4) + '1231'))
					 WHEN A.rank = 1 AND LEFT(A.date_given_key, 4) < A.survey_year_begin THEN DATEADD(SS, 86399, CONVERT(DATETIME, LEFT(A.date_given_key, 4) + '1231'))
					 ELSE DATEADD(YY, 100, CONVERT(DATETIME, CONVERT(VARCHAR(20), COALESCE(A.date_given_key, 20010101))))
				END,
				CASE WHEN A.rank <> 1 THEN 0
					ELSE A.rank
				END,
				A.module,
				A.aggregate_type,
				A.rank;
	COMMIT TRAN

	BEGIN TRAN
	SELECT	A.organization_key,
			A.survey_form_key,
			A.batch_key,
			A.previous_batch_key,
			COALESCE(C.previous_year_batch_key, 0) previous_year_batch_key,
			A.date_given_key,
			A.previous_date_given_key,
			C.previous_year,
			C.previous_year_date_given_key,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.module,
			A.aggregate_type,
			A.rank

	INTO	#BMP

	FROM	#BMPRSLT A
			LEFT JOIN
			(
			SELECT	A.organization_key,
					A.survey_form_key,
					A.date_given_key,
					A.previous_date_given_key,
					A.previous_year,
					A.previous_year_date_given_key,
					B.batch_key previous_year_batch_key,
					A.module,
					A.aggregate_type
			
			FROM	(
					SELECT	A.organization_key,
							A.survey_form_key,
							B.survey_form_code,
							A.date_given_key,
							A.previous_date_given_key,
							LEFT(A.date_given_key, 4) - 1 previous_year,
							MAX(A.previous_date_given_key) previous_year_date_given_key,
							A.module,
							A.aggregate_type
					
					FROM	#BMPRSLT A
							INNER JOIN Seer_MDM.dbo.Survey_Form B
								ON A.survey_form_key = B.survey_form_key
					
					WHERE	A.previous_date_given_key <= CONVERT(INT, CONVERT(VARCHAR(4), LEFT(A.date_given_key, 4) - 1) + '1231')
							AND B.current_indicator = 1
							
					GROUP BY A.organization_key,
							A.survey_form_key,
							B.survey_form_code,
							A.date_given_key,
							A.previous_date_given_key,
							A.module,
							A.aggregate_type
					) A
					INNER JOIN Seer_MDM.dbo.Batch B
						ON A.survey_form_code = B.form_code
							AND A.previous_year_date_given_key = B.date_given_key
							
			WHERE	B.current_indicator = 1
			) C
		
			ON A.organization_key = C.organization_key
				AND A.survey_form_key = C.survey_form_key
				AND A.date_given_key = C.date_given_key
				AND A.previous_date_given_key = C.previous_date_given_key
				AND A.module = C.module
				AND A.aggregate_type = C.aggregate_type
				
	GROUP BY A.organization_key,
			A.survey_form_key,
			A.batch_key,
			A.previous_batch_key,
			COALESCE(C.previous_year_batch_key, 0),
			A.date_given_key,
			A.previous_date_given_key,
			C.previous_year,
			C.previous_year_date_given_key,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.module,
			A.aggregate_type,
			A.rank;
			
	COMMIT TRAN

	BEGIN TRAN
		MERGE	Seer_MDM.dbo.Batch_Map AS target
		USING	(
				SELECT	A.organization_key,
						A.survey_form_key,
						A.batch_key,
						A.previous_batch_key,
						A.previous_year_batch_key,
						A.date_given_key,
						A.previous_date_given_key,
						A.previous_year,
						A.previous_year_date_given_key,
						A.change_datetime,
						A.next_change_datetime,
						A.current_indicator,
						A.module,
						A.aggregate_type,
						A.rank
						
				FROM	#BMP A
								
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
						previous_year_batch_key,
						date_given_key,
						previous_date_given_key,
						previous_year_date_given_key,
						change_datetime,
						next_change_datetime,
						current_indicator,
						module,
						aggregate_type)
				VALUES (organization_key,
						survey_form_key,
						batch_key,
						previous_batch_key,
						previous_year_batch_key,
						date_given_key,
						previous_date_given_key,
						previous_year_date_given_key,
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
				
				SELECT	A.organization_key,
						A.survey_form_key,
						A.batch_key,
						A.previous_batch_key,
						A.previous_year_batch_key,
						A.date_given_key,
						A.previous_date_given_key,
						A.previous_year,
						A.previous_year_date_given_key,
						A.change_datetime,
						A.next_change_datetime,
						A.current_indicator,
						A.module,
						A.aggregate_type,
						A.rank
						
				FROM	#BMP A
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
						previous_year_batch_key,
						date_given_key,
						previous_date_given_key,
						previous_year_date_given_key,
						module,
						aggregate_type)
				VALUES ([change_datetime],
						[next_change_datetime],
						organization_key,
						survey_form_key,
						batch_key,
						previous_batch_key,
						previous_year_batch_key,
						date_given_key,
						previous_date_given_key,
						previous_year_date_given_key,
						module,
						aggregate_type)
			;
	COMMIT TRAN

	BEGIN TRAN
		DROP TABLE #BMPRSLT;
		DROP TABLE #BMP;
		DROP TABLE #BCUR;
		DROP TABLE #BPRV;
		DROP TABLE #BPRVNM;
		DROP TABLE #BFTR;
	COMMIT TRAN
END