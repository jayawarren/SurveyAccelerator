SELECT	A.SurveyFormKey,
		A.QuestionKey,
		A.ResponseKey,
		A.OrganizationKey,
		A.Year,
		A.PeerGroup,
		A.SurveyType,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN COALESCE(C.PercentageDenominator,'Survey') = 'Survey' THEN A.ResponseCount/B.SurveyCount 
													ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN A.ResponseCount/B.SurveyCount 
															ELSE A.ResponseCount/B.QuestionCount
														END
													END, 5)

FROM	(
		SELECT	bsr.OrganizationSurveyKey SurveyFormKey,
				dq.QuestionKey,
				dr.ResponseKey, 
				db.OrganizationKey,
				ds.SurveyType, 
				CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)) Year, 
				CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
					ELSE COALESCE(db.PeerGroup,'Unknown')
				END PeerGroup,
				SUM(ResponseCount) ResponseCount
				
		FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
				INNER JOIN dimBranch db
					ON bsr.BranchKey = db.BranchKey
				INNER JOIN dimSurveyForm ds
					ON bsr.OrganizationSurveyKey = ds.SurveyFormKey
				INNER JOIN dimSurveyQuestion dq
					ON bsr.OrganizationSurveyKey = dq.SurveyFormKey
						AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
				INNER JOIN dimQuestionResponse dr
					ON bsr.SurveyQuestionKey = dr.SurveyQuestionKey
						AND bsr.QuestionResponseKey = dr.QuestionResponseKey

		--SurveyFormKey Filter for performance				
		WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
					
		GROUP BY bsr.OrganizationSurveyKey,
				dq.QuestionKey,
				dr.ResponseKey, 
				db.OrganizationKey,
				ds.SurveyType, 
				CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)), 
				CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
					ELSE COALESCE(db.PeerGroup,'Unknown')
				END
		) A
		INNER JOIN
		(
		SELECT	PSR.SurveyFormKey,
				PSR.QuestionKey,
				PSR.OrganizationKey,
				PSR.Year,
				PSR.SurveyType,
				PSR.PeerGroup,
				SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
							ELSE
					PSR.ResponseCount END) AS QuestionCount,
				SUM(PSR.ResponseCount) AS SurveyCount

		FROM	(
				SELECT	bsr.OrganizationSurveyKey SurveyFormKey,
						dr.ResponseKey, 
						dq.QuestionKey,
						db.OrganizationKey,
						ds.SurveyType, 
						CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)) Year, 
						CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
							ELSE COALESCE(db.PeerGroup,'Unknown')
						END PeerGroup,
						SUM(ResponseCount) ResponseCount
						
				FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
						INNER JOIN dimBranch db
							ON bsr.BranchKey = db.BranchKey
						INNER JOIN dimSurveyForm ds
							ON bsr.OrganizationSurveyKey = ds.SurveyFormKey
						INNER JOIN dimSurveyQuestion dq
							ON bsr.OrganizationSurveyKey = dq.SurveyFormKey
								AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
						INNER JOIN dimQuestionResponse dr
							ON bsr.SurveyQuestionKey = dr.SurveyQuestionKey
								AND bsr.QuestionResponseKey = dr.QuestionResponseKey

				--SurveyFormKey Filter for performance				
				WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
							
				GROUP BY bsr.OrganizationSurveyKey,
						dr.ResponseKey, 
						dq.QuestionKey,
						db.OrganizationKey,
						ds.SurveyType, 
						CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)), 
						CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
							ELSE COALESCE(db.PeerGroup,'Unknown')
						END
				
				) PSR
				INNER JOIN
				(
				SELECT	DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey, 
						DSF.SurveyType,
						MAX(DQR.ExcludeFromReportCalculation) AS ExcludeFromReportCalculation
						
				FROM	dimSurveyForm DSF
						INNER JOIN dimSurveyQuestion DSQ
							ON DSF.SurveyFormKey = DSQ.SurveyFormKey
						INNER JOIN dimQuestionResponse DQR
							ON DSQ.SurveyQuestionKey = DQR.SurveyQuestionKey
							
				GROUP BY DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey,
						DSF.SurveyType
				) DQR
					ON PSR.SurveyFormKey = DQR.SurveyFormKey
					AND PSR.QuestionKey = DQR.QuestionKey
					AND PSR.ResponseKey = DQR.ResponseKey
					
		GROUP BY PSR.SurveyFormKey,
				PSR.QuestionKey,
				PSR.OrganizationKey,
				PSR.Year,
				PSR.SurveyType,
				PSR.PeerGroup
		) B
			ON A.SurveyFormKey = B.SurveyFormKey
				AND A.QuestionKey = B.QuestionKey
				AND A.OrganizationKey = B.OrganizationKey
				AND A.Year = B.Year
				AND A.PeerGroup = B.PeerGroup
		INNER JOIN dimSurveyQuestion C
			ON A.SurveyFormKey = C.SurveyFormKey
				AND A.QuestionKey = C.QuestionKey
		INNER JOIN dimQuestionResponse D
			ON C.SurveyQuestionKey = D.SurveyQuestionKey
				AND A.ResponseKey = D.ResponseKey
				
--SurveyFormKey Filter for performance				
WHERE	A.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
;