/*
truncate table Seer_ODS.dbo.Observation_Data
drop procedure spPopulate_odsObservation_Data
truncate table Seer_CTRL.dbo.[Observation Data]
*/
CREATE PROCEDURE spPopulate_odsObservation_Data AS
BEGIN
	MERGE	Seer_ODS.dbo.Observation_Data AS target
	USING	(
			SELECT	COALESCE(C.member_key, B.member_key) member_key,
					A.[Seer_Key] seer_key,
					A.[CreateDateTime] create_datetime,
					A.[Form_Code] form_code,
					CASE WHEN LEN(A.[Batch_Number]) = 3 THEN A.[Batch_Number] + '.0'
						ELSE A.[Batch_Number]
					END batch_number,
					CASE WHEN LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						ELSE A.[Off_Assoc_Num]
					END official_association_number,
					CASE WHEN LEN(A.[Off_Br_Num]) = 3 THEN '0' + A.[Off_Br_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) <> 3 THEN A.[Off_Assoc_Num]
						ELSE A.[Off_Br_Num]
					END official_branch_number,
					A.[Channel] channel,
					H.program_site_location site_location,
					CASE WHEN A.[Status] = 'R' THEN 'Received'
						WHEN A.[Status] = 'S' THEN 'Sent'
						ELSE A.[Status]
					END status,
					CASE WHEN LEN(A.[Response_Date]) = 0 THEN '1900-01-01'
						ELSE A.[Response_Date]
					END response_date

			FROM	Seer_STG.dbo.[Observation Data] A
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.Seer_Key = B.seer_key
					LEFT JOIN Seer_MDM.dbo.Member C
						ON A.Member_Key = C.member_key
					LEFT JOIN Seer_MDM.dbo.Organization D
						ON A.Off_Assoc_Num = D.association_number
						 AND A.Off_Br_Num = D.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Batch E
						ON A.batch_number = E.batch_number
					LEFT JOIN Seer_MDM.dbo.Survey_Form F
						ON A.form_code = F.survey_form_code
					LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map G
						ON COALESCE(C.member_key, B.member_key) = G.member_key
							AND D.organization_key = G.organization_key
							AND E.batch_key = G.batch_key
							AND F.survey_form_key = G.survey_form_key
					LEFT JOIN Seer_MDM.dbo.Program_Group H
						ON G.program_group_key = H.program_group_key
						
			WHERE	ISNUMERIC(A.[Seer_Key]) = 1
			
			UNION
			
			SELECT	COALESCE(C.member_key, B.member_key) member_key,
					A.[Seer_Key] seer_key,
					A.[CreateDateTime] create_datetime,
					A.[Form_Code] form_code,
					CASE WHEN LEN(A.[Batch_Number]) = 3 THEN A.[Batch_Number] + '.0'
						ELSE A.[Batch_Number]
					END batch_number,
					CASE WHEN LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						ELSE A.[Off_Assoc_Num]
					END official_association_number,
					CASE WHEN LEN(A.[Off_Br_Num]) = 3 THEN '0' + A.[Off_Br_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) <> 3 THEN A.[Off_Assoc_Num]
						ELSE A.[Off_Br_Num]
					END official_branch_number,
					A.[Channel] channel,
					H.program_site_location site_location,
					'Sent' status,
					CASE WHEN LEN(A.[Response_Date]) = 0 THEN '1900-01-01'
						ELSE A.[Response_Date]
					END response_date

			FROM	Seer_STG.dbo.[Observation Data] A
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.Seer_Key = B.seer_key
					LEFT JOIN Seer_MDM.dbo.Member C
						ON A.Member_Key = C.member_key
					LEFT JOIN Seer_MDM.dbo.Organization D
						ON A.Off_Assoc_Num = D.association_number
						 AND A.Off_Br_Num = D.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Batch E
						ON A.batch_number = E.batch_number
					LEFT JOIN Seer_MDM.dbo.Survey_Form F
						ON A.form_code = F.survey_form_code
					LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map G
						ON COALESCE(C.member_key, B.member_key) = G.member_key
							AND D.organization_key = G.organization_key
							AND E.batch_key = G.batch_key
							AND F.survey_form_key = G.survey_form_key
					LEFT JOIN Seer_MDM.dbo.Program_Group H
						ON G.program_group_key = H.program_group_key
						
			WHERE	ISNUMERIC(A.[Seer_Key]) = 1
					AND A.[Status] IN ('R')
			
			) AS source
			ON target.member_key = source.member_key
				AND target.form_code = source.form_code
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.status = source.status
				
				
			
	WHEN MATCHED AND ((target.channel <> source.channel
						OR target.response_date	<> source.response_date)
						AND ISDATE(source.response_date) = 1
					)
		THEN
			UPDATE	
			SET	channel = source.channel,
				response_date = source.response_date


						
	WHEN NOT MATCHED BY target AND
		(source.member_key IS NOT NULL
			AND LEN(source.form_code) > 0
			AND LEN(source.batch_number) > 0
			AND LEN(source.official_association_number) > 0
			AND LEN(source.status) > 0
			AND ISDATE(source.response_date) = 1
		)
		THEN 
			INSERT ([member_key],
					[form_code],
					[batch_number],
					[official_association_number],
					[official_branch_number],
					[channel],
					[status],
					[response_date]
					)
			VALUES ([member_key],
					[form_code],
					[batch_number],
					[official_association_number],
					[official_branch_number],
					[channel],
					[status],
					[response_date]
					)
					
	;
	INSERT INTO Seer_CTRL.dbo.[Observation Data]([Member_Key],
												[Seer_Key],
												[Form_Code],
												[Batch_Number],
												[Off_Assoc_Num],
												[Off_Br_Num],
												[Channel],
												[Status],
												[Response_Date],
												[CreateDateTime]
												)
	SELECT	A.[Member_Key],
			A.[Seer_Key],
			A.[Form_Code],
			A.[Batch_Number],
			A.[Off_Assoc_Num],
			A.[Off_Br_Num],
			A.[Channel],
			A.[Status],
			A.[Response_Date],
			A.[CreateDateTime]
			
	FROM	Seer_STG.dbo.[Observation Data] A
			LEFT JOIN Seer_MDM.dbo.Member_Map B
				ON A.Seer_Key = B.seer_key
			LEFT JOIN Seer_MDM.dbo.Member C
				ON A.Member_Key = C.member_key

	WHERE	ISNUMERIC(A.[Seer_Key]) = 1
			AND ISDATE(A.Response_Date) = 1
			AND (COALESCE(B.member_key, C.member_key) IS NULL
				OR LEN(A.[Form_Code]) = 0
				OR LEN(A.[Batch_Number]) = 0
				OR LEN(A.[Off_Assoc_Num]) = 0
				OR LEN(A.[Status]) = 0
				)
				
	UNION ALL
	
	SELECT	A.[Member_Key],
			A.[Seer_Key],
			A.[Form_Code],
			A.[Batch_Number],
			A.[Off_Assoc_Num],
			A.[Off_Br_Num],
			A.[Channel],
			A.[Status],
			A.[Response_Date],
			A.[CreateDateTime]
			
	FROM	Seer_STG.dbo.[Observation Data] A

	WHERE	ISNUMERIC(A.[Seer_Key]) = 0
			OR ISDATE(A.[Response_Date]) = 0

	;
END