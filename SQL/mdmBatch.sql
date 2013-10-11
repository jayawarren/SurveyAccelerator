drop table Batch
go
CREATE TABLE [Batch](
	[batch_key] int NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[source_id] [varchar](50) DEFAULT '',
	[batch_number] [varchar](20) DEFAULT '',
	[form_code] [varchar] (75) DEFAULT '',
	[target_date] [varchar](50) DEFAULT '',
	[report_date] [varchar](50) DEFAULT '',
	[date_given_key] [int] DEFAULT 19000101,
	[enabled] [varchar](5) DEFAULT '',
	[hidden] [varchar](5) DEFAULT ''
) ON DIMGROUP
GO


