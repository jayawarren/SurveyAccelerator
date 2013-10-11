drop table Batch
go
CREATE TABLE [Batch](
	[SourceID] [varchar](50) DEFAULT '',
	[TargetDate] [varchar](50) DEFAULT '',
	[ReportDate] [varchar](50) DEFAULT '',
	[DateGivenKey] [int] DEFAULT 19000101,
	[BatchNumber] [varchar](20) DEFAULT '',
	[FormCode] varchar(50) DEFAULT '',
	[Enabled] [varchar](5) DEFAULT '',
	[Hidden] [varchar](5) DEFAULT '',
	[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP
GO


