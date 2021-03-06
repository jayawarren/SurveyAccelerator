/****** Script for SelectTopNRows command from SSMS  ******/
SELECT	TOP 1000
		A.MemberResponseKey,
		A.ResponseCount,
		A.MemberKey,
		A.BranchKey,
		A.ProgramSiteLocationKey,
		A.OrganizationSurveyKey,
		A.QuestionResponseKey,
		A.OpenEndResponseKey,
		A.SurveyQuestionKey,
		A.GivenDateKey
select	top 10
		M.member_key MemberKey,
		L.organization_key BranchKey,
		COALESCE(N.program_group_key, -1) ProgramSiteLocationKey,
		K.survey_form_key OrganizationSurveyKey,
		Q.survey_question_key SurveyQuestionKey,
		O.survey_response_key QuestionResponseKey,
		K.batch_key,
		K.date_given_key GivenDateKey,
		1 current_indicator,
		A.ResponseCount
--select	TOP 10 *		
FROM	SeerDWH.dbo.factMemberSurveyResponse A
		INNER JOIN SeerDWH.dbo.dimMember B
			ON A.MemberKey = B.MemberKey
		INNER JOIN SeerDWH.dbo.dimBranch C
			ON A.BranchKey = C.BranchKey
		INNER JOIN SeerDWH.dbo.dimProgramSiteLocation D
			ON a.ProgramSiteLocationKey = D.ProgramSiteLocationKey
		INNER JOIN SeerDWH.dbo.dimProgramGroup E
			ON D.ProgramGroupKey = E.ProgramGroupKey
		INNER JOIN SeerDWH.dbo.dimOrganizationSurvey F
			ON A.OrganizationSurveyKey = F.OrganizationSurveyKey
		INNER JOIN SeerDWH.dbo.dimQuestionResponse G
			ON A.QuestionResponseKey = G.QuestionResponseKey
		INNER JOIN SeerDWH.dbo.dimSurveyQuestion H
			ON A.SurveyQuestionKey = H.SurveyQuestionKey
		INNER JOIN SeerDWH.dbo.dimQuestion I
			ON H.QuestionKey = I.QuestionKey
		INNER JOIN SeerDWH.dbo.dimOpenEndResponse J
			ON A.OpenEndResponseKey = J.OpenEndResponseKey
		INNER JOIN
		(
		SELECT	A.batch_key,
				A.batch_number,
				B.form_code,
				C.survey_form_key,
				C.survey_type,
				B.date_given_key,
				B.year_given_key,
				B.month_given_key
				
		FROM	Seer_MDM.dbo.Batch A
				INNER JOIN Seer_MDM.dbo.Survey_Form C
					ON A.form_code = C.survey_form_code
				INNER JOIN	
				(
				SELECT	A.form_code,
						DATEPART(YY, CONVERT(VARCHAR(20), A.date_given_key)) year_given_key,
						DATEPART(MM, CONVERT(VARCHAR(20), A.date_given_key)) month_given_key,
						MAX(date_given_key) date_given_key
						
				FROM	Seer_MDM.dbo.Batch A
				
				WHERE	A.date_given_key < 20120101
						AND A.current_indicator = 1
						
				GROUP BY A.form_code,
						DATEPART(YY, CONVERT(VARCHAR(20), date_given_key)),
						DATEPART(MM, CONVERT(VARCHAR(20), date_given_key))
				) B
				ON A.form_code = B.form_code
					AND A.date_given_key = B.date_given_key
					
		WHERE	A.current_indicator = 1
				AND C.current_indicator = 1
		) K
		ON F.SurveyType = K.survey_type
			AND LEFT(A.GivenDateKey, 4) = K.year_given_key
			AND CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), A.GivenDateKey), 5, 2)) = K.month_given_key
		INNER JOIN Seer_MDM.dbo.Organization L
			ON C.AssociationNumber = L.association_number
				AND C.OfficialBranchNumber = L.official_branch_number
		INNER JOIN Seer_MDM.dbo.Member_Map M
			ON B.SeerKey = M.seer_key
		INNER JOIN Seer_MDM.dbo.Survey_Response O
			ON (CASE WHEN LEN(G.ResponseCode) = 1 THEN '0' + G.ResponseCode
					ELSE G.ResponseCode
				END) = O.response_code
				AND K.survey_form_key = O.survey_form_key
		/*INNER JOIN Seer_MDM.dbo.Question P
			ON H.Question = P.question
		INNER JOIN Seer_MDM.dbo.Survey_Question Q
			ON K.survey_form_key = Q.survey_form_key
				AND P.question_key = Q.question_key
		LEFT JOIN Seer_MDM.dbo.Program_Group N
			ON D.ProgramSiteLocation = N.program_site_location
				AND D.ProgramGroup = N.program_group*/

where	A.GivenDateKey < 20120101
		AND L.current_indicator = 1
		AND N.current_indicator = 1
		AND O.current_indicator = 1
		AND P.current_indicator = 1
		AND Q.current_indicator = 1