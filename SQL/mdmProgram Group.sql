drop table Program_Group
go
CREATE TABLE [dbo].[Program_Group] (
	[program_group_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[organization_key] [int] DEFAULT -1,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[program_group] varchar(75) DEFAULT '',
	[program_category] varchar(75) DEFAULT '',
	[program_type] varchar(75) DEFAULT '',
	[program_site_location] varchar(100)
) ON DIMGROUP