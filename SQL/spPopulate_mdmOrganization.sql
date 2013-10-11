/*
drop procedure spPopulate_mdmOrganization
truncate table dbo.Organization
select * from dbo.Organization
*/
CREATE PROCEDURE spPopulate_mdmOrganization AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

	BEGIN TRAN
		MERGE	Seer_MDM.dbo.Organization AS target
		USING	(
				SELECT	1 current_indicator,
						OrganizationName organization_name,
						OrganizationNumber organization_number,
						AssociationName association_name,
						AssociationNumber association_number,
						OfficialBranchName official_branch_name,
						ShortBranchName short_branch_name,
						OfficialBranchNumber official_branch_number,
						LocalBranchNumber local_branch_number,
						BranchAddress1 branch_address_1,
						BranchAddress2 branch_address_2,
						BranchCity branch_city,
						BranchState branch_state,
						BranchPostal branch_postal,
						BranchCountry branch_country,
						BranchAddressLineQuality branch_address_line_quality,
						BranchAddressCSZQuality branch_address_csz_quality,
						SignatureName signature_name,
						SignatureTitle signature_title,
						CallName call_name,
						CallBranchAssociation call_branch_association,
						CallPhone call_phone,
						MemberCount member_count,
						UnitCount unit_count,
						LoadDate load_date,
						PhoneNumber phone_number,
						MSAOnFile msa_on_file,
						SourceID source_id,
						SubSourceID sub_source_id,
						PeerGroup peer_group,
						ActiveFlag active_flag,
						CustomQuestion1 custom_question_1,
						CustomQuestion2 custom_question_2,
						CustomQuestion3 custom_question_3
			
				FROM	Seer_STG.dbo.Organization
				) AS source
				ON target.association_number = source.association_number
					AND target.official_branch_number = source.official_branch_number
					AND target.current_indicator = source.current_indicator
				
		WHEN MATCHED AND (target.organization_name	 <> 	source.organization_name
							OR	target.organization_number	 <> 	source.organization_number
							OR	target.association_name	 <> 	source.association_name
							OR	target.official_branch_name	 <> 	source.official_branch_name
							OR	target.short_branch_name	 <> 	source.short_branch_name
							OR	target.local_branch_number	 <> 	source.local_branch_number
							OR	target.branch_address_1	 <> 	source.branch_address_1
							OR	target.branch_address_2	 <> 	source.branch_address_2
							OR	target.branch_city	 <> 	source.branch_city
							OR	target.branch_state	 <> 	source.branch_state
							OR	target.branch_postal	 <> 	source.branch_postal
							OR	target.branch_country	 <> 	source.branch_country
							OR	target.branch_address_line_quality	 <> 	source.branch_address_line_quality
							OR	target.branch_address_csz_quality	 <> 	source.branch_address_csz_quality
							OR	target.signature_name	 <> 	source.signature_name
							OR	target.signature_title	 <> 	source.signature_title
							OR	target.call_name	 <> 	source.call_name
							OR	target.call_branch_association	 <> 	source.call_branch_association
							OR	target.call_phone	 <> 	source.call_phone
							OR	target.member_count	 <> 	source.member_count
							OR	target.unit_count	 <> 	source.unit_count
							OR	target.phone_number	 <> 	source.phone_number
							OR	target.msa_on_file	 <> 	source.msa_on_file
							OR	target.source_id	 <> 	source.source_id
							OR	target.sub_source_id	 <> 	source.sub_source_id
							OR	target.peer_group	 <> 	source.peer_group
							OR	target.active_flag	 <> 	source.active_flag
							OR	target.custom_question_1	 <> 	source.custom_question_1
							OR	target.custom_question_2	 <> 	source.custom_question_2
							OR	target.custom_question_3	 <> 	source.custom_question_3
						 )
			THEN
				UPDATE	
				SET		organization_name	 = 	source.organization_name,
						organization_number	 = 	source.organization_number,
						association_name	 = 	source.association_name,
						official_branch_name	 = 	source.official_branch_name,
						short_branch_name	 = 	source.short_branch_name,
						local_branch_number	 = 	source.local_branch_number,
						branch_address_1	 = 	source.branch_address_1,
						branch_address_2	 = 	source.branch_address_2,
						branch_city	 = 	source.branch_city,
						branch_state	 = 	source.branch_state,
						branch_postal	 = 	source.branch_postal,
						branch_country	 = 	source.branch_country,
						branch_address_line_quality	 = 	source.branch_address_line_quality,
						branch_address_csz_quality	 = 	source.branch_address_csz_quality,
						signature_name	 = 	source.signature_name,
						signature_title	 = 	source.signature_title,
						call_name	 = 	source.call_name,
						call_branch_association	 = 	source.call_branch_association,
						call_phone	 = 	source.call_phone,
						member_count	 = 	source.member_count,
						unit_count	 = 	source.unit_count,
						phone_number	 = 	source.phone_number,
						msa_on_file	 = 	source.msa_on_file,
						source_id	 = 	source.source_id,
						sub_source_id	 = 	source.sub_source_id,
						peer_group	 = 	source.peer_group,
						active_flag	 = 	source.active_flag,
						custom_question_1	 = 	source.custom_question_1,
						custom_question_2	 = 	source.custom_question_2,
						custom_question_3	 = 	source.custom_question_3
				
		WHEN NOT MATCHED BY target AND
			(LEN(source.association_number) > 0 AND LEN(source.official_branch_number) > 0
			 AND (LEN(source.member_count) = 0 OR (LEN(source.member_count) > 0 AND ISNUMERIC(source.member_count) = 1))
			 AND (LEN(source.unit_count) = 0 OR (LEN(source.unit_count) > 0 AND ISNUMERIC(source.unit_count) = 1))
			)
			THEN 
				INSERT (organization_name,
						organization_number,
						association_name,
						association_number,
						official_branch_name,
						short_branch_name,
						official_branch_number,
						local_branch_number,
						branch_address_1,
						branch_address_2,
						branch_city,
						branch_state,
						branch_postal,
						branch_country,
						branch_address_line_quality,
						branch_address_csz_quality,
						signature_name,
						signature_title,
						call_name,
						call_branch_association,
						call_phone,
						member_count,
						unit_count,
						phone_number,
						msa_on_file,
						source_id,
						sub_source_id,
						peer_group,
						active_flag,
						custom_question_1,
						custom_question_2,
						custom_question_3
						)
				VALUES (organization_name,
						organization_number,
						association_name,
						association_number,
						official_branch_name,
						short_branch_name,
						official_branch_number,
						local_branch_number,
						branch_address_1,
						branch_address_2,
						branch_city,
						branch_state,
						branch_postal,
						branch_country,
						branch_address_line_quality,
						branch_address_csz_quality,
						signature_name,
						signature_title,
						call_name,
						call_branch_association,
						call_phone,
						member_count,
						unit_count,
						phone_number,
						msa_on_file,
						source_id,
						sub_source_id,
						peer_group,
						active_flag,
						custom_question_1,
						custom_question_2,
						custom_question_3
						)
						
		;
	COMMIT TRAN
	
	BEGIN TRAN
		UPDATE	A
		SET		current_indicator = 0,
				next_change_datetime = @next_change_datetime
		FROM	Seer_MDM.dbo.Organization A
				INNER JOIN
				(
				SELECT	MAX(B.organization_key) last_association_key,
						B.association_number,
						B.association_name
				FROM	Seer_MDM.dbo.Organization B
				WHERE	B.association_name IN (
												SELECT	A.association_name
												FROM	Seer_MDM.dbo.Organization A
												WHERE	A.official_branch_number = A.association_number
														AND A.current_indicator = 1
												GROUP BY A.association_name
												HAVING COUNT(A.association_name) > 1
												)
						AND B.association_number = B.official_branch_number
				GROUP BY B.association_number,
						B.association_name
				) B
				ON A.association_number = B.association_number
					AND A.official_branch_number = B.association_number
					AND A.association_name = B.association_name
					
		WHERE	A.organization_key <> B.last_association_key;
	COMMIT TRAN

	BEGIN TRAN
		UPDATE	A
		SET		current_indicator = 0,
				next_change_datetime = @next_change_datetime
		FROM	Seer_MDM.dbo.Organization A
				INNER JOIN
				(
				SELECT	MAX(B.organization_key) last_branch_key,
						B.association_number,
						B.official_branch_name,
						B.official_branch_number
				FROM	Seer_MDM.dbo.Organization B
				WHERE	B.official_branch_name IN (SELECT	C.official_branch_name
													FROM	(
															SELECT	A.association_number,
																	A.official_branch_name
															FROM	Seer_MDM.dbo.Organization A
															WHERE	A.official_branch_number <> A.association_number
																	--AND official_branch_name = 'Toby Wells'
															GROUP BY A.association_number,
																	A.official_branch_name
															HAVING COUNT(DISTINCT A.association_number) = 1
																	AND COUNT(A.official_branch_name) > 1
															) C
												)
						AND B.official_branch_number <> B.association_number
				GROUP BY B.association_number,
						B.official_branch_name,
						B.official_branch_number
				) B
				ON A.association_number = B.association_number
					AND A.official_branch_name = B.official_branch_name
					AND A.official_branch_number = B.official_branch_number
					
		WHERE	A.organization_key <> B.last_branch_key
	COMMIT TRAN
	
	BEGIN TRAN
		INSERT INTO Seer_CTRL.dbo.Organization(OrganizationName,
												OrganizationNumber,
												AssociationName,
												AssociationNumber,
												OfficialBranchName,
												ShortBranchName,
												OfficialBranchNumber,
												LocalBranchNumber,
												BranchAddress1,
												BranchAddress2,
												BranchCity,
												BranchState,
												BranchPostal,
												BranchCountry,
												BranchAddressLineQuality,
												BranchAddressCSZQuality,
												SignatureName,
												SignatureTitle,
												CallName,
												CallBranchAssociation,
												CallPhone,
												MemberCount,
												UnitCount,
												LoadDate,
												PhoneNumber,
												MSAOnFile,
												SourceID,
												SubSourceID,
												PeerGroup,
												ActiveFlag,
												CustomQuestion1,
												CustomQuestion2,
												CustomQuestion3
											)
		SELECT	OrganizationName,
				OrganizationNumber,
				AssociationName,
				AssociationNumber,
				OfficialBranchName,
				ShortBranchName,
				OfficialBranchNumber,
				LocalBranchNumber,
				BranchAddress1,
				BranchAddress2,
				BranchCity,
				BranchState,
				BranchPostal,
				BranchCountry,
				BranchAddressLineQuality,
				BranchAddressCSZQuality,
				SignatureName,
				SignatureTitle,
				CallName,
				CallBranchAssociation,
				CallPhone,
				MemberCount,
				UnitCount,
				LoadDate,
				PhoneNumber,
				MSAOnFile,
				SourceID,
				SubSourceID,
				PeerGroup,
				ActiveFlag,
				CustomQuestion1,
				CustomQuestion2,
				CustomQuestion3
				
		FROM	Seer_STG.dbo.Organization

		WHERE	LEN(AssociationNumber) = 0
				OR LEN(OfficialBranchNumber) = 0
				OR (LEN(MemberCount) > 0 AND ISNUMERIC(MemberCount) = 0)
				OR (LEN(UnitCount) > 0 AND ISNUMERIC(UnitCount) = 0)
		;
	COMMIT TRAN
END