USE [Seer_ODS]
GO

/****** Object:  View [dbo].[factProgramGroupSurveyResponse]    Script Date: 09/06/2013 07:36:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from factProgramGroupSurveyResponse

ALTER VIEW [dbo].[factProgramGroupSurveyResponse] AS
	
SELECT	A.ProgramGroupKey ProgramGroupResponseKey,
		A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey,
		A.QuestionResponseKey,
		A.SurveyQuestionKey,
		A.batch_key,
		A.GivenDateKey,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN C.PercentageDenominator = 'Survey' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.SurveyCount
												ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.SurveyCount
															ELSE CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.QuestionCount
														END
											END, 5)
											
FROM	(
		SELECT	DPG.ProgramGroupKey,
				DPG.AssociationKey,
				PSR.OrganizationSurveyKey, 
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.batch_key,
				PSR.GivenDateKey,
				SUM(PSR.ResponseCount) ResponseCount
	
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
				DPG.AssociationKey,
				PSR.OrganizationSurveyKey,
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.batch_key,
				PSR.GivenDateKey
		) A
		INNER JOIN
		(
		SELECT	A.ProgramGroupKey,
				A.AssociationKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.batch_key,
				A.GivenDateKey,
				SUM(CASE WHEN COALESCE(C.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
						ELSE A.ResponseCount
					END) AS QuestionCount,
				SUM(A.ResponseCount) AS SurveyCount
				
		FROM	(
				SELECT	DPG.ProgramGroupKey,
						DPG.AssociationKey,
						PSR.OrganizationSurveyKey, 
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.batch_key,
						PSR.GivenDateKey,
						SUM(PSR.ResponseCount) ResponseCount
						
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
						DPG.AssociationKey,
						PSR.OrganizationSurveyKey,
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.batch_key,
						PSR.GivenDateKey
				) A
				INNER JOIN dimSurveyQuestion B
					ON A.SurveyQuestionKey = B.SurveyQuestionKey
				INNER JOIN dimQuestionResponse C
					ON A.QuestionResponseKey = C.QuestionResponseKey
					
		GROUP BY A.ProgramGroupKey,
				A.AssociationKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.batch_key,
				A.GivenDateKey
		) B
			ON A.ProgramGroupKey = B.ProgramGroupKey
				AND A.AssociationKey = B.AssociationKey
				AND A.OrganizationSurveyKey = B.OrganizationSurveyKey
				AND A.SurveyQuestionKey = B.SurveyQuestionKey
				AND A.batch_key	 = B.batch_key
				AND A.GivenDateKey = B.GivenDateKey
		INNER JOIN Seer_ODS.dbo.dimSurveyQuestion C
			ON A.SurveyQuestionKey = C.SurveyQuestionKey
		INNER JOIN Seer_ODS.dbo.dimQuestionResponse D
			ON A.QuestionResponseKey = D.QuestionResponseKey



GO


