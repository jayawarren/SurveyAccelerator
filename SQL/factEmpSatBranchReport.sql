USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factEmpSatBranchReport]    Script Date: 08/09/2013 23:32:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factEmpSatBranchReport](
	[EmpSatBranchReportKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 19000101,
	[PrevGivenDateKey] [int] DEFAULT 19000101,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [nvarchar](100) DEFAULT '',
	[Branch] [nvarchar](100) DEFAULT '',
	[CategoryType] [nvarchar](100) DEFAULT '',
	[Category] [nvarchar](100) DEFAULT '',
	[CategoryPosition] [int] DEFAULT 0,
	[Question] [nvarchar](255) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[AssociationValue] [float] DEFAULT 0,
	[PrvAssociationValue] [float] DEFAULT 0,
	[NationalValue] [float] DEFAULT 0,
	[CrtBranchValue] [float] DEFAULT 0,
	[PrvBranchValue] [float] DEFAULT 0,
	[ShortQuestion] [varchar](100) DEFAULT '',
	[QuestionCode] [varchar](10) DEFAULT ''
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


