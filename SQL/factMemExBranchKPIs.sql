USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExBranchKPIs]    Script Date: 08/04/2013 13:47:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExBranchKPIs](
	[MemExBranchKPIsKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0, 
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationName] [varchar](100) DEFAULT '',
	[Branch] [varchar](100) DEFAULT 0,
	[SurveyYear] [int] DEFAULT 1900,
	[CategoryType] [varchar](50) DEFAULT '',
	[Category] [varchar](50) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[Question] [varchar](255) DEFAULT '',
	[SortOrder] [int] DEFAULT 0,
	[BranchPercentage] [decimal](38, 5) DEFAULT 0,
	[AssociationPercentage] [decimal](38, 5) DEFAULT 0,
	[NationalPercentage] [decimal](38, 5) DEFAULT 0,
	[PreviousBranchPercentage] [decimal](38, 5) DEFAULT 0,
	[PeerGroupPercentage] [decimal](15, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


