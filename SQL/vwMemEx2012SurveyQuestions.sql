USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemEx2012SurveyQuestions]    Script Date: 08/04/2013 08:25:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemEx2012SurveyQuestions] where Questionnumber = 44
ALTER VIEW [dd].[vwMemEx2012SurveyQuestions]
AS 
SELECT	qc.CategoryType,
		qc.Category,
		sq.Question,	
		sq.QuestionNumber,
		sq.ShortQuestion,
		sq.SurveyQuestionKey,
		qc.CategoryPosition,
		qc.QuestionPosition

FROM	dbo.dimSurveyQuestion sq
		LEFT JOIN dbo.dimQuestionCategory qc
			ON qc.SurveyQuestionKey = sq.SurveyQuestionKey
		INNER JOIN dbo.dimSurveyForm sf
			ON sf.SurveyFormKey = sq.SurveyFormKey
				AND sf.Description like '2012%mem%sat'








GO


