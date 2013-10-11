USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factNewMemAssociationComparisonPivot]    Script Date: 08/04/2013 18:39:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factNewMemAssociationComparisonPivot](
	[NewMemAssociationComparisonPivotKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[Association] [varchar](100) DEFAULT '',
	[OfficialBranchNumber] [varchar](10) DEFAULT '',
	[OfficialBranchName] [varchar](100) DEFAULT '',
	[Branch] [varchar](100) DEFAULT '',
	[Q010101] [varchar](10) DEFAULT '',
	[Q010201] [varchar](10) DEFAULT '',
	[Q010204] [varchar](10) DEFAULT '',
	[Q010205] [varchar](10) DEFAULT '',
	[Q010301] [varchar](10) DEFAULT '',
	[Q010302] [varchar](10) DEFAULT '',
	[Q010303] [varchar](10) DEFAULT '',
	[Q010401] [varchar](10) DEFAULT '',
	[Q020501] [varchar](10) DEFAULT '',
	[Q020502] [varchar](10) DEFAULT '',
	[Q020503] [varchar](10) DEFAULT '',
	[Q020504] [varchar](10) DEFAULT '',
	[Q020505] [varchar](10) DEFAULT '',
	[Q020506] [varchar](10) DEFAULT '',
	[Q020507] [varchar](10) DEFAULT '',
	[Q020508] [varchar](10) DEFAULT '',
	[Q020601] [varchar](10) DEFAULT '',
	[Q020602] [varchar](10) DEFAULT '',
	[Q020603] [varchar](10) DEFAULT '',
	[Q020604] [varchar](10) DEFAULT '',
	[Q020605] [varchar](10) DEFAULT '',
	[Q020902] [varchar](10) DEFAULT '',
	[Q020903] [varchar](10) DEFAULT '',
	[Q020904] [varchar](10) DEFAULT '',
	[Q020905] [varchar](10) DEFAULT '',
	[Q031101] [varchar](10) DEFAULT '',
	[Q031102] [varchar](10) DEFAULT ''

) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


