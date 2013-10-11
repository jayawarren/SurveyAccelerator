USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMemAssociationComparison]    Script Date: 08/13/2013 19:36:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--select * from [dd].[vwNewMemAssociationComparison] where ASsociationname = 'YMCA of Greater Seattle'
CREATE VIEW [dd].[vwNewMemAssociationComparison]
AS 
SELECT	A.AssociationNumber, 
		A.AssociationName,
		A.Association,
		A.OfficialBranchNumber,
		A.OfficialBranchName,
		A.Branch,
		A.SurveyYear,
		A.Question,
		A.ShortQuestion,
		A.CategoryType,
		A.Category,
		A.CategoryPosition,
		A.QuestionPosition,
		A.BranchPercentage AS BranchValue,
		A.PreviousPercentage AS PreviousValue,
		A.BranchPercentage - A.PreviousPercentage AS BranchValueDelta

FROM	[dd].factNewMemBranchExperienceReport A

GO


