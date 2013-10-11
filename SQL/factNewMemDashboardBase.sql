USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factNewMemDashboardBase]    Script Date: 08/12/2013 21:06:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factNewMemDashboardBase](
	[NewMemDashboardBaseKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 19000101,
	[PrevGivenDateKey] [int] DEFAULT 19000101,
	[AssocGivenDateKey] [int] DEFAULT 19000101,
	[AssocPrevGivenDateKey] [int] DEFAULT 19000101,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[AssociationNameEx] [varchar](100) DEFAULT '',
	[OfficialBranchNumber] [varchar](10) DEFAULT '',
	[OfficialBranchName] [varchar](100) DEFAULT '',
	[BranchNameShort] [varchar](100) DEFAULT '',
	[SurveyDate] [int] DEFAULT 19000101,
	[SurveyYear] [int] DEFAULT 1900,
	[PrevYear] [int] DEFAULT 1900,
	[AssocSurveyDate] [int] DEFAULT 19000101,
	[AssocSurveyYear] [int] DEFAULT 1900,
	[AssocPrevYear] [int] DEFAULT 1900,
	[AssocGrpInd] [int] DEFAULT 0,
	[GrpInd] [int] DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


