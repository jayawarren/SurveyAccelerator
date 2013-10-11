CREATE TABLE [dbo].[Survey Questions] (
[SurveyType] varchar(75),
[Description] varchar(100),
[QuestionNumber] varchar(10),
[Question] varchar(1000),
[ShortQuestion] varchar(255),
[PercentageDenominator] varchar(50),
[SurveyColumn] varchar(50),
[SurveyOpenEndColumn] varchar(50),
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP