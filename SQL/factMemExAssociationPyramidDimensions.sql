USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factMemExAssociationPyramidDimensions]    Script Date: 08/02/2013 20:13:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factMemExAssociationPyramidDimensions](
	[MemExAssociationPyramidDimensionsKey] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[batch_key] [int] DEFAULT 0,
	[AssociationName] [varchar](100) DEFAULT '',
	[CategoryGroup] [varchar](7) DEFAULT '',
	[PyramidCategory] [varchar](100) DEFAULT '',
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationPercentile] [decimal](16, 10) DEFAULT 0,
	[PrevAssociationPercentile] [decimal](16, 10) DEFAULT 0,
	[Width] [numeric](24, 10) DEFAULT 0,
	[Height] [decimal](5, 2) DEFAULT 0,
	[SurveyYear] [int] DEFAULT 1900
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


