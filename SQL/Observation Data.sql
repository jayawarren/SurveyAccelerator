CREATE TABLE [dbo].[Observation Data] (
[Member_Key] varchar(20) Default '',
[Seer_Key] varchar(20) Default '',
[Form_Code] varchar(25) Default '',
[Batch_Number] varchar(10) Default '',
[Off_Assoc_Num] varchar(10) Default '',
[Off_Br_Num] varchar(10) Default '',
[Channel] varchar(25) Default '',
[Status] varchar(25) Default '',
[Response_Date] varchar(25) Default '',
[CreateDateTime] [datetime] DEFAULT GETDATE()
) ON TRXGROUP



