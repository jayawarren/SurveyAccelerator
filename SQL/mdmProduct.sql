drop table Product
go
CREATE TABLE [Product](
	[product_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[source_id] [varchar](50) DEFAULT '',
	[category] [varchar](75) DEFAULT '',
	[number] [varchar](50) DEFAULT '',
	[code] [varchar](50) DEFAULT '',
	[enabled] [varchar] (5) DEFAULT '',
	[acronym] [varchar](50) DEFAULT '',
	[description] [varchar](4000) DEFAULT '',
	[list_price] money DEFAULT 0,
	[program_type] [varchar](75) DEFAULT '',
	[surveys_ordered_flag] [varchar](5) DEFAULT '',
	[survey_sample_flag] [varchar](5) DEFAULT ''
) ON DIMGROUP


