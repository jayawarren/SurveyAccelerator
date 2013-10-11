USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMem2012SurveyAssociations]    Script Date: 08/01/2013 18:41:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dd].[vwNewMem2012SurveyAssociations]
AS 
SELECT	B.AssociationName,
		B.AssociationNumber,	
		B.OfficialBranchName,
		B.OfficialBranchNumber,
		A.date_given_key GivenDateKey,
		B.BranchKey,
		B.AssociationKey,
		C.[Description]

FROM	Seer_MDM.dbo.Batch_Map A
		INNER JOIN dbo.dimBranch B
			ON A.organization_key = B.AssociationKey
		INNER JOIN dbo.dimSurveyForm C
			ON A.survey_form_key = 	C.SurveyFormKey
			
WHERE	C.SurveyType = 'YMCA New Member Satisfaction Survey'
		AND A.module = 'New Member'
		AND A.aggregate_type = 'Association'
		AND A.date_given_key > 20120101

GROUP BY B.AssociationName,
		B.AssociationNumber,	
		B.OfficialBranchName,
		B.OfficialBranchNumber,
		A.date_given_key,
		B.BranchKey,
		B.AssociationKey,
		C.[Description]


GO


