USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatBranchKPIs]    Script Date: 08/04/2013 08:27:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dd.vwEmpSatBranchKPIs WHERE AssociationName like '%boulder%'
ALTER VIEW [dd].[vwEmpSatBranchKPIs]
AS 
with mostrec AS (
	SELECT	AssociationKey,
			GivenDateKey
	
	FROM	dd.factEmpSatDashboardBase msp
	
	WHERE	msp.current_indicator = 1
			
	GROUP BY AssociationKey,
			GivenDateKey
)
,KPIvals AS (
	SELECT	db.BranchKey,		
			db.AssociationKey,
			db.current_indicator,
			dsq.Question,
			dsq.QuestionNumber,	 
			bmsr.[GivenDateKey],
			dqr.ResponseText,
			dqr.ResponseCode,
			[BranchPercentage],
			[NationalPercentage],
			CASE WHEN [PreviousBranchPercentage] = 0 then NULL
				ELSE [PreviousBranchPercentage]
			END AS [PreviousBranchPercentage],
			[AssociationPercentage],
			[PeerGroupPercentage],
			db.SurveyYear
			
	 FROM	[dbo].[factBranchStaffExperienceReport] bmsr
			INNER JOIN dd.factEmpSatDashboardBase db
				ON db.BranchKey = bmsr.BranchKey
					AND db.GivenDateKey = bmsr.GivenDateKey
			INNER JOIN mostrec 
				ON mostrec.AssociationKey = db.AssociationKey
					AND mostrec.GivenDateKey = db.GivenDateKey
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				ON dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				ON dqr.QuestionResponseKey = bmsr.QuestionResponseKey
			INNER JOIN dd.vwEmpSat2012SurveyQuestions s
				ON dsq.SurveyQuestionKey = s.SurveyQuestionKey
	
	WHERE	s.CategoryType = 'Dashboard'
			AND s.Category = 'Key Indicators'
			AND (isnumeric(ResponseCode) = 1
			AND CONVERT(INT, ResponseCode) >= 0
			AND CONVERT(INT, ResponseCode) <> 99)
			AND SurveyYear is not null						
)
--select	* from KPIvals
,promoter as
(
		SELECT	BranchKey,
				current_indicator,
				SUM(BranchPercentage) AS BranchPercentage,
				SUM(PreviousBranchPercentage) AS PreviousBranchPercentage,
				GivenDateKey,
				Question
				
		FROM	KPIvals
		
		WHERE	isnumeric(ResponseCode) = 1 and 
				(
				 (Question like '%recommend%membership%' AND CONVERT(INT, ResponseCode) >= 9) or
				 (Question like '%recommend%place to work%' AND CONVERT(INT, ResponseCode) >= 9) or
				 (Question like '%still be employed%' AND CONVERT(INT, ResponseCode) = 1) or
				 (Question like '%real positive impact%your life%' AND CONVERT(INT, ResponseCode) >= 9) or
				 (Question like '%real positive impact%community%' AND CONVERT(INT, ResponseCode) >= 9)
				 )								
				
		GROUP BY BranchKey,
				current_indicator,
				Question,
				GivenDateKey
)
--select * from promoter
,detractor AS 
(
	SELECT 	BranchKey,
			current_indicator,
			SUM(BranchPercentage) AS BranchPercentage,
			SUM(PreviousBranchPercentage) AS PreviousBranchPercentage,
			GivenDateKey,
			Question
			
	FROM	KPIvals
	
	WHERE	isnumeric(ResponseCode) = 1 and 
			(
			 (Question like '%recommend%membership%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%recommend%place to work%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%still be employed%' and CONVERT(INT, ResponseCode) = -100) or
			 (Question like '%real positive impact%your life%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%real positive impact%community%' and CONVERT(INT, ResponseCode) <= 6)
			 )	
			
	GROUP BY BranchKey,
			current_indicator,
			Question,
			GivenDateKey
)
,apromoterb AS (
	SELECT	distinct 
			AssociationKey,
			current_indicator,
			ResponseCode,
			[AssociationPercentage],
			[NationalPercentage],
			GivenDateKey,
			Question
	
	FROM	KPIVals
	
	WHERE	isnumeric(ResponseCode) = 1 and 
			(
			 (Question like '%recommend%membership%' AND CONVERT(INT, ResponseCode) >= 9) or
			 (Question like '%recommend%place to work%' AND CONVERT(INT, ResponseCode) >= 9) or
			 (Question like '%still be employed%' AND CONVERT(INT, ResponseCode) = 1) or
			 (Question like '%real positive impact%your life%' AND CONVERT(INT, ResponseCode) >= 9) or
			 (Question like '%real positive impact%community%' AND CONVERT(INT, ResponseCode) >= 9)
			 )
)

,apromoter AS 
(
	SELECT	AssociationKey,
			current_indicator,
			SUM(AssociationPercentage) AS AssociationPercentage,
			SUM(NationalPercentage) AS NationalPercentage,
			GivenDateKey,
			Question
			
	FROM	apromoterb
	
	GROUP BY AssociationKey,
			current_indicator,
			Question,
			GivenDateKey
)
,adetractorb as
(
	SELECT	distinct
			AssociationKey,
			current_indicator,
			AssociationPercentage,
			NationalPercentage,
			GivenDateKey,
			Question
			
	FROM	KPIvals
	
	WHERE	isnumeric(ResponseCode) = 1 and 
			(
			 (Question like '%recommend%membership%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%recommend%place to work%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%still be employed%' and CONVERT(INT, ResponseCode) = -100) or
			 (Question like '%real positive impact%your life%' and CONVERT(INT, ResponseCode) <= 6) or
			 (Question like '%real positive impact%community%' and CONVERT(INT, ResponseCode) <= 6)
			 )	
)
,adetractor as
(
		SELECT	AssociationKey,
				current_indicator,
				SUM(AssociationPercentage) AS AssociationPercentage,
				SUM(NationalPercentage) AS NationalPercentage,
				GivenDateKey,
				Question
				
		FROM	adetractorb
		
		GROUP BY AssociationKey,
				current_indicator,
				Question,
				GivenDateKey
)

--this is the actual SELECT
,allkpis AS 
(
--Net Promoters
SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,
		db.BranchNameShort AS Branch,
		db.SurveyYear,
		'Key Indicators' as CategoryType,	
		CASE
			WHEN KPIvals.Question like '%recommend%place to work%' then 'Net Promoter - Employment'
			WHEN KPIvals.Question like '%recommend%membership%' then 'Net Promoter - Membership'				
			WHEN KPIvals.Question like '%real positive impact%your life%' then 'Real Positive Impact - Individual'
			WHEN KPIvals.Question like '%real positive impact%community%' then 'Real Positive Impact - Community'
			WHEN KPIvals.Question like '%still be employed%' then 'Retention'		
		END AS Category,
		2 as CategoryPosition,
		KPIvals.Question,	
		QuestionNumber,
		CASE 
			WHEN KPIvals.Question like '%recommend%place to work%' then 1
			WHEN KPIvals.Question like '%recommend%membership%' then 2
			WHEN KPIvals.Question like '%real positive impact%your life%' then 3
			WHEN KPIvals.Question like '%real positive impact%community%' then 4
			WHEN KPIvals.Question like '%still be employed%' then 5		
			else 0
		END AS SortOrder,
		(promoter.BranchPercentage - detractor.BranchPercentage) AS BranchPercentage,
		(apromoter.AssociationPercentage - adetractor.AssociationPercentage) AS AssociationPercentage,
		(apromoter.NationalPercentage - adetractor.NationalPercentage) AS NationalPercentage,
		(promoter.PreviousBranchPercentage - detractor.PreviousBranchPercentage) AS PreviousBranchPercentage,	
		NULL AS PeerGroupPercentage
		
FROM	dd.factEmpSatDashboardBase db
		INNER JOIN KPIvals 
			ON KPIVals.BranchKey = db.BranchKey
				AND KPIVals.GivenDateKey = db.GivenDateKey
		LEFT JOIN promoter
			on promoter.BranchKey = db.BranchKey
				AND db.GivenDateKey = promoter.GivenDateKey
				AND db.current_indicator = promoter.current_indicator
		LEFT JOIN apromoter
			on apromoter.AssociationKey = db.AssociationKey
				AND db.GivenDateKey = apromoter.GivenDateKey
				AND apromoter.Question = promoter.Question
				AND db.current_indicator = apromoter.current_indicator
		LEFT JOIN detractor
			on detractor.BranchKey = db.BranchKey
				AND db.GivenDateKey = detractor.GivenDateKey
				AND detractor.Question = promoter.Question
				AND db.current_indicator = detractor.current_indicator
		LEFT JOIN adetractor
			on adetractor.AssociationKey = db.AssociationKey
				AND db.GivenDateKey = adetractor.GivenDateKey
				AND adetractor.Question = promoter.Question
				AND db.current_indicator = adetractor.current_indicator


)
SELECT	AssociationKey,
		BranchKey,
		AssociationName,
		Branch,
		SurveyYear,
		CategoryType,	
		Category,
		CategoryPosition,
		Question,
		QuestionNumber,
		SortOrder,
		BranchPercentage,
		AssociationPercentage,
		NationalPercentage,
		PreviousBranchPercentage,
		PeerGroupPercentage

FROM	allkpis












GO


