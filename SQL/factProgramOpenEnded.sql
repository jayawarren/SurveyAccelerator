USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factProgramOpenEnded]    Script Date: 08/03/2013 07:43:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factProgramOpenEnded](
	[ProgramOpenEndedKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[ProgramGroupKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [varchar](100) DEFAULT 0,
	[Program] [varchar](100) DEFAULT '',
	[Grouping] [varchar](100) DEFAULT '',
	[OpenEndedGroup] [varchar](255) DEFAULT '',
	[Category] [varchar](255) DEFAULT '',
	[Subcategory] [varchar](255) DEFAULT '',
	[Response] [varchar](1000) DEFAULT '',
	[CategoryPercentage] [decimal](19, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO

