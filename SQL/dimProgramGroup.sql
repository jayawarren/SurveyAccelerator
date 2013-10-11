USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimProgramGroup]    Script Date: 07/01/2013 01:28:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[dimProgramGroup] as
SELECT	MIN(A.program_group_key) as ProgramGroupKey,
		A.organization_key as AssociationKey,
		A.program_type as ProgramType,
		A.program_group as ProgramGroup,
		A.program_category as ProgramCategory
		
FROM	Seer_MDM.dbo.Program_Group A
		INNER JOIN Seer_MDM.dbo.Organization B
			ON A.organization_key = B.organization_key

WHERE	A.current_indicator = 1
		
GROUP BY A.organization_key,
		A.program_type,
		A.program_group,
		A.program_category
GO


