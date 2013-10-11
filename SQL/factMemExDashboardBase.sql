USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExDashboardBase]    Script Date: 08/02/2013 07:22:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExDashboardBase](
	[MemExDashboardBaseKey] [int] IDENTITY NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 0,
	[PrevGivenDateKey] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](20) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[AssociationNameEx] [varchar](100) DEFAULT '',
	[OfficialBranchNumber] [varchar](20) DEFAULT '',
	[OfficialBranchName] [varchar](100) DEFAULT '',
	[BranchNameShort] [varchar](100) DEFAULT'',
	[SurveyYear] [int] DEFAULT 1900,
	[PrevYear] [int] DEFAULT 1900
	
 ) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


