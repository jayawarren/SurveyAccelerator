USE [Seer_ODS]
GO

/****** Object:  View [dbo].[factProgramGroupSurveyResponse]    Script Date: 08/01/2013 11:29:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[factProgramGroupSurveyResponse] AS
	
SELECT	A.ProgramGroupKey ProgramGroupResponseKey,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN C.PercentageDenominator = 'Survey' THEN A.ResponseCount/B.SurveyCount
												ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN A.ResponseCount/B.SurveyCount
															ELSE A.ResponseCount/B.QuestionCount
														END
											END, 5),
		A.ProgramGroupKey,
		A.OrganizationSurveyKey,
		A.QuestionResponseKey,
		A.SurveyQuestionKey,
		A.GivenDateKey
											
FROM	(
		SELECT	SUM(PSR.ResponseCount) ResponseCount,
				DPG.ProgramGroupKey,
				PSR.OrganizationSurveyKey, 
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.GivenDateKey
				
		FROM	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse PSR
				INNER JOIN Seer_ODS.dbo.dimProgramSiteLocation DPG
					ON PSR.ProgramSiteLocationKey = DPG.ProgramSiteLocationKey
		
		--SurveyFormKey Filter is for performance			
		WHERE	PSR.OrganizationSurveyKey IN	(
												SELECT	SurveyFormKey
												FROM	dimSurveyForm
												WHERE	ProductCategory LIKE '%Program Survey%'
												)
					
		GROUP BY DPG.ProgramGroupKey,
				PSR.OrganizationSurveyKey,
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.GivenDateKey
		) A
		INNER JOIN
		(
		SELECT	A.ProgramGroupKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.GivenDateKey,
				SUM(CASE WHEN COALESCE(C.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
						ELSE A.ResponseCount
					END) AS QuestionCount,
				SUM(A.ResponseCount) AS SurveyCount
				
		FROM	(
				SELECT	SUM(PSR.ResponseCount) ResponseCount,
						DPG.ProgramGroupKey,
						PSR.OrganizationSurveyKey, 
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.GivenDateKey
						
				FROM	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse PSR
						INNER JOIN Seer_ODS.dbo.dimProgramSiteLocation DPG
							ON PSR.ProgramSiteLocationKey = DPG.ProgramSiteLocationKey
				
				--SurveyFormKey Filter is for performance		
				WHERE	PSR.OrganizationSurveyKey IN	(
														SELECT	SurveyFormKey
														FROM	dimSurveyForm
														WHERE	ProductCategory LIKE '%Program Survey%'
														)
							
				GROUP BY DPG.ProgramGroupKey,
						PSR.OrganizationSurveyKey,
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.GivenDateKey
				) A
				INNER JOIN dimSurveyQuestion B
					ON A.SurveyQuestionKey = B.SurveyQuestionKey
				INNER JOIN dimQuestionResponse C
					ON A.QuestionResponseKey = C.QuestionResponseKey
					
		GROUP BY A.ProgramGroupKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.GivenDateKey
		) B
			ON A.ProgramGroupKey = B.ProgramGroupKey
				AND A.OrganizationSurveyKey = B.OrganizationSurveyKey
				AND A.SurveyQuestionKey = B.SurveyQuestionKey
				AND A.GivenDateKey = B.GivenDateKey
		INNER JOIN Seer_ODS.dbo.dimSurveyQuestion C
			ON A.SurveyQuestionKey = C.SurveyQuestionKey
		INNER JOIN Seer_ODS.dbo.dimQuestionResponse D
			ON A.QuestionResponseKey = D.QuestionResponseKey


GO


