USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimSurveyQuestion]    Script Date: 07/01/2013 01:55:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[dimSurveyQuestion] as
select	A.survey_question_key as SurveyQuestionKey,
		A.question_number as QuestionNumber,
		'' as QuestionType,
		'' as ResponseType,
		B.question as Question,
		B.short_question as ShortQuestion,
		A.percentage_denominator as PercentageDenominator,
		A.survey_form_key as SourceID,
		A.survey_form_key as SurveyFormKey,
		A.question_key as QuestionKey

from	Seer_MDM.dbo.Survey_Question A
		INNER JOIN Seer_MDM.dbo.Question B
			ON A.question_key = B.question_key

where	A.current_indicator = 1
		AND B.current_indicator = 1
GO
