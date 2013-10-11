USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchReportEx]    Script Date: 08/04/2013 16:55:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwMemExBranchReportEx] WHERE branch like '%lake community%' AND Category = 'Pyramid Dimensions'
ALTER VIEW [dd].[vwMemExBranchReportEx]
AS 
WITH
--determine most recent survey date at the association level
bsr AS (
		SELECT	AssociationKey,
				MAX(GivenDateKey) AS GivenDateKey
		
		FROM	dd.factMemExDashboardBase msp
		
		WHERE	msp.current_indicator = 1
			
		GROUP BY AssociationKey 
)
,pprevvals AS (
	SELECT	msp.BranchKey,
			msp.AssociationKey,
			msp.batch_key, 
			msp.[GivenDateKey],
			CASE WHEN [PyramidCategory] = 'Facilities' THEN 'Facility'
				WHEN [PyramidCategory] = 'Support' THEN 'Service'
				WHEN [PyramidCategory] = 'Impact' THEN 'Health & Wellness'
				ELSE [PyramidCategory]
			END AS [PyramidCategory],
			[Percentile]	
	
	FROM	[dbo].[factMemSatPyramid] msp
			INNER JOIN dd.factMemExDashboardBase db
				ON db.BranchKey = msp.BranchKey
					AND db.batch_key = msp.batch_key
					AND db.PrevGivenDateKey = msp.GivenDateKey
					
	WHERE	msp.current_indicator = 1
			AND db.current_indicator = 1
)			
--most recent pyramid values
,pcrtvals AS (
	SELECT	msp.BranchKey,
			bsr.AssociationKey, 
			msp.batch_key,
			bsr.[GivenDateKey],
			msp.[PyramidCategory],
			msp.[Percentile],
			msp.Percentile - pp.Percentile AS [HistoricalChangeIndex]
				
	FROM	[dbo].[factMemSatPyramid] msp
			INNER JOIN dbo.dimBranch db
				ON db.BranchKey = msp.BranchKey
			INNER JOIN bsr 
				ON bsr.AssociationKey = db.AssociationKey
					AND bsr.GivenDateKey = msp.GivenDateKey
			LEFT JOIN pprevvals pp
				ON pp.BranchKey = msp.BranchKey
					AND pp.PyramidCategory = msp.PyramidCategory
					
	WHERE	msp.current_indicator = 1
)
--select * from pcrtvals
--this is the actual SELECT
--KPI Values
,br AS (
SELECT	AssociationKey,
		BranchKey,
		1 current_indicator,
		AssociationName,	
		Branch,
		batch_key,
		SurveyYear,
		'Key Indicators' AS DimensionGroup,	
		Category AS Dimension,
		100*[BranchPercentage] AS BranchValue,
		100*[AssociationPercentage] AS AssociationValue,	
		100*[NationalPercentage] AS NationalValue,
		100*[PreviousBranchPercentage] AS PreviousBranchValue,	
		SortOrder AS DimensionPosition
		
FROM	[dd].[vwMemExBranchKPIs]		

--pyramid values
UNION 

SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		AssociationName,
		BranchNameShort AS Branch,
		db.batch_key,
		cast(LEFT(pcrtvals.GivenDateKey, 4) AS int) AS SurveyYear,
		'Pyramid Dimensions' AS DimensionGroup,
		CASE WHEN pcrtvals.PyramidCategory in ('Impact', 'Well Being') THEN 'Health & Wellness'
			WHEN pcrtvals.PyramidCategory = 'Facilities' THEN 'Facility' 
			WHEN pcrtvals.PyramidCategory = 'Support' THEN 'Service'
			ELSE pcrtvals.PyramidCategory
		END AS Dimension,
		pcrtvals.Percentile AS BranchValue,
		avgvals.Percentile AS AssociationValue,
		50.0 AS NationalValue,
		pcrtvals.Percentile-pcrtvals.HistoricalChangeIndex AS PreviousBranchValue,
		CASE WHEN pcrtvals.PyramidCategory in ('Facility', 'Facilities') THEN 1
			WHEN pcrtvals.PyramidCategory in ('Support', 'Service') THEN 3
			WHEN pcrtvals.PyramidCategory = 'Value' THEN 2
			WHEN pcrtvals.PyramidCategory = 'Engagement' THEN 4
			WHEN pcrtvals.PyramidCategory in ('Impact', 'Well Being', 'Health & Wellness') THEN 5
			WHEN pcrtvals.PyramidCategory = 'Involvement' THEN 6
			ELSE 7
		END AS DimensionPosition	

FROM	(
		SELECT	distinct
				BranchKey,
				AssociationName,
				AssociationKey,
				BranchNameShort,
				current_indicator,
				batch_key
				
		FROM	dd.factMemExDashboardBase
		
		WHERE	current_indicator = 1
		) db
		LEFT JOIN pcrtvals
			ON pcrtvals.BranchKey = db.BranchKey
				AND pcrtvals.batch_key = db.batch_key
				AND PyramidCategory NOT IN ('Missions', 'Overall', 'Operations')
		LEFT JOIN
		(
		SELECT	AssociationKey,
				PyramidCategory,
				batch_key,
				AVG(Percentile) AS Percentile
		
		FROM	pcrtvals 
		
		WHERE	PyramidCategory NOT IN ('Missions', 'Overall', 'Operations')
		
		GROUP BY AssociationKey,
				PyramidCategory,
				batch_key	
		) avgvals
			ON avgvals.AssociationKey = db.AssociationKey
			AND avgvals.batch_key = db.batch_key
			AND avgvals.PyramidCategory = pcrtvals.PyramidCategory

WHERE	pcrtvals.GivenDateKey IS NOT NULL		
)
--select * from br
SELECT	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		[AssociationName],      
		Branch AS [Branch],     
		DimensionGroup AS [Category],
		DimensionPosition AS [CategoryPosition],
		Dimension AS [Question],
		1 AS [QuestionPosition],     
		BranchValue AS [CrtBranchPercentage],    
		NationalValue AS [NationalPercentage],      
		PreviousBranchValue AS [PrevBranchPercentage],
		AssociationValue AS [CrtAssociationPercentage],
		'Q'+ 
			CASE WHEN DimensionGroup = 'Pyramid Dimensions' THEN '01' WHEN DimensionGroup = 'Key Indicators' THEN '02'
				ELSE '03'
			END +			
			CASE WHEN [DimensionPosition]<10 THEN '0'
				ELSE ''
			END + CAST(DimensionPosition AS varchar(2)) +
			CASE WHEN [DimensionPosition]<10 THEN '0'
				ELSE ''
			END + CAST(DimensionPosition AS varchar(2))      
		AS [QuestionCode],
		Dimension AS [ShortQuestion]
			
FROM	br
		
UNION
 
SELECT	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		[AssociationName],   
		[OfficialBranchName] AS Branch,      
		Category,
		[CategoryPosition],      
		[Question],
		[QuestionPosition],
		[CrtBranchPercentage],
		[NationalPercentage],
		[PrevBranchPercentage],
		[CrtAssociationPercentage],
		[QuestionCode],
		[ShortQuestion] 
      
FROM	[dd].[vwMemExBranchReport]

WHERE	CategoryType = 'KKI'

GO


