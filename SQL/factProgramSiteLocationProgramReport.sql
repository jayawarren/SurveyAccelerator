USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factProgramSiteLocationProgramReport]    Script Date: 07/31/2013 20:23:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[factProgramSiteLocationProgramReport](
	[ProgramSiteLocationProgramReportKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[ProgramSiteLocationKey] [int] DEFAULT 0,
	[OrganizationSurveyKey] [int] DEFAULT 0,
	[QuestionResponseKey] [int] DEFAULT 0,
	[SurveyQuestionKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[ProgramSiteLocationCount] [int] DEFAULT 0,
	[ProgramSiteLocationPercentage] [decimal](15, 5) DEFAULT 0,
	[ProgramGroupPercentage] [decimal](15, 5) DEFAULT 0,
	[AssociationPercentage] [decimal](15, 5) DEFAULT 0,
	[NationalPercentage] [decimal](15, 5) DEFAULT 0,
	[PreviousProgramSiteLocationPercentage] [decimal](15, 5) DEFAULT 0,
	[SegmentNPPromoter] [decimal](15, 5) DEFAULT 0,
	[SegmentNPDetractor] [decimal](15, 5) DEFAULT 0,
	[SegmentNPNeither] [decimal](15, 5) NULL
) ON [TRXGROUP]

GO


