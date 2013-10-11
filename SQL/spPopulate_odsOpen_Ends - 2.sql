/*
truncate table Seer_ODS.dbo.Open_Ends
drop procedure spPopulate_odsOpen_Ends
select * from Seer_ODS.dbo.Open_Ends
*/
CREATE PROCEDURE spPopulate_odsOpen_Ends AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	distinct
			1 current_indicator,
			E.module,
			E.batch_number,
			COALESCE(F.report_date, '1900-01-01') report_date,
			E.official_association_number,
			E.official_branch_number,
			E.form_code,
			E.member_key,
			E.response_channel,
			E.closed_question,
			E.closed_response,
			E.open_question,
			E.open_response
			
	INTO	#OED

	FROM	(SELECT	A.module,
					A.batch_number,
					A.official_association_number,
					A.official_branch_number,
					A.form_code,
					A.member_key,
					A.response_channel,
					A.closed_question,
					A.closed_response,
					A.open_question,
					A.open_response
					
			FROM	(SELECT	module,
							official_association_number,
							official_branch_number,
							form_code,
							batch_number,
							file_name,
							job_order_number,
							member_key,
							response_channel,
							closed_question,
							closed_response,
							open_question,
							open_response

					FROM	(SELECT		module,
										CASE WHEN LEN(official_association_number) = 3 THEN '0' + official_association_number
											WHEN LEN(official_association_number) = 0 THEN '0000'
											ELSE official_association_number
										END official_association_number,
										CASE WHEN LEN(official_branch_number) = 3 THEN '0' + official_branch_number
											WHEN LEN(official_branch_number) = 0 AND LEN(official_association_number) = 0 THEN '0000'
											WHEN LEN(official_branch_number) = 0 AND LEN(official_association_number) = 3 THEN '0' + official_association_number
											WHEN LEN(official_branch_number) = 0 AND LEN(official_association_number) > 3 THEN official_association_number
											ELSE official_branch_number
										END official_branch_number,
										form_code,
										batch_number,
										file_name,
										job_order_number,
										member_key,
										response_channel,
										REPLACE([t_01] ,'"', '') [t_01],
										[t_01_category],
										REPLACE([t_02] ,'"', '') [t_02],
										[t_02_category],
										REPLACE([t_03] ,'"', '') [t_03],
										[t_03_category],
										REPLACE([t_04] ,'"', '') [t_04],
										[t_04_category],
										REPLACE([t_05] ,'"', '') [t_05],
										[t_05_category],
										REPLACE([t_06] ,'"', '') [t_06],
										[t_06_category],
										REPLACE([t_07] ,'"', '') [t_07],
										[t_07_category],
										REPLACE([t_08] ,'"', '') [t_08],
										[t_08_category],
										REPLACE([t_09] ,'"', '') [t_09],
										[t_09_category],
										REPLACE([t_10] ,'"', '') [t_10],
										[t_10_category]

								FROM	dbo.Response_Data
								
								WHERE	current_indicator = 1
								) PVT
								UNPIVOT
								(closed_response FOR closed_question IN	(t_01_category,
																			t_02_category,
																			t_03_category,
																			t_04_category,
																			t_05_category,
																			t_06_category,
																			t_07_category,
																			t_08_category,
																			t_09_category,
																			t_10_category
																			)
								) as UPVT1
								UNPIVOT
								(open_response FOR open_question IN	(t_01,
																		t_02,
																		t_03,
																		t_04,
																		t_05,
																		t_06,
																		t_07,
																		t_08,
																		t_09,
																		t_10
																		)
								) as UPVT2
					) A
				) E
				LEFT JOIN Seer_MDM.dbo.Batch F
					ON E.batch_number = F.batch_number
						AND E.form_code = F.form_code;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Open_Ends AS target
	USING	(
			SELECT	A.current_indicator,
					A.module,
					A.batch_number,
					A.report_date,
					A.official_association_number,
					A.official_branch_number,
					A.form_code,
					A.member_key,
					A.response_channel,
					A.closed_question,
					A.closed_response,
					A.open_question,
					A.open_response

			FROM	#OED A
			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.form_code = source.form_code
				AND target.member_key = source.member_key
				AND target.closed_question = source.closed_question
				AND target.open_question = source.open_question
			
			WHEN MATCHED AND (target.[report_date] <> source.[report_date]
								OR target.[response_channel] <> source.[response_channel]
								OR target.[closed_response] <> source.[closed_response]
								OR target.[open_response] <> source.[open_response]
							)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([module],
					[batch_number],
					[report_date],
					[official_association_number],
					[official_branch_number],
					[form_code],
					[member_key],
					[response_channel],
					[closed_question],
					[closed_response],
					[open_question],
					[open_response]
					)
			VALUES ([module],
					[batch_number],
					[report_date],
					[official_association_number],
					[official_branch_number],
					[form_code],
					[member_key],
					[response_channel],
					[closed_question],
					[closed_response],
					[open_question],
					[open_response]
					)		
	;
COMMIT TRAN

BEGIN TRAN
MERGE	Seer_ODS.dbo.Open_Ends AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.current_indicator,
					A.module,
					A.batch_number,
					A.report_date,
					A.official_association_number,
					A.official_branch_number,
					A.form_code,
					A.member_key,
					A.response_channel,
					A.closed_question,
					A.closed_response,
					A.open_question,
					A.open_response

			FROM	#OED A
			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.form_code = source.form_code
				AND target.member_key = source.member_key
				AND target.closed_question = source.closed_question
				AND target.open_question = source.open_question
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[module],
					[batch_number],
					[report_date],
					[official_association_number],
					[official_branch_number],
					[form_code],
					[member_key],
					[response_channel],
					[closed_question],
					[closed_response],
					[open_question],
					[open_response]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[module],
					[batch_number],
					[report_date],
					[official_association_number],
					[official_branch_number],
					[form_code],
					[member_key],
					[response_channel],
					[closed_question],
					[closed_response],
					[open_question],
					[open_response]
					)
	;
COMMIT TRAN

BEGIN TRAN
	DROP TABLE #OED;
COMMIT TRAN
END