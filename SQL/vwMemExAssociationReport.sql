USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExAssociationReport]    Script Date: 08/04/2013 14:08:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Josh Erhardt
-- Create date: 20120301 / modified by md on 03/25
-- Description:	<Description,,>
-- =============================================

--SELECT * FROM [dd].[vwMemExAssociationReport] WHERE OfficialAssociationName like '%paul and%'
--SELECT * FROM [dd].[vwMemExAssociationReport] WHERE associationname = 'YMCA of Greater Seattle' and OfficialAssociationName = 'downtown'
ALTER VIEW [dd].[vwMemExAssociationReport]
AS
WITH newsq AS (			
SELECT	sq.SurveyQuestionKey,
		Category,
		Question,
		CategoryPosition,
		QuestionPosition
			
FROM	dbo.dimSurveyQuestion sq
		INNER JOIN dbo.dimQuestionCategory dc
			ON dc.SurveyQuestionKey = sq.SurveyQuestionKey
		INNER JOIN dbo.dimSurveyForm sf
			ON sq.SurveyFormKey = sf.SurveyFormKey
				AND sf.Description like '%mem%sat%'

WHERE	dc.CategoryType = 'Dashboard'		
)
,newsqmapped AS (
SELECT	distinct
		sq.SurveyQuestionKey,
		newsq.Question,
		newsq.Category,
		newsq.CategoryPosition,
		newsq.QuestionPosition

FROM	dbo.dimSurveyQuestion sq
		INNER JOIN newsq
			ON newsq.Question = sq.Question
)
,allakki AS (
SELECT	distinct
		db1.AssociationKey,
		db1.batch_key,
		db1.current_indicator,
		db.AssociationNumber,
		db.AssociationName,
		dsq.QuestionPosition,
		dsq.Question,
		CASE WHEN dsq.Category = 'Operational Excellence' then 1
			WHEN dsq.Category = 'Impact' then 2
			WHEN dsq.Category = 'Support' then 3
			ELSE CategoryPosition
		END AS CategoryPosition,		  
		dsq.Category,					   			  
		'KKI' AS CategoryType,			  
		dqr.ResponseText,
		bmsr.[GivenDateKey], 
		[AssociationCount],
		[AssociationPercentage],
		[NationalPercentage],
		[PreviousAssociationPercentage],
		[PeerGroupPercentage],
		CASE WHEN (dsq.Question like '%how frequently%' and ResponseCode in ('01', '02', '03')) then '61'
			WHEN (dsq.Question like '%mainly engage%' and ResponseCode in ('01', '03')) then '61'
			WHEN (dsq.Question like '%likely would you be%' and ResponseCode in ('01', '02')) then '61'				
			ELSE ResponseCode
		 END AS ResponseCode,
		RANK() over (partition by db.AssociationKey order by bmsr.GivenDateKey desc) AS srn

FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
		INNER JOIN dbo.dimAssociation db
			ON bmsr.AssociationKey = db.AssociationKey
		INNER JOIN dd.factMemExDashboardBase db1
			ON bmsr.AssociationKey = db1.AssociationKey
				AND bmsr.GivenDateKey = db1.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey 
				AND (
						dsq.Category in ('Operational Excellence', 'Impact', 'Support')
					)
		  INNER JOIN dbo.dimQuestionResponse dqr
			ON dqr.QuestionResponseKey = bmsr.QuestionResponseKey

WHERE	isnumeric(dqr.ResponseCode) = 1 
		and (
				(
					dqr.ResponseCode = '01' or 
					(
						dqr.ResponseCode <> '-1' and 
						(dsq.Question like '%volunteered at other organizations%' or 
						 dsq.Question like '%charitable, financial contribution%')
					) 
				) or 				
				(
					(dsq.Question like '%how frequently%' and ResponseCode in ('01', '02', '03')) or
					(dsq.Question like '%mainly engage%' and ResponseCode in ('01', '03')) or
					(dsq.Question like '%likely would you be%' and ResponseCode in ('01', '02')) 
				) 
			)				
)
,allapyramid AS (
SELECT	distinct
		db1.AssociationKey,
		db1.batch_key,
		db1.current_indicator,
		db.AssociationNumber,
		db.AssociationName,
		dsq.QuestionPosition,
		dsq.Question,		  
		CategoryPosition,			  
		dsq.Category,					   			  
		'Pyramid' AS CategoryType,			  
		dqr.ResponseText,
		bmsr.[GivenDateKey], 
		[AssociationCount],
		[AssociationPercentage],
		[NationalPercentage],
		[PreviousAssociationPercentage],
		[PeerGroupPercentage],
		CASE WHEN (dsq.Question like '%how frequently%' and ResponseCode in ('01', '02', '03')) then '61'
			WHEN (dsq.Question like '%mainly engage%' and ResponseCode in ('01', '03')) then '61'
			WHEN (dsq.Question like '%likely would you be%' and ResponseCode in ('01', '02')) then '61'				
			ELSE ResponseCode
		 END AS ResponseCode,
		RANK() over (partition by db.AssociationKey order by bmsr.GivenDateKey desc) AS srn	

FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
		INNER JOIN dbo.dimAssociation db
			ON bmsr.AssociationKey = db.AssociationKey
		INNER JOIN dd.factMemExDashboardBase db1
			ON bmsr.AssociationKey = db1.AssociationKey
				AND bmsr.GivenDateKey = db1.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey 
				AND (
						dsq.Category in ('Facility', 'Engagement', 'Service', 'Health & Wellness', 'Value', 'Involvement')
					)
		INNER JOIN dbo.dimQuestionResponse dqr
			ON dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
WHERE	isnumeric(dqr.ResponseCode) = 1 
		and (
				(
					dqr.ResponseCode = '01' or 
					(
						dqr.ResponseCode <> '-1' and 
						(dsq.Question like '%volunteered at other organizations%' or 
						 dsq.Question like '%charitable, financial contribution%')
					) 
				) or 				
				(
					(dsq.Question like '%how frequently%' and ResponseCode in ('01', '02', '03')) or
					(dsq.Question like '%mainly engage%' and ResponseCode in ('01', '03')) or
					(dsq.Question like '%likely would you be%' and ResponseCode in ('01', '02')) 
				) 
			)				
)
,allagrouped as
(
SELECT	AssociationKey,
		batch_key,
		current_indicator,
		AssociationNumber,
		AssociationName,
		AssociationNumber +' - '+ AssociationName AS Association,
		CASE WHEN Category in ('Impact', 'Well Being') then 'Health & Wellness'
			WHEN Category='Support' then 'Service' 
			WHEN Category='Facilities' then 'Facility' 
			ELSE Category END AS Category,
		CategoryType,
		CategoryPosition,
		Left([GivenDateKey],4) AS SurveyYear,
		Question,
		QuestionPosition,	
		SUM(AssociationCount) AssociationCount,
		SUM(AssociationPercentage*100) AS CrtAssociationPercentage,
		SUM(AssociationPercentage*100)-SUM(PreviousAssociationPercentage*100) AS CrtAssociationPercentageYrDelta,
		SUM(NationalPercentage*100) AS NationalPercentage,
		SUM(AssociationPercentage*100)-SUM(NationalPercentage*100) AS CrtAssociationPercentageNtnlDelta,
		SUM(PreviousAssociationPercentage*100) AS PrevAssociationPercentage,
		SUM(PeerGroupPercentage*100) AS PeerGroupPercentage	
	
FROM	allapyramid

WHERE	srn = 1

GROUP BY AssociationKey,
		batch_key,
		current_indicator,
		AssociationNumber,
		AssociationName,
		GivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,
		Question,
		QuestionPosition,
		ResponseCode
	
UNION

SELECT	AssociationKey,
		batch_key,
		current_indicator,
		AssociationNumber,
		AssociationName,
		AssociationNumber +' - '+ AssociationName AS Association,
		Category,
		CategoryType,
		CategoryPosition,
		Left([GivenDateKey],4) AS SurveyYear,
		Question,
		QuestionPosition,	
		SUM(AssociationCount) AssociationCount,
		SUM(AssociationPercentage*100) AS CrtAssociationPercentage,
		SUM(AssociationPercentage*100)-SUM(PreviousAssociationPercentage*100) AS CrtAssociationPercentageYrDelta,
		SUM(NationalPercentage*100) AS NationalPercentage,
		SUM(AssociationPercentage*100)-SUM(NationalPercentage*100) AS CrtAssociationPercentageNtnlDelta,
		SUM(PreviousAssociationPercentage*100) AS PrevAssociationPercentage,
		SUM(PeerGroupPercentage*100) AS PeerGroupPercentage	
	
FROM	allakki
	
WHERE	srn=1

GROUP BY AssociationKey,
		batch_key,
		current_indicator,
		AssociationNumber,
		AssociationName,
		GivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,
		Question,
		QuestionPosition,
		ResponseCode
)
,rpt AS (
SELECT	FBMSR.*,
		left(surveyyear.surveyyear,4) 'PreviousSurveyYear',
		CAST(FBMSR.SurveyYear AS DECIMAL(10,0)) AS 'CurrentNumericYear',
		CAST(left(surveyyear.surveyyear,4) AS decimal(10,0)) AS 'PreviousNumericYear'

FROM	(
		SELECT	*
		
		FROM	allagrouped	
		--KPIs (md on 20120229)
		UNION
		
		SELECT	distinct
				db.AssociationKey,
				batch_key,
				1 current_indicator,
				AssociationNumber,
				db.AssociationName,
				AssociationNumber +' - '+db.AssociationName AS Association,
				CASE WHEN vkpi.Category in ('Health Seekers Meeting Goals', 'Non-Health Seekers Meeting Goals') THEN 'Meeting Goals'
					ELSE vkpi.Category
				 END AS Category,
				CategoryType,
				CategoryPosition,
				SurveyYear,
				vkpi.Category AS Question,
				SortOrder AS QuestionPosition,
				NULL AS AssociationCount, --need to fill this in later if needed
				(100*AssociationPercentage) AS CrtAssociationPercentage,
				CASE WHEN PreviousAssociationPercentage = 0 THEN NULL
					ELSE 100*(AssociationPercentage - PreviousAssociationPercentage)
				END AS CrtAssociationPercentageYrDelta,
				100*NationalPercentage AS NationalPercentage,
				100*(AssociationPercentage - NationalPercentage) AS CrtAssociationPercentageNtnlDelta,
				CASE WHEN PreviousAssociationPercentage = 0 THEN NULL
					ELSE 100*PreviousAssociationPercentage
				END AS PrevAssociationPercentage,
				100*PeerGroupPercentage AS PeerGroupPercentage		
		
		FROM	dd.vwMemExAssociationKPIs vkpi
				INNER JOIN dbo.dimAssociation db
					on db.AssociationKey = vkpi.AssociationKey
		
		WHERE	SurveyYear IS NOT NULL		
				--and vkpi.AssociationName like '%cinci%' and CategoryType = 'KPI'
	) FBMSR
	LEFT JOIN
	(
	SELECT	AssociationNumber,
			Left(GivenDateKey,4) AS SurveyYear,
			RANK() over (partition by AssociationNumber order by GivenDateKey desc) AS 'Rank'
	FROM	(
			SELECT	distinct
					db.AssociationNumber,
					bmsr.GivenDateKey
					
			FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
					INNER JOIN dbo.dimAssociation db
						ON bmsr.AssociationKey = db.AssociationKey
			) SurveyYears
	) SurveyYear 
		ON SurveyYear.AssociationNumber = fBmsr.AssociationNumber
			AND surveyyear.Rank = 2
)
SELECT	[AssociationKey],
		[batch_key],
		[current_indicator],
		[AssociationNumber],
		[AssociationName],
		[Association],
		[Category],
		[CategoryType],
		[CategoryPosition],
		[SurveyYear],
		[Question],
		[QuestionPosition],
		[AssociationCount],
		[CrtAssociationPercentage],
		[CrtAssociationPercentageYrDelta],
		[NationalPercentage],
		[CrtAssociationPercentageNtnlDelta],
		[PrevAssociationPercentage],
		[PeerGroupPercentage],
		[PreviousSurveyYear],
		[CurrentNumericYear],
		[PreviousNumericYear],
		'Q'+ 
		CASE WHEN CategoryType = 'Pyramid' then '01' WHEN CategoryType = 'KPI' then '02' ELSE '03' END +			
		CASE WHEN [CategoryPosition]<10 then '0' ELSE '' END + CAST(CategoryPosition AS varchar(2)) +
		CASE WHEN [QuestionPosition]<10 then '0' ELSE '' END + CAST(QuestionPosition AS varchar(2))
		AS QuestionCode,
		CASE WHEN Question = 'Score' then Category
			ELSE isnull((SELECT	top 1 ShortQuestion 
						FROM	dbo.dimSurveyQuestion sq1 
								INNER JOIN dbo.dimSurveyForm sf
									ON sf.SurveyFormKey = sq1.SurveyFormKey
										AND sf.[Description] like '2012%mem%sat%'
						WHERE	sq1.Question = rpt.Question), left(rpt.Question, 100))
		END AS ShortQuestion

FROM	rpt

GO


