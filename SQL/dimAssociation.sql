USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimAssociation]    Script Date: 08/25/2013 04:28:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
ALTER view [dbo].[dimAssociation] as
select	A.organization_key AssociationKey,
		A.organization_name OrganizationName,
		A.association_name AssociationName,
		A.association_number AssociationNumber,
		A.organization_key OrganizationKey
from	Seer_MDM.dbo.Organization A
where	A.association_number = A.official_branch_number
		AND A.current_indicator = 1

GO


