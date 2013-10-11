USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimOrganizationSurvey]    Script Date: 07/01/2013 01:12:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 ALTER view [dbo].[dimOrganizationSurvey] as
 select	C.survey_form_key as OrganizationSurveyKey,
		C.survey_type as SurveyType,
		C.description as Description,
		COUNT(A.member_key) as NumberSurveysMailed,
		D.date_given_key GivenDateKey,
		D.source_id as SourceID,
		C.survey_form_key as SurveyFormKey,
		B.organization_key as BranchKey
		
from	dbo.Observation_Data A
		INNER JOIN Seer_MDM.dbo.Organization B
			ON A.official_association_number = B.association_number
				AND A.official_branch_number = B.official_branch_number
		INNER JOIN Seer_MDM.dbo.Survey_Form C
			ON A.form_code = C.survey_form_code
		INNER JOIN Seer_MDM.dbo.Batch D
			ON A.batch_number = D.batch_number
				AND A.form_code = D.form_code

where	A.channel IN ('Mail', 'Online')
		AND A.status = 'Sent'
		AND A.current_indicator = 1

group by C.survey_type,
		C.description,
		D.date_given_key,
		D.source_id,
		C.survey_form_key,
		B.organization_key
GO


