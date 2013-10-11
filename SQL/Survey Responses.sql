CREATE TABLE [dbo].[Survey Responses] (
[SurveyType] varchar(75),
[Description] varchar(100),
[QuestionNumber] varchar(10),
[Question] varchar(1000),
[ResponseCode] varchar(10),
[ResponseText] varchar(1000),
[CategoryCode] varchar(10),
[Category] varchar(75),
[IncludeInPyramidCalculation] varchar(5),
[ExcludeFromReportCalculation] varchar(5),
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP