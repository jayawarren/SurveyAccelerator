USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExAssociationKPIs]    Script Date: 08/04/2013 08:27:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dd.vwMemExAssociationKPIs WHERE AssociationName like '%San Francisco%' and SurveyYear = 2012
ALTER VIEW [dd].[vwMemExAssociationKPIs]
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
	SELECT	distinct
			db.AssociationKey,		
			db.current_indicator,
			dsq.Question,
			db.batch_key,		 
			bmsr.[GivenDateKey],
			dqr.ResponseText,
			dqr.ResponseCode,
			[AssociationPercentage],
			[NationalPercentage],
			CASE WHEN [PreviousAssociationPercentage] = 0 then NULL
				ELSE [PreviousAssociationPercentage]
			END AS [PreviousAssociationPercentage],
			[PeerGroupPercentage],
			db.SurveyYear
			
	 FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on bmsr.AssociationKey = db.AssociationKey
					and bmsr.batch_key = db.batch_key
					and bmsr.GivenDateKey = db.GivenDateKey
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
--select * from KPIvals
,promoter as
(
		SELECT	AssociationKey,
				current_indicator,
				SUM(AssociationPercentage) AS AssociationPercentage,
				SUM(PreviousAssociationPercentage) AS PreviousAssociationPercentage,
				batch_key,
				GivenDateKey,
				Question
				
		FROM	KPIvals
		
		WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
				--and ResponseText in ('Definitely would','Net Promoter - 10','Net Promoter - 6','Net Promoter - 7','Net Promoter - 8','Net Promoter - 9','Probably would')			
				and isnumeric(ResponseCode) = 1
				and CONVERT(INT, ResponseCode) >= 9
				
		GROUP BY AssociationKey,
				current_indicator,
				Question,
				batch_key,
				GivenDateKey
)
,detractor AS 
(
		SELECT 	AssociationKey,
				current_indicator,
				SUM(AssociationPercentage) AS AssociationPercentage,
				SUM(PreviousAssociationPercentage) AS PreviousAssociationPercentage,
				batch_key,
				GivenDateKey,
				Question
				
		FROM	KPIvals
		
		WHERE	(Question like '%Would you recommend%to your friends%' or Question like '%extent%real positive impact%')
				--and ResponseText in ('Definitely not','Definitely would not','Probably not')			
				and isnumeric(ResponseCode) = 1
				and CONVERT(INT, ResponseCode) <= 6
				
		GROUP BY AssociationKey,
				current_indicator,
				Question,
				batch_key,
				GivenDateKey
)
,apromoterb AS (
	SELECT	distinct 
			AssociationKey,
			current_indicator,
			ResponseCode,
			[AssociationPercentage],
			[NationalPercentage],
			batch_key,
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
			batch_key,
			GivenDateKey,
			Question
			
	FROM	apromoterb
	
	GROUP BY AssociationKey,
			current_indicator,
			Question,
			batch_key,
			GivenDateKey
)
,adetractorb as
(
	SELECT	distinct
			AssociationKey,
			current_indicator,
			AssociationPercentage,
			NationalPercentage,
			batch_key,
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
				batch_key,
				GivenDateKey,
				Question
				
		FROM	adetractorb
		
		GROUP BY AssociationKey,
				current_indicator,
				Question,
				batch_key,
				GivenDateKey
)
,KPI_Loyalty_Crt_vals AS (
	SELECT	distinct
			db.AssociationKey,
			db.batch_key,
			db.current_indicator,		
			'Definitely will' AS ResponseText,
			'01' AS ResponseCode,				
			db.SurveyYear,
			db.GivenDateKey,
			bmsr.AssociationPercentage,
			bmsr.NationalPercentage,
			CASE WHEN bmsr.PreviousAssociationPercentage = 0 then NULL
				ELSE bmsr.[PreviousAssociationPercentage]
			END AS [PreviousAssociationPercentage]
	
	FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr		
			INNER JOIN dd.factMemExDashboardBase db
				on db.AssociationKey = bmsr.AssociationKey
					and db.GivenDateKey = bmsr.GivenDateKey		
			INNER JOIN mostrec 
				on mostrec.AssociationKey = db.AssociationKey
					and mostrec.GivenDateKey = db.GivenDateKey
	
	WHERE 	bmsr.Segment = 'Very Loyal Likely to Renew'
			and db.current_indicator = 1
			and bmsr.current_indicator = 1
			
)
--adding health seekers generic (no meeting goals)
,KPI_HS_Crt_vals AS (
	SELECT	distinct
			db.AssociationKey,
			db.batch_key,
			db.current_indicator,		
			'Very much' AS ResponseText,
			'01' AS ResponseCode,		
			db.SurveyYear,
			db.GivenDateKey,
			bmsr.AssociationPercentage,
			bmsr.NationalPercentage,
			CASE WHEN bmsr.PreviousAssociationPercentage = 0 then NULL
				ELSE bmsr.[PreviousAssociationPercentage]
			END AS [PreviousAssociationPercentage]
	
	FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.AssociationKey = bmsr.AssociationKey
					and db.batch_key = bmsr.batch_key
					and db.GivenDateKey = bmsr.GivenDateKey
			
	WHERE 	bmsr.Segment = 'Health Seeker'
			and bmsr.current_indicator = 1
			and db.current_indicator = 1
			
)

,KPI_HealthSeekers_Crt_vals AS (
	SELECT	distinct
			db.AssociationKey,
			db.current_indicator,		
			'Very much' AS ResponseText,
			'01' AS ResponseCode,		
			db.SurveyYear,
			db.batch_key,
			db.GivenDateKey,
			bmsr.AssociationPercentage,
			bmsr.NationalPercentage,
			CASE WHEN bmsr.PreviousAssociationPercentage = 0 then NULL
				ELSE bmsr.[PreviousAssociationPercentage]
			END AS [PreviousAssociationPercentage]
	
	FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.AssociationKey = bmsr.AssociationKey
					and db.batch_key = bmsr.batch_key
					and db.GivenDateKey = bmsr.GivenDateKey
	
	WHERE	bmsr.Segment = 'Health Seeker Fitness Goals'
			and bmsr.current_indicator = 1	
			and db.current_indicator = 1
			
)

,KPI_NonHealthSeekers_Crt_vals AS (
	SELECT	distinct
			db.AssociationKey,
			db.current_indicator,		
			'Very Much' AS ResponseText,
			'01' AS ResponseCode,		
			db.SurveyYear,
			db.batch_key,
			db.GivenDateKey,
			bmsr.AssociationPercentage,
			bmsr.NationalPercentage,
			CASE WHEN bmsr.PreviousAssociationPercentage = 0 then NULL
				ELSE bmsr.[PreviousAssociationPercentage]
			END AS [PreviousAssociationPercentage]
	
	FROM	[dbo].[factAssociationMemberSatisfactionReport] bmsr
			INNER JOIN dd.factMemExDashboardBase db
				on db.AssociationKey = bmsr.AssociationKey
					and db.batch_key = bmsr.batch_key
					and db.GivenDateKey = bmsr.GivenDateKey
	
	WHERE	Segment = 'Non Health Seeker Fitness Goals'
			and bmsr.current_indicator = 1
			and db.current_indicator = 1
				
)

--this is the actual SELECT
,allkpis AS 
(
SELECT	A.AssociationKey,
		A.current_indicator,
		A.AssociationName,	
		A.batch_key,
		A.SurveyYear,
		A.CategoryType,	
		A.Category,
		A.CategoryPosition,
		A.Question,
		A.SortOrder,
		COALESCE(B.AssociationPercentage, A.AssociationPercentage) AssociationPercentage,
		COALESCE(B.NationalPercentage, A.NationalPercentage) NationalPercentage,
		A.PreviousAssociationPercentage,
		A.PeerGroupPercentage
		
FROM	(
		SELECT	db.AssociationKey,
				db.current_indicator,
				AssociationName,	
				db.batch_key,
				KPIVals.SurveyYear,
				'Key Indicators' AS CategoryType,	
				'Overall Satisfaction' AS Category,
				1 AS CategoryPosition,
				ResponseText AS Question,
				ResponseCode AS SortOrder,
				AssociationPercentage,
				NationalPercentage,
				PreviousAssociationPercentage,
				PeerGroupPercentage

		FROM	--Seer_ODS.dbo.dimAssociation db 
				dd.factMemExDashboardBase db
				LEFT JOIN KPIvals
					on KPIvals.AssociationKey = db.AssociationKey
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
				db.current_indicator,
				db.AssociationName,
				db.batch_key,
				db.SurveyYear,
				'Key Indicators' AS CategoryType,
				--,'Net Promoter' AS Category
				CASE
					WHEN promoter.Question like '%Would you recommend%to your friends%' then 'Net Promoter'
					WHEN promoter.Question like '%real positive impact%your life%' then 'RPI Individual'
					WHEN promoter.Question like '%real positive impact%community%' then 'RPI Community'
				 END AS Category,
				2 AS CategoryPosition,
				--,'Net Promoter' AS Question
				CASE
					WHEN promoter.Question like '%Would you recommend%to your friends%' then 'Net Promoter'
					WHEN promoter.Question like '%real positive impact%your life%' then 'RPI Individual'
					WHEN promoter.Question like '%real positive impact%community%' then 'RPI Community'
				 END AS Question,
				
				--,1 AS SortOrder
				CASE
					WHEN promoter.Question like '%Would you recommend%to your friends%' then 1
					WHEN promoter.Question like '%real positive impact%your life%' then 2
					WHEN promoter.Question like '%real positive impact%community%' then 3
				 END AS SortOrder,
				(COALESCE(promoter.AssociationPercentage, 0.000000) - COALESCE(detractor.AssociationPercentage, 0.000000)) AS AssociationPercentage,
				(COALESCE(apromoter.NationalPercentage, 0.000000) - COALESCE(adetractor.NationalPercentage, 0.000000)) AS NationalPercentage,
				(COALESCE(promoter.PreviousAssociationPercentage, 0.000000) - COALESCE(detractor.PreviousAssociationPercentage, 0.000000)) AS PreviousAssociationPercentage,	
				NULL AS PeerGroupPercentage
				
		FROM	dd.factMemExDashboardBase db
				LEFT JOIN promoter
					on promoter.AssociationKey = db.AssociationKey
						and db.GivenDateKey = promoter.GivenDateKey
						AND db.current_indicator = promoter.current_indicator
				LEFT JOIN apromoter
					on apromoter.AssociationKey = db.AssociationKey
						and db.GivenDateKey = apromoter.GivenDateKey
						and apromoter.Question = promoter.Question
						and db.current_indicator = apromoter.current_indicator
				LEFT JOIN detractor
					on detractor.AssociationKey = db.AssociationKey
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
				db.current_indicator,
				db.AssociationName,
				db.batch_key,
				db.SurveyYear,
				'Key Indicators' AS CategoryType,	
				'Intent to Renew for Loyalists' AS Category,
				4 AS CategoryPosition,
				COALESCE(KPI_Loyalty_Crt_vals.ResponseText, 'Intent to Renew for Loyalists') AS Question,
				KPI_Loyalty_Crt_vals.ResponseCode AS SortOrder,
				KPI_Loyalty_Crt_vals.AssociationPercentage,
				KPI_Loyalty_Crt_vals.NationalPercentage,
				KPI_Loyalty_Crt_vals.PreviousAssociationPercentage,
				NULL AS PeerGroupPercentage
				
		FROM	dd.factMemExDashboardBase db
				LEFT JOIN KPI_Loyalty_Crt_vals
					on KPI_Loyalty_Crt_vals.AssociationKey = db.AssociationKey
						AND db.batch_key = KPI_Loyalty_Crt_vals.batch_key
						AND db.current_indicator = KPI_Loyalty_Crt_vals.current_indicator

		UNION

		SELECT	db.AssociationKey,
				db.current_indicator,
				db.AssociationName,
				db.batch_key,
				db.SurveyYear,
				'Key Indicators' AS CategoryType,	
				'Health Seekers' AS Category,
				3 AS CategoryPosition,
				COALESCE(KPI_HS_Crt_vals.ResponseText, 'Health Seekers') AS Question,
				KPI_HS_Crt_vals.ResponseCode AS SortOrder,
				KPI_HS_Crt_vals.AssociationPercentage,
				KPI_HS_Crt_vals.NationalPercentage,
				KPI_HS_Crt_vals.PreviousAssociationPercentage,
				NULL AS PeerGroupPercentage
				
		FROM	dd.factMemExDashboardBase db
				LEFT JOIN KPI_HS_Crt_vals
					on KPI_HS_Crt_vals.AssociationKey = db.AssociationKey
						AND db.batch_key = KPI_HS_Crt_vals.batch_key
						AND db.current_indicator = KPI_HS_Crt_vals.current_indicator

		UNION

		SELECT	db.AssociationKey,
				db.current_indicator,
				db.AssociationName,	
				db.batch_key,
				db.SurveyYear,
				'Key Indicators' AS CategoryType,	
				'Health Seekers Meeting Goals' AS Category,
				3 AS CategoryPosition,
				COALESCE(KPI_HealthSeekers_Crt_vals.ResponseText, 'Health Seekers Meeting Goals') AS Question,
				KPI_HealthSeekers_Crt_vals.ResponseCode AS SortOrder,
				KPI_HealthSeekers_Crt_vals.AssociationPercentage,
				KPI_HealthSeekers_Crt_vals.NationalPercentage,
				KPI_HealthSeekers_Crt_vals.PreviousAssociationPercentage,
				NULL AS PeerGroupPercentage
			
		FROM	dd.factMemExDashboardBase db
				LEFT JOIN KPI_HealthSeekers_Crt_vals
					on KPI_HealthSeekers_Crt_vals.AssociationKey = db.AssociationKey
						AND db.batch_key = KPI_HealthSeekers_Crt_vals.batch_key
						AND db.current_indicator = KPI_HealthSeekers_Crt_vals.current_indicator	

		UNION
					
		SELECT	db.AssociationKey,
				db.current_indicator,
				db.AssociationName,	
				db.batch_key,
				db.SurveyYear,
				'Key Indicators' AS CategoryType,	
				'Non-Health Seekers Meeting Goals' AS Category,
				3 AS CategoryPosition,
				COALESCE(KPI_NonHealthSeekers_Crt_vals.ResponseText, 'Non-Health Seekers Meeting Goals') AS Question,
				KPI_NonHealthSeekers_Crt_vals.ResponseCode AS SortOrder,
				KPI_NonHealthSeekers_Crt_vals.AssociationPercentage,
				KPI_NonHealthSeekers_Crt_vals.NationalPercentage,
				KPI_NonHealthSeekers_Crt_vals.PreviousAssociationPercentage,
				NULL AS PeerGroupPercentage
				
		FROM	dd.factMemExDashboardBase db
				LEFT JOIN KPI_NonHealthSeekers_Crt_vals
					on KPI_NonHealthSeekers_Crt_vals.AssociationKey = db.AssociationKey
						AND db.batch_key = KPI_NonHealthSeekers_Crt_vals.batch_key
						AND db.current_indicator = KPI_NonHealthSeekers_Crt_vals.current_indicator
		) A
		LEFT JOIN
		(
		SELECT	B.AssociationKey,
				B.SurveyFormKey,
				B.batch_key,
				B.GivenDateKey,
				B.current_indicator,
				B.Category,
				B.AssociationPercentage,
				C.NationalPercentage
			
		FROM	(
				SELECT	C.organization_key AssociationKey,
						B.organization_key BranchKey,
						D.survey_form_key SurveyFormKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(REPLACE(A.measure_type, 'nps', 'Net Promoter'), 'rpi_com', 'RPI Community'), 'rpi_ind', 'RPI Individual') Category,
						A.measure_value AssociationPercentage

				FROM	dbo.Top_Box A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_branch_number = B.official_branch_number
						INNER JOIN Seer_MDM.dbo.Organization C
							ON A.official_association_number = C.association_number
								AND A.official_association_number = B.official_branch_number
						INNER JOIN Seer_MDM.dbo.Survey_Form D
							ON A.form_code = D.survey_form_code
						INNER JOIN Seer_MDM.dbo.Batch E
							ON A.form_code = E.form_code

				WHERE	A.calculation = 'base'
						AND A.measure_type IN ('nps', 'rpi_com', 'rpi_ind')
						AND A.module = 'Member'
						AND A.aggregate_type = 'Association'
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1
				) B
				LEFT JOIN
				(
				SELECT	0 AssociationKey,
						D.survey_form_key SurveyFormKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(REPLACE(A.measure_type, 'nps', 'Net Promoter'), 'rpi_com', 'RPI Community'), 'rpi_ind', 'RPI Individual') Category,
						A.measure_value NationalPercentage

				FROM	dbo.Top_Box A
						INNER JOIN Seer_MDM.dbo.Survey_Form D
							ON A.form_code = D.survey_form_code
						INNER JOIN Seer_MDM.dbo.Batch E
							ON A.form_code = E.form_code

				WHERE	A.calculation = 'base'
						AND A.measure_type IN ('nps', 'rpi_com', 'rpi_ind')
						AND A.module = 'Member'
						AND A.aggregate_type = 'National'
						AND D.current_indicator = 1
				) C
				ON B.SurveyFormKey = C.SurveyFormKey
					AND B.batch_key = C.batch_key
					AND B.Category = C.Category
			) B
			ON A.AssociationKey = B.AssociationKey
				AND A.batch_key = B.batch_key
				AND A.Category = B.Category
)
SELECT	AssociationKey,
		AssociationName,
		batch_key,
		SurveyYear,
		CategoryType,	
		Category,
		CategoryPosition,
		Question,
		--,SortOrder
		CASE WHEN Category = 'Overall Satisfaction' then 1
			WHEN Category = 'Net Promoter' then 2
			WHEN Category = 'RPI Individual' then 3
			WHEN Category = 'RPI Community' then 4
			WHEN Category = 'Intent to Renew for Loyalists' then 5
			WHEN Category = 'Health Seekers' then 6
			WHEN Category = 'Health Seekers Meeting Goals' then 7
			WHEN Category = 'Non-Health Seekers Meeting Goals' then 8		
			ELSE 10
		END AS SortOrder,
		AssociationPercentage,
		NationalPercentage,
		PreviousAssociationPercentage,
		PeerGroupPercentage

FROM	allkpis
GO


