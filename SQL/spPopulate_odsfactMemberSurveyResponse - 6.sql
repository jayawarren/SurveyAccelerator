/*
truncate table Seer_ODS.dbo.factMemberSurveyResponse
drop procedure spPopulate_odsfactMemberSurveyResponse
SELECT * FROM Seer_ODS.dbo.factMemberSurveyResponse
*/
CREATE PROCEDURE spPopulate_odsfactMemberSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN

	SELECT	A.MemberResponseKey,
			A.MemberKey,
			A.BranchKey,
			A.ProgramSiteLocationKey,
			A.OrganizationSurveyKey,
			A.SurveyQuestionKey,
			A.QuestionResponseKey,
			A.OpenEndResponseKey,
			--Maximum function used to select one batch key when a specific GivenDateKey is associated
			--with more than one batch (i.e. New Member)
			MAX(A.batch_key) batch_key,
			A.GivenDateKey,
			A.current_indicator,
			SUM(A.ResponseCount) ResponseCount
	
	INTO	#MSR
			
	FROM	(
			SELECT	F.survey_response_key as MemberResponseKey,
					COALESCE(A.member_key, 0) as MemberKey,
					B.organization_key as BranchKey,
					COALESCE(J.program_group_key, -1) as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					-1 as OpenEndResponseKey,
					I.batch_key,
					I.date_given_key as GivenDateKey,
					COALESCE(A.current_indicator, 1) current_indicator,
					CASE WHEN A.member_key IS NULL THEN 0
						ELSE 1
					END as ResponseCount
			
			FROM	Seer_MDM.dbo.Survey_Question E
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON E.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON E.survey_form_key = C.survey_form_key
					INNER JOIN Seer_MDM.dbo.Batch I
						ON C.survey_form_code = I.form_code
					LEFT JOIN Seer_ODS.dbo.Close_Ends A
						ON I.batch_number = A.batch_number
							AND I.form_code = A.form_code
							AND E.survey_column = A.question
							AND F.response_code =	(CASE WHEN LEN(CONVERT(VARCHAR(5), A.response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.response)
														ELSE CONVERT(VARCHAR(5), A.response)
													END)
					INNER JOIN Seer_MDM.dbo.Organization B
						ON A.official_association_number = B.association_number
							AND A.official_branch_number = B.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map J
						ON A.member_key = J.member_key
							AND B.organization_key = J.organization_key
							AND C.survey_form_key = J.survey_form_key
							AND I.batch_key = J.batch_key
							
			WHERE	COALESCE(A.current_indicator, 1) = 1
					AND B.current_indicator = 1
					AND C.current_indicator = 1
					AND E.current_indicator = 1
					AND F.current_indicator = 1
					AND I.current_indicator = 1
					AND COALESCE(J.current_indicator, 1) = 1
							
			UNION ALL

			SELECT	F.survey_response_key as MemberResponseKey,
					COALESCE(A.member_key, 0) as MemberKey,
					B.organization_key as BranchKey,
					COALESCE(J.program_group_key, -1) as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					-1 as OpenEndResponseKey,
					I.batch_key,
					I.date_given_key as GivenDateKey,
					COALESCE(A.current_indicator, 1) current_indicator,
					CASE WHEN A.member_key IS NULL THEN 0
						ELSE 1
					END as ResponseCount
			
			FROM	Seer_MDM.dbo.Survey_Question E
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON E.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON E.survey_form_key = C.survey_form_key
					INNER JOIN Seer_MDM.dbo.Batch I
						ON C.survey_form_code = I.form_code
					LEFT JOIN
					(
					SELECT	A.official_association_number,
							A.official_branch_number,
							A.member_key,
							A.batch_number,
							A.form_code,
							'response_channel' question,
							LOWER(A.response_channel) response,
							A.current_indicator
							
					FROM	Seer_ODS.dbo.Close_Ends A
					
					WHERE	A.current_indicator = 1
					
					GROUP BY A.official_association_number,
							A.official_branch_number,
							A.member_key,
							A.batch_number,
							A.form_code,
							A.response_channel,
							A.current_indicator
					) A
						ON I.batch_number = A.batch_number
							AND I.form_code = A.form_code
							AND LOWER(E.survey_column) = A.question
							AND LOWER(F.response_code) = A.response
					INNER JOIN Seer_MDM.dbo.Organization B
						ON A.official_association_number = B.association_number
							AND A.official_branch_number = B.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map J
						ON A.member_key = J.member_key
							AND B.organization_key = J.organization_key
							AND C.survey_form_key = J.survey_form_key
							AND I.batch_key = J.batch_key
							
			WHERE	COALESCE(A.current_indicator, 1) = 1
					AND B.current_indicator = 1
					AND C.current_indicator = 1
					AND E.current_indicator = 1
					AND F.current_indicator = 1
					AND I.current_indicator = 1
					AND COALESCE(J.current_indicator, 1) = 1
							
			UNION ALL
			
			SELECT	F.survey_response_key as MemberResponseKey,
					A.member_key as MemberKey,
					B.organization_key as BranchKey,
					COALESCE(J.program_group_key, -1) as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					COALESCE(A.open_ends_key, -1) as OpenEndResponseKey,
					I.batch_key,
					I.date_given_key as GivenDateKey,
					COALESCE(A.current_indicator, 1) current_indicator,
					CASE WHEN A.member_key IS NULL THEN 0
						ELSE 1
					END as ResponseCount

			FROM	Seer_MDM.dbo.Survey_Question E
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON E.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON E.survey_form_key = C.survey_form_key
					INNER JOIN Seer_MDM.dbo.Batch I
						ON C.survey_form_code = I.form_code
					LEFT JOIN Seer_ODS.dbo.Open_Ends A
						ON I.batch_number = A.batch_number
							AND I.form_code = A.form_code
							AND E.survey_open_end_column = A.open_question
							AND F.response_code =	(CASE WHEN LEN(CONVERT(VARCHAR(5), A.closed_response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.closed_response)
														ELSE CONVERT(VARCHAR(5), A.closed_response)
													END)
					INNER JOIN Seer_MDM.dbo.Organization B
						ON A.official_association_number = B.association_number
							AND A.official_branch_number = B.official_branch_number
					LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map J
						ON A.member_key = J.member_key
							AND B.organization_key = J.organization_key
							AND C.survey_form_key = J.survey_form_key
							AND I.batch_key = J.batch_key
							
			WHERE	COALESCE(A.current_indicator, 1) = 1
					AND B.current_indicator = 1
					AND C.current_indicator = 1
					AND E.current_indicator = 1
					AND F.current_indicator = 1
					AND I.current_indicator = 1
					AND COALESCE(J.current_indicator, 1) = 1
			) A
			
	GROUP BY A.MemberResponseKey,
			A.MemberKey,
			A.BranchKey,
			A.ProgramSiteLocationKey,
			A.OrganizationSurveyKey,
			A.SurveyQuestionKey,
			A.QuestionResponseKey,
			A.OpenEndResponseKey,
			A.GivenDateKey,
			A.current_indicator
					
	MERGE	Seer_ODS.dbo.factMemberSurveyResponse AS target
	USING	(
			SELECT	A.MemberResponseKey,
					A.MemberKey,
					A.BranchKey,
					A.ProgramSiteLocationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.OpenEndResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.ResponseCount
			
			FROM	#MSR A
			
			) AS source
			
			ON target.current_indicator = source.current_indicator
				AND target.MemberResponseKey = source.MemberResponseKey
				AND target.MemberKey = source.MemberKey
				AND target.BranchKey = source.BranchKey
				AND target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.OpenEndResponseKey = source.OpenEndResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
			
			WHEN MATCHED AND (target.[ResponseCount] <> source.[ResponseCount]
							)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([MemberResponseKey],
					[MemberKey],
					[BranchKey],
					[ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[OpenEndResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount]
					)
			VALUES ([MemberResponseKey],
					[MemberKey],
					[BranchKey],
					[ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[OpenEndResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factMemberSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.MemberResponseKey,
					A.MemberKey,
					A.BranchKey,
					A.ProgramSiteLocationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.OpenEndResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.ResponseCount
			
			FROM	#MSR A
			) AS source
			
			ON target.current_indicator = source.current_indicator
				AND target.MemberResponseKey = source.MemberResponseKey
				AND target.MemberKey = source.MemberKey
				AND target.BranchKey = source.BranchKey
				AND target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.OpenEndResponseKey = source.OpenEndResponseKey
				AND target.GivenDateKey = source.GivenDateKey
				AND target.batch_key = source.batch_key
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[MemberResponseKey],
					[MemberKey],
					[BranchKey],
					[ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[OpenEndResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[MemberResponseKey],
					[MemberKey],
					[BranchKey],
					[ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[OpenEndResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount]
					)
	;
COMMIT TRAN
BEGIN TRAN
	DROP TABLE #MSR;
COMMIT TRAN
END