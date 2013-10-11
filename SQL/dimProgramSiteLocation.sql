USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimProgramSiteLocation]    Script Date: 07/01/2013 01:32:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[dimProgramSiteLocation] as
select	A.program_group_key as ProgramSiteLocationKey,
		B.organization_key as AssociationKey,
		A.program_type as ProgramType,
		A.program_site_location as ProgramSiteLocation,
		A.program_group as ProgramGroup,
		C.ProgramGroupKey

from	Seer_MDM.dbo.Program_Group A
		INNER JOIN Seer_MDM.dbo.Organization B
			ON A.organization_key = B.organization_key
		INNER JOIN Seer_ODS.dbo.dimProgramGroup C
			ON A.organization_key = C.AssociationKey
				AND A.program_category = C.ProgramCategory
				AND A.program_group = C.ProgramGroup
				AND A.program_type = C.ProgramType

where	A.current_indicator = 1

GO


