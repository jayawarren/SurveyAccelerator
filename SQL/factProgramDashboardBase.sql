USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factProgramDashboardBase]    Script Date: 08/10/2013 21:06:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factProgramDashboardBase](
	[ProgramDashboardBaseKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[GroupingKey] [int] DEFAULT 0,
	[ProgramKey] [int] DEFAULT 0,
	[SurveyFormKey] [int] DEFAULT 0,
	[AssociationKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 19000101,
	[PrevGivenDateKey] [int] DEFAULT 19000101,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[GroupingLabel] [varchar](20) DEFAULT '',
	[GroupName] [varchar](100) DEFAULT '',
	[Program] [varchar](100) DEFAULT '',
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[AssociationNameEx] [varchar](100) DEFAULT '',
	[SurveyYear] [int] DEFAULT 1900,
	[PrevYear] [int] DEFAULT 1900,
	[SurveyType] [varchar](100) DEFAULT '',
	[SurveysSent] [int] DEFAULT 0,
	[SurveysReceived] [int] DEFAULT 0,
	[ResponsePercentage] [DECIMAL] (19,5) DEFAULT 0
) ON [TRXGROUP]