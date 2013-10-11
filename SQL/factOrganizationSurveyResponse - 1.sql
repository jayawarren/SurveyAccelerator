USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factOrganizationSurveyResponse]    Script Date: 07/28/2013 09:48:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [factOrganizationSurveyResponse](
	[OrganizationSurveyResponseKey] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[SurveyFormKey] [int] NULL DEFAULT 0,
	[ResponseKey] [int] NULL DEFAULT 0,
	[QuestionKey] [int] NULL DEFAULT 0,
	[OrganizationResponseKey] [int] NULL DEFAULT 0,
	[OrganizationKey] [int] NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Year] [int] NULL,
	[SurveyType] [varchar](255) NULL,
	[ResponseCount] [int] NULL DEFAULT 0,
	[ResponsePercentage] [decimal](6, 5) NULL DEFAULT 0,
	[AvgBranchResponsePercentage] [decimal](6, 5) NULL DEFAULT 0,
	[AvgAssociationResponsePercentage] [decimal](6, 5) NULL DEFAULT 0,
	[StdDevBranchResponsePercentage] [decimal](6, 5) NULL DEFAULT 0,
	[StdDevAssociationResponsePercentage] [decimal](6, 5) NULL DEFAULT 0
	
) ON TRXGROUP

GO

SET ANSI_PADDING OFF
GO


