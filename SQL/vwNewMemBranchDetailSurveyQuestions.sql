USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMemBranchDetailSurveyQuestions]    Script Date: 08/13/2013 11:50:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwNewMemBranchDetailSurveyQuestions] where associationname = 'YMCA of Greater Seattle'
CREATE VIEW [dd].[vwNewMemBranchDetailSurveyQuestions]
AS 
with rspn AS (
Select	sq.Category
		,sq.CategoryPosition
		,sq.CategoryType
		,sq.SurveyQuestionKey
		,sq.Question
		,sq.QuestionPosition
		,sq.QuestionNumber
		,sq.ShortQuestion
		,dqr.ResponseText
		,dqr.ResponseCode
		,dqr.QuestionResponseKey

from	dd.vwNewMem2012SurveyQuestions sq
		inner join [dbo].dimQuestionResponse dqr
			on dqr.SurveyQuestionKey = sq.SurveyQuestionKey
				and dqr.ResponseCode <>'-1'
				and sq.CategoryType = 'Reporting'
				and sq.Category <> 'Survey Responders'
	) 
, core as(
select	distinct
		fe.BranchKey
		,fe.GivenDateKey
		,case when sq.Category in ('Health Seekers','Meeting Expectations', 'Net Promoter', 'Onboarding') then 'Key Indicators' 
		when sq.Category in ('Operational Excellence', 'Drivers Joining', 'Perceptions') then 'Performance Measures'
		else sq.Category end as CategoryType 
		,case when sq.Category = 'Drivers Joining' then 'Reasons for Joining' 
		else sq.Category end as Category
		,sq.CategoryPosition as  CategoryPosition
		,case when sq.QuestionResponseKey = fe.QuestionResponseKey then fe.BranchCount end BranchCount
		,sq.QuestionPosition as QuestionPosition
		, sq.QuestionNumber as QuestionNumber
		,sq.Question as Question
		,sq.ShortQuestion as ShortQuestion
		,round(100* case when sq.QuestionResponseKey = fe.QuestionResponseKey then fe.BranchPercentage end,0) as BranchPercentage
		,case when ( sq.Question like '%would you recommend%friends%') then
		( case when sq.ResponseCode in ('9','10') then '9,10'
		when sq.ResponseCode in ('7','8') then '7,8'					
		else '0-6'end ) else sq.ResponseText end as ResponseText
		,case when ( sq.Question like '%would you recommend%friends%') then
		( case when sq.ResponseCode in ('9','10') then '1'
		when sq.ResponseCode in ('7','8') then '2'					
		else '3' end ) else sq.ResponseCode end as ResponseCode
		--,sq.ResponseCode as ResponseCode
		--,sq.ResponseText as ResponseText
		,case when sq.QuestionResponseKey = fe.QuestionResponseKey then fe.SegmentHealthSeekerNo end as SegmentHealthSeekerNo
		,case when sq.QuestionResponseKey = fe.QuestionResponseKey then fe.SegmentHealthSeekerYes end as SegmentHealthSeekerYes
		,fe.Segment
		,fe.GrpDateName

From	rspn sq
		inner join
		dd.vwBranchNewMemberExperienceReport fe
			on sq.SurveyQuestionKey = fe.SurveyQuestionKey
	)
, PREV AS (
Select	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
		,sum(core.BranchPercentage) as PreviousPercentage
		,core.GrpDateName

from	core
		INNER JOIN dd.factNewMemDashboardBase db
			ON db.BranchKey = core.BranchKey
				and db.PrevGivenDateKey = core.GivenDateKey 

GROUP By core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
		,core.GrpDateName
	)
, CURR AS (
Select	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
		,sum(core.BranchPercentage) as CurrentPercentage
		
from	core
		INNER JOIN dd.factNewMemDashboardBase db
			ON db.BranchKey = core.BranchKey
				and db.GivenDateKey = core.GivenDateKey 

group by core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
	)
, brnch AS (
Select	core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
		,SUM(core.BranchCount) as BranchCount
		,sum(core.BranchPercentage) as BranchPercentage
		,MAX(core.SegmentHealthSeekerNo) as SegmentHealthSeekerNo
		,MAX(core.SegmentHealthSeekerYes) as SegmentHealthSeekerYes

from	core
group by core.GivenDateKey
		,core.BranchKey
		,core.Category
		,core.Question
		,core.ResponseText
	)

, COMBO as (	
Select	distinct
		core.BranchKey
		,core.Category
		,core.CategoryPosition
		,core.CategoryType
		,core.GivenDateKey
		,curr.GivenDateKey as CurrentSurveyDate
		,prev.GivenDateKey as PreviousSurveyDate
		,case when core.GivenDateKey = curr.GivenDateKey then 1 
		when core.GivenDateKey = prev.GivenDateKey then 2 else 0 end as CurrentSurveyIndicator
		,core.Question
		,core.QuestionNumber
		,core.QuestionPosition
		,core.ShortQuestion
		,brnch.BranchCount
		,brnch.BranchPercentage as BranchPercentage
		,curr.CurrentPercentage as CurrentPercentage
		,prev.PreviousPercentage as PreviousPercentage	
		,core.Segment
		,brnch.SegmentHealthSeekerNo
		,brnch.SegmentHealthSeekerYes
		,core.ResponseCode
		,core.ResponseText
		,core.GrpDateName
		,prev.GrpDateName as PrevGrpDateName
		
from	core
		INNER JOIN brnch
			ON brnch.BranchKey = core.BranchKey
				and brnch.Category = core.Category
				and brnch.Question = core.Question
				and brnch.GivenDateKey = core.GivenDateKey
				and brnch.ResponseText = core.ResponseText
		left outer JOIN curr
			ON curr.BranchKey = core.BranchKey
				and curr.Category = core.Category
				and curr.Question = core.Question
				and curr.ResponseText = core.ResponseText
		left outer join prev
			on prev.BranchKey = core.BranchKey
				and prev.Category = core.Category
				and prev.Question = core.Question
				and prev.ResponseText = core.ResponseText
)
select	combo.GivenDateKey as GivenSurveyDate
		,LEFT(combo.GivenDateKey,4) as SurveyYear
		,left(combo.PreviousSurveyDate ,4) as PreviousSurveyYear
		,combo.CurrentSurveyIndicator as CurrentSurveyIndicator
		,db.AssociationName as AssociationName
		,db.AssociationNumber as AssociationNumber
		,db.OfficialBranchName as OfficialBranchName
		,db.OfficialBranchNumber as OfficialBranchNumber
		,db.BranchNameShort as Branch
		,combo.CategoryType
		,combo.Category
		,combo.CategoryPosition
		,combo.QuestionNumber as QuestionPosition
		,'Q'+ case when combo.CategoryType = 'Key Indicators' then '01' 
		when combo.CategoryType = 'Performance Measures' then '02' else '03' end +			
		case when combo.[CategoryPosition]<10  and combo.Category <> 'Survey Responders' then '0' else '' end + CAST(case when combo.Category = 'Perceptions' then '9' 
		when combo.Category = 'Survey Responders' then '11'
		else combo.CategoryPosition end as varchar(2)) +
		case when combo.[QuestionPosition]<10 then '0' else '' end + CAST(case when combo.ShortQuestion = 'Y nutures potential all children'
		then '05' else combo.QuestionPosition end as varchar(2))	 as QuestionCode
		,combo.ResponseText
		,combo.ResponseCode	
		,combo.Question	
		,combo.ShortQuestion
		,cast(combo.BranchPercentage as int) as BranchPercentage
		,cast(combo.CurrentPercentage as int) as CurrentPercentage	
		,cast(combo.PreviousPercentage as int) as PreviousPercentage
		--,combo.GrpDateName
		
from	combo
		INNER JOIN dd.factNewMemDashboardBase db
			ON db.BranchKey = combo.BranchKey 
GO


