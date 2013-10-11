USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimSurveyForm]    Script Date: 07/31/2013 14:41:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 ALTER view [dbo].[dimSurveyForm] as
 select	A.survey_form_key as SurveyFormKey,
		A.survey_type as SurveyType,
		A.description as Description,
		A.survey_form_key as SourceID,
		A.product_category as ProductCategory

from	Seer_MDM.dbo.Survey_Form A

where	A.current_indicator = 1

GO


