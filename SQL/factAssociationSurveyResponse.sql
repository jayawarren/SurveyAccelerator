USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factAssociationSurveyResponse]    Script Date: 07/21/2013 07:36:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE factAssociationSurveyResponse
(
	[AssociationSurveyResponseKey] [BIGINT] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[AssociationResponseKey] [INT] NOT NULL DEFAULT 0,
	[AssociationKey][INT] NOT NULL DEFAULT 0,
	[SurveyFormKey] [INT] NOT NULL DEFAULT 0,
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


