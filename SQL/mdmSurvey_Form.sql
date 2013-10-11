drop table Survey_Form
GO
CREATE TABLE [dbo].[Survey_Form] (
	[survey_form_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[survey_type] varchar(75) DEFAULT '',
	[description] varchar(4000) DEFAULT '',
	[current_form_flag] varchar(5) DEFAULT '',
	[survey_form_code] varchar(75) DEFAULT '',
	[survey_language] varchar(50) DEFAULT '',
	[survey_cut_off_days] smallint DEFAULT 0,
	[product_category] varchar(75) DEFAULT '',
	[module] varchar(50) DEFAULT ''
) ON DIMGROUP