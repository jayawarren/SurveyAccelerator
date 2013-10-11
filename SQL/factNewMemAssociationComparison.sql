USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factNewMemAssociationComparison]    Script Date: 08/04/2013 07:14:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factNewMemAssociationComparison](
	[NewMemBranchComparisonKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 19000101,
	[PreviousGivenDateKey] [int] DEFAULT 19000101,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationNumber] [varchar](10) DEFAULT '',
	[AssociationName] [varchar](100) DEFAULT '',
	[Association] [varchar](100) DEFAULT '',
	[OfficialBranchNumber] [varchar](10) DEFAULT '',
	[OfficialBranchName] [varchar](100) DEFAULT '',
	[Branch] [varchar](100) DEFAULT '',
	[Question] [varchar](500) DEFAULT '',
	[ShortQuestion] [varchar](500) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[CategoryType] [varchar](50) DEFAULT '',
	[Category] [varchar](100) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[SurveyYear] [varchar](4) DEFAULT 1900,
	[BranchValue] [decimal](15, 5) DEFAULT 0,
	[PreviousValue] [decimal](15, 5) DEFAULT 0,
	[BranchValueDelta] [decimal](15, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO

