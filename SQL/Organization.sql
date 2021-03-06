CREATE TABLE [Organization](
	[OrganizationName] [varchar](50) DEFAULT '',
	[OrganizationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[AssociationNumber] [varchar](10) DEFAULT '',
	[OfficialBranchName] [varchar](100) DEFAULT '',
	[ShortBranchName] [varchar](50) DEFAULT '',
	[OfficialBranchNumber] [varchar](10) DEFAULT '',
	[LocalBranchNumber] [varchar](10) DEFAULT '',
	[BranchAddress1] [varchar](100) DEFAULT '',
	[BranchAddress2] [varchar](100) DEFAULT '',
	[BranchCity] [varchar](100) DEFAULT '',
	[BranchState] [varchar](25) DEFAULT '',
	[BranchPostal] [varchar](25) DEFAULT '',
	[BranchCountry] [varchar](25) DEFAULT '',
	[BranchAddressLineQuality] [varchar](20) DEFAULT '',
	[BranchAddressCSZQuality] [varchar](20) DEFAULT '',
	[SignatureName] [varchar](75) DEFAULT '',
	[SignatureTitle] [varchar](75) DEFAULT '',
	[CallName] [varchar](75) DEFAULT '',
	[CallBranchAssociation] [varchar](50) DEFAULT '',
	[CallPhone] [varchar](50) DEFAULT '',
	[MemberCount] [varchar](10) DEFAULT '',
	[UnitCount] [varchar](10) DEFAULT '',
	[LoadDate] [varchar](50) DEFAULT '',
	[PhoneNumber] [varchar](20) DEFAULT '',
	[MSAOnFile] [varchar](5) DEFAULT '',
	[SourceID] [varchar](50) DEFAULT '',
	[SubSourceID] [varchar](50) DEFAULT '',
	[PeerGroup] [varchar](50) DEFAULT '',
	[ActiveFlag] [varchar](5) DEFAULT '',
	[CustomQuestion1] [varchar](255) DEFAULT '',
	[CustomQuestion2] [varchar](255) DEFAULT '',
	[CustomQuestion3] [varchar](255) DEFAULT '',
	[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP


