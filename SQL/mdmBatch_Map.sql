CREATE TABLE [Batch_Map](
	[batch_map_key] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[organization_key] [int] DEFAULT 0,
	[survey_form_key]  [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[previous_batch_key] [int] DEFAULT 0,
	[previous_year_batch_key] [int] DEFAULT 0,
	[date_given_key] [int] DEFAULT 19000101,
	[previous_date_given_key] [int] DEFAULT 19000101,
	[previous_year_date_given_key] [int] DEFAULT 19000101,
	[module] varchar(50) DEFAULT '',
	[aggregate_type] varchar(20) DEFAULT '',
) ON DIMGROUP


