USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factProgramSurveyResponders]    Script Date: 08/12/2013 11:11:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factProgramSurveyResponders](
	[ProgramSurveyRespondersKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
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
	[Question] [nvarchar](255) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[Response] [nvarchar](255) DEFAULT '',
	[ResponsePosition] [int] DEFAULT 0,
	[ResponseCount] [int] DEFAULT 0,
	[CurrentResponsePercentage] [float] DEFAULT 0,
	[PreviousResponsePercentage] [float] DEFAULT 0,
	[CrtAssocResponsePercentage] [float] DEFAULT 0,
	[PrvAssocResponsePercentage] [float] DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


