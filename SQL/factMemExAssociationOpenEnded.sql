USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExAssociationOpenEnded]    Script Date: 08/03/2013 07:43:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExAssociationOpenEnded](
	[MemExAssociationOpenEndedKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[batch_key] [int] DEFAULT 0,
	[AssociationName] [varchar](100) DEFAULT 0,
	[SurveyYear] [int] DEFAULT 1900,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[RowNumber] [int] DEFAULT 0,
	[OpenEndedGroup] [varchar](29) DEFAULT '',
	[Category] [varchar](255) DEFAULT '',
	[CategoryCount] [int] DEFAULT 0,
	[CategoryPercentage] [decimal](19, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


