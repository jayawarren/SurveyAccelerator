USE [Seer_ODS]
GO

/****** Object:  VIEW [dbo].[factProgramSiteLocationSurveyResponse]    Script Date: 07/27/2013 21:32:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[factProgramSiteLocationSurveyResponse] AS
SELECT	A.ProgramSiteLocationKey ProgramSiteLocationResponseKey,
		A.ProgramSiteLocationKey,
		A.OrganizationSurveyKey,
		A.SurveyQuestionKey,
		C.QuestionResponseKey,
		A.GivenDateKey,
		A.SurveyCount,
		C.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN B.PercentageDenominator = 'Survey' THEN C.ResponseCount/A.SurveyCount
												ELSE
													CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN C.ResponseCount/A.SurveyCount
														ELSE C.ResponseCount/A.QuestionCount
													END
											END, 5)

FROM	(
		SELECT	COUNT(DISTINCT sr.MemberKey) ResponseCount,
				sr.ProgramSiteLocationKey,
				sr.OrganizationSurveyKey,
				sr.QuestionResponseKey,
				sr.SurveyQuestionKey,
				sr.GivenDateKey
				
		FROM	Seer_ODS.dbo.factMemberSurveyResponse sr

		WHERE	sr.ProgramSiteLocationKey <> -1
				AND sr.current_indicator = 1

		GROUP BY sr.ProgramSiteLocationKey,
				sr.OrganizationSurveyKey,
				sr.QuestionResponseKey,
				sr.SurveyQuestionKey,
				sr.GivenDateKey
		) C
		INNER JOIN
		(
		SELECT	ProgramSiteLocationKey,
				OrganizationSurveyKey,
				PSR.SurveyQuestionKey,
				GivenDateKey,
				SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
						ELSE ResponseCount
					END) AS QuestionCount,
				SUM(PSR.ResponseCount) AS SurveyCount
				
		FROM	(
				SELECT	COUNT(DISTINCT sr.MemberKey) ResponseCount,
						sr.ProgramSiteLocationKey,
						sr.OrganizationSurveyKey,
						sr.QuestionResponseKey,
						sr.SurveyQuestionKey,
						sr.GivenDateKey
						
				FROM	Seer_ODS.dbo.factMemberSurveyResponse sr

				WHERE	sr.ProgramSiteLocationKey <> -1
						AND sr.current_indicator = 1

				GROUP BY sr.ProgramSiteLocationKey,
						sr.OrganizationSurveyKey,
						sr.QuestionResponseKey,
						sr.SurveyQuestionKey,
						sr.GivenDateKey
				) PSR
				INNER JOIN dimQuestionResponse DQR
					ON PSR.QuestionResponseKey = DQR.QuestionResponseKey
					
		GROUP BY ProgramSiteLocationKey,
				OrganizationSurveyKey,
				PSR.SurveyQuestionKey,
				GivenDateKey
		) A
		ON C.GivenDateKey = A.GivenDateKey
				AND C.OrganizationSurveyKey = A.OrganizationSurveyKey
				AND C.ProgramSiteLocationKey = A.ProgramSiteLocationKey
				AND C.SurveyQuestionKey = A.SurveyQuestionKey
		INNER JOIN dimSurveyQuestion B
			ON C.SurveyQuestionKey = B.SurveyQuestionKey
		INNER JOIN dimQuestionResponse D
					ON C.QuestionResponseKey = D.QuestionResponseKey
GO


