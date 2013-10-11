USE [Seer_ODS]
GO

/****** Object:  View [dbo].[vwfactMemSatPyramid]    Script Date: 07/27/2013 19:52:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from dbo.vwfactMemSatPyramid where AssociationKey = 302

ALTER VIEW [dbo].[vwfactMemSatPyramid] as

SELECT	BSR.BranchKey AssociationKey,
		BSR.BranchKey,
		S.SurveyFormKey,
		BSR.batch_key,
		BSR.GivenDateKey,
		BSR.current_indicator,
		Q.Category PyramidCategory,
		AVG(BSR.ResponsePercentageZScore) AvgZScore,
		Percentile = dbo.RoundToZero(dbo.NormSDist(AVG(BSR.ResponsePercentageZScore))*100,0),
		0 HistoricalChangeIndex,
		0 HistoricalChangePercentile

FROM	factBranchSurveyResponse BSR
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
			
GROUP BY BSR.BranchKey,
		S.SurveyFormKey,
		BSR.batch_key,
		BSR.GivenDateKey,
		BSR.current_indicator,
		Q.Category

UNION

SELECT	ASR.AssociationKey,
		ASR.AssociationKey BranchKey,
		S.SurveyFormKey,
		ASR.batch_key,
		ASR.GivenDateKey,
		ASR.current_indicator,
		Q.Category PyramidCategory,
		AVG(ASR.ResponsePercentageZScore) AvgZScore,
		Percentile = dbo.RoundToZero(dbo.NormSDist(AVG(ASR.ResponsePercentageZScore))*100,0),
		0 HistoricalChangeIndex,
		0 HistoricalChangePercentile

FROM	factAssociationSurveyResponse ASR
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

GROUP BY ASR.AssociationKey,
		S.SurveyFormKey,
		ASR.batch_key,
		ASR.GivenDateKey,
		ASR.current_indicator,
		Q.Category;
GO


