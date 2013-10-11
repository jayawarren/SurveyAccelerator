/*
truncate table Seer_ODS.dbo.Observation_Data
drop procedure spPopulate_odsObservation_Data
truncate table Seer_CTRL.dbo.[Observation Data]
select * from Seer_ODS.dbo.Observation_Data where LEN(site_location) > 0 and status = 'Received'
select * from Seer_CTRL.dbo.[Observation Data]
*/
CREATE PROCEDURE spPopulate_odsObservation_Data AS
BEGIN
	MERGE	Seer_ODS.dbo.Observation_Data AS target
	USING	(
			SELECT	distinct
					COALESCE(C.member_key, H.member_key, 0) member_key,
					A.[Seer_Key] seer_key,
					A.[CreateDateTime] create_datetime,
					A.[Form_Code] form_code,
					A.[Batch_Number] batch_number,
					CASE WHEN LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						ELSE A.[Off_Assoc_Num]
					END official_association_number,
					CASE WHEN LEN(A.[Off_Br_Num]) = 3 THEN '0' + A.[Off_Br_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) <> 3 THEN A.[Off_Assoc_Num]
						ELSE A.[Off_Br_Num]
					END official_branch_number,
					A.[Channel] channel,
					REPLACE(COALESCE(G.program_site_location, ''), 'NULL', '') site_location,
					CASE WHEN A.[Status] = 'R' THEN 'Received'
						WHEN A.[Status] = 'S' THEN 'Sent'
						ELSE A.[Status]
					END status,
					CASE WHEN (LEN(A.[Response_Date]) = 0 OR ISDATE(A.[Response_Date]) = 0) THEN '1900-01-01'
						ELSE A.[Response_Date]
					END response_date
			
			FROM	Seer_STG.dbo.[Observation Data] A
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.Seer_Key = B.seer_key
					LEFT JOIN Seer_MDM.dbo.Member C
						ON A.Member_Key = C.member_key
					LEFT JOIN Seer_MDM.dbo.Member H
						ON B.member_key = H.member_key
					LEFT JOIN Seer_MDM.dbo.Organization D
						ON A.Off_Assoc_Num = D.association_number
						 AND A.Off_Br_Num = D.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Batch E
						ON A.batch_number = E.batch_number
					LEFT JOIN Seer_MDM.dbo.Survey_Form F
						ON A.form_code = F.survey_form_code
					LEFT JOIN Seer_MDM.dbo.Program_Group G
						ON D.organization_key = G.organization_key
							AND COALESCE(H.program_site_location, C.program_site_location) = G.program_site_location
							AND D.organization_key = G.organization_key
						
			WHERE	ISNUMERIC(A.[Seer_Key]) = 1
					AND COALESCE(C.current_indicator, 1) = 1
					AND COALESCE(D.current_indicator, 1) = 1
					AND COALESCE(E.current_indicator, 1) = 1
					AND COALESCE(F.current_indicator, 1) = 1
					AND COALESCE(G.current_indicator, 1) = 1
					AND COALESCE(H.current_indicator, 1) = 1
			
			UNION
			
			SELECT	distinct
					COALESCE(C.member_key, H.member_key, 0) member_key,
					A.[Seer_Key] seer_key,
					A.[CreateDateTime] create_datetime,
					A.[Form_Code] form_code,
					A.[Batch_Number] batch_number,
					CASE WHEN LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						ELSE A.[Off_Assoc_Num]
					END official_association_number,
					CASE WHEN LEN(A.[Off_Br_Num]) = 3 THEN '0' + A.[Off_Br_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) = 3 THEN '0' + A.[Off_Assoc_Num]
						WHEN LEN(A.[Off_Br_Num]) = 0 AND LEN(A.[Off_Assoc_Num]) <> 3 THEN A.[Off_Assoc_Num]
						ELSE A.[Off_Br_Num]
					END official_branch_number,
					A.[Channel] channel,
					REPLACE(COALESCE(G.program_site_location, ''), 'NULL', '') site_location,
					'Sent' status,
					CASE WHEN (LEN(A.[Response_Date]) = 0 OR ISDATE(A.[Response_Date]) = 0) THEN '1900-01-01'
						ELSE A.[Response_Date]
					END response_date

			FROM	Seer_STG.dbo.[Observation Data] A
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.Seer_Key = B.seer_key
					LEFT JOIN Seer_MDM.dbo.Member C
						ON A.Member_Key = C.member_key
					LEFT JOIN Seer_MDM.dbo.Member H
						ON B.member_key = H.member_key
					LEFT JOIN Seer_MDM.dbo.Organization D
						ON A.Off_Assoc_Num = D.association_number
						 AND A.Off_Br_Num = D.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Batch E
						ON A.batch_number = E.batch_number
					LEFT JOIN Seer_MDM.dbo.Survey_Form F
						ON A.form_code = F.survey_form_code
					LEFT JOIN Seer_MDM.dbo.Program_Group G
						ON D.organization_key = G.organization_key
							AND COALESCE(H.program_site_location, C.program_site_location) = G.program_site_location
							AND D.organization_key = G.organization_key
						
			WHERE	ISNUMERIC(A.[Seer_Key]) = 1
					AND COALESCE(C.current_indicator, 1) = 1
					AND COALESCE(D.current_indicator, 1) = 1
					AND COALESCE(E.current_indicator, 1) = 1
					AND COALESCE(F.current_indicator, 1) = 1
					AND COALESCE(G.current_indicator, 1) = 1
					AND COALESCE(H.current_indicator, 1) = 1
					AND A.[Status] IN ('R')
			
			) AS source
			ON (target.member_key = source.member_key OR target.seer_key = source.seer_key)
				AND target.form_code = source.form_code
				AND target.batch_number = source.batch_number
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
				AND target.status = source.status
				
	WHEN MATCHED AND (target.member_key <> source.member_key
						OR target.seer_key <> source.seer_key
						OR target.channel <> source.channel
						OR target.response_date <> source.response_date
					)
		THEN
			UPDATE	
			SET	member_key = source.member_key,
				seer_key = source.seer_key,
				channel = source.channel,
				response_date = source.response_date
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
			AND LEN(source.batch_number) > 0
			AND LEN(source.official_association_number) > 0
			AND LEN(source.status) > 0
		)
		THEN 
			INSERT ([member_key],
					[seer_key],
					[form_code],
					[batch_number],
					[official_association_number],
					[official_branch_number],
					[site_location],
					[channel],
					[status],
					[response_date]
					)
			VALUES ([member_key],
					[seer_key],
					[form_code],
					[batch_number],
					[official_association_number],
					[official_branch_number],
					[site_location],
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
	SELECT	distinct
			A.[Member_Key],
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
			LEFT JOIN Seer_MDM.dbo.Member H
				ON B.member_key = H.member_key

	WHERE	ISNUMERIC(A.Seer_Key) = 1
			AND
			(COALESCE(C.member_key, H.member_key) IS NULL
			OR LEN(A.[Form_Code]) = 0
			OR LEN(A.[Batch_Number]) = 0
			OR LEN(A.[Off_Assoc_Num]) = 0
			OR LEN(A.[Status]) = 0	)
			
	UNION
	
	SELECT	distinct
			A.[Member_Key],
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
			LEFT JOIN Seer_MDM.dbo.Member H
				ON B.member_key = H.member_key

	WHERE	ISNUMERIC(A.Member_Key) = 1
			AND
			(COALESCE(C.member_key, H.member_key) IS NULL
			OR LEN(A.[Form_Code]) = 0
			OR LEN(A.[Batch_Number]) = 0
			OR LEN(A.[Off_Assoc_Num]) = 0
			OR LEN(A.[Status]) = 0	)
			
	UNION
	
	SELECT	distinct
			A.[Member_Key],
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

	WHERE	ISNUMERIC(A.Seer_Key) = 0
			AND ISNUMERIC(A.Member_Key) = 0
				
	;
END