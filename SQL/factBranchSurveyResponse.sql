USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factBranchSurveyResponse]    Script Date: 07/21/2013 07:36:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE factBranchSurveyResponse
(
	[BranchSurveyResponseKey] [BIGINT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[BranchResponseKey] [INT] NOT NULL DEFAULT 0,
	[BranchKey][INT] NOT NULL DEFAULT 0,
	[OrganizationSurveyKey] [INT] NOT NULL DEFAULT 0,
	[SurveyQuestionKey] [INT] NOT NULL DEFAULT 0,
	[QuestionResponseKey] [INT] NOT NULL DEFAULT 0,
	[batch_key] [INT] NOT NULL DEFAULT 0,
	[GivenDateKey] [INT] NOT NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[ResponseCount] [INT] NOT NULL DEFAULT 0,
	[ResponsePercentage] [DECIMAL] (19, 6) DEFAULT 0,
	[ResponsePercentageZScore] [DECIMAL] (19, 6) DEFAULT 0
) ON TRXGROUP

GO


