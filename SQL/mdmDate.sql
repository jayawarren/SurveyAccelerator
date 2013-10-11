CREATE TABLE [dbo].[Date](
	[date_key] [int] IDENTITY(0, 1) not null PRIMARY KEY,
	[create_datetime] [datetime] default getdate(),
	[current_indicator] bit default 1,
	[date] [datetime] default getdate(),
	[standard_date] [varchar](20) default '',
	[year] [char](5)  default '',
	[quarter] [varchar](10)  default '',
	[month] [varchar](10)  default '',
	[day] [varchar](10)  default '',
	[quarter_number] [tinyint]  default 0,
	[quarter_description] [varchar](100)  default '',
	[quarter_name] [varchar](75)  default '',
	[month_number] [tinyint]  default 0,
	[month_description] [varchar](100)  default '',
	[month_name] [varchar](75)  default '',
	[day_number] [tinyint]  default '',
	[day_description] [varchar](100)  default '',
	[day_of_week] [tinyint]  default 0,
	[day_name] [varchar](75)  default ''
) ON DIMGROUP

GO



