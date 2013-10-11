USE [Seer_ODS]
GO

/****** Object:  Table [dd].[factEmpSatAssocSurveyResponders]    Script Date: 08/03/2013 20:12:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dd].[factEmpSatAssocSurveyResponders]
(
	[EmpSatAssocSurveyRespondersKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Association] [varchar](100) DEFAULT 0,
	[Sent] [int] DEFAULT 0,
	[Received] [int] DEFAULT 0,
	[ResponseCount] [int] DEFAULT 0,
	[Question] [varchar](255) DEFAULT '',
	[QuestionPosition] [int] DEFAULT 0,
	[Response] [varchar] (255) DEFAULT '',
	[ResponsePosition] [int] DEFAULT 0,
	[CurrentResponsePercentage] [int] DEFAULT 0,
	[PreviousResponsePercentage] [int] DEFAULT 0,
	[CurrentSurveyPercentage] [int] DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


