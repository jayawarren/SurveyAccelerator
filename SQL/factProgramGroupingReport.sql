USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factProgramGroupingReport]    Script Date: 08/04/2013 15:23:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factProgramGroupingReport](
	[ProgramGroupingReportKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[ProgramGroupKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [varchar](100) DEFAULT '',
	[Program] [varchar](100) DEFAULT '',
	[Grouping] [varchar](100) DEFAULT '',
	[Category] [varchar](100) DEFAULT '',
	[CategoryType] [varchar](50) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[Question] [varchar](500) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[QuestionCode] [varchar](10) DEFAULT '',
	[ShortQuestion] [varchar](255) DEFAULT '',
	[AssociationValue] [decimal](38, 5) DEFAULT 0,
	[PrvAssociationValue] [decimal](38, 5) DEFAULT 0,
	[NationalValue] [decimal](38, 5) DEFAULT 0,
	[CrtGroupingValue] [decimal](38, 5) DEFAULT 0,
	[PrvGroupingValue] [decimal](38, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


