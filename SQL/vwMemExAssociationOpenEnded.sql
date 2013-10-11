USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExAssociationOpenEnded]    Script Date: 08/03/2013 17:11:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwMemExAssociationOpenEnded] where associationname = 'YMCA of Central Stark County' order by 2, 3
--SELECT * FROM [dd].[factMemExAssociationOpenEnded] where associationname = 'YMCA of Central Stark County' order by 2, 3
ALTER VIEW [dd].[vwMemExAssociationOpenEnded]
AS 
WITH 
mostrec AS 
(
	SELECT	msp.AssociationName,
			MAX(SurveyYear) AS SurveyYear
	
	FROM	dd.factMemExDashboardBase msp
			
	GROUP BY msp.AssociationName 
)

,allt AS 
(
	SELECT	db.AssociationName,
			db.SurveyYear,
			OpenEndedGroup,
			SUM(ResponseCount) AS CategoryCount	
	
	FROM 	[dd].[factMemExBranchOpenEnded]	db		
			INNER JOIN mostrec 
				ON mostrec.AssociationName = db.AssociationName
					AND db.SurveyYear = mostrec.SurveyYear
	
	GROUP BY db.AssociationName,
			db.SurveyYear,
			OpenEndedGroup
)
,alla AS 
(
	SELECT	db.AssociationName,
			db.SurveyYear,
			db.OpenEndedGroup,
			CASE WHEN db.Category = 'Support' THEN 'Service'
				WHEN db.Category = 'Impact' THEN 'Health & Wellness'
				WHEN db.Category = 'Facilities' THEN 'Facility'
				ELSE db.Category
			END AS Category,
			--,Subcategory
			SUM(db.ResponseCount) AS CategoryCount
			
	FROM	[dd].[factMemExBranchOpenEnded]	db		
			INNER JOIN mostrec 
				ON mostrec.AssociationName = db.AssociationName
					AND db.SurveyYear = mostrec.SurveyYear	
				
	GROUP BY db.AssociationName,
			db.SurveyYear,
			db.OpenEndedGroup,
			db.Category	
)
,allarn AS 
(
	SELECT	alla.*,
			ROW_NUMBER() over (partition by alla.AssociationName, alla.SurveyYear, alla.OpenEndedGroup order by alla.CategoryCount desc) AS RowNumber,
			CASE WHEN allt.CategoryCount<> 0 THEN 100.00 * alla.CategoryCount / allt.CategoryCount
				ELSE 0
			END AS CategoryPercentage
			
	FROM	alla	
			INNER JOIN allt
				ON alla.AssociationName = allt.AssociationName
				AND alla.OpenEndedGroup = allt.OpenEndedGroup
)
SELECT	* 

FROM	allarn
GO


