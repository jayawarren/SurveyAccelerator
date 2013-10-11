USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgram2012SurveyAssociations]    Script Date: 08/10/2013 19:49:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dd].[vwProgram2012SurveyAssociations]
AS 
SELECT	B.AssociationName,
		B.AssociationNumber,
		D.ProgramCategory,
		D.ProgramCategory Program,
		D.ProgramGroup,
		D.ProgramType,
		A.date_given_key GivenDateKey,
		D.ProgramGroupKey,	
		B.AssociationKey,
		C.[Description]
--select	*
FROM	Seer_MDM.dbo.Batch_Map A
		INNER JOIN dbo.dimBranch B
			ON A.organization_key = B.AssociationKey
		INNER JOIN dbo.dimSurveyForm C
			ON A.survey_form_key = 	C.SurveyFormKey
		INNER JOIN dbo.dimProgramGroup D
			ON A.organization_key = D.AssociationKey
			
WHERE	C.ProductCategory LIKE '%Program Survey%'
		AND A.module = 'Program'
		AND A.aggregate_type = 'Association'
		AND A.date_given_key > 20120101

GROUP BY B.AssociationName,
		B.AssociationNumber,
		D.ProgramCategory,
		D.ProgramGroup,
		D.ProgramType,
		A.date_given_key,
		D.ProgramGroupKey,	
		B.AssociationKey,
		C.[Description]



GO


