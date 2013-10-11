/*
truncate table Seer_ODS.dbo.Open_Ends
drop procedure spPopulate_odsOpen_Ends
SELECT * FROM Seer_ODS.dbo.Open_Ends
*/
CREATE PROCEDURE spPopulate_odsfactMemberSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factMemberSurveyResponse AS target
	USING	(
			SELECT	F.survey_response_key as MemberResponseKey,
					A.member_key as MemberKey,
					B.organization_key as BranchKey,
					B.program_group_key as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					-1 as OpenEndResponseKey,
					I.date_given_key as GivenDateKey,
					1 current_indicator,
					1 as ResponseCount

			FROM	Seer_ODS.dbo.Close_Ends A
					INNER JOIN Seer_MDM.dbo.Member_Map B
						ON A.member_key = B.member_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON A.form_code = C.survey_form_code
							AND C.current_indicator = 1
					INNER JOIN Seer_MDM.dbo.Survey_Question E
						ON A.question = E.survey_column
							AND C.survey_form_key = E.survey_form_key
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON C.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
							AND (CASE WHEN LEN(CONVERT(VARCHAR(5), A.response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.response)
									ELSE CONVERT(VARCHAR(5), A.response)
								END) = F.response_code
					INNER JOIN Seer_MDM.dbo.Batch I
						ON A.batch_number = I.batch_number
							AND A.form_code = I.form_code
							
			UNION ALL

			SELECT	F.survey_response_key as MemberResponseKey,
					A.member_key as MemberKey,
					B.organization_key as BranchKey,
					B.program_group_key as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					A.open_ends_key as OpenEndResponseKey,
					I.date_given_key as GivenDateKey,
					1 current_indicator,
					1 as ResponseCount

			FROM	Seer_ODS.dbo.Open_Ends A
					INNER JOIN Seer_MDM.dbo.Member_Map B
						ON A.member_key = B.member_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON A.form_code = C.survey_form_code
							AND C.current_indicator = 1
					INNER JOIN Seer_MDM.dbo.Survey_Question E
						ON A.open_question = E.survey_open_end_column
							AND C.survey_form_key = E.survey_form_key
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON C.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
							AND (CASE WHEN LEN(CONVERT(VARCHAR(5), A.closed_response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.closed_response)
									ELSE CONVERT(VARCHAR(5), A.closed_response)
								END) = F.response_code
					INNER JOIN Seer_MDM.dbo.Batch I
						ON A.batch_number = I.batch_number
							AND A.form_code = I.form_code

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
					[QuestionSurveyKey],
					[OpenEndResponseKey],
					[GivenDateKey],
					[ResponseCount]
					)
			VALUES ([MemberResponseKey],
					[MemberKey],
					[BranchKey],
					[ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionSurveyKey],
					[OpenEndResponseKey],
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
					F.survey_response_key as MemberResponseKey,
					A.member_key as MemberKey,
					B.organization_key as BranchKey,
					B.program_group_key as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					-1 as OpenEndResponseKey,
					I.date_given_key as GivenDateKey,
					1 current_indicator,
					1 as ResponseCount

			FROM	Seer_ODS.dbo.Close_Ends A
					INNER JOIN Seer_MDM.dbo.Member_Map B
						ON A.member_key = B.member_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON A.form_code = C.survey_form_code
							AND C.current_indicator = 1
					INNER JOIN Seer_MDM.dbo.Survey_Question E
						ON A.question = E.survey_column
							AND C.survey_form_key = E.survey_form_key
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON C.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
							AND (CASE WHEN LEN(CONVERT(VARCHAR(5), A.response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.response)
									ELSE CONVERT(VARCHAR(5), A.response)
								END) = F.response_code
					INNER JOIN Seer_MDM.dbo.Batch I
						ON A.batch_number = I.batch_number
							AND A.form_code = I.form_code
							
			UNION ALL

			SELECT	F.survey_response_key as MemberResponseKey,
					A.member_key as MemberKey,
					B.organization_key as BranchKey,
					B.program_group_key as ProgramSiteLocationKey,
					F.survey_form_key as OrganizationSurveyKey,
					F.survey_question_key as SurveyQuestionKey,
					F.survey_response_key as QuestionResponseKey,
					A.open_ends_key as OpenEndResponseKey,
					I.date_given_key as GivenDateKey,
					1 current_indicator,
					1 as ResponseCount

			FROM	Seer_ODS.dbo.Open_Ends A
					INNER JOIN Seer_MDM.dbo.Member_Map B
						ON A.member_key = B.member_key
					INNER JOIN Seer_MDM.dbo.Survey_Form C
						ON A.form_code = C.survey_form_code
							AND C.current_indicator = 1
					INNER JOIN Seer_MDM.dbo.Survey_Question E
						ON A.open_question = E.survey_open_end_column
							AND C.survey_form_key = E.survey_form_key
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON C.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key
							AND (CASE WHEN LEN(CONVERT(VARCHAR(5), A.closed_response)) = 1 THEN '0' + CONVERT(VARCHAR(5), A.closed_response)
									ELSE CONVERT(VARCHAR(5), A.closed_response)
								END) = F.response_code
					INNER JOIN Seer_MDM.dbo.Batch I
						ON A.batch_number = I.batch_number
							AND A.form_code = I.form_code

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
					[QuestionSurveyKey],
					[OpenEndResponseKey],
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
					[QuestionSurveyKey],
					[OpenEndResponseKey],
					[GivenDateKey],
					[ResponseCount]
					)
	;
COMMIT TRAN
END