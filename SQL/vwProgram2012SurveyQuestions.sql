USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgram2012SurveyQuestions]    Script Date: 08/10/2013 22:17:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwProgram2012SurveyQuestions]
CREATE VIEW [dd].[vwProgram2012SurveyQuestions]
AS 
SELECT	LTRIM(RTRIM(REPLACE(REPLACE(sf.SurveyType, 'Satisfaction Survey', ''), 'YMCA', ''))) as Program,
		sf.SurveyFormKey,
		sf.SurveyType,
		qc.CategoryType, 
		qc.Category,
		sq.Question,	
		sq.QuestionNumber,	
		ltrim(rtrim(sq.ShortQuestion)) as ShortQuestion,
		sq.SurveyQuestionKey,
		sf.[Description],
		qc.CategoryPosition,
		qc.QuestionPosition
	
FROM	dbo.dimSurveyQuestion sq
		LEFT JOIN dbo.dimQuestionCategory qc
			ON qc.SurveyQuestionKey = sq.SurveyQuestionKey
		INNER JOIN dbo.dimSurveyForm sf
			on sf.SurveyFormKey = sq.SurveyFormKey
		INNER JOIN Seer_MDM.dbo.Survey_Form s
			on sf.SurveyFormKey = s.survey_form_key

WHERE	s.product_category LIKE '%Program%'
		and s.current_form_flag = 'Y'

GO


