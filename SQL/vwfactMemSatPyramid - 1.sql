USE [Seer_ODS]
GO

/****** Object:  View [dbo].[vwfactMemSatPyramid]    Script Date: 07/27/2013 19:52:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.vwfactMemSatPyramid where LEFT(GivenDateKey, 4) = 2012 and AssociationKey = 236

ALTER VIEW [dbo].[vwfactMemSatPyramid] as

SELECT	D.AssociationKey,
		D.BranchKey,
		D.SurveyFormKey,
		D.batch_key,
		D.GivenDateKey,
		D.current_indicator,
		D.PyramidCategory,
		AVG(D.ResponsePercentageZSCore) AvgZScore,
		Percentile = dbo.RoundToZero(dbo.NormSDist(AVG(D.ResponsePercentageZSCore))*100,0),
		D.HistoricalChangeIndex,
		D.HistoricalChangePercentile
		
FROM	(
		SELECT	C.AssociationKey,
				C.BranchKey,
				C.SurveyFormKey,
				C.batch_key,
				C.GivenDateKey,
				C.current_indicator,
				C.PyramidCategory,
				SUM(C.ResponsePercentageZSCore) ResponsePercentageZSCore,
				SUM(C.HistoricalChangeIndex) HistoricalChangeIndex,
				SUM(C.HistoricalChangePercentile) HistoricalChangePercentile
				
		FROM	(
				SELECT	B.organization_key AssociationKey,
						BSR.BranchKey,
						S.SurveyFormKey,
						BSR.batch_key,
						BSR.GivenDateKey,
						BSR.current_indicator,
						Q.Category PyramidCategory,
						BSR.ResponsePercentageZScore,
						--AVG(BSR.ResponsePercentageZScore) AvgZScore,
						--Percentile = dbo.RoundToZero(dbo.NormSDist(AVG(BSR.ResponsePercentageZScore))*100,0),
						0 HistoricalChangeIndex,
						0 HistoricalChangePercentile

				FROM	dbo.factBranchSurveyResponse BSR
						INNER JOIN Seer_MDM.dbo.Organization A
							ON BSR.BranchKey = A.organization_key
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.association_number = B.association_number
								AND A.association_number = B.official_branch_number
						INNER JOIN dimQuestionCategory Q
							ON BSR.SurveyQuestionKey = Q.SurveyQuestionKey
							AND Q.CategoryType = 'Pyramid'
						INNER JOIN dimOrganizationSurvey S
							ON BSR.OrganizationSurveyKey = S.OrganizationSurveyKey
							AND BSR.BranchKey = S.BranchKey
							AND BSR.GivenDateKey = S.GivenDateKey
							AND S.SurveyType = 'YMCA Membership Satisfaction Survey'
						INNER JOIN dimQuestionResponse R
							ON BSR.QuestionResponseKey = R.QuestionResponseKey
							AND R.IncludeInPyramidCalculation = 'Y'
							
				WHERE	BSR.current_indicator = 1
						AND A.current_indicator = 1
						AND B.current_indicator = 1

				UNION

				SELECT	ASR.AssociationKey,
						ASR.AssociationKey BranchKey,
						S.SurveyFormKey,
						ASR.batch_key,
						ASR.GivenDateKey,
						ASR.current_indicator,
						Q.Category PyramidCategory,
						ASR.ResponsePercentageZScore,
						--AVG(ASR.ResponsePercentageZScore) AvgZScore,
						--Percentile = dbo.RoundToZero(dbo.NormSDist(AVG(ASR.ResponsePercentageZScore))*100,0),
						0 HistoricalChangeIndex,
						0 HistoricalChangePercentile

				FROM	dbo.factAssociationSurveyResponse ASR
						INNER JOIN dimQuestionCategory Q
							ON ASR.SurveyQuestionKey = Q.SurveyQuestionKey
								AND Q.CategoryType = 'Pyramid'
						INNER JOIN dimSurveyForm S
							ON ASR.SurveyFormKey = S.SurveyFormKey
								AND S.SurveyType = 'YMCA Membership Satisfaction Survey'
						INNER JOIN dimQuestionResponse R
							ON ASR.QuestionResponseKey = R.QuestionResponseKey
								AND R.IncludeInPyramidCalculation = 'Y'
							
				WHERE	ASR.current_indicator = 1
				) C
				
		GROUP BY C.AssociationKey,
				C.BranchKey,
				C.SurveyFormKey,
				C.batch_key,
				C.GivenDateKey,
				C.current_indicator,
				C.PyramidCategory	
		) D
					
GROUP BY D.AssociationKey,
		D.BranchKey,
		D.SurveyFormKey,
		D.batch_key,
		D.GivenDateKey,
		D.current_indicator,
		D.PyramidCategory,
		D.HistoricalChangeIndex,
		D.HistoricalChangePercentile;
GO


