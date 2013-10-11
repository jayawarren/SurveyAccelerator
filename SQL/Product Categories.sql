CREATE TABLE [dbo].[Product Categories](
	[Category] [varchar](75) NOT NULL DEFAULT '',
	[Code] [varchar](50) NOT NULL DEFAULT '',
	[SurveysOrderedFlag] [varchar](5) NOT NULL DEFAULT '',
	[SurveySampleFlag] [varchar](5) NOT NULL DEFAULT '',
	[ProgramType] [varchar](75) NOT NULL DEFAULT '',
	[CreateDateTime] [datetime] NULL DEFAULT GETDATE()
) ON [DIMGROUP]


