drop table Question
go
CREATE TABLE [dbo].[Question] (
	[question_key] [int] NOT NULL IDENTITY (1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[current_indicator] [bit] DEFAULT 1,
	[question] varchar(1000),
	[short_question] varchar(255)
) ON DIMGROUP

