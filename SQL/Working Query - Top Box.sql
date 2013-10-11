SELECT	C.organization_key AssociationKey,
		B.organization_key BranchKey,
		D.survey_form_key SurveyFormKey,
		E.survey_question_key SurveyQuestionKey,
		F.survey_response_key SurveyResponseKey,
		G.batch_key,
		A.module,
		A.aggregate_type,
		CASE WHEN DATEDIFF(MM, A.create_datetime, A.response_load_date) < 3 THEN DATEPART(YY, A.response_load_date) - 1
			ELSE DATEPART(YY, A.response_load_date)
		END SurveyYear,
		E.survey_column SurveyColumn,
		RIGHT(A.measure_type, 2) ResponseCode,
		A.measure_value ResponsePercentage
		
FROM	dbo.Top_Box A
		INNER JOIN Seer_MDM.dbo.Organization B
			ON A.official_association_number = B.association_number
				AND A.official_branch_number = B.official_branch_number
		INNER JOIN Seer_MDM.dbo.Organization C
			ON A.official_association_number = C.association_number
				AND A.official_association_number = C.official_branch_number
		INNER JOIN Seer_MDM.dbo.Survey_Form D
			ON A.form_code = D.survey_form_code
		INNER JOIN Seer_MDM.dbo.Survey_Question E
			ON D.survey_form_key = E.survey_form_key
				AND UPPER(LEFT(A.measure_type, 4)) = E.survey_column
		INNER JOIN Seer_MDM.dbo.Survey_Response F
			ON	D.survey_form_key = F.survey_form_key
				AND E.survey_question_key = F.survey_question_key	
				AND RIGHT(A.measure_type, 2) = F.response_code
		INNER JOIN Seer_MDM.dbo.Batch G
			ON A.form_code = G.form_code
				AND (CASE WHEN DATEDIFF(MM, A.create_datetime, A.response_load_date) < 3 THEN DATEPART(YY, A.response_load_date) - 1
						ELSE DATEPART(YY, A.response_load_date)
					END) = LEFT(G.date_given_key, 4)

WHERE	A.module = 'Member'
		AND	A.aggregate_type = 'Association'
		AND A.calculation = 'average'
		AND A.measure_value <> 0
		AND A.current_indicator = 1
		AND B.current_indicator = 1
		AND C.current_indicator = 1
		AND D.current_indicator = 1
		AND E.current_indicator = 1
		AND F.current_indicator = 1
		AND G.current_indicator = 1
		