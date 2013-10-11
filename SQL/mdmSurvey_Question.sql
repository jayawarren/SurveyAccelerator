drop table Survey_Question
go
CREATE TABLE [dbo].[Survey_Question] (
	[survey_question_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[survey_form_key] [int] DEFAULT 0,
	[question_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[question_number] varchar(10),
	[percentage_denominator] varchar(50),
	[survey_column] varchar(50),
	[survey_open_end_column] varchar(50)
) ON DIMGROUP

