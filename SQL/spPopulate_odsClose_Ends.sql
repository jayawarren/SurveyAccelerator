/*
truncate table Seer_ODS.dbo.Close_Ends
drop procedure spPopulate_odsClose_Ends
select * from Seer_ODS.dbo.Close_Ends
*/
CREATE PROCEDURE spPopulate_odsClose_Ends AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Close_Ends AS target
	USING	(
			SELECT	1 current_indicator,
					E.module,
					E.batch_number,
					COALESCE(F.report_date, '1900-01-01') report_date,
					E.official_association_number,
					E.official_branch_number,
					E.form_code,
					E.member_key,
					E.response_channel,
					E.question,
					E.response

			FROM	(SELECT	A.module,
							CASE WHEN LEN(A.batch_number) > 0 THEN A.batch_number
									ELSE COALESCE(B.batch_number, C.batch_number, D.batch_number, '000.0')
							END batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code,
							A.member_key,
							A.response_channel,
							A.question,
							A.response
							
					FROM	(SELECT	module,
									official_association_number,
									official_branch_number,
									form_code,
									batch_number,
									file_name,
									job_order_number,
									member_key,
									response_channel,
									question,
									response

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
												[q_01],
												[q_02],
												[q_03],
												[q_04],
												[q_05],
												[q_06],
												[q_07],
												[q_08],
												[q_09],
												[q_10],
												[q_11],
												[q_12],
												[q_13],
												[q_14],
												[q_15],
												[q_16],
												[q_17],
												[q_18],
												[q_19],
												[q_20],
												[q_21],
												[q_22],
												[q_23],
												[q_24],
												[q_25],
												[q_26],
												[q_27],
												[q_28],
												[q_29],
												[q_30],
												[q_31],
												[q_32],
												[q_33],
												[q_34],
												[q_35],
												[q_36],
												[q_37],
												[q_38],
												[q_39],
												[q_40],
												[q_41],
												[q_42],
												[q_43],
												[q_44],
												[q_45],
												[q_46],
												[q_47],
												[q_48],
												[q_49],
												[q_50],
												[q_51],
												[q_52],
												[q_53],
												[q_54],
												[q_55],
												[q_56],
												[q_57],
												[q_58],
												[q_59],
												[q_60],
												[q_61],
												[q_62],
												[q_63],
												[q_64],
												[q_65],
												[q_66],
												[q_67],
												[q_68],
												[q_69],
												[q_70],
												[q_71],
												[q_72],
												[q_73],
												[q_74],
												[q_75],
												CONVERT(TINYINT, [m_01a]) [m_01a],
												CONVERT(TINYINT, [m_01b]) [m_01b],
												CONVERT(TINYINT, [m_01c]) [m_01c],
												CONVERT(TINYINT, [m_01d]) [m_01d],
												CONVERT(TINYINT, [m_01e]) [m_01e],
												CONVERT(TINYINT, [m_01f]) [m_01f],
												CONVERT(TINYINT, [m_02a]) [m_02a],
												CONVERT(TINYINT, [m_02b]) [m_02b],
												CONVERT(TINYINT, [m_02c]) [m_02c],
												CONVERT(TINYINT, [m_02d]) [m_02d],
												CONVERT(TINYINT, [m_02e]) [m_02e],
												CONVERT(TINYINT, [m_02f]) [m_02f],
												CONVERT(TINYINT, [m_03a]) [m_03a],
												CONVERT(TINYINT, [m_03b]) [m_03b],
												CONVERT(TINYINT, [m_03c]) [m_03c],
												CONVERT(TINYINT, [m_03d]) [m_03d],
												CONVERT(TINYINT, [m_03e]) [m_03e],
												CONVERT(TINYINT, [m_03f]) [m_03f],
												CONVERT(TINYINT, [m_04a]) [m_04a],
												CONVERT(TINYINT, [m_04b]) [m_04b],
												CONVERT(TINYINT, [m_04c]) [m_04c],
												CONVERT(TINYINT, [m_04d]) [m_04d],
												CONVERT(TINYINT, [m_04e]) [m_04e],
												CONVERT(TINYINT, [m_04f]) [m_04f],
												CONVERT(TINYINT, [m_05a]) [m_05a],
												CONVERT(TINYINT, [m_05b]) [m_05b],
												CONVERT(TINYINT, [m_05c]) [m_05c],
												CONVERT(TINYINT, [m_05d]) [m_05d],
												CONVERT(TINYINT, [m_05e]) [m_05e],
												CONVERT(TINYINT, [m_05f]) [m_05f],
												CONVERT(TINYINT, [c_01]) [c_01],
												CONVERT(TINYINT, [c_02]) [c_02],
												CONVERT(TINYINT, [c_03]) [c_03],
												CONVERT(TINYINT, [c_04]) [c_04],
												CONVERT(TINYINT, [c_05]) [c_05],
												CONVERT(TINYINT, [c_06]) [c_06]


										FROM	dbo.Response_Data
										
										WHERE	current_indicator = 1
										) PVT
										UNPIVOT
										(response FOR question IN ([q_01],
																	[q_02],
																	[q_03],
																	[q_04],
																	[q_05],
																	[q_06],
																	[q_07],
																	[q_08],
																	[q_09],
																	[q_10],
																	[q_11],
																	[q_12],
																	[q_13],
																	[q_14],
																	[q_15],
																	[q_16],
																	[q_17],
																	[q_18],
																	[q_19],
																	[q_20],
																	[q_21],
																	[q_22],
																	[q_23],
																	[q_24],
																	[q_25],
																	[q_26],
																	[q_27],
																	[q_28],
																	[q_29],
																	[q_30],
																	[q_31],
																	[q_32],
																	[q_33],
																	[q_34],
																	[q_35],
																	[q_36],
																	[q_37],
																	[q_38],
																	[q_39],
																	[q_40],
																	[q_41],
																	[q_42],
																	[q_43],
																	[q_44],
																	[q_45],
																	[q_46],
																	[q_47],
																	[q_48],
																	[q_49],
																	[q_50],
																	[q_51],
																	[q_52],
																	[q_53],
																	[q_54],
																	[q_55],
																	[q_56],
																	[q_57],
																	[q_58],
																	[q_59],
																	[q_60],
																	[q_61],
																	[q_62],
																	[q_63],
																	[q_64],
																	[q_65],
																	[q_66],
																	[q_67],
																	[q_68],
																	[q_69],
																	[q_70],
																	[q_71],
																	[q_72],
																	[q_73],
																	[q_74],
																	[q_75],
																	[m_01a],
																	[m_01b],
																	[m_01c],
																	[m_01d],
																	[m_01e],
																	[m_01f],
																	[m_02a],
																	[m_02b],
																	[m_02c],
																	[m_02d],
																	[m_02e],
																	[m_02f],
																	[m_03a],
																	[m_03b],
																	[m_03c],
																	[m_03d],
																	[m_03e],
																	[m_03f],
																	[m_04a],
																	[m_04b],
																	[m_04c],
																	[m_04d],
																	[m_04e],
																	[m_04f],
																	[m_05a],
																	[m_05b],
																	[m_05c],
																	[m_05d],
																	[m_05e],
																	[m_05f],
																	[c_01],
																	[c_02],
																	[c_03],
																	[c_04],
																	[c_05],
																	[c_06])
										)AS UPVT
							) A
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									file_name,
									SUBSTRING(REPLACE(REPLACE(REPLACE(file_name, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 2, 5) batch_number
							FROM	Seer_ODS.dbo.[Response_Data]	
							WHERE	file_name IS NOT NULL
									AND module = 'Program'
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(file_name, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 1, 1) = 'B'
							) B
							ON A.module = B.module
								AND A.form_code = B.form_code
								AND A.file_name = B.file_name
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									job_order_number,
									SUBSTRING(RIGHT(job_order_number, 4), 1, 3) + '.0' batch_number
							FROM	Seer_ODS.dbo.[Response_Data]
							WHERE	LEN(job_order_number) > 10
									AND module = 'Member'
							) C
							ON A.module = C.module
								AND A.form_code = C.form_code
								AND A.job_order_number = C.job_order_number
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									file_name,
									SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(file_name, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 2, 5) batch_number
							FROM	Seer_ODS.dbo.[Response_Data]
							WHERE	file_name IS NOT NULL
									AND module = 'Staff'
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(file_name, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 1, 1) = 'B'
									AND LEN(FORM_CODE) > 0
							) D
							ON A.module = D.module
								AND A.form_code = D.form_code
								AND A.file_name = D.file_name
						) E
						LEFT JOIN Seer_MDM.dbo.Batch F
						ON E.batch_number = SUBSTRING(F.batch_number, 1, 5)
							AND E.form_code = F.form_code

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.form_code = source.form_code
				AND target.member_key = source.member_key
				AND target.question = source.question
			
			WHEN MATCHED AND (target.[report_date] <> source.[report_date]
								OR target.[response_channel] <> source.[response_channel]
								OR target.[response] <> source.[response]
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
					[question],
					[response]
					)
			VALUES ([module],
					[batch_number],
					[report_date],
					[official_association_number],
					[official_branch_number],
					[form_code],
					[member_key],
					[response_channel],
					[question],
					[response]
					)		
	;
COMMIT TRAN

BEGIN TRAN
MERGE	Seer_ODS.dbo.Close_Ends AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					1 current_indicator,
					E.module,
					E.batch_number,
					COALESCE(F.report_date, '1900-01-01') report_date,
					E.official_association_number,
					E.official_branch_number,
					E.form_code,
					E.member_key,
					E.response_channel,
					E.question,
					E.response

			FROM	(SELECT	A.module,
							CASE WHEN LEN(A.batch_number) > 0 THEN A.batch_number
									ELSE COALESCE(B.batch_number, C.batch_number, D.batch_number, '000.0')
							END batch_number,
							A.official_association_number,
							A.official_branch_number,
							A.form_code,
							A.member_key,
							A.response_channel,
							A.question,
							A.response
							
					FROM	(SELECT	module,
									official_association_number,
									official_branch_number,
									form_code,
									batch_number,
									file_name,
									job_order_number,
									member_key,
									response_channel,
									question,
									response

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
												[q_01],
												[q_02],
												[q_03],
												[q_04],
												[q_05],
												[q_06],
												[q_07],
												[q_08],
												[q_09],
												[q_10],
												[q_11],
												[q_12],
												[q_13],
												[q_14],
												[q_15],
												[q_16],
												[q_17],
												[q_18],
												[q_19],
												[q_20],
												[q_21],
												[q_22],
												[q_23],
												[q_24],
												[q_25],
												[q_26],
												[q_27],
												[q_28],
												[q_29],
												[q_30],
												[q_31],
												[q_32],
												[q_33],
												[q_34],
												[q_35],
												[q_36],
												[q_37],
												[q_38],
												[q_39],
												[q_40],
												[q_41],
												[q_42],
												[q_43],
												[q_44],
												[q_45],
												[q_46],
												[q_47],
												[q_48],
												[q_49],
												[q_50],
												[q_51],
												[q_52],
												[q_53],
												[q_54],
												[q_55],
												[q_56],
												[q_57],
												[q_58],
												[q_59],
												[q_60],
												[q_61],
												[q_62],
												[q_63],
												[q_64],
												[q_65],
												[q_66],
												[q_67],
												[q_68],
												[q_69],
												[q_70],
												[q_71],
												[q_72],
												[q_73],
												[q_74],
												[q_75],
												CONVERT(TINYINT, [m_01a]) [m_01a],
												CONVERT(TINYINT, [m_01b]) [m_01b],
												CONVERT(TINYINT, [m_01c]) [m_01c],
												CONVERT(TINYINT, [m_01d]) [m_01d],
												CONVERT(TINYINT, [m_01e]) [m_01e],
												CONVERT(TINYINT, [m_01f]) [m_01f],
												CONVERT(TINYINT, [m_02a]) [m_02a],
												CONVERT(TINYINT, [m_02b]) [m_02b],
												CONVERT(TINYINT, [m_02c]) [m_02c],
												CONVERT(TINYINT, [m_02d]) [m_02d],
												CONVERT(TINYINT, [m_02e]) [m_02e],
												CONVERT(TINYINT, [m_02f]) [m_02f],
												CONVERT(TINYINT, [m_03a]) [m_03a],
												CONVERT(TINYINT, [m_03b]) [m_03b],
												CONVERT(TINYINT, [m_03c]) [m_03c],
												CONVERT(TINYINT, [m_03d]) [m_03d],
												CONVERT(TINYINT, [m_03e]) [m_03e],
												CONVERT(TINYINT, [m_03f]) [m_03f],
												CONVERT(TINYINT, [m_04a]) [m_04a],
												CONVERT(TINYINT, [m_04b]) [m_04b],
												CONVERT(TINYINT, [m_04c]) [m_04c],
												CONVERT(TINYINT, [m_04d]) [m_04d],
												CONVERT(TINYINT, [m_04e]) [m_04e],
												CONVERT(TINYINT, [m_04f]) [m_04f],
												CONVERT(TINYINT, [m_05a]) [m_05a],
												CONVERT(TINYINT, [m_05b]) [m_05b],
												CONVERT(TINYINT, [m_05c]) [m_05c],
												CONVERT(TINYINT, [m_05d]) [m_05d],
												CONVERT(TINYINT, [m_05e]) [m_05e],
												CONVERT(TINYINT, [m_05f]) [m_05f],
												CONVERT(TINYINT, [c_01]) [c_01],
												CONVERT(TINYINT, [c_02]) [c_02],
												CONVERT(TINYINT, [c_03]) [c_03],
												CONVERT(TINYINT, [c_04]) [c_04],
												CONVERT(TINYINT, [c_05]) [c_05],
												CONVERT(TINYINT, [c_06]) [c_06]


										FROM	dbo.Response_Data
										
										WHERE	current_indicator = 1
										) PVT
										UNPIVOT
										(response FOR question IN ([q_01],
																	[q_02],
																	[q_03],
																	[q_04],
																	[q_05],
																	[q_06],
																	[q_07],
																	[q_08],
																	[q_09],
																	[q_10],
																	[q_11],
																	[q_12],
																	[q_13],
																	[q_14],
																	[q_15],
																	[q_16],
																	[q_17],
																	[q_18],
																	[q_19],
																	[q_20],
																	[q_21],
																	[q_22],
																	[q_23],
																	[q_24],
																	[q_25],
																	[q_26],
																	[q_27],
																	[q_28],
																	[q_29],
																	[q_30],
																	[q_31],
																	[q_32],
																	[q_33],
																	[q_34],
																	[q_35],
																	[q_36],
																	[q_37],
																	[q_38],
																	[q_39],
																	[q_40],
																	[q_41],
																	[q_42],
																	[q_43],
																	[q_44],
																	[q_45],
																	[q_46],
																	[q_47],
																	[q_48],
																	[q_49],
																	[q_50],
																	[q_51],
																	[q_52],
																	[q_53],
																	[q_54],
																	[q_55],
																	[q_56],
																	[q_57],
																	[q_58],
																	[q_59],
																	[q_60],
																	[q_61],
																	[q_62],
																	[q_63],
																	[q_64],
																	[q_65],
																	[q_66],
																	[q_67],
																	[q_68],
																	[q_69],
																	[q_70],
																	[q_71],
																	[q_72],
																	[q_73],
																	[q_74],
																	[q_75],
																	[m_01a],
																	[m_01b],
																	[m_01c],
																	[m_01d],
																	[m_01e],
																	[m_01f],
																	[m_02a],
																	[m_02b],
																	[m_02c],
																	[m_02d],
																	[m_02e],
																	[m_02f],
																	[m_03a],
																	[m_03b],
																	[m_03c],
																	[m_03d],
																	[m_03e],
																	[m_03f],
																	[m_04a],
																	[m_04b],
																	[m_04c],
																	[m_04d],
																	[m_04e],
																	[m_04f],
																	[m_05a],
																	[m_05b],
																	[m_05c],
																	[m_05d],
																	[m_05e],
																	[m_05f],
																	[c_01],
																	[c_02],
																	[c_03],
																	[c_04],
																	[c_05],
																	[c_06])
										)AS UPVT
							) A
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									file_name,
									SUBSTRING(REPLACE(REPLACE(REPLACE(file_name, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 2, 5) batch_number
							FROM	Seer_ODS.dbo.[Response_Data]	
							WHERE	file_name IS NOT NULL
									AND module = 'Program'
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(file_name, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 1, 1) = 'B'
							) B
							ON A.module = B.module
								AND A.form_code = B.form_code
								AND A.file_name = B.file_name
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									job_order_number,
									SUBSTRING(RIGHT(job_order_number, 4), 1, 3) + '.0' batch_number
							FROM	Seer_ODS.dbo.[Response_Data]
							WHERE	LEN(job_order_number) > 10
									AND module = 'Member'
							) C
							ON A.module = C.module
								AND A.form_code = C.form_code
								AND A.job_order_number = C.job_order_number
							LEFT JOIN
							(
							SELECT	distinct
									module,
									form_code,
									file_name,
									SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(file_name, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 2, 5) batch_number
							FROM	Seer_ODS.dbo.[Response_Data]
							WHERE	file_name IS NOT NULL
									AND module = 'Staff'
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(file_name, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 1, 1) = 'B'
									AND LEN(FORM_CODE) > 0
							) D
							ON A.module = D.module
								AND A.form_code = D.form_code
								AND A.file_name = D.file_name
						) E
						LEFT JOIN Seer_MDM.dbo.Batch F
						ON E.batch_number = SUBSTRING(F.batch_number, 1, 5)
							AND E.form_code = F.form_code

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.form_code = source.form_code
				AND target.member_key = source.member_key
				AND target.question = source.question
						
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
					[question],
					[response]
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
					[question],
					[response]
					)
	;
COMMIT TRAN
END