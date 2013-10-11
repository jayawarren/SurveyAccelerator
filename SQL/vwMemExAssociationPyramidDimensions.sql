USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExAssociationPyramidDimensions]    Script Date: 08/03/2013 06:54:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--select * from [dd].[vwMemExAssociationPyramidDimensions] where associationname = 'YMCA of Silicon Valley'
CREATE VIEW [dd].[vwMemExAssociationPyramidDimensions]
AS
	with alla as (
		select distinct
		  db.AssociationName as Association      		  
		  ,db.[GivenDateKey]
		  ,[PyramidCategory]
		  ,[Percentile]
		  ,HistoricalChangeIndex
		  ,db.SurveyYear
		  ,msp.AssociationKey			
		from 
			[dbo].[factMemSatPyramid] msp
			inner join dd.factMemExDashboardBase db
				on db.AssociationKey = msp.AssociationKey and db.GivenDateKey = msp.GivenDateKey
	)		
	,heights as (
		select distinct
			Association 						
			,PyramidCategory									
			,Percentile as Height	
			,AssociationKey		
		from 
			alla 
		where 
			PyramidCategory in ('Facilities', 'Engagement', 'Support', 'Impact', 'Value', 'Involvement', 'Facility', 'Well Being', 'Health & Wellness', 'Service')		
	)	
	,hcalc as (
	select distinct
		alla.Association as AssociationName,		
		case when alla.PyramidCategory in ('Missions', 'Overall', 'Operations') then 'Overall' else 'Pyramid' end as CategoryGroup,
		case when alla.PyramidCategory in ('Impact', 'Well Being') then 'Health & Wellness'
			when alla.PyramidCategory = 'Facilities' then 'Facility' 
			when alla.PyramidCategory = 'Support' then 'Service' 
			else alla.PyramidCategory end as PyramidCategory,
		cast(round((alla.Percentile), 0) as int) as AssociationPercentile,				
		cast(round(alla.Percentile + alla.HistoricalChangeIndex, 0) as int) as PrevAssociationPercentile
		 ,heights.Height		
		 ,alla.SurveyYear
		 ,InvolvementHeight
		 ,ImpactHeight
		 ,EngagementHeight
		 ,SupportHeight
		 ,ValueHeight
		 ,FacilityHeight
	from 
		alla
		left join heights 
			on heights.AssociationKey = alla.AssociationKey and heights.PyramidCategory = alla.PyramidCategory
		left join (select Height as InvolvementHeight, AssociationKey, PyramidCategory from heights ) heights1
				on heights1.AssociationKey = alla.AssociationKey and heights1.Pyramidcategory = 'Involvement'				
		left join (select Height as ImpactHeight, AssociationKey, PyramidCategory from heights ) heights2
				on heights2.AssociationKey = alla.AssociationKey and heights2.Pyramidcategory in ('Impact', 'Well Being', 'Health & Wellness')
		left join (select Height as EngagementHeight, AssociationKey, PyramidCategory from heights ) heights3
				on heights3.AssociationKey = alla.AssociationKey and heights3.Pyramidcategory = 'Engagement'
		left join (select Height as SupportHeight, AssociationKey, PyramidCategory from heights ) heights4
				on heights4.AssociationKey = alla.AssociationKey and heights4.Pyramidcategory in ('Support', 'Service')
		left join (select Height as ValueHeight, AssociationKey, PyramidCategory from heights ) heights5
				on heights5.AssociationKey = alla.AssociationKey and heights5.Pyramidcategory = 'Value'
		left join (select Height as FacilityHeight, AssociationKey, PyramidCategory from heights ) heights6
				on heights6.AssociationKey = alla.AssociationKey and heights6.Pyramidcategory in ('Facilities', 'Facility')
	)	
	select
		AssociationName,	
		CategoryGroup,	
		PyramidCategory,
		AssociationPercentile,				
		PrevAssociationPercentile
		,case
			when PyramidCategory = 'Involvement' then	
				(200.00 *
					InvolvementHeight 					
				) / 225.00
			when PyramidCategory in ('Impact', 'Well Being', 'Health & Wellness') then
				(200.00 * (
					InvolvementHeight +
					ImpactHeight					
				)) / 225.00
			when PyramidCategory = 'Engagement' then
				(200.00 * (
					InvolvementHeight +
					ImpactHeight + 					
					EngagementHeight 
				)) / 225.00			
			when PyramidCategory in ('Support', 'Service') then
				(200.00 * (
					InvolvementHeight +
					ImpactHeight + 					
					EngagementHeight +
					SupportHeight 
				)) / 225.00			
			when PyramidCategory = 'Value' then
				(200.00 * (
					InvolvementHeight +
					ImpactHeight + 					
					EngagementHeight +
					SupportHeight +
					ValueHeight
					 
				)) / 225.00			
			when PyramidCategory in ('Facilities', 'Facility') then
				(200.00 * (
					InvolvementHeight +
					ImpactHeight + 					
					EngagementHeight +
					SupportHeight +
					ValueHeight +
					FacilityHeight
				)) / 225.00									
		 end as Width		
		 ,Height		
		 ,SurveyYear
	from 
		hcalc
		
	UNION
	select distinct
		Association as AssociationName		
		,'Pyramid' as CategoryGroup
		,'Dummy' as PyramidCategory
		,0 as AssociationPercentile
		,0 as PrevAssociationPercentile		
		,0 as Width
		,0 as Height	
		,SurveyYear		
	from alla





GO


