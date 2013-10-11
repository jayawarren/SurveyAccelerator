drop table Survey_Response
go
CREATE TABLE [dbo].[Survey_Response] (
	[survey_response_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[survey_question_key] [int] DEFAULT -1,
	[survey_form_key] [int] DEFAULT -1,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[response_code] varchar(10) DEFAULT '',
	[response_text] varchar(1000) DEFAULT '',
	[category_code] varchar(10) DEFAULT '',
	[category] varchar(75) DEFAULT '',
	[include_in_pyramid_calculation] varchar(1) DEFAULT '',
	[exclude_from_report_calculation] varchar(1) DEFAULT ''
) ON DIMGROUP