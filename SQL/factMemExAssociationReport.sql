USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExAssociationReport]    Script Date: 08/04/2013 15:23:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExAssociationReport](
	[MemExAssociationReportKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[Association] [varchar](100) DEFAULT '',
	[Category] [varchar](100) DEFAULT '',
	[CategoryType] [varchar](50) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[SurveyYear] [int] DEFAULT 1900,
	[Question] [varchar](500) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[QuestionCode] [varchar](10) DEFAULT '',
	[ShortQuestion] [varchar](100) DEFAULT '',
	[AssociationCount] [int] DEFAULT 0,
	[CrtAssociationPercentage] [decimal](38, 5) DEFAULT 0,
	[CrtAssociationPercentageYrDelta] [decimal](38, 5) DEFAULT 0,
	[NationalPercentage] [decimal](38, 5) DEFAULT 0,
	[CrtAssociationPercentageNtnlDelta] [decimal](38, 5) DEFAULT 0,
	[PrevAssociationPercentage] [decimal](38, 5) DEFAULT 0,
	[PeerGroupPercentage] [decimal](38, 5) DEFAULT 0,
	[PreviousSurveyYear] [varchar](4) DEFAULT '1900',
	[CurrentNumericYear] [int] DEFAULT 1900,
	[PreviousNumericYear] [int] DEFAULT 1900,
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


