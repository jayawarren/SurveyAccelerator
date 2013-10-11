CREATE TABLE [dbo].[Top_Box] (
[top_box_key] bigint identity (1, 1) NOT NULL PRIMARY KEY,
[create_datetime] [datetime] default getdate(),
[change_datetime] [datetime] default getdate(),
[next_change_datetime] [datetime] default dateadd(YY, 100, getdate()),
[current_indicator] [bit] default 1,
[module] [varchar](50) default '',
[aggregate_type] [varchar](50) default '',
[response_load_date] [datetime] default '1900-01-01',
[official_association_number] varchar(10) default '',
[official_branch_number] varchar(10) default '',
[form_code] [varchar](75) default '',
[survey_year] [smallint] default 2001,
[calculation] [varchar](25) default '',
[measure_type] [varchar](50) default '',
[measure_value] decimal(19, 6) default 0
) ON TRXGROUP