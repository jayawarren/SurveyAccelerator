USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimDate]    Script Date: 06/30/2013 23:31:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[dimDate] as
select	A.date_key as DateKey,
		A.date as Date,
		A.standard_date as StandardDate,
		A.year as Year,
		A.quarter as Quarter,
		A.month as Month,
		A.day as Day,
		A.quarter_number as QuarterNum,
		A.quarter_description as QuarterDescr,
		A.quarter_name as QuarterName,
		A.month_number as MonthNum,
		A.month_description as MonthDescr,
		A.month_name as MonthName,
		A.day_number as DayNum,
		A.day_description as DayDescr,
		A.day_of_week as DayOfWeek,
		A.day_name as DayName

from	Seer_MDM.dbo.Date A
GO


