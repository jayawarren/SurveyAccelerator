USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factMemSatPyramid]    Script Date: 08/04/2013 15:23:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[factMemSatPyramid](
	[MemSatPyramidKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[BranchKey] [int] DEFAULT 0,
	[SurveyFormKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[PyramidCategory] [varchar](50) DEFAULT '',
	[AvgZScore] [decimal](38, 6) DEFAULT 0,
	[Percentile] [decimal](32, 16) DEFAULT 0,
	[HistoricalChangeIndex] [int] DEFAULT 1900,
	[HistoricalChangePercentile] [int] DEFAULT 1900
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


