USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimQuestionResponse]    Script Date: 07/01/2013 01:44:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[dimQuestionResponse] as
select	A.survey_response_key as QuestionResponseKey,
		A.response_code as ResponseCode,
		A.response_text as ResponseText,
		A.category_code as CategoryCode,
		A.category as Category,
		A.include_in_pyramid_calculation as IncludeInPyramidCalculation,
		A.exclude_from_report_calculation as ExcludeFromReportCalculation,
		A.survey_form_key as SourceID,
		A.survey_question_key as SurveyQuestionKey,
		A.survey_response_key as ResponseKey

from	Seer_MDM.dbo.Survey_Response A

where	A.current_indicator = 1

GO


