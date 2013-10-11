USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factProgramDetailSurvey]    Script Date: 08/12/2013 11:11:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factProgramDetailSurvey](
	[ProgramDetailSurveyKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[ProgramGroupKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [nvarchar](100) DEFAULT '',
	[Program] [nvarchar](100) DEFAULT '',
	[Grouping] [nvarchar](100) DEFAULT '',
	[CategoryType] [nvarchar](100) DEFAULT '',
	[Category] [nvarchar](100) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[Question] [nvarchar](255) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[Response] [nvarchar](255) DEFAULT '',
	[ResponsePosition] [int] DEFAULT 0,
	[CrtPercentage] [float] DEFAULT 0,
	[PrevPercentage] [float] DEFAULT 0,
	[NationalPercentage] [float] DEFAULT 0,
	[AssociationPercentage] [float] DEFAULT 0,
	[ReportType] [varchar](20) DEFAULT ''
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


