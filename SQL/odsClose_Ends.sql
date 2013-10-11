CREATE TABLE [dbo].[Close_Ends] (
[close_ends_key] bigint identity (1, 1) NOT NULL PRIMARY KEY,
[create_datetime] [datetime] default getdate(),
[change_datetime] [datetime] default getdate(),
[next_change_datetime] [datetime] default dateadd(YY, 100, getdate()),
[current_indicator] [bit] default 1,
[module] [varchar](50) default '',
[batch_number] [varchar](10) default '',
[report_date] [datetime] default '1900-01-01',
[official_association_number] varchar(10) default '',
[official_branch_number] varchar(10) default '',
[form_code] [varchar](75) default '',
[member_key] [bigint] default 0,
[response_channel] [varchar](25) default '',
[question] [varchar](10) default '',
[response] [tinyint] default 0
) ON TRXGROUP