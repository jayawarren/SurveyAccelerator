USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimQuestionCategory]    Script Date: 07/01/2013 01:37:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[dimQuestionCategory] as
select	A.category as Category,
		A.category_position as CategoryPosition,
		A.question_position as QuestionPosition,
		A.category_type as CategoryType,
		A.survey_question_key as SurveyQuestionKey

from	Seer_MDM.dbo.Survey_Category A

where	A.current_indicator = 1
GO


