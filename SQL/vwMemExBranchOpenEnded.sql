USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchOpenEnded]    Script Date: 08/03/2013 07:29:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemExBranchOpenEnded] where AssociationName like '%stark%' and Branch like '%canton%' and OpenEndedGroup like '%change%'
CREATE VIEW [dd].[vwMemExBranchOpenEnded]
AS 
	with alla as (
	select
		db.AssociationName
		,db.BranchNameShort as Branch
		,sq.Question
		--,qr.Category
		,case 
			when qr.Category = 'Support' then 'Service'
			when qr.Category = 'Impact' then 'Health & Wellness'
			when qr.Category = 'Facilities' then 'Facility'
			else qr.Category
		 end as Category
				
        ,qr.ResponseText as Subcategory
		
		,msr.GivenDateKey	
		,qr.ResponseCode	
		,oer.OpenEndResponse		
		,msr.ResponseCount		
		,case 
			when Question like '%if you could change%' then 'What would members change'
			when Question like '%do you like %most%' then 'What do members like the most'
			when Question like '%you believe%real positive impact in your life%' then 'RPI Individual - Promoter'
			when Question like '%less than sure%real positive impact in your life%' then 'RPI Individual - Detractor'
			when Question like '%you believe%real positive impact in your community%' then 'RPI Community - Promoter'			
			when Question like '%less than sure%real positive impact in your community%' then 'RPI Community - Detractor'			
			else 'Other'
		 end as OpenEndedGroup		 
	from 
		dbo.factMemberSurveyResponse msr
		--inner join dbo.dimBranch db
		inner join dd.factMemExDashboardBase db
			on msr.BranchKey = db.BranchKey and db.GivenDateKey = msr.GivenDateKey
				and msr.OpenEndResponseKey <> -1
		--inner join dbo.dimOrganizationSurvey os
			--on os.OrganizationSurveyKey = msr.OrganizationSurveyKey and os.SurveyType = 'YMCA Membership Satisfaction Survey'		
		inner join dimSurveyQuestion sq
			ON msr.SurveyQuestionKey = sq.SurveyQuestionKey
		INNER JOIN dimQuestionResponse qr
			ON msr.QuestionResponseKey = qr.QuestionResponseKey --and qr.Category <> 'What do you like the most about your YMCA'
				and qr.ResponseCode <> '-1'
		INNER JOIN dimOpenEndResponse oer
			ON msr.OpenEndResponseKey = oer.OpenEndResponseKey		
	where 
		--msr.OpenEndResponseKey <> -1
		--and (ISNUMERIC(ResponseCode)=1 and ResponseCode <> -1 and ResponseCode <> 27)	
		--and 
		OpenEndResponse <> ' '	
	)
	
	,allt as (
		select AssociationName, Branch, --Question, 
		OpenEndedGroup, GivenDateKey, SUM(ResponseCount) as CategoryResponseCount
		from alla
		group by AssociationName, Branch, --Question, 
		OpenEndedGroup, GivenDateKey
	)
	select distinct
		alla.AssociationName
		,alla.Branch
		,cast(SUBSTRING(cast(alla.GivenDateKey as varchar), 1, 4) as int) as SurveyYear		
		,alla.OpenEndedGroup
		,alla.Category		
		,alla.Subcategory
		,OpenEndResponse
		--,sums.ResponseCount
		,ResponseCount
		--,ResponseCode
		,case when allt.CategoryResponseCount <> 0 then 100.00 * alla.ResponseCount / allt.CategoryResponseCount else 0 end as CategoryPercentage
	from 
		alla
		inner join allt
			on alla.AssociationName = allt.AssociationName 
			and alla.Branch = allt.Branch and 
			   alla.OpenEndedGroup = allt.OpenEndedGroup
			    and alla.GivenDateKey = allt.GivenDateKey 
			  --  and alla.Question = allt.Question














GO


