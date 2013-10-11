USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExBranchReportEx]    Script Date: 08/04/2013 17:25:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExBranchReportEx](
	[MemExBranchReportExKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationName] [varchar](100) DEFAULT '',
	[Branch] [varchar](100) DEFAULT '',
	[Category] [varchar](100) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[Question] [varchar](500) DEFAULT '',
	[QuestionCode] [varchar](10) DEFAULT '',
	[ShortQuestion] [varchar](100) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[CrtBranchPercentage] [decimal](38, 5) DEFAULT 0,
	[NationalPercentage] [decimal](38, 5) DEFAULT 0,
	[PrevBranchPercentage] [decimal](38, 5) DEFAULT 0,
	[CrtAssociationPercentage] [decimal](38, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


