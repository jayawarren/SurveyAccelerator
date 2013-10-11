CREATE TABLE [Product](
	[Number] [varchar](50) DEFAULT '',
	[Enabled] [varchar] (5) DEFAULT '',
	[Acronym] [varchar](50) DEFAULT '',
	[ListPrice] [varchar](10) DEFAULT '',
	[Description] [varchar](4000) DEFAULT '',
	[SourceID] [varchar](50) DEFAULT '',
	[CreateDateTime] [datetime] DEFAULT GETDATE() 
) ON DIMGROUP


