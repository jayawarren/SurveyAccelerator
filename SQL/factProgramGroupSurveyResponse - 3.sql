USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factProgramGroupSurveyResponse]    Script Date: 07/28/2013 20:08:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[factProgramGroupSurveyResponse](
	[ProgramGroupSurveyResponseKey] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProgramGroupResponseKey] [int] NULL DEFAULT 0,
	[ProgramGroupKey] [int] NULL DEFAULT 0,
	[AssociationKey] [int] NULL DEFAULT 0,
	[OrganizationSurveyKey] [int] NULL DEFAULT 0,
	[SurveyQuestionKey] [int] NULL DEFAULT 0,
	[QuestionResponseKey] [int] NULL DEFAULT 0,
	[batch_key] [int] NULL DEFAULT 0,
	[GivenDateKey] [int] NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[ResponseCount] [int] NULL DEFAULT 0,
	[ResponsePercentage] [decimal](6, 5) NULL DEFAULT 0
	
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


