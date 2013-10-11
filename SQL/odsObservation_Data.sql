CREATE TABLE [dbo].[Observation_Data] (
[observation_data_key] [bigint] not null identity(1, 1) PRIMARY KEY,
[member_key] [bigint] default 0,
[seer_key] [bigint] default 0,
[create_datetime] [datetime] default getdate(),
[current_indicator] [bit] default 1,
[form_code] varchar(25) default '',
[batch_number] varchar(10) default '',
[official_association_number] varchar(10) default '',
[official_branch_number] varchar(10) default '',
[site_location] varchar(75) default '',
[channel] varchar(25) default '',
[status] varchar(25) default '',
[response_date] [datetime] default getdate()
) ON TRXGROUP