USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factPeerGroupSurveyResponse]    Script Date: 07/28/2013 20:08:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[factPeerGroupSurveyResponse](
	[PeerGroupSurveyResponseKey] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SurveyFormKey] [int] NULL DEFAULT 0,
	[QuestionKey] [int] NULL DEFAULT 0,
	[ResponseKey] [int] NULL DEFAULT 0,
	[OrganizationKey] [int] NULL DEFAULT 0,
	[PeerGroupResponseKey] [int] NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[PeerGroup] [varchar](50) NULL DEFAULT '',
	[Year] [int] NULL DEFAULT 1900,
	[SurveyType] [varchar](255) NULL DEFAULT 0,
	[ResponseCount] [bigint] NULL DEFAULT 0,
	[ResponsePercentage] [decimal](6, 5) NULL DEFAULT 0
	
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


