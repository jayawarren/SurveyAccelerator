USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatBranchReport]    Script Date: 08/10/2013 00:11:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mike Druta
-- Create date: 20120424
-- Description:	<Description,,>
-- =============================================

--SELECT * FROM [dd].[vwEmpSatBranchReport] WHERE Association like '%seattle%' AND questiON = 'I have good working conditions.'
ALTER VIEW [dd].[vwEmpSatBranchReport]
AS
WITH newsq AS (			
SELECT	SurveyQuestionKey,	
		Category,
		Question,
		CategoryPosition,
		QuestionPosition,
		QuestionNumber,
		ShortQuestion	
		--row number not needed here because we actually need questiON in more than one category

FROM	dd.vwEmpSat2012SurveyQuestions

WHERE	CategoryType = 'Dashboard'	
		AND Category NOT IN ('Survey Responders')
)
,newsqmapped AS (
SELECT	distinct
		sq.SurveyQuestionKey,
		newsq.Question,
		newsq.Category,
		--,'' AS Category
		newsq.CategoryPosition,
		newsq.QuestionPosition,
		newsq.SurveyQuestionKey AS NewSurveyQuestionKey,
		newsq.QuestionNumber,
		isnull(newsq.ShortQuestion, newsq.Question) AS ShortQuestion
		
FROM 	dbo.dimSurveyQuestion sq
		INNER JOIN newsq
			ON newsq.Question = sq.Question
)
,allakki_assoc AS (
SELECT	distinct
		db1.AssociationKey,
		db1.current_indicator,
		db1.batch_key,
		amsr.SurveyQuestionKey,
		amsr.QuestionResponseKey,
		amsr.GivenDateKey,
		[NationalPercentage],
		[AssociationPercentage]

FROM  [dbo].[factAssociationStaffExperienceReport] amsr	  	  
	  INNER JOIN dd.factEmpSatDashboardBase db1
		ON amsr.AssociationKey = db1.AssociationKey
			AND amsr.batch_key = db1.batch_key
			AND amsr.GivenDateKey = db1.GivenDateKey				
	  INNER JOIN newsqmapped dsq
		ON dsq.SurveyQuestionKey = amsr.SurveyQuestionKey 
			AND (
					dsq.Category in ('Effectiveness', 'Engagement', 'Impact', 'Operational Excellence', 'Satisfaction', 'Support')
				)
	  INNER JOIN dbo.dimQuestionResponse dqr
		ON dqr.QuestionResponseKey = amsr.QuestionResponseKey

WHERE	isnumeric(dqr.ResponseCode) = 1
		AND dqr.ResponseCode = '01'
		AND amsr.current_indicator = 1
		AND db1.current_indicator = 1
		--AND db1.AssociationNumber = '1523'
)
--SELECT * FROM allakki_assoc
,allakki AS (
SELECT	distinct
		db1.AssociationKey,
		db1.BranchKey,
		db1.batch_key,
		db1.current_indicator,
		db1.AssociationName,
		db1.BranchNameShort AS Branch,
		db1.GivenDateKey,
		db1.PrevGivenDateKey,
		dsq.QuestionPosition,
		dsq.Question,
		dsq.ShortQuestion,	  
		CASE WHEN dsq.Category = 'Operational Excellence' then 1
			WHEN dsq.Category = 'Impact' then 2
			WHEN dsq.Category = 'Support' then 3
			ELSE CategoryPosition
		END AS CategoryPosition,		  
		CASE WHEN dsq.Category = 'Operational Excellence' then 'Operational Excellence'
			ELSE dsq.Category					   			  
		END AS Category,
		CASE WHEN dsq.Category in ('Effectiveness', 'Engagement', 'Satisfaction') then 'Staff Experience'		
			WHEN dsq.Category in ('Operational Excellence', 'Impact', 'Support') then 'Performance Measures'
			ELSE dsq.Category
		END AS CategoryType,
		dqr.ResponseText,		
		--,[BranchCount]
		[BranchPercentage],
		allakki_assoc.[NationalPercentage],
		[PreviousBranchPercentage],
		allakki_assoc.[AssociationPercentage],
		[PeerGroupPercentage],
		ResponseCode, --check MemEx code if more than one response needs to be captured
		RANK() over (partitiON by db1.BranchKey order by bmsr.GivenDateKey desc) AS srn
			
FROM	[dbo].[factBranchStaffExperienceReport] bmsr	  	  
		INNER JOIN dd.factEmpSatDashboardBase db1
			ON bmsr.BranchKey = db1.BranchKey
				AND bmsr.batch_key = db1.batch_key
				AND bmsr.GivenDateKey = db1.GivenDateKey				
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey 
			AND (
					dsq.Category in ('Effectiveness', 'Engagement', 'Impact', 'Operational Excellence', 'Satisfaction', 'Support')
				)
		INNER JOIN dbo.dimQuestionResponse dqr
			ON dqr.QuestionResponseKey = bmsr.QuestionResponseKey			  
		INNER JOIN allakki_assoc
			ON allakki_assoc.AssociationKey = db1.AssociationKey
				AND allakki_assoc.batch_key = db1.batch_key
				AND allakki_assoc.GivenDateKey = db1.GivenDateKey
				AND allakki_assoc.SurveyQuestionKey = bmsr.SurveyQuestionKey
				AND allakki_assoc.QuestionResponseKey = bmsr.QuestionResponseKey

WHERE 	isnumeric(dqr.ResponseCode) = 1
		AND dqr.ResponseCode = '01'
		ANd bmsr.current_indicator = 1
		AND db1.current_indicator = 1
)
--SELECT * FROM allakki
,allagrouped as
(
SELECT	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		AssociationName AS Association,
		Branch,
		GivenDateKey,
		PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,	
		SUM(BranchPercentage*100) AS CrtBranchPercentage,		
		SUM(NationalPercentage*100) AS NationalPercentage,		
		SUM(PreviousBranchPercentage*100) AS PrevBranchPercentage,
		SUM(AssociationPercentage*100) AS CrtAssociationPercentage,	
		SUM(PeerGroupPercentage*100) AS PeerGroupPercentage		

FROM	allakki

WHERE	srn=1

GROUP BY AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		AssociationName,
		Branch,
		GivenDateKey,
		PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,
		ResponseCode
)
--SELECT * FROM allagrouped
,rpt AS (
SELECT	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		Association,
		Branch,
		GivenDateKey,
		PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,	
		CrtBranchPercentage,		
		NationalPercentage,	
		PrevBranchPercentage,
		CrtAssociationPercentage,	
		PeerGroupPercentage

FROM	allagrouped
	
--add the KPIs
UNION

SELECT	distinct
		db.AssociationKey,
		db.BranchKey,
		db.batch_key,
		1 current_indicator,
		vkpi.AssociationName AS Association,
		Branch,
		db.GivenDateKey,
		db.PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		vkpi.Category AS Question,
		SortOrder AS QuestionPosition,
		Category AS ShortQuestion,
		100*BranchPercentage AS CrtBranchPercentage,		
		100*NationalPercentage AS NationalPercentage,
		100*PreviousBranchPercentage AS PrevBranchPercentage,
		100*AssociationPercentage AS CrtAssociationPercentage,
		100*PeerGroupPercentage AS PeerGroupPercentage		

FROM	dd.vwEmpSatBranchKPIs vkpi
		INNER JOIN dd.factEmpSatDashboardBase db
			ON db.BranchKey = vkpi.BranchKey
				AND db.batch_key = vkpi.batch_key

WHERE	db.GivenDateKey is not NULL
		AND db.current_indicator = 1				
)
--SELECT * FROM rpt
,aprevrptbase AS 
(
SELECT	distinct
		AssociationKey,
		batch_key,
		current_indicator,
		Association,
		Question,
		Category,
		PrevBranchPercentage

FROM	rpt	
)
,aprevrpt AS 
(
	SELECT	AssociationKey,
			batch_key,
			current_indicator,
			Association,
			Question,
			Category,
			AVG(PrevBranchPercentage) AS PrvAssociationPercentage
			
	FROM	aprevrptbase
	
	GROUP BY AssociationKey,
			batch_key,
			current_indicator,
			Association,
			Question,
			Category
)
SELECT	rpt.AssociationKey,
		rpt.BranchKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.[Association],
		rpt.[Branch],
		rpt.GivenDateKey,
		rpt.PrevGivenDateKey,
		rpt.[CategoryType],
		rpt.[Category],     
		rpt.[CategoryPosition],      
		rpt.[Question],
		rpt.[QuestionPosition],
		cast(ROUND([rpt].[CrtAssociationPercentage], 0) AS int) AS AssociationValue,
		cast(ROUND([aprevrpt].[PrvAssociationPercentage], 0) AS int) AS PrvAssociationValue,
		cast(ROUND([rpt].[NationalPercentage], 0) AS int) AS NationalValue,
		cast(ROUND([rpt].[CrtBranchPercentage], 0) AS int) AS CrtBranchValue,                  
		cast(ROUND([rpt].[PrevBranchPercentage], 0) AS int) AS PrvBranchValue,
		rpt.ShortQuestion,
		'Q'+ 
		CASE WHEN rpt.CategoryType = 'Staff Experience' then '01' WHEN rpt.CategoryType = 'Key Indicators' then '02' ELSE '03' END +			
		CASE WHEN rpt.[CategoryPosition] < 10 then '0' ELSE '' END + CAST(rpt.CategoryPosition AS varchar(2)) +
		CASE WHEN rpt.[QuestionPosition] < 10 then '0' ELSE '' END + CAST(rpt.QuestionPosition AS varchar(2))
		AS QuestionCode	 

FROM	rpt
		LEFT JOIN aprevrpt
			ON rpt.AssociationKey = aprevrpt.AssociationKey
				AND rpt.Association = aprevrpt.Association
				AND rpt.Question = aprevrpt.Question
				AND rpt.Category = aprevrpt.Category
				AND rpt.batch_key = aprevrpt.batch_key
				ANd rpt.current_indicator = aprevrpt.current_indicator
		
GO


