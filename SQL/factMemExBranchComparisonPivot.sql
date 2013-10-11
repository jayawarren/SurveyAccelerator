USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExBranchComparisonPivot]    Script Date: 08/04/2013 18:39:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExBranchComparisonPivot](
	[MemExBranchComparisonPivotKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [varchar](100) DEFAULT '',
	[Branch] [varchar](100) DEFAULT '',
	[Q010101] [varchar](10) DEFAULT '',
	[Q010202] [varchar](10) DEFAULT '',
	[Q010303] [varchar](10) DEFAULT '',
	[Q010404] [varchar](10) DEFAULT '',
	[Q010505] [varchar](10) DEFAULT '',
	[Q010606] [varchar](10) DEFAULT '',
	[Q020101] [varchar](10) DEFAULT '',
	[Q020202] [varchar](10) DEFAULT '',
	[Q020303] [varchar](10) DEFAULT '',
	[Q020404] [varchar](10) DEFAULT '',
	[Q020505] [varchar](10) DEFAULT '',
	[Q020606] [varchar](10) DEFAULT '',
	[Q020707] [varchar](10) DEFAULT '',
	[Q020808] [varchar](10) DEFAULT '',
	[Q030101] [varchar](10) DEFAULT '',
	[Q030102] [varchar](10) DEFAULT '',
	[Q030103] [varchar](10) DEFAULT '',
	[Q030104] [varchar](10) DEFAULT '',
	[Q030105] [varchar](10) DEFAULT '',
	[Q030106] [varchar](10) DEFAULT '',
	[Q030107] [varchar](10) DEFAULT '',
	[Q030108] [varchar](10) DEFAULT '',
	[Q030109] [varchar](10) DEFAULT '',
	[Q030201] [varchar](10) DEFAULT '',
	[Q030202] [varchar](10) DEFAULT '',
	[Q030203] [varchar](10) DEFAULT '',
	[Q030204] [varchar](10) DEFAULT '',
	[Q030205] [varchar](10) DEFAULT '',
	[Q030206] [varchar](10) DEFAULT '',
	[Q030207] [varchar](10) DEFAULT '',
	[Q030208] [varchar](10) DEFAULT '',
	[Q030209] [varchar](10) DEFAULT '',
	[Q030301] [varchar](10) DEFAULT '',
	[Q030302] [varchar](10) DEFAULT '',
	[Q030303] [varchar](10) DEFAULT '',
	[Q030304] [varchar](10) DEFAULT '',
	[Q030305] [varchar](10) DEFAULT '',
	[Q030306] [varchar](10) DEFAULT '',
	[Q030307] [varchar](10) DEFAULT '',
	[Q030308] [varchar](10) DEFAULT '',
	[Q030309] [varchar](10) NULL
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


