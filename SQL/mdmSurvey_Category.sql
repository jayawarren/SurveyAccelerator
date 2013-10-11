drop table Survey_Category
go
CREATE TABLE [dbo].[Survey_Category](
	[survey_category_key] INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	[survey_form_key] INT NOT NULL DEFAULT 0,
	[survey_question_key] INT NOT NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[category_type] [varchar](25) NOT NULL DEFAULT '',
	[category] [varchar](50) NOT NULL DEFAULT '',
	[category_position] INT NOT NULL DEFAULT 0,
	[question_position] INT NOT NULL DEFAULT 0
) ON [DIMGROUP]


