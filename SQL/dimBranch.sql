USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimBranch]    Script Date: 06/30/2013 23:05:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[dimBranch] as
SELECT	A.organization_key as BranchKey,
		A.organization_name as OrganizationName,
		A.association_name as AssociationName,
		A.association_number as AssociationNumber,
		A.official_branch_name as OfficialBranchName,
		A.official_branch_number as OfficialBranchNumber,
		A.phone_number as PhoneNumber,
		A.branch_address_1 as BranchAddress1,
		A.branch_address_2 as BranchAddress2,
		A.branch_city as BranchCity,
		A.branch_state as BranchState,
		A.branch_postal as BranchPostal,
		A.branch_country as BranchCountry,
		A.branch_address_line_quality as BranchAddressLineQuality,
		A.branch_address_csz_quality as BranchAddressCSZQuality,
		A.msa_on_file as MSAOnFile,
		A.member_count as MemberCount,
		A.unit_count as UnitCount,
		A.peer_group as PeerGroup,
		A.source_id as SourceID,
		B.AssociationKey,
		B.OrganizationKey

FROM	Seer_MDM.dbo.Organization A
		INNER JOIN Seer_ODS.dbo.dimAssociation B
			ON A.association_number = B.AssociationNumber

WHERE	A.current_indicator = 1

GO


