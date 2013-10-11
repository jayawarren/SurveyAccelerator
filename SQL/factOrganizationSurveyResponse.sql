USE [Seer_ODS]
GO

/****** Object:  View [dbo].[factOrganizationSurveyResponse]    Script Date: 07/28/2013 02:29:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
--select * from dbo.factOrganizationSurveyResponse
ALTER VIEW [dbo].[factOrganizationSurveyResponse] AS
SELECT	A.SurveyFormKey,
		A.QuestionKey,
		A.ResponseKey,
		A.OrganizationKey OrganizationResponseKey,
		A.OrganizationKey,
		A.Year,
		E.SurveyType,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN COALESCE(C.PercentageDenominator,'Survey') = 'Survey' THEN A.ResponseCount/B.SurveyCount
												ELSE
													CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'Y') = 'Y' THEN A.ResponseCount/B.SurveyCount 
														ELSE A.ResponseCount/B.QuestionCount
													END
											END, 5),
		A.AvgBranchResponsePercentage,
		A.AvgAssociationResponsePercentage,
		A.StdDevBranchResponsePercentage,
		A.StdDevAssociationResponsePercentage
		
--SELECT	*											
FROM	(
		SELECT	asr.OrganizationSurveyKey SurveyFormKey,
				dq.QuestionKey,
				dr.ResponseKey,
				asr.OrganizationKey,
				CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4)) Year,
				SUM(bsr.ResponseCount) ResponseCount,
				AVG(bsr.ResponsePercentage) AvgBranchResponsePercentage,
				MAX(asr.AvgAssociationResponsePercentage) AvgAssociationResponsePercentage,
				CAST(CASE WHEN STDEVP(bsr.ResponsePercentage) IS NULL THEN 0
					ELSE STDEVP(bsr.ResponsePercentage)
				END  AS DECIMAL(6,5)) StdDevBranchResponsePercentage,
				MAX(asr.StdDevAssociationResponsePercentage) StdDevAssociationResponsePercentage

		FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
				inner join dimBranch db
					ON bsr.BranchKey = db.BranchKey
				INNER JOIN dimSurveyQuestion dq 
					on bsr.OrganizationSurveyKey = dq.SurveyFormKey
						AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
				INNER JOIN dimQuestionResponse dr 
					on bsr.SurveyQuestionKey = dr.SurveyQuestionKey
						AND bsr.QuestionResponseKey = dr.QuestionResponseKey
				INNER JOIN
				(SELECT	AVG(asr.ResponsePercentage) AS AvgAssociationResponsePercentage,
						CAST(CASE WHEN STDEVP(asr.ResponsePercentage) IS NULL THEN 0
								ELSE STDEVP(asr.ResponsePercentage)
							END  AS DECIMAL(6,5)) AS StdDevAssociationResponsePercentage,
						da.OrganizationKey,
						da.AssociationKey,
						asr.SurveyFormKey OrganizationSurveyKey,
						CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4)) Year,
						dr.ResponseKey,
						dq.QuestionKey
				
				FROM 	Seer_ODS.dbo.factAssociationSurveyResponse asr
						INNER JOIN dimAssociation da
							ON asr.AssociationKey = da.AssociationKey
						INNER JOIN dimSurveyQuestion dq 
							ON asr.SurveyFormKey = dq.SurveyFormKey
								AND asr.SurveyQuestionKey = dq.SurveyQuestionKey
						INNER JOIN dimQuestionResponse dr 
							ON asr.SurveyQuestionKey = dr.SurveyQuestionKey
								AND asr.QuestionResponseKey = dr.QuestionResponseKey
						
				
				--Filter added for performance
				WHERE	asr.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
				
				GROUP BY da.OrganizationKey,
						da.AssociationKey,
						CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4)),
						asr.SurveyFormKey,
						dq.QuestionKey,
						dr.ResponseKey
				) asr
					ON bsr.OrganizationSurveyKey = asr.OrganizationSurveyKey
						AND CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4)) = asr.Year
						AND db.OrganizationKey = asr.OrganizationKey
						AND dq.QuestionKey = asr.QuestionKey
						AND dr.ResponseKey = asr.ResponseKey
										
		--Filter added for performance
		WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
						
		GROUP BY asr.OrganizationSurveyKey,
				dq.QuestionKey,
				dr.ResponseKey,
				asr.OrganizationKey,
				CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4))	
		) A
		INNER JOIN dimSurveyForm E
			ON A.SurveyFormKey = E.SurveyFormKey
		INNER JOIN dimSurveyQuestion C
			ON A.SurveyFormKey = C.SurveyFormKey
			AND A.QuestionKey = C.QuestionKey
		INNER JOIN dimQuestionResponse D
			ON A.ResponseKey = D.ResponseKey
		INNER JOIN
		(
		SELECT	OSR.SurveyFormKey,
				OSR.QuestionKey,
				OrganizationKey,
				Year,
				SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'Y') = 'Y' THEN 0
						ELSE ResponseCount
				END) AS QuestionCount,
				SUM(ResponseCount) AS SurveyCount
				
		FROM	(
				SELECT	asr.OrganizationSurveyKey SurveyFormKey,
						dq.QuestionKey,
						dr.ResponseKey,
						asr.OrganizationKey,
						CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4)) Year,
						SUM(bsr.ResponseCount) ResponseCount,
						AVG(bsr.ResponsePercentage) AvgBranchResponsePercentage,
						MAX(asr.AvgAssociationResponsePercentage) AvgAssociationResponsePercentage,
						CAST(CASE WHEN STDEVP(bsr.ResponsePercentage) IS NULL THEN 0
							ELSE STDEVP(bsr.ResponsePercentage)
						END  AS DECIMAL(6,5)) StdDevBranchResponsePercentage,
						MAX(asr.StdDevAssociationResponsePercentage) StdDevAssociationResponsePercentage
						
						

				FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
						inner join dimBranch db
							ON bsr.BranchKey = db.BranchKey
						INNER JOIN dimSurveyQuestion dq 
							on bsr.OrganizationSurveyKey = dq.SurveyFormKey
								AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
						INNER JOIN dimQuestionResponse dr 
							on bsr.SurveyQuestionKey = dr.SurveyQuestionKey
								AND bsr.QuestionResponseKey = dr.QuestionResponseKey
						INNER JOIN
						(SELECT	AVG(asr.ResponsePercentage) AS AvgAssociationResponsePercentage,
								CAST(CASE WHEN STDEVP(asr.ResponsePercentage) IS NULL THEN 0
										ELSE STDEVP(asr.ResponsePercentage)
									END  AS DECIMAL(6,5)) AS StdDevAssociationResponsePercentage,
								da.OrganizationKey,
								da.AssociationKey,
								asr.SurveyFormKey OrganizationSurveyKey,
								CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4)) Year,
								dr.ResponseKey,
								dq.QuestionKey
						
						FROM 	Seer_ODS.dbo.factAssociationSurveyResponse asr
								INNER JOIN dimAssociation da
									ON asr.AssociationKey = da.AssociationKey
								INNER JOIN dimQuestionResponse dr 
									ON asr.SurveyQuestionKey = dr.SurveyQuestionKey
										AND asr.QuestionResponseKey = dr.QuestionResponseKey
								INNER JOIN dimSurveyQuestion dq 
									ON asr.SurveyFormKey = dq.SurveyFormKey
										AND asr.SurveyQuestionKey = dq.SurveyQuestionKey
						
						--Filter added for performance
						WHERE	asr.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
						
						GROUP BY asr.SurveyFormKey,
								dq.QuestionKey,
								dr.ResponseKey,
								da.OrganizationKey,
								da.AssociationKey,
								CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4))
						) asr
							ON bsr.OrganizationSurveyKey = asr.OrganizationSurveyKey
								AND dq.QuestionKey = asr.QuestionKey
								AND dr.ResponseKey = asr.ResponseKey
								AND db.OrganizationKey = asr.OrganizationKey
								AND CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4)) = asr.Year
								
								
												
				--Filter added for performance
				WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
								
				GROUP BY asr.OrganizationSurveyKey,
						dq.QuestionKey,
						dr.ResponseKey,
						asr.OrganizationKey,
						CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4))
				) OSR
				LEFT OUTER JOIN
				(
				SELECT	DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey, 
						MAX(COALESCE(DQR.ExcludeFromReportCalculation,'')) AS ExcludeFromReportCalculation
						
				FROM	dimSurveyForm DSF
						INNER JOIN dimSurveyQuestion DSQ
							ON DSF.SurveyFormKey = DSQ.SurveyFormKey
						INNER JOIN dimQuestionResponse DQR
							ON DSQ.SurveyQuestionKey = DQR.SurveyQuestionKey
							
				GROUP BY DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey
				) DQR
					ON OSR.SurveyFormKey = DQR.SurveyFormKey
						AND OSR.QuestionKey = DQR.QuestionKey
						AND OSR.ResponseKey = DQR.ResponseKey
						
		--Filter added for performance
		WHERE	OSR.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
				
		GROUP BY OSR.SurveyFormKey,
				OSR.QuestionKey,
				OrganizationKey,
				Year
		) B
			ON A.SurveyFormKey = B.SurveyFormKey
				AND A.QuestionKey = B.QuestionKey
				AND A.OrganizationKey = B.OrganizationKey
				AND A.Year = B.Year
GO

SET ANSI_PADDING OFF
GO


