INSERT INTO Seer_ODS.dbo.Close_Ends(module,
									batch_number,
									report_date,
									official_association_number,
									official_branch_number,
									form_code,
									member_key,
									response_channel,
									question,
									response
									)
SELECT	distinct
		J.module,
		I.batch_number,
		I.report_date,
		G.AssociationNumber official_association_number,
		G.OfficialBranchNumber official_branch_number,
		J.survey_form_code form_code,
		H.member_key,
		'' response_channel,
		LEFT(LOWER(E.SurveyColumn), 10) question,
		CASE WHEN (F.ResponseCode = '-1' OR ISNUMERIC(F.ResponseCode) = 0) THEN 0
			ELSE F.ResponseCode
		END response
		
FROM	SeerStaging.Survey.SurveyResults A
		INNER JOIN SeerStaging.Survey.OrganizationSurveys B
			ON A.OrganizationSurveyID = B.OrganizationSurveyID
		INNER JOIN SeerStaging.mem.MemberCleansed C
			ON A.MemberID = C.MemberCleansedId
		INNER JOIN SeerStaging.Survey.SurveyForms D
			ON B.SurveyFormID = D.SurveyFormID
		INNER JOIN SeerStaging.Survey.SurveyQuestions E
			ON A.SurveyQuestionID = E.SurveyQuestionID
		INNER JOIN SeerStaging.Survey.AvailableResponses F
			ON A.AvailableResponseID = F.AvailableResponseID
				AND A.SurveyQuestionID = F.SurveyQuestionID
		INNER JOIN SeerStaging.OIS.Organizations G
			ON B.OrganizationID = G.OrganizationId
		INNER JOIN Seer_MDM.dbo.Member_Map H
			ON A.MemberID = H.seer_key
		INNER JOIN Seer_MDM.dbo.Batch I
			ON D.SurveyForm = I.form_code
				AND DATEPART(YY, B.DateGiven) = DATEPART(YY, CONVERT(VARCHAR(20), I.date_given_key))
				AND DATEPART(MM, B.DateGiven) = DATEPART(MM, CONVERT(VARCHAR(20), I.date_given_key))
		INNER JOIN Seer_MDM.dbo.Survey_Form J
			ON D.SurveyForm = J.survey_form_code
			
WHERE	E.SurveyColumn IS NOT NULL
		AND E.SurveyOpenEndColumn IS NULL
		AND B.DateGiven < 'JAN 01 2012'
		AND I.current_indicator = 1
		AND J.current_indicator = 1;
				
		