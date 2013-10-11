USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchKPIs]    Script Date: 08/04/2013 08:27:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dd.vwMemExBranchKPIs WHERE AssociationName like '%boulder%'
ALTER VIEW [dd].[vwMemExBranchKPIs]
AS 
with mostrec AS (
	SELECT	AssociationKey,
			GivenDateKey
	
	FROM	dd.factMemExDashboardBase msp
	
	WHERE	msp.current_indicator = 1
			
	GROUP BY AssociationKey,
			GivenDateKey
)
,KPIvals AS (
	SELECT	db.BranchKey,		
			db.AssociationKey,
			db.current_indicator,
			dsq.Question,		 
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
			
	 FROM	[dbo].[factBranchMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.BranchKey = bmsr.BranchKey
					and db.GivenDateKey = bmsr.GivenDateKey
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
	WHERE	(dsq.Question like '%Overall%rate%' or
			 dsq.Question like '%Would you recommend%to your friends%' or
			 dsq.Question like '%extent%real positive impact%'
			)
			and (isnumeric(ResponseCode) = 1
			and CONVERT(INT, ResponseCode) >= 0
			and CONVERT(INT, ResponseCode) <> 99)
			and SurveyYear is not null						
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
		
		WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
				--and ResponseText in ('Definitely would','Net Promoter - 10','Net Promoter - 6','Net Promoter - 7','Net Promoter - 8','Net Promoter - 9','Probably would')			
				and isnumeric(ResponseCode) = 1
				and CONVERT(INT, ResponseCode) >= 9
				
		GROUP BY BranchKey,
				current_indicator,
				Question,
				GivenDateKey
)

,detractor AS 
(
		SELECT 	BranchKey,
				current_indicator,
				SUM(BranchPercentage) AS BranchPercentage,
				SUM(PreviousBranchPercentage) AS PreviousBranchPercentage,
				GivenDateKey,
				Question
				
		FROM	KPIvals
		
		WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
				--and ResponseText in ('Definitely not','Definitely would not','Probably not')			
				and isnumeric(ResponseCode) = 1
				and CONVERT(INT, ResponseCode) <= 6
				
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
	
	WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
			--and ResponseText in ('Definitely would','Net Promoter - 10','Net Promoter - 6','Net Promoter - 7','Net Promoter - 8','Net Promoter - 9','Probably would')			
			and isnumeric(ResponseCode) = 1
			and CONVERT(INT, ResponseCode) >= 9
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
	
	WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
			--and ResponseText in ('Definitely not','Definitely would not','Probably not')			
			and isnumeric(ResponseCode) = 1
			and CONVERT(INT, ResponseCode) <= 6	
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

,KPI_Loyalty_Crt_vals AS (
	SELECT	distinct
			db.BranchKey,
			db.current_indicator,		
			'Definitely will' AS ResponseText,
			'01' AS ResponseCode,				
			db.AssociationKey,
			db.SurveyYear,
			db.GivenDateKey,
			BranchPercentage,
			AssociationPercentage,
			NationalPercentage,
			CASE WHEN PreviousBranchPercentage = 0 then NULL
				ELSE [PreviousBranchPercentage]
			END AS [PreviousBranchPercentage]
	
	FROM	[dbo].[factBranchMemberSatisfactionReport] bmsr		
			INNER JOIN dd.factMemExDashboardBase db
				on db.BranchKey = bmsr.BranchKey
					and db.GivenDateKey = bmsr.GivenDateKey		
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey			
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
	WHERE 	Segment = 'Very Loyal Likely to Renew'
)
--adding health seekers generic (no meeting goals)
,KPI_HS_Crt_vals AS (
	SELECT	distinct
			db.BranchKey,
			db.current_indicator,		
			'Very much' AS ResponseText,
			'01' AS ResponseCode,		
			db.AssociationKey,
			db.SurveyYear,
			db.GivenDateKey,
			BranchPercentage,
			AssociationPercentage,
			NationalPercentage,
			CASE WHEN PreviousBranchPercentage = 0 then NULL
				ELSE [PreviousBranchPercentage]
			END AS [PreviousBranchPercentage]
		 
	FROM	[dbo].[factBranchMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.BranchKey = bmsr.BranchKey
					and db.GivenDateKey = bmsr.GivenDateKey
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey			
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
	WHERE 	Segment = 'Health Seeker'	
)

,KPI_HealthSeekers_Crt_vals AS (
	SELECT	distinct
			db.BranchKey,
			db.current_indicator,		
			'Very much' AS ResponseText,
			'01' AS ResponseCode,		
			db.AssociationKey,
			db.SurveyYear,
			db.GivenDateKey,
			BranchPercentage,
			AssociationPercentage,
			NationalPercentage,
			CASE WHEN PreviousBranchPercentage = 0 then NULL
				ELSE [PreviousBranchPercentage]
			END AS [PreviousBranchPercentage]
	
	FROM	[dbo].[factBranchMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.BranchKey = bmsr.BranchKey
					and db.GivenDateKey = bmsr.GivenDateKey
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey			
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
	WHERE	Segment = 'Health Seeker Fitness Goals'	
)

,KPI_NonHealthSeekers_Crt_vals AS (
	SELECT	distinct
			db.BranchKey,
			db.current_indicator,		
			'Very Much' AS ResponseText,
			'01' AS ResponseCode,		
			db.AssociationKey,
			db.SurveyYear,
			db.GivenDateKey,
			BranchPercentage,
			AssociationPercentage,
			NationalPercentage,
			CASE WHEN PreviousBranchPercentage = 0 then NULL
				ELSE [PreviousBranchPercentage]
			END AS [PreviousBranchPercentage]
			
	FROM	[dbo].[factBranchMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.BranchKey = bmsr.BranchKey
					and db.GivenDateKey = bmsr.GivenDateKey
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey			
			INNER JOIN Seer_ODS.dbo.dimSurveyQuestion dsq
				on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
			INNER JOIN Seer_ODS.dbo.dimQuestionResponse dqr
				on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
	
	WHERE	Segment = 'Non Health Seeker Fitness Goals'
)

--this is the actual SELECT
,allkpis AS 
(
SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		AssociationName,	
		BranchNameShort AS Branch,
		KPIVals.SurveyYear,
		'Key Indicators' AS CategoryType,	
		'Overall Satisfaction' AS Category,
		1 AS CategoryPosition,
		ResponseText AS Question,
		ResponseCode AS SortOrder,
		BranchPercentage,
		AssociationPercentage,
		NationalPercentage,
		PreviousBranchPercentage,
		PeerGroupPercentage

FROM	--Seer_ODS.dbo.dimBranch db 
		dd.factMemExDashboardBase db
		LEFT JOIN KPIvals
			on KPIvals.BranchKey = db.BranchKey
				and db.GivenDateKey = KPIVals.GivenDateKey
				and Question like '%Overall%rate%' --and ResponseCode=1
				AND db.current_indicator = KPIVals.current_indicator
		INNER JOIN mostrec 
			on mostrec.AssociationKey = db.AssociationKey
				and mostrec.GivenDateKey = db.GivenDateKey

WHERE	isnumeric(ResponseCode) = 1
		and ResponseCode = '01'
		
UNION 

--Net Promoters
SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,
		db.BranchNameShort AS Branch,
		db.SurveyYear,
		'Key Indicators' AS CategoryType,
		--,'Net Promoter' AS Category
		CASE
			WHEN promoter.Question like '%Would you recommend%to your friends%' then 'Net Promoter'
			WHEN promoter.Question like '%real positive impact%your life%' then 'Net Outcome - Individual'
			WHEN promoter.Question like '%real positive impact%community%' then 'Net Outcome - Community'
		 END AS Category,
		2 AS CategoryPosition,
		--,'Net Promoter' AS Question
		CASE
			WHEN promoter.Question like '%Would you recommend%to your friends%' then 'Net Promoter'
			WHEN promoter.Question like '%real positive impact%your life%' then 'Net Outcome - Individual'
			WHEN promoter.Question like '%real positive impact%community%' then 'Net Outcome - Community'
		 END AS Question,
		
		--,1 AS SortOrder
		CASE
			WHEN promoter.Question like '%Would you recommend%to your friends%' then 1
			WHEN promoter.Question like '%real positive impact%your life%' then 2
			WHEN promoter.Question like '%real positive impact%community%' then 3
		 END AS SortOrder,
		
		(promoter.BranchPercentage - detractor.BranchPercentage) AS BranchPercentage,
		(apromoter.AssociationPercentage - adetractor.AssociationPercentage) AS AssociationPercentage,
		(apromoter.NationalPercentage - adetractor.NationalPercentage) AS NationalPercentage,
		(promoter.PreviousBranchPercentage - detractor.PreviousBranchPercentage) AS PreviousBranchPercentage,	
		NULL AS PeerGroupPercentage
		
FROM	dd.factMemExDashboardBase db
		INNER JOIN promoter
			on promoter.BranchKey = db.BranchKey
				and db.GivenDateKey = promoter.GivenDateKey
				AND db.current_indicator = promoter.current_indicator
		LEFT JOIN apromoter
			on apromoter.AssociationKey = db.AssociationKey
				and db.GivenDateKey = apromoter.GivenDateKey
				and apromoter.Question = promoter.Question
				and db.current_indicator = apromoter.current_indicator
		LEFT JOIN detractor
			on detractor.BranchKey = db.BranchKey
				and db.GivenDateKey = detractor.GivenDateKey
				and detractor.Question = promoter.Question
				and db.current_indicator = detractor.current_indicator
		LEFT JOIN adetractor
			on adetractor.AssociationKey = db.AssociationKey
				and db.GivenDateKey = adetractor.GivenDateKey
				and adetractor.Question = promoter.Question
				and db.current_indicator = adetractor.current_indicator

UNION

SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,
		db.BranchNameShort	as Branch,
		KPI_Loyalty_Crt_vals.SurveyYear,
		'Key Indicators' AS CategoryType,	
		'Intent to Renew for Loyalists' AS Category,
		4 AS CategoryPosition,
		KPI_Loyalty_Crt_vals.ResponseText AS Question,
		KPI_Loyalty_Crt_vals.ResponseCode AS SortOrder,
		KPI_Loyalty_Crt_vals.BranchPercentage,
		KPI_Loyalty_Crt_vals.AssociationPercentage,
		KPI_Loyalty_Crt_vals.NationalPercentage,
		KPI_Loyalty_Crt_vals.PreviousBranchPercentage,
		NULL AS PeerGroupPercentage
		
FROM	dd.factMemExDashboardBase db
		LEFT JOIN KPI_Loyalty_Crt_vals
			on KPI_Loyalty_Crt_vals.BranchKey = db.BranchKey
				and db.GivenDateKey = KPI_Loyalty_Crt_vals.GivenDateKey
				AND db.current_indicator = KPI_Loyalty_Crt_vals.current_indicator

UNION

SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,
		BranchNameShort	as Branch,
		KPI_HS_Crt_vals.SurveyYear,
		'Key Indicators' AS CategoryType,	
		'Health Seekers' AS Category,
		3 AS CategoryPosition,
		KPI_HS_Crt_vals.ResponseText AS Question,
		KPI_HS_Crt_vals.ResponseCode AS SortOrder,
		KPI_HS_Crt_vals.BranchPercentage,
		KPI_HS_Crt_vals.AssociationPercentage,
		KPI_HS_Crt_vals.NationalPercentage,
		KPI_HS_Crt_vals.PreviousBranchPercentage,
		NULL AS PeerGroupPercentage
		
FROM	dd.factMemExDashboardBase db
		LEFT JOIN KPI_HS_Crt_vals
			on KPI_HS_Crt_vals.BranchKey = db.BranchKey
				AND db.current_indicator = KPI_HS_Crt_vals.current_indicator

UNION

SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,	
		db.BranchNameShort AS Branch,
		KPI_HealthSeekers_Crt_vals.SurveyYear,
		'Key Indicators' AS CategoryType,	
		'Health Seekers Meeting Goals' AS Category,
		3 AS CategoryPosition,
		KPI_HealthSeekers_Crt_vals.ResponseText AS Question,
		KPI_HealthSeekers_Crt_vals.ResponseCode AS SortOrder,
		KPI_HealthSeekers_Crt_vals.BranchPercentage,
		KPI_HealthSeekers_Crt_vals.AssociationPercentage,
		KPI_HealthSeekers_Crt_vals.NationalPercentage,
		KPI_HealthSeekers_Crt_vals.PreviousBranchPercentage,
		NULL AS PeerGroupPercentage
	
FROM	dd.factMemExDashboardBase db
		LEFT JOIN KPI_HealthSeekers_Crt_vals
			on KPI_HealthSeekers_Crt_vals.BranchKey = db.BranchKey
				AND db.current_indicator = KPI_HealthSeekers_Crt_vals.current_indicator	

UNION
			
SELECT	db.AssociationKey,
		db.BranchKey,
		db.current_indicator,
		db.AssociationName,	
		db.BranchNameShort	as Branch,
		KPI_NonHealthSeekers_Crt_vals.SurveyYear,
		'Key Indicators' AS CategoryType,	
		'Non-Health Seekers Meeting Goals' AS Category,
		3 AS CategoryPosition,
		KPI_NonHealthSeekers_Crt_vals.ResponseText AS Question,
		KPI_NonHealthSeekers_Crt_vals.ResponseCode AS SortOrder,
		KPI_NonHealthSeekers_Crt_vals.BranchPercentage,
		KPI_NonHealthSeekers_Crt_vals.AssociationPercentage,
		KPI_NonHealthSeekers_Crt_vals.NationalPercentage,
		KPI_NonHealthSeekers_Crt_vals.PreviousBranchPercentage,
		NULL AS PeerGroupPercentage
		
FROM	dd.factMemExDashboardBase db
		LEFT JOIN KPI_NonHealthSeekers_Crt_vals
			on KPI_NonHealthSeekers_Crt_vals.BranchKey = db.BranchKey
				AND db.current_indicator = KPI_NonHealthSeekers_Crt_vals.current_indicator	
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
		--,SortOrder
		CASE WHEN Category = 'Overall Satisfaction' then 1
			WHEN Category = 'Net Promoter' then 2
			WHEN Category = 'Net Outcome - Individual' then 3
			WHEN Category = 'Net Outcome - Community' then 4
			WHEN Category = 'Intent to Renew for Loyalists' then 5
			WHEN Category = 'Health Seekers' then 6
			WHEN Category = 'Health Seekers Meeting Goals' then 7
			WHEN Category = 'Non-Health Seekers Meeting Goals' then 8		
			ELSE 10
		END AS SortOrder,
		BranchPercentage,
		AssociationPercentage,
		NationalPercentage,
		PreviousBranchPercentage,
		PeerGroupPercentage

FROM	allkpis












GO


