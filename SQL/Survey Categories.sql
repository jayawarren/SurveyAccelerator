CREATE TABLE [dbo].[Survey Categories] (
[SurveyType] varchar(75),
[Description] varchar(100),
[QuestionNumber] varchar(10),
[Question] varchar(1000),
[CategoryType] varchar(25),
[Category] varchar(50),
[CategoryPosition] varchar(10),
[QuestionPosition] varchar(10),
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP