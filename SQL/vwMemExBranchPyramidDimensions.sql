USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchPyramidDimensions]    Script Date: 08/02/2013 19:52:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwMemExBranchPyramidDimensions] WHERE associationname = 'YMCA of Central Stark County' AND branch = 'Paul AND Carol David'
ALTER VIEW [dd].[vwMemExBranchPyramidDimensions]
AS
	WITH alla AS (
		SELECT	db.AssociationName AS Association,     
				db.BranchNameShort AS Branch,		  
				db.[GivenDateKey],
				msp.[PyramidCategory],
				msp.[Percentile],
				msp.HistoricalChangeIndex,
				db.SurveyYear			
		
		FROM	[dbo].[factMemSatPyramid] msp
				INNER JOIN dd.factMemExDashboardBase db
					ON db.BranchKey = msp.BranchKey
						AND db.GivenDateKey = msp.GivenDateKey
	)		
	,heights AS (
		SELECT	Association,
				Branch,
				PyramidCategory,									
				Percentile AS Height
							
		FROM	alla
		 
		WHERE	PyramidCategory in ('Facilities', 'Engagement', 'Support', 'Impact', 'Value', 'Involvement', 'Facility', 'Well Being', 'Health & Wellness', 'Service')		
	)	
	SELECT	distinct
			alla.AssociatiON AS AssociationName,
			alla.Branch,
			case when alla.PyramidCategory in ('Missions', 'Overall', 'Operations') then 'Overall' else 'Pyramid' end AS CategoryGroup,
			case when alla.PyramidCategory in ('Impact', 'Well Being') then 'Health & Wellness'
				when alla.PyramidCategory = 'Facilities' then 'Facility' 
				when alla.PyramidCategory = 'Support' then 'Service' 
				else alla.PyramidCategory end AS PyramidCategory,
			floor(alla.Percentile) AS CrtBranchPercentile,				
			alla.Percentile + alla.HistoricalChangeIndex AS PrevBranchPercentile,
			floor(assoc.Percentile) AS AssocPercentile,
			case
				when alla.PyramidCategory = 'Involvement' then	
					(200.00 *
						heights1.InvolvementHeight 					
					) / 225.00
				when alla.PyramidCategory in ('Impact', 'Well Being', 'Health & Wellness') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight					
					)) / 225.00
				when alla.PyramidCategory = 'Engagement' then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight 
					)) / 225.00			
				when alla.PyramidCategory in ('Support', 'Service') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight 
					)) / 225.00			
				when alla.PyramidCategory = 'Value' then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight +
						heights5.ValueHeight
						 
					)) / 225.00			
				when alla.PyramidCategory in ('Facilities', 'Facility') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight +
						heights5.ValueHeight +
						heights6.FacilityHeight
					)) / 225.00									
			 end AS Width,		
			 heights.Height,	
			 alla.SurveyYear
			 
	FROM	alla
			LEFT JOIN heights 
				ON heights.AssociatiON = alla.AssociatiON AND heights.Branch = alla.Branch AND heights.PyramidCategory = alla.PyramidCategory
			LEFT JOIN (SELECT Height AS InvolvementHeight, Association, Branch, PyramidCategory FROM heights ) heights1
					ON heights1.AssociatiON = alla.AssociatiON AND heights1.Branch = alla.Branch AND heights1.Pyramidcategory = 'Involvement'				
			LEFT JOIN (SELECT Height AS ImpactHeight, Association, Branch, PyramidCategory FROM heights ) heights2
					ON heights2.AssociatiON = alla.AssociatiON AND heights2.Branch = alla.Branch AND heights2.Pyramidcategory in ('Impact', 'Well Being', 'Health & Wellness')
			LEFT JOIN (SELECT Height AS EngagementHeight, Association, Branch, PyramidCategory FROM heights ) heights3
					ON heights3.AssociatiON = alla.AssociatiON AND heights3.Branch = alla.Branch AND heights3.Pyramidcategory = 'Engagement'
			LEFT JOIN (SELECT Height AS SupportHeight, Association, Branch, PyramidCategory FROM heights ) heights4
					ON heights4.AssociatiON = alla.AssociatiON AND heights4.Branch = alla.Branch AND heights4.Pyramidcategory in ('Support', 'Service')
			LEFT JOIN (SELECT Height AS ValueHeight, Association, Branch, PyramidCategory FROM heights ) heights5
					ON heights5.AssociatiON = alla.AssociatiON AND heights5.Branch = alla.Branch AND heights5.Pyramidcategory = 'Value'
			LEFT JOIN (SELECT Height AS FacilityHeight, Association, Branch, PyramidCategory FROM heights ) heights6
					ON heights6.AssociatiON = alla.AssociatiON AND heights6.Branch = alla.Branch AND heights6.Pyramidcategory in ('Facilities', 'Facility')
			LEFT JOIN (
						SELECT	Association,
								PyramidCategory,			
								AVG(Percentile) AS Percentile
						FROM	alla
						GROUP BY Association,
							PyramidCategory			
			) assoc
				ON assoc.AssociatiON = alla.AssociatiON AND assoc.PyramidCategory = alla.PyramidCategory

	UNION
	SELECT	distinct
			Association AS AssociationName,
			Branch,
			'Pyramid' AS CategoryGroup,
			'Dummy' AS PyramidCategory,
			0 AS CrtBranchPercentile,
			0 AS PrevBranchPercentile,
			0 AS AssocPercentile,
			0 AS Width,
			0 AS Height,
			SurveyYear
					
	FROM	alla

GO


