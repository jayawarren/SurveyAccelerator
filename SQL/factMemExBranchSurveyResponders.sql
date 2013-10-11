USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExBranchSurveyResponders]    Script Date: 08/03/2013 20:12:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExBranchSurveyResponders]
(
	[MemExBranchSurveyRespondersKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT 0,
	[AssociationName] [varchar](100) DEFAULT 0,
	[OfficialBranchNumber] [varchar](10) DEFAULT 0,
	[OfficialBranchName] [varchar](100) DEFAULT 0,
	[Year] [varchar](4) DEFAULT 0,
	[Members] [int] DEFAULT 0,
	[SurveysMailed] [int] DEFAULT 0,
	[ResponsePercentage] [decimal](10, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


