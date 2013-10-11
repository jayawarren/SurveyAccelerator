USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExBranchDetailSurveyQuestions]    Script Date: 08/04/2013 11:58:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExBranchDetailSurveyQuestions](
	[MemExBranchDetailSurveyQuestionsKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
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
	[Question] [varchar](500) DEFAULT '',
	[ResponseText] [varchar](255) DEFAULT '',
	[PeerGroup] [int] DEFAULT '',
	[BranchPercentage] [decimal](19, 5) DEFAULT 0,
	[AssociationPercentage] [decimal](19, 5) DEFAULT 0,
	[NationalPercentage] [decimal](19, 5) DEFAULT 0,
	[PeerPercentage] [decimal](19, 5) DEFAULT 0,
	[PreviousBranchPercentage] [decimal](19, 5) DEFAULT 0,
	[CategoryPosition] [int] DEFAULT 0,
	[QuestionPosition] [int] DEFAULT 0,
	[ResponseCode] [int] DEFAULT 0,
	[QuestionNumber] [int] DEFAULT 0,
	[txtBranchPercentage] [varchar](10) DEFAULT '',
	[txtAssociationPercentage] [varchar](10) DEFAULT '',
	[txtNationalPercentage] [varchar](10) DEFAULT '',
	[txtPeerPercentage] [varchar](10) DEFAULT '',
	[txtPreviousBranchPercentage] [varchar](10) DEFAULT '',
	[ReportType] [varchar](20) DEFAULT ''
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


