USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMemBranchExperienceReport]    Script Date: 08/13/2013 16:33:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwNewMemBranchExperienceReport] where associationname = 'YMCA of Greater Seattle'
CREATE VIEW [dd].[vwNewMemBranchExperienceReport]
AS 
with core as(
select	distinct
		fe.BranchKey,
		fe.GivenDateKey,
		CASE WHEN sq.Category in ('Health Seekers','Meeting Expectations', 'Net Promoter', 'Onboarding') or fe.Segment = 'Health Seeker' THEN 'Key Indicators' 
			WHEN sq.Category in ('Operational Excellence', 'Drivers Joining', 'Support') THEN 'Performance Measures'
			ELSE sq.Category
		END AS CategoryType, 
		CASE WHEN sq.Category = 'Drivers Joining' THEN 'Reasons for Joining' 
			WHEN fe.Segment = 'Health Seeker' THEN 'Health Seekers'
			ELSE sq.Category
		END AS Category,
		CASE WHEN fe.Segment = 'Health Seeker' THEN 2
			ELSE sq.CategoryPosition
		END AS  CategoryPosition,
		CASE WHEN (dqr.ResponseCode in ('01','-1') and sq.Category <> 'Net Promoter') THEN fe.BranchCount
		END BranchCount,
		--CASE WHEN sq.Category <> 'Net Promoter' THEN fe.BranchCount END BranchCount
		CASE WHEN sq.Category = 'Net Promoter' or fe.Segment = 'Health Seeker' THEN 1
			ELSE sq.QuestionPosition
		END AS QuestionPosition,
		CASE WHEN sq.Category = 'Net Promoter' or fe.Segment = 'Health Seeker' THEN 1
			ELSE sq.QuestionNumber
		END AS QuestionNumber,
		CASE WHEN sq.Category = 'Net Promoter' THEN sq.Category 
			WHEN fe.Segment = 'Health Seeker' THEN fe.Segment
			ELSE sq.Question END AS Question,
		CASE WHEN sq.Category = 'Net Promoter' THEN sq.Category 
			WHEN fe.Segment = 'Health Seeker' THEN fe.Segment
			ELSE sq.ShortQuestion
		END AS ShortQuestion,
		round(100*CASE WHEN (dqr.ResponseCode in ('01','-1') and sq.Category <> 'Net Promoter' and sq.ShortQuestion not like 'Health Seeker%')
		or (dqr.ResponseCode in ('10','09','06','05','04','03','02','01') and sq.Category = 'Net Promoter') OR fe.Segment = 'Health Seeker' THEN fe.BranchPercentage END, 0) AS BranchPercentage,
		CASE WHEN sq.Category = 'Net Promoter' and dqr.ResponseCode in ('10','9') THEN '01'
			WHEN fe.Segment = 'Health Seeker' THEN '01'
			WHEN sq.Category = 'Net Promoter' and dqr.ResponseCode in ('06','05','04','03','02','01') THEN '02' 
			WHEN dqr.ResponseCode = '01' THEN dqr.ResponseCode
		END AS ResponseCode,
		fe.GrpDateName

FROM	dd.vwBranchNewMemberExperienceReport fe
		left outer JOIN
		dd.vwNewMem2012SurveyQuestions sq
		on (sq.SurveyQuestionKey = fe.SurveyQuestionKey
		and sq.CategoryType = 'Dashboard' and sq.Category <> 'Survey Responders')
		inner join dbo.dimQuestionResponse dqr
		on dqr.QuestionResponseKey = fe.QuestionResponseKey

WHERE	sq.ShortQuestion not like 'Health Seeker%' or fe.Segment = 'Health Seeker'
		
		)
, PREV AS (
SELECT	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,sum(CASE WHEN core.ResponseCode = 1 THEN core.BranchPercentage ELSE 0 END -
		CASE WHEN core.ResponseCode = 2 THEN core.BranchPercentage ELSE 0 END)
		as PreviousPercentage
		,core.GrpDateName
		
from	core
		INNER JOIN dd.factNewMemDashboardBase db
			ON db.BranchKey = core.BranchKey
				and db.PrevGivenDateKey = core.GivenDateKey
				 
group by core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.GrpDateName
)
, CURR AS (
SELECT	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,sum(CASE WHEN core.ResponseCode = 1 THEN core.BranchPercentage ELSE 0 END -
		CASE WHEN core.ResponseCode = 2 THEN core.BranchPercentage ELSE 0 END)
		as CurrentPercentage
		
from	core
		INNER JOIN dd.factNewMemDashboardBase db
		ON db.BranchKey = core.BranchKey
		and db.GivenDateKey = core.GivenDateKey
		
group by core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
	)
, brnch AS (
SELECT	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,sum(CASE WHEN core.ResponseCode = 1 THEN core.BranchCount ELSE 0 END) AS BranchCount
		,sum(CASE WHEN core.ResponseCode = 1 THEN core.BranchPercentage ELSE 0 END -
		CASE WHEN core.ResponseCode = 2 THEN core.BranchPercentage ELSE 0 END)
		as BranchPercentage
		
from core

group by core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
	)
, COMBO AS (	
SELECT	distinct
		core.BranchKey
		,core.Category
		,core.CategoryPosition
		,core.CategoryType
		,core.GivenDateKey
		,curr.GivenDateKey AS CurrentSurveyDate
		,prev.GivenDateKey AS PreviousSurveyDate
		,CASE WHEN core.GivenDateKey = curr.GivenDateKey THEN 1 
		WHEN core.GivenDateKey = prev.GivenDateKey THEN 2 ELSE 0 END AS CurrentSurveyIndicator
		,core.Question
		,core.QuestionNumber
		,core.QuestionPosition
		,core.ShortQuestion
		,brnch.BranchCount
		,brnch.BranchPercentage AS BranchPercentage
		,curr.CurrentPercentage AS CurrentPercentage
		,prev.PreviousPercentage AS PreviousPercentage	
		,core.GrpDateName
		,prev.GrpDateName AS PrevGrpDateName
		
from	core 
		INNER JOIN brnch
			ON brnch.BranchKey = core.BranchKey
				and brnch.Category = core.Category
				and brnch.Question = core.Question
				and brnch.GivenDateKey = core.GivenDateKey
		INNER JOIN curr
			ON curr.BranchKey = core.BranchKey
				and curr.Category = core.Category
				and curr.Question = core.Question
		LEFT outer join prev
			on prev.BranchKey = core.BranchKey
				and prev.Category = core.Category
				and prev.Question = core.Question
	)
select	distinct
		combo.GivenDateKey AS GivenSurveyDate
		,LEFT(combo.GivenDateKey,4) AS SurveyYear
		,LEFT(combo.CurrentSurveyDate,4) AS CurrentSurveyYear
		,LEFT(combo.PreviousSurveyDate,4) AS PreviousSurveyyear
		,combo.CurrentSurveyIndicator AS CurrentSurveyIndicator
		--,Left(datename(MONTH,convert(datetime,cast(combo.GivenDateKey AS varchar(8))) ) ,3) + ' '+ cast(datepart(yyyy,convert(datetime,cast(combo.GivenDateKey AS varchar(8)))) AS varchar(4)) AS GivenSurveyCategory
		,combo.GrpDateName AS GivenSurveyCategory
		,db.AssociationNameEx AS Association
		,db.AssociationName AS AssociationName
		,db.AssociationNumber AS AssociationNumber
		,db.BranchNameShort AS Branch
		,db.OfficialBranchName AS OfficialBranchName
		,db.OfficialBranchNumber AS OfficialBranchNumber
		,combo.CategoryType 
		,combo.Category
		,combo.CategoryPosition
		,combo.BranchCount
		,combo.QuestionPosition
		,'Q' + CASE WHEN combo.CategoryType = 'Key Indicators' THEN '01' 
					WHEN combo.CategoryType = 'Performance Measures' THEN '02'
					ELSE '03' END 
			 +			
			   CASE WHEN combo.[CategoryPosition] < 10  and combo.Category <> 'Survey Responders' THEN '0'
					ELSE '' END 
			 + CAST(CASE WHEN combo.Category = 'Support' THEN '9' 
						WHEN combo.Category = 'Survey Responders' THEN '11'
						ELSE combo.CategoryPosition END AS varchar(2))
			 + CASE WHEN combo.[QuestionPosition] < 10 THEN '0'
					ELSE '' 
			   END 
			 + CAST(CASE WHEN combo.ShortQuestion = 'Y nutures potential all children' THEN '05'
						ELSE combo.QuestionPosition END AS varchar(2))
		AS QuestionCode,
		combo.Question,
		combo.ShortQuestion,
		cast(combo.BranchPercentage AS int) AS BranchPercentage,
		cast(combo.CurrentPercentage AS int) AS CurrentPercentage,
		cast(combo.PreviousPercentage AS int) AS PreviousPercentage
		--,combo.GrpDateName
		--,combo.PrevGrpDateName
		
from	combo
		INNER JOIN dd.factNewMemDashboardBase db
			ON db.BranchKey = combo.BranchKey 













GO


