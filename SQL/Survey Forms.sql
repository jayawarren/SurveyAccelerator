CREATE TABLE [dbo].[Survey Forms] (
[SurveyType] varchar(75),
[Description] varchar(100),
[CurrentFormFlag] varchar(5),
[SurveyFormId] varchar(25),
[SurveyLanguage] varchar(50),
[SurveyCutoffDays] varchar(10),
[ProductCategory] varchar(75),
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP