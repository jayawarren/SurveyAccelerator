/*
drop procedure spPopulate_odsMember_Data
truncate table Seer_ODS.dbo.[Member_Data]
truncate table Seer_CTRL.dbo.[Member Data]
select count(*) from Seer_STG.dbo.[Member Data]
select * from Seer_ODS.dbo.Member_Data
select* from Seer_CTRL.dbo.[Member Data] where y_memb_id = '100007'
select * from Seer_MDM.dbo.Member where member_id = '100007'
*/
CREATE PROCEDURE spPopulate_odsMember_Data AS
BEGIN
	MERGE	Seer_ODS.dbo.[Member_Data] AS target
	USING	(
			SELECT	distinct
					COALESCE(B.member_key, C.member_key) member_key,
					A.[ORG_NAME] organization_name,
					A.[BATCH_NUM] batch_number,
					CASE WHEN LEN(A.[OFF_ASS_NUM]) = 3 THEN '0' + A.[OFF_ASS_NUM]
						ELSE A.[OFF_ASS_NUM]
					END official_association_number,
					CASE WHEN LEN(A.[OFF_BR_NUM]) = 3 THEN '0' + A.[OFF_BR_NUM]
						ELSE A.[OFF_BR_NUM]
					END official_branch_number,
					A.[Y_MEMB_ID] y_member_id,
					A.[Y_FAM_ID] y_family_id,
					A.[FIRST_NAME] first_name,
					A.[MID_NAME] middle_name,
					A.[LAST_NAME] last_name,
					A.[SUFFIX] suffix,
					A.[FULL_NAME] full_name,
					A.[ADDRESS1] address_1,
					A.[ADDRESS2] address_2,
					A.[CITY] city,
					A.[STATE] state,
					A.[ZIP] zip,
					A.[COUNTRY] country,
					A.[LAST_LINE] last_line,
					A.[PHONE] phone,
					A.[HHH_IND] hhh_indicator,
					A.[DOB] date_of_birth,
					A.[JOIN_DATE] join_date,
					A.[GENDER] gender,
					A.[CATEGORY] category,
					A.[MEMBER_TYPE] member_type,
					A.[STAFF_TYPE] staff_type,
					A.[BILL_MEMB] bill_member,
					A.[HH_ID] hh_id,
					A.[EMAIL] email,
					A.[EMPLOYEE] employee,
					A.[DONOR] donor,
					A.[PROGRAM_MEMBER] program_member,
					A.[Program_Type] program_type,
					A.[Program_Site_Location] program_site_location,
					A.[NEW_MEMBER] new_member,
					A.[ACTIVE] active,
					A.[REMOVAL_REASON] removal_reason,
					A.[FULL_TIME PART_TIME] full_time_part_time,
					A.[HOURLY SALARY] hourly_salary,
					A.[ETHNICITY] ethnicity,
					A.[COMMENTS] comments,
					A.[SITE_NUMBER] site_number,
					A.[GROUP_NAME] group_name,
					A.[GROUP_NUMBER] group_number
			
			FROM	Seer_STG.dbo.[Member Data] A
					LEFT JOIN Seer_MDM.dbo.[Member] B
						ON A.Member_key = B.member_key
					LEFT JOIN Seer_MDM.dbo.[Member] C
						ON A.ORG_NAME = C.organization_name
							AND A.Y_MEMB_ID = C.member_id
							AND A.OFF_BR_NUM = C.organization_id
							AND COALESCE(A.FIRST_NAME, '') = COALESCE(C.member_first_name, '')
							AND COALESCE(A.MID_NAME, '') = COALESCE(C.member_middle_name, '')
							AND COALESCE(A.LAST_NAME, '') = COALESCE(C.member_last_name, '')
							AND A.EMAIL = C.email_address
			
			) AS source
			ON target.member_key = source.member_key
					AND target.organization_name = source.organization_name
					AND target.batch_number= source.batch_number
					AND target.official_association_number = source.official_association_number
					AND target.official_branch_number = source.official_branch_number
					AND target.y_member_id = source.y_member_id
			
	WHEN MATCHED AND (target.[y_family_id] <> source.[y_family_id]
						OR target.[first_name] <> source.[first_name]
						OR target.[middle_name] <> source.[middle_name]
						OR target.[last_name] <> source.[last_name]
						OR target.[suffix] <> source.[suffix]
						OR target.[full_name] <> source.[full_name]
						OR target.[address_1] <> source.[address_1]
						OR target.[address_2] <> source.[address_2]
						OR target.[city] <> source.[city]
						OR target.[state] <> source.[state]
						OR target.[zip] <> source.[zip]
						OR target.[country] <> source.[country]
						OR target.[last_line] <> source.[last_line]
						OR target.[phone] <> source.[phone]
						OR target.[hhh_indicator] <> source.[hhh_indicator]
						OR target.[date_of_birth] <> source.[date_of_birth]
						OR target.[join_date] <> source.[join_date]
						OR target.[gender] <> source.[gender]
						OR target.[category] <> source.[category]
						OR target.[member_type] <> source.[member_type]
						OR target.[staff_type] <> source.[staff_type]
						OR target.[bill_member] <> source.[bill_member]
						OR target.[hh_id] <> source.[hh_id]
						OR target.[email] <> source.[email]
						OR target.[employee] <> source.[employee]
						OR target.[donor] <> source.[donor]
						OR target.[program_member] <> source.[program_member]
						OR target.[program_type] <> source.[program_type]
						OR target.[program_site_location] <> source.[program_site_location]
						OR target.[new_member] <> source.[new_member]
						OR target.[active] <> source.[active]
						OR target.[removal_reason] <> source.[removal_reason]
						OR target.[full_time_part_time] <> source.[full_time_part_time]
						OR target.[hourly_salary] <> source.[hourly_salary]
						OR target.[ethnicity] <> source.[ethnicity]
						OR target.[comments] <> source.[comments]
						OR target.[site_number] <> source.[site_number]
						OR target.[group_name] <> source.[group_name]
						OR target.[group_number] <> source.[group_number]

						)
		THEN
			UPDATE	
			SET		[y_family_id] = source.[y_family_id],
					[first_name] = source.[first_name],
					[middle_name] = source.[middle_name],
					[last_name] = source.[last_name],
					[suffix] = source.[suffix],
					[full_name] = source.[full_name],
					[address_1] = source.[address_1],
					[address_2] = source.[address_2],
					[city] = source.[city],
					[state] = source.[state],
					[zip] = source.[zip],
					[country] = source.[country],
					[last_line] = source.[last_line],
					[phone] = source.[phone],
					[hhh_indicator] = source.[hhh_indicator],
					[date_of_birth] = source.[date_of_birth],
					[join_date] = source.[join_date],
					[gender] = source.[gender],
					[category] = source.[category],
					[member_type] = source.[member_type],
					[staff_type] = source.[staff_type],
					[bill_member] = source.[bill_member],
					[hh_id] = source.[hh_id],
					[email] = source.[email],
					[employee] = source.[employee],
					[donor] = source.[donor],
					[program_member] = source.[program_member],
					[program_type] = source.[program_type],
					[program_site_location] = source.[program_site_location],
					[new_member] = source.[new_member],
					[active] = source.[active],
					[removal_reason] = source.[removal_reason],
					[full_time_part_time] = source.[full_time_part_time],
					[hourly_salary] = source.[hourly_salary],
					[ethnicity] = source.[ethnicity],
					[comments] = source.[comments],
					[site_number] = source.[site_number],
					[group_name] = source.[group_name],
					[group_number] = source.[group_number]

						
	WHEN NOT MATCHED BY target AND
		(source.member_key is NOT NULL
		)
		THEN 
			INSERT ([member_key],
					[organization_name],
					[official_association_number],
					[official_branch_number],
					[batch_number],
					[y_member_id],
					[y_family_id],
					[first_name],
					[middle_name],
					[last_name],
					[suffix],
					[full_name],
					[address_1],
					[address_2],
					[city],
					[state],
					[zip],
					[country],
					[last_line],
					[phone],
					[hhh_indicator],
					[date_of_birth],
					[join_date],
					[gender],
					[category],
					[member_type],
					[staff_type],
					[bill_member],
					[hh_id],
					[email],
					[employee],
					[donor],
					[program_member],
					[program_type],
					[program_site_location],
					[new_member],
					[active],
					[removal_reason],
					[full_time_part_time],
					[hourly_salary],
					[ethnicity],
					[comments],
					[site_number],
					[group_name],
					[group_number]
					)
			VALUES ([member_key],
					[organization_name],
					[official_association_number],
					[official_branch_number],
					[batch_number],
					[y_member_id],
					[y_family_id],
					[first_name],
					[middle_name],
					[last_name],
					[suffix],
					[full_name],
					[address_1],
					[address_2],
					[city],
					[state],
					[zip],
					[country],
					[last_line],
					[phone],
					[hhh_indicator],
					[date_of_birth],
					[join_date],
					[gender],
					[category],
					[member_type],
					[staff_type],
					[bill_member],
					[hh_id],
					[email],
					[employee],
					[donor],
					[program_member],
					[program_type],
					[program_site_location],
					[new_member],
					[active],
					[removal_reason],
					[full_time_part_time],
					[hourly_salary],
					[ethnicity],
					[comments],
					[site_number],
					[group_name],
					[group_number]
)
					
	;
	INSERT INTO Seer_CTRL.dbo.[Member Data] ([Member_Key],
											[ORG_NAME],
											[BATCH_NUM],
											[OFF_ASS_NUM],
											[OFF_BR_NUM],
											[Y_MEMB_ID],
											[Y_FAM_ID],
											[FIRST_NAME],
											[MID_NAME],
											[LAST_NAME],
											[SUFFIX],
											[FULL_NAME],
											[ADDRESS1],
											[ADDRESS2],
											[CITY],
											[STATE],
											[ZIP],
											[COUNTRY],
											[LAST_LINE],
											[PHONE],
											[HHH_IND],
											[DOB],
											[JOIN_DATE],
											[GENDER],
											[CATEGORY],
											[MEMBER_TYPE],
											[STAFF_TYPE],
											[BILL_MEMB],
											[HH_ID],
											[EMAIL],
											[EMPLOYEE],
											[DONOR],
											[PROGRAM_MEMBER],
											[Program_Type],
											[Program_Site_Location],
											[NEW_MEMBER],
											[ACTIVE],
											[REMOVAL_REASON],
											[FULL_TIME PART_TIME],
											[HOURLY SALARY],
											[ETHNICITY],
											[COMMENTS],
											[SITE_NUMBER],
											[GROUP_NAME],
											[GROUP_NUMBER]
									)
	SELECT	distinct
			A.Member_Key,
			A.[ORG_NAME],
			A.[BATCH_NUM],
			CASE WHEN LEN(A.[OFF_ASS_NUM]) = 3 THEN '0' + A.[OFF_ASS_NUM]
				ELSE A.[OFF_ASS_NUM]
			END [OFF_ASS_NUM],
			CASE WHEN LEN(A.[OFF_BR_NUM]) = 3 THEN '0' + A.[OFF_BR_NUM]
				ELSE A.[OFF_BR_NUM]
			END [OFF_BR_NUM],
			A.[Y_MEMB_ID],
			A.[Y_FAM_ID],
			A.[FIRST_NAME],
			A.[MID_NAME],
			A.[LAST_NAME],
			A.[SUFFIX],
			A.[FULL_NAME],
			A.[ADDRESS1],
			A.[ADDRESS2],
			A.[CITY],
			A.[STATE],
			A.[ZIP],
			A.[COUNTRY],
			A.[LAST_LINE],
			A.[PHONE],
			A.[HHH_IND],
			A.[DOB],
			A.[JOIN_DATE],
			A.[GENDER],
			A.[CATEGORY],
			A.[MEMBER_TYPE],
			A.[STAFF_TYPE],
			A.[BILL_MEMB],
			A.[HH_ID],
			A.[EMAIL],
			A.[EMPLOYEE],
			A.[DONOR],
			A.[PROGRAM_MEMBER],
			A.[Program_Type],
			A.[Program_Site_Location],
			A.[NEW_MEMBER],
			A.[ACTIVE],
			A.[REMOVAL_REASON],
			A.[FULL_TIME PART_TIME],
			A.[HOURLY SALARY],
			A.[ETHNICITY],
			A.[COMMENTS],
			A.[SITE_NUMBER],
			A.[GROUP_NAME],
			A.[GROUP_NUMBER]
	
	FROM	Seer_STG.dbo.[Member Data] A
			LEFT JOIN Seer_MDM.dbo.[Member] B
				ON A.Member_key = B.member_key
			LEFT JOIN Seer_MDM.dbo.[Member] C
				ON A.ORG_NAME = C.organization_name
					AND A.Y_MEMB_ID = C.member_id
					AND A.OFF_BR_NUM = C.organization_id
					AND COALESCE(A.FIRST_NAME, '') = COALESCE(C.member_first_name, '')
					AND COALESCE(A.MID_NAME, '') = COALESCE(C.member_middle_name, '')
					AND COALESCE(A.LAST_NAME, '') = COALESCE(C.member_last_name, '')
					AND A.EMAIL = C.email_address

	WHERE	COALESCE(B.member_key, C.member_key) IS NULL
			
	;
END