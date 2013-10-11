USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExAssociationSegment]    Script Date: 08/04/2013 08:08:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemExAssociationSegment] where associationname = 'YMCA of Central Stark County' and Question = 'Please Check your Membership Type:'
--select distinct ResponseText from [dd].[vwMemExAssociationSegment] where Question = 'Please Check your Membership Type:'
--select * from [dd].[vwMemExAssociationSegment] where associationname like '%boulder%' and Question like 'data source%'
CREATE VIEW [dd].[vwMemExAssociationSegment]
AS
with bs as (
	SELECT distinct    
		'0' as AssociationNumber, 
		db.AssociationName, 
		AssociationName AS Association,
		LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
		MSR.GivenDateKey, 
		DQ.Question, 
		'' AS QuestionLabel, 
		DC.Category, 
		DC.CategoryType, DC.CategoryPosition, 
		--DC.QuestionPosition, 		
		--DR.ResponseCode, 
		--DR.ResponseText, 	
		case 
			when Question like 'data source%' then 0
			else QuestionPosition
		end as QuestionPosition,
		
		case
			when ResponseText like '%Adult%' then '61' 
			when ResponseText like '%Family%' then '62'
			when ResponseText like '%Senior%' then '63'
			else ResponseCode
		end as ResponseCode,		
		case
			when ResponseText like '%Adult%' then 'Adult' 
			when ResponseText like '%Family%' then 'Family' 
			when ResponseText like '%Senior%' then 'Senior' 
			else ResponseText
		end as ResponseText,
		MSR.Segment, 
		MSR.AssociationCount, 
		MSR.AssociationPercentage, 
		MSR.PreviousAssociationPercentage
	FROM          
		dbo.factAssociationMemberSatisfactionReport AS MSR INNER JOIN
		dd.factMemExDashboardBase db
			ON MSR.AssociationKey = DB.AssociationKey and msr.GivenDateKey = db.GivenDateKey
		INNER JOIN			
			dbo.dimSurveyQuestion AS DQ ON MSR.SurveyQuestionKey = DQ.SurveyQuestionKey
		INNER JOIN
			dbo.dimQuestionCategory AS DC 
				ON DQ.SurveyQuestionKey = DC.SurveyQuestionKey 
				--and CategoryType = 'Dashboard'
				--and CategoryType = 'Reporting'
				and dc.Category = 'Survey Responders'
			INNER JOIN dbo.dimQuestionResponse AS DR 
				ON MSR.QuestionResponseKey = DR.QuestionResponseKey 
					and DR.ResponseCode <> '-1'
			
)
SELECT distinct  
	bs.AssociationNumber, 
	bs.AssociationName, 
	Association,                       
	bs.SurveyYear, 
	bs.GivenDateKey, 
	SUM(bs.AssociationCount) as AssociationCount, 
	bs.Segment, 
	bs.Question, 
	bs.QuestionLabel, 	
	'Reporting' as CategoryType,
	bs.Category, 
	bs.CategoryPosition, 
	QuestionPosition,
	bs.ResponseCode, 
	bs.ResponseText, 
	SUM(bs.AssociationPercentage) as AssociationPercentage,
	case 
		when SUM(bs.PreviousAssociationPercentage) is null then 99999
		else SUM(bs.PreviousAssociationPercentage)
	end as PrevAssociationPercentage
FROM         
	bs
group by 	
	bs.AssociationNumber, 
	bs.AssociationName, 
	Association,                       
	bs.SurveyYear, 
	bs.GivenDateKey, 
	bs.Segment, 
	bs.Question, 
	bs.QuestionLabel, 	
	CategoryType,
	bs.Category, 
	bs.CategoryPosition, 
	QuestionPosition,
	bs.ResponseCode, 
	bs.ResponseText










GO


