/*
drop procedure spPopulate_mdmSurvey_Segment
truncate table Seer_MDM.dbo.Survey_Segment
*/
CREATE PROCEDURE spPopulate_mdmSurvey_Segment AS

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

	SELECT	F.member_key,
			G.organization_key,
			B.survey_form_key,
			F.change_datetime,
			F.next_change_datetime,
			F.current_indicator,
			MAX(CASE WHEN D.question = 'Please Check your Membership Type:' THEN E.response_text
					ELSE ''
				END
				) AS membership_type,
			MAX(CASE WHEN D.question = 'Compared to other organizations in your community or companies you deal with, please rate your loyalty to the YMCA.' THEN E.response_text
					ELSE ''
				END
				) AS loyalty,
			MAX(CASE WHEN D.question = 'All things considered, do you think you will belong to this Y a year from now?' THEN E.response_text
					ELSE ''
				END
				) AS intent_to_renew,
			MAX(CASE WHEN D.question = 'On the average, about how frequently do you come to the YMCA?' THEN E.response_text
					ELSE ''
				END) AS frequency_of_use,
			MAX(CASE WHEN D.question = 'How long have you been a member or participant of this YMCA?' THEN E.response_text
					ELSE ''
				END) AS length_of_membership,
			MAX(CASE WHEN D.question = 'What time of day do you most frequently visit the YMCA?' THEN E.response_text
					ELSE ''
				END) AS time_of_day,
			MAX(CASE WHEN D.question = 'If asked, would you recommend the YMCA to your friends?' AND E.response_code IN ('06','05','04','03','02','01','00') THEN 'Detractor' 
					 WHEN D.question = 'If asked, would you recommend the YMCA to your friends?' AND E.response_code IN ('10','09') THEN 'Promoter'
					 WHEN D.question = 'If asked, would you recommend the YMCA to your friends?' AND E.response_code IN ('08','07') THEN 'Neither'
					ELSE ''
				END
				) AS net_promoter,
			CASE	WHEN SUM(CASE	WHEN D.question = 'I try to make every day healthy choices and live well, but I struggle to do so' AND E.response_text = 'Yes' THEN 1
									WHEN D.question = 'I try to make every day healthy choices and live well, but I struggle to do so' AND E.response_text <> 'Yes' THEN -10
									WHEN D.question = 'I believe in exercising regularly, but I have difficulty doing so on my own' AND E.response_text = 'Yes' THEN 1
									WHEN D.question = 'I believe in exercising regularly, but I have difficulty doing so on my own' AND E.response_text <> 'Yes' THEN -10
							ELSE 0
							END
							) = 2 THEN 'Yes'
					WHEN SUM(CASE	WHEN D.question = 'I try to make every day healthy choices and live well, but I struggle to do so' AND E.response_text = 'Yes' THEN 1
									WHEN D.question = 'I try to make every day healthy choices and live well, but I struggle to do so' AND E.response_text <> 'Yes' THEN -10
									WHEN D.question = 'I believe in exercising regularly, but I have difficulty doing so on my own' AND E.response_text = 'Yes' THEN 1
									WHEN D.question = 'I believe in exercising regularly, but I have difficulty doing so on my own' AND E.response_text <> 'Yes' THEN -10
							ELSE 0 
							END
							) < 0 THEN 'No'
					WHEN MAX(F.is_health_seeker) = 'Y' THEN 'Yes'
					WHEN MAX(F.is_health_seeker) = 'N' THEN 'No'
					ELSE 'Unknown'
			END AS health_seeker,
			MAX(CASE WHEN D.question = 'How much has this YMCA helped you meet your health and well-being goals?' THEN E.response_text 
					ELSE ''
				END
				) AS health_seeker_fitness_goals,
			MAX(CASE WHEN D.question = 'Are you(Hourly/Salaried):' THEN E.response_text 
					ELSE ''
				END
				) AS employee_type,
			MAX(CASE WHEN D.question = 'Are you(Full/Part Time):' THEN E.response_text
					ELSE ''
				END
				) AS employee_work_time,
			MAX(CASE WHEN D.question = 'How long have you worked at the Y?' THEN E.response_text
					ELSE ''
				END
				) AS employee_length_of_service,
			MAX(CASE WHEN D.question = 'Please indicate your department.' THEN E.response_text
					ELSE ''
				END
				) AS employee_department,
			MAX(CASE WHEN D.question = 'If asked, how likely are you to recommend the YMCA as a place to work to a friend or neighbor?' AND E.response_code IN ('06','05','04','03','02','01','00') THEN 'Detractor' 
					 WHEN D.question = 'If asked, how likely are you to recommend the YMCA as a place to work to a friend or neighbor?' AND E.response_code IN ('10','09') THEN 'Promoter'
					 WHEN D.question = 'If asked, how likely are you to recommend the YMCA as a place to work to a friend or neighbor?' AND E.response_code IN ('08','07') THEN 'Neither'
					ELSE ''
				END) AS employee_promoter,
			MAX(CASE WHEN D.question = 'If asked, how likely are you to recommend Y membership to a friend or neighbor?' AND E.response_code IN ('06','05','04','03','02','01','00') THEN 'Detractor' 
					 WHEN D.question = 'If asked, how likely are you to recommend Y membership to a friend or neighbor?' AND E.response_code IN ('10','09') THEN 'Promoter'
					 WHEN D.question = 'If asked, how likely are you to recommend Y membership to a friend or neighbor?' AND E.response_code IN ('08','07') THEN 'Neither'
					ELSE ''
				END) AS employee_membership_promoter,
			MAX(CASE WHEN D.question = 'When you come to the Y, do you mainly engage in group activities or individual exercise activities?' THEN E.response_text
					ELSE ''
				END
				) AS group_activities,
			MAX(CASE WHEN D.question LIKE '%If asked, how likely are you to recommend the YMCA%%Program to a friend or neighbor?%' AND E.response_code IN ('06','05','04','03','02','01','00') THEN 'Detractor' 
					 WHEN D.question LIKE '%If asked, how likely are you to recommend the YMCA%%Program to a friend or neighbor?%' AND E.response_code IN ('10','09') THEN 'Promoter'
					 WHEN D.question LIKE '%If asked, how likely are you to recommend the YMCA%%Program to a friend or neighbor?%' AND E.response_code IN ('08','07') THEN 'Neither'
					ELSE ''
				END
				) AS program_promoter
		
	INTO	#SSG
	
	FROM	Seer_ODS.dbo.Close_Ends A
			INNER JOIN Seer_MDM.dbo.Survey_Form B
				ON A.form_code = B.survey_form_code
			INNER JOIN Seer_MDM.dbo.Survey_Question C
				ON B.survey_form_key = C.survey_form_key
					AND A.question = C.survey_column
			INNER JOIN Seer_MDM.dbo.Question D
				ON C.question_key = D.question_key
			INNER JOIN
			(
			SELECT	question_key
			FROM	Seer_MDM.dbo.Question
			WHERE	question IN ('Please Check your Membership Type:',
									'Compared to other organizations in your community or companies you deal with, please rate your loyalty to the YMCA.',
									'All things considered, do you think you will belong to this Y a year from now?',
									'On the average, about how frequently do you come to the YMCA?',
									'How long have you been a member or participant of this YMCA?',
									'What time of day do you most frequently visit the YMCA?',
									'If asked, would you recommend the YMCA to your friends?',
									'I try to make every day healthy choices and live well, but I struggle to do so',
									'How much has this YMCA helped you meet your health and well-being goals?',
									'I believe in exercising regularly, but I have difficulty doing so on my own',
									'Are you(Hourly/Salaried):',
									'Are you(Full/Part Time):',
									'How long have you worked at the Y?',
									'Please indicate your department.',
									'If asked, how likely are you to recommend the YMCA as a place to work to a friend or neighbor?',
									'If asked, how likely are you to recommend Y membership to a friend or neighbor?',
									'When you come to the Y, do you mainly engage in group activities or individual exercise activities?'
									)
					OR question LIKE '%If asked, how likely are you to recommend the YMCA%%Program to a friend or neighbor?%'
			) D1
				ON D.question_key = D1.question_key
			INNER JOIN Seer_MDM.dbo.Survey_Response E
				ON C.survey_question_key = E.survey_question_key
					AND (
						CASE WHEN LEN(A.response) = 1 THEN '0' + CONVERT(VARCHAR(20), A.response)
							ELSE CONVERT(VARCHAR(20), A.response)
						END
						) = E.response_code
			INNER JOIN Seer_MDM.dbo.Member F
				ON A.member_key = F.member_key
			INNER JOIN Seer_MDM.dbo.Organization G
				ON A.official_association_number = G.association_number
					AND A.official_branch_number = G.official_branch_number
				
	WHERE	E.response_code <> '-1'
			AND A.current_indicator = 1
			AND B.current_indicator = 1
			AND C.current_indicator = 1
			AND D.current_indicator = 1
			AND E.current_indicator = 1
			AND F.current_indicator = 1
			AND G.current_indicator = 1
			
	GROUP BY F.member_key,
			G.organization_key,
			B.survey_form_key,
			F.change_datetime,
			F.next_change_datetime,
			F.current_indicator

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Survey_Segment AS target
	USING	(
			SELECT	A.member_key,
					A.organization_key,
					A.survey_form_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.membership_type,
					A.loyalty,
					A.intent_to_renew,
					A.frequency_of_use,
					A.length_of_membership,
					A.time_of_day,
					A.net_promoter,
					A.health_seeker,
					A.health_seeker_fitness_goals,
					A.employee_type,
					A.employee_work_time,
					A.employee_length_of_service,
					A.employee_department,
					A.employee_promoter,
					A.employee_membership_promoter,
					A.group_activities,
					A.program_promoter
				
			FROM	#SSG A
			) AS source
			ON target.member_key = source.member_key
					AND target.organization_key = source.organization_key
					AND target.survey_form_key = source.survey_form_key
					AND target.current_indicator = source.current_indicator
			
	WHEN MATCHED AND (target.membership_type	 <> 	source.membership_type
						OR target.loyalty	 <> 	source.loyalty
						OR target.intent_to_renew	 <> 	source.intent_to_renew
						OR target.frequency_of_use	 <> 	source.frequency_of_use
						OR target.length_of_membership	 <> 	source.length_of_membership
						OR target.time_of_day	 <> 	source.time_of_day
						OR target.net_promoter	 <> 	source.net_promoter
						OR target.health_seeker	 <> 	source.health_seeker
						OR target.health_seeker_fitness_goals <> source.health_seeker_fitness_goals
						OR target.employee_type	 <> 	source.employee_type
						OR target.employee_work_time <> 	source.employee_work_time
						OR target.employee_length_of_service	 <> 	source.employee_length_of_service
						OR target.employee_department	 <> 	source.employee_department
						OR target.employee_promoter	 <> 	source.employee_promoter
						OR target.employee_membership_promoter	 <> 	source.employee_membership_promoter
						OR target.group_activities	 <> 	source.group_activities
						OR target.program_promoter	 <> 	source.program_promoter
						)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([member_key],
					[organization_key],
					[survey_form_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[membership_type],
					[loyalty],
					[intent_to_renew],
					[frequency_of_use],
					[length_of_membership],
					[time_of_day],
					[net_promoter],
					[health_seeker],
					[health_seeker_fitness_goals],
					[employee_type],
					[employee_work_time],
					[employee_length_of_service],
					[employee_department],
					[employee_promoter],
					[employee_membership_promoter],
					[group_activities],
					[program_promoter]
					)
			VALUES ([member_key],
					[organization_key],
					[survey_form_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[membership_type],
					[loyalty],
					[intent_to_renew],
					[frequency_of_use],
					[length_of_membership],
					[time_of_day],
					[net_promoter],
					[health_seeker],
					[health_seeker_fitness_goals],
					[employee_type],
					[employee_work_time],
					[employee_length_of_service],
					[employee_department],
					[employee_promoter],
					[employee_membership_promoter],
					[group_activities],
					[program_promoter]
					)
;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Survey_Segment AS target
	USING	(
			SELECT	A.member_key,
					A.organization_key,
					A.survey_form_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.membership_type,
					A.loyalty,
					A.intent_to_renew,
					A.frequency_of_use,
					A.length_of_membership,
					A.time_of_day,
					A.net_promoter,
					A.health_seeker,
					A.health_seeker_fitness_goals,
					A.employee_type,
					A.employee_work_time,
					A.employee_length_of_service,
					A.employee_department,
					A.employee_promoter,
					A.employee_membership_promoter,
					A.group_activities,
					A.program_promoter
				
			FROM	#SSG A
			) AS source
			ON target.member_key = source.member_key
					AND target.organization_key = source.organization_key
					AND target.survey_form_key = source.survey_form_key
					AND target.current_indicator = source.current_indicator
			
	
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([member_key],
					[organization_key],
					[survey_form_key],
					[change_datetime],
					[next_change_datetime],
					[membership_type],
					[loyalty],
					[intent_to_renew],
					[frequency_of_use],
					[length_of_membership],
					[time_of_day],
					[net_promoter],
					[health_seeker],
					[health_seeker_fitness_goals],
					[employee_type],
					[employee_work_time],
					[employee_length_of_service],
					[employee_department],
					[employee_promoter],
					[employee_membership_promoter],
					[group_activities],
					[program_promoter]
					)
			VALUES ([member_key],
					[organization_key],
					[survey_form_key],
					[change_datetime],
					[next_change_datetime],
					[membership_type],
					[loyalty],
					[intent_to_renew],
					[frequency_of_use],
					[length_of_membership],
					[time_of_day],
					[net_promoter],
					[health_seeker],
					[health_seeker_fitness_goals],
					[employee_type],
					[employee_work_time],
					[employee_length_of_service],
					[employee_department],
					[employee_promoter],
					[employee_membership_promoter],
					[group_activities],
					[program_promoter]
					)
;
COMMIT TRAN

BEGIN TRAN
	DROP TABLE #SSG;
COMMIT TRAN
