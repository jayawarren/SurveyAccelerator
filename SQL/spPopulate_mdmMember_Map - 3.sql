/*
drop procedure spPopulate_mdmMember_Map
truncate table Seer_MDM.dbo.Member_Map
*/
CREATE PROCEDURE spPopulate_mdmMember_Map AS
BEGIN

	SELECT	A.member_key,
			A.seer_key,
			A.member_cleansed_id
	
	INTO	#RSLT
	
	FROM	(
			SELECT	D.Seer_Key seer_key,
					D.MemberCleansedID member_cleansed_id,
					max(C.member_key) member_key
					
			 FROM	Seer_MDM.dbo.Member C
					INNER JOIN Seer_STG.dbo.Member D
						ON C.member_cleansed_id = D.MemberCleansedID
			 
			 WHERE	C.current_indicator = 1
			 
			 GROUP BY D.Seer_Key,
					D.MemberCleansedID
			) A
			
	ORDER BY A.member_key;
	
	MERGE	Seer_MDM.dbo.Member_Map AS target
	USING	(
			SELECT	B.member_map_key,
					A.member_key,
					COALESCE(C.member_key, A.member_key) matching_member_key,
					COALESCE(C.seer_key, A.member_cleansed_id) seer_key,
					COALESCE(D.organization_key, 0) organization_key,
					COALESCE(C.member_cleansed_id, A.member_cleansed_id) member_cleansed_id,
					COALESCE(B.confidence_percentage, 1) confidence_percentage
			
			FROM	Seer_MDM.dbo.Member A
					LEFT JOIN Seer_MDM.dbo.Organization D
						ON A.organization_id = D.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.member_key = B.member_key
							AND A.Member_Key = B.matching_member_key
					LEFT JOIN #RSLT C
						ON A.member_key = C.member_key
			
			WHERE	A.current_indicator = 1
					AND D.current_indicator = 1
			
			GROUP BY B.member_map_key,
					A.member_key,
					COALESCE(C.member_key, A.member_key),
					COALESCE(C.seer_key, A.member_cleansed_id),
					COALESCE(D.organization_key, 0),
					COALESCE(C.member_cleansed_id, A.member_cleansed_id),
					COALESCE(B.confidence_percentage, 1)

			) AS source
			ON target.member_map_key = source.member_map_key
			
	WHEN MATCHED AND (target.confidence_percentage	 <> 	source.confidence_percentage
						)
		THEN
			UPDATE	
			SET		confidence_percentage	 = 	source.confidence_percentage

						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT (member_key,
					matching_member_key,
					seer_key,
					organization_key,
					member_cleansed_id,
					confidence_percentage
					)
			VALUES (member_key,
					matching_member_key,
					seer_key,
					organization_key,
					member_cleansed_id,
					confidence_percentage
					)			
	;
END