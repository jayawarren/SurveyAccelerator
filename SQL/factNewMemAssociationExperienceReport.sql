USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factNewMemAssociationExperienceReport]    Script Date: 08/04/2013 07:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factNewMemAssociationExperienceReport](
	[NewMemAssociationExperienceReportKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 19000101,
	[PreviousGivenDateKey] [int] DEFAULT 19000101,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[CurrentSurveyIndicator] [smallint] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[Association] [varchar](100) DEFAULT '',
	[Question] [varchar](500) DEFAULT '',
	[ShortQuestion] [varchar](500) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[QuestionCode] [varchar](50) DEFAULT '',
	[CategoryType] [varchar](50) DEFAULT '',
	[Category] [varchar](100) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[GivenSurveyCategory] [varchar](100) DEFAULT '',
	[GivenSurveyDate] [int] DEFAULT 19000101,
	[SurveyYear] [varchar](4) DEFAULT 1900,
	[CurrentSurveyYear] [varchar](4) DEFAULT 1900,
	[PreviousSurveyYear] [varchar](4) DEFAULT 1900,
	[AssociationCount] [int] DEFAULT 0,
	[AssociationPercentage] [int] DEFAULT 0,
	[CurrentPercentage] [int] DEFAULT 0,
	[PreviousPercentage] [int] DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


