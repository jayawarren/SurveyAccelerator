USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatBranchKPIs]    Script Date: 08/04/2013 08:27:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dd.vwEmpSatBranchKPIs WHERE AssociationKey = 2165--AssociationName like '%boulder%'
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
	SELECT	distinct
			db.BranchKey,		
			db.AssociationKey,
			db.batch_key,
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
					AND db.batch_key = bmsr.batch_key
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
			AND bmsr.current_indicator = 1
			AND db.current_indicator = 1							
)
--select	* from KPIvals
,promoter as
(
		SELECT	BranchKey,
				batch_key,
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
				batch_key,
				current_indicator,
				Question,
				GivenDateKey
)
--select * from promoter
,detractor AS 
(
	SELECT 	BranchKey,
			batch_key,
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
			batch_key,
			current_indicator,
			Question,
			GivenDateKey
)
,apromoterb AS (
	SELECT	AssociationKey,
			batch_key,
			current_indicator,
			ResponseCode,
			SUM([AssociationPercentage]) AssociationPercentage,
			SUM([NationalPercentage]) NationalPercentage,
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
			 
	GROUP BY AssociationKey,
			batch_key,
			current_indicator,
			ResponseCode,
			GivenDateKey,
			Question
)
,apromoter AS 
(
	SELECT	AssociationKey,
			batch_key,
			current_indicator,
			SUM(AssociationPercentage) AS AssociationPercentage,
			SUM(NationalPercentage) AS NationalPercentage,
			GivenDateKey,
			Question
			
	FROM	apromoterb
	
	GROUP BY AssociationKey,
			batch_key,
			current_indicator,
			Question,
			GivenDateKey
)
,adetractorb as
(
	SELECT	AssociationKey,
			batch_key,
			current_indicator,
			SUM([AssociationPercentage]) AssociationPercentage,
			SUM([NationalPercentage]) NationalPercentage,
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
	
	GROUP BY AssociationKey,
			batch_key,
			current_indicator,
			GivenDateKey,
			Question
)
,adetractor as
(
		SELECT	AssociationKey,
				batch_key,
				current_indicator,
				SUM(AssociationPercentage) AS AssociationPercentage,
				SUM(NationalPercentage) AS NationalPercentage,
				GivenDateKey,
				Question
				
		FROM	adetractorb
		
		GROUP BY AssociationKey,
				batch_key,
				current_indicator,
				Question,
				GivenDateKey
)

--this is the actual SELECT
,allkpis AS 
(
SELECT	A.AssociationKey,
		A.BranchKey,
		A.current_indicator,
		A.AssociationName,	
		A.Branch,
		A.batch_key,
		A.SurveyYear,
		A.CategoryType,	
		A.Category,
		A.CategoryPosition,
		A.Question,
		A.QuestionNumber,
		A.SortOrder,
		COALESCE(B.BranchPercentage, A.BranchPercentage) BranchPercentage,
		COALESCE(B.AssociationPercentage, A.AssociationPercentage) AssociationPercentage,
		COALESCE(B.NationalPercentage, A.NationalPercentage) NationalPercentage,
		A.PreviousBranchPercentage,
		A.PeerGroupPercentage
		
FROM	(
		--Net Promoters
		SELECT	db.AssociationKey,
				db.BranchKey,
				db.batch_key,
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
						AND KPIVals.batch_key = db.batch_key
						AND KPIVals.GivenDateKey = db.GivenDateKey
				LEFT JOIN promoter
					on promoter.BranchKey = db.BranchKey
						AND db.batch_key = promoter.batch_key
						AND db.GivenDateKey = promoter.GivenDateKey
						AND db.current_indicator = promoter.current_indicator
						AND KPIvals.Question = promoter.Question
				LEFT JOIN apromoter
					on apromoter.AssociationKey = db.AssociationKey
						AND db.batch_key = apromoter.batch_key
						AND db.GivenDateKey = apromoter.GivenDateKey
						AND apromoter.Question = promoter.Question
						AND db.current_indicator = apromoter.current_indicator
				LEFT JOIN detractor
					on detractor.BranchKey = db.BranchKey
						AND db.batch_key = detractor.batch_key
						AND db.GivenDateKey = detractor.GivenDateKey
						AND detractor.Question = KPIvals.Question
						AND db.current_indicator = detractor.current_indicator
				LEFT JOIN adetractor
					on adetractor.AssociationKey = db.AssociationKey
						AND db.GivenDateKey = adetractor.GivenDateKey
						AND db.GivenDateKey = adetractor.GivenDateKey
						AND adetractor.Question = KPIvals.Question
						AND db.current_indicator = adetractor.current_indicator

		WHERE	db.current_indicator = 1
		) A
		LEFT JOIN
		(
		SELECT	A.AssociationKey,
				A.BranchKey,
				A.SurveyFormKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator,
				A.Category,
				A.BranchPercentage,
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
						REPLACE(REPLACE(REPLACE(REPLACE(A.measure_type, 'nps_mem', 'Net Promoter - Membership'), 'rpi_com', 'Real Positive Impact - Community'), 'rpi_ind', 'Real Positive Impact - Individual'), 'nps_work', 'Net Promoter - Membership') Category,
						A.measure_value BranchPercentage

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
						AND A.measure_type IN ('nps_mem', 'nps_work', 'rpi_com', 'rpi_ind')
						AND A.module = 'Staff'
						AND A.aggregate_type = 'Branch'
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1
				) A	
				LEFT JOIN
				(
				SELECT	C.organization_key AssociationKey,
						B.organization_key BranchKey,
						D.survey_form_key SurveyFormKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(REPLACE(REPLACE(A.measure_type, 'nps_mem', 'Net Promoter - Membership'), 'rpi_com', 'Real Positive Impact - Community'), 'rpi_ind', 'Real Positive Impact - Individual'), 'nps_work', 'Net Promoter - Membership') Category,
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
						AND A.measure_type IN ('nps_mem', 'nps_work', 'rpi_com', 'rpi_ind')
						AND A.module = 'Staff'
						AND A.aggregate_type = 'Association'
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1
				) B
				ON A.AssociationKey = B.AssociationKey
					AND A.BranchKey = B.BranchKey
					AND A.SurveyFormKey = B.SurveyFormKey
					AND A.batch_key = B.batch_key
					AND A.Category = B.Category
				LEFT JOIN
				(
				SELECT	0 AssociationKey,
						0 BranchKey,
						D.survey_form_key SurveyFormKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(REPLACE(REPLACE(A.measure_type, 'nps_mem', 'Net Promoter - Membership'), 'rpi_com', 'Real Positive Impact - Community'), 'rpi_ind', 'Real Positive Impact - Individual'), 'nps_work', 'Net Promoter - Membership') Category,
						A.measure_value NationalPercentage

				FROM	dbo.Top_Box A
						INNER JOIN Seer_MDM.dbo.Survey_Form D
							ON A.form_code = D.survey_form_code
						INNER JOIN Seer_MDM.dbo.Batch E
							ON A.form_code = E.form_code

				WHERE	A.calculation = 'base'
						AND A.measure_type IN ('nps_mem', 'nps_work', 'rpi_com', 'rpi_ind')
						AND A.module = 'Staff'
						AND A.aggregate_type = 'National'
						AND D.current_indicator = 1
				) C
				ON A.SurveyFormKey = C.SurveyFormKey
					AND A.batch_key = C.batch_key
					AND A.Category = C.Category
			) B
			ON A.AssociationKey = B.AssociationKey
				AND A.BranchKey = B.BranchKey
				AND A.batch_key = B.batch_key
				AND A.Category = B.Category
)
SELECT	distinct
		AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
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


