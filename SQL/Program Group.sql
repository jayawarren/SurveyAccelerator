CREATE TABLE [dbo].[Program Group] (
[ORGANIZATION_NAME] varchar(75),
[OFF_BR_NUM] varchar(10),
[Program_Type] varchar(75),
[Program_Site_Location] varchar(100),
[Group_Name] varchar(75),
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON DIMGROUP