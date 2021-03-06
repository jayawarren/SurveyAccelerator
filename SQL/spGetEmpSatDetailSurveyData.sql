USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGetEmpSatDetailSurveyData]    Script Date: 08/05/2013 09:18:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		mike druta
-- Create date: 20120425
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dd].[spGetEmpSatDetailSurveyData] (
	@ACategory varchar(100)
)	
AS
BEGIN

--DECLARE @ACategory varchar(20);
--SET @ACategory = 'Dashboard';
WITH newsq AS (			
SELECT	SurveyQuestionKey,	
		Category,
		Question,
		CategoryPosition,
		QuestionPosition,
		QuestionNumber,
		ROW_NUMBER() over (partitiON by SurveyQuestionKey, Question order by CategoryPosition, QuestionPosition) AS rn

FROM 	dd.vwEmpSat2012SurveyQuestions
 
WHERE 	--CategoryType = @ACategory AND 
		(
		 (@ACategory = 'Dashboard' AND CategoryType is not null) or 
		 (@ACategory <> 'Dashboard' AND CategoryType = @ACategory)
		)
		AND Category not in ('Survey Responders')
)
,newsqmapped AS (
SELECT	distinct
		sq.SurveyQuestionKey,
		newsq.Question,
		newsq.Category,
		--'' AS Category,
		newsq.CategoryPosition,
		newsq.QuestionPosition,
		newsq.SurveyQuestionKey AS NewSurveyQuestionKey,
		newsq.QuestionNumber

FROM 	dbo.dimSurveyQuestion sq
		INNER JOIN newsq
			ON newsq.Question = sq.Question
			AND rn=1
)
,allr AS (
SELECT	distinct
		newsqmapped.NewSurveyQuestionKey,
		qr.ResponseText,
		qr.ResponseCode,
		qr.QuestionResponseKey

FROM	newsqmapped
		INNER JOIN dimQuestionResponse qr
			ON qr.SurveyQuestionKey = newsqmapped.NewSurveyQuestionKey
			AND isnumeric(ResponseCode)=1
			AND ResponseCode <> -1
)
,rpt_allr as
(
SELECT	distinct
		AssociationName,
		DB.BranchNameShort,
		dsq.Category,
		dsq.Question,
		dsq.CategoryPosition,
		dsq.QuestionPosition,
		allr.ResponseCode,
		allr.ResponseText,
		allr.QuestionResponseKey,
		dsq.QuestionNumber
	
FROM 	dbo.factBranchStaffExperienceReport msr
		INNER JOIN dd.factEmpSatDashboardBase db
			ON db.BranchKey = msr.BranchKey
				AND db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		RIGHT JOIN allr 
			ON dsq.NewSurveyQuestionKey = allr.NewSurveyQuestionKey 

WHERE	ISNUMERIC(ResponseCode)=1				
)
,rpt_null AS (

		SELECT	distinct
				db.AssociationName,
				db.BranchNameShort AS Branch,
				qc.Category,
				dsq.Question,
				dr.ResponseText,	 
				msr.AssociationPercentage AS AssociationPercentage,
				msr.NationalPercentage AS NationalPercentage,
				qc.CategoryPosition,
				qc.QuestionPosition,
				dsq.QuestionType,
				dsq.QuestionNumber,
				dr.ResponseCode
					
		FROM 	dbo.factBranchStaffExperienceReport msr
				INNER JOIN dd.factEmpSatDashboardBase db
					ON db.BranchKey = msr.BranchKey
						AND db.GivenDateKey = msr.GivenDateKey			
				INNER JOIN dbo.dimSurveyQuestion dsq
					ON dsq.SurveyQuestionKey = msr.SurveyQuestionKey
				INNER JOIN dbo.dimQuestionCategory qc
					ON qc.SurveyQuestionKey = msr.SurveyQuestionKey	
				INNER JOIN dimQuestionResponse dr
					ON dr.QuestionResponseKey = msr.QuestionResponseKey	
						AND isnumeric(dr.ResponseCode)=1
						AND dr.ResponseCode <> -1
						
		--WHERE	db.AssociationName = 'YMCA of SilicON Valley'
)
--SELECT * FROM rpt_null;
,rpt_miss AS (
SELECT	distinct
		rll.AssociationName,
		rll.Branch,
		rll.Category,
		rll.Question,
		rll.ResponseText,	 
		NULL AS PeerGroup,
		100*msr.BranchPercentage AS BranchPercentage,
		100*rll.AssociationPercentage AS AssociationPercentage,
		100*rll.NationalPercentage AS NationalPercentage,
		100*msr.PeerGroupPercentage AS PeerPercentage,
		100*msr.PreviousBranchPercentage AS PreviousBranchPercentage,
		rll.CategoryPosition,
		--,dsq.QuestionPosition
		rll.ResponseCode,
		COALESCE(msr.QuestionResponseKey, -1) QuestionResponseKey
			
FROM	dbo.factBranchStaffExperienceReport msr
		INNER JOIN dd.factEmpSatDashboardBase db
			ON db.BranchKey = msr.BranchKey
				AND db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		RIGHT JOIN rpt_null rll
			ON rll.AssociationName = db.AssociationName
			AND rll.Branch = db.BranchNameShort		
		INNER JOIN dimQuestionResponse dr
			ON msr.QuestionResponseKey = dr.QuestionResponseKey	
				AND rll.Category = dsq.Category
				AND rll.Question = dsq.Question
				AND rll.ResponseText = dr.ResponseText
				AND rll.CategoryPositiON = dsq.CategoryPosition
				AND rll.QuestionPositiON = dsq.QuestionPosition
				AND rll.ResponseCode = dr.ResponseCode
				AND isnumeric(dr.ResponseCode)=1
				AND dr.ResponseCode <> -1

--WHERE	rll.AssociationName = 'YMCA of SilicON Valley'
)
--SELECT * FROM rpt_miss;
,rpt AS (
SELECT	distinct
		rpt_allr.AssociationName,
		rpt_allr.BranchNameShort AS Branch,
		rpt_allr.Category,
		rpt_allr.Question,
		rpt_allr.ResponseText AS OriginalResponseText, 
		CASE WHEN rpt_allr.Category = 'Key Indicators' AND rpt_allr.Question not like '%still be employed%' THEN
				(
					CASE 
						WHEN rpt_allr.ResponseCode in ('09','10') THEN '9,10'
						WHEN rpt_allr.ResponseCode in ('07','08') THEN '7,8'					
						ELSE '0-6'
					END
				)
			ELSE rpt_allr.ResponseText
		END AS ResponseText,	 
		NULL AS PeerGroup,
		rpt_miss.BranchPercentage,
		rpt_miss.AssociationPercentage,
		rpt_miss.NationalPercentage,
		rpt_miss.PeerPercentage,
		rpt_miss.PreviousBranchPercentage,
		rpt_allr.CategoryPosition,
		--,rpt_allr.QuestionPosition
		--,rpt_allr.ResponseCode
		CASE WHEN rpt_allr.Category = 'Key Indicators' AND rpt_allr.Question not like '%still be employed%' THEN
				(
					CASE 
						WHEN rpt_allr.ResponseCode in ('09','10') THEN 69
						WHEN rpt_allr.ResponseCode in ('07','08') THEN 67					
						ELSE 60
					END
				)
			ELSE rpt_allr.ResponseCode
		END AS ResponseCode,	 
		rpt_allr.QuestionNumber

FROM 	rpt_miss				
		RIGHT JOIN rpt_allr 
			ON rpt_allr.AssociationName = rpt_miss.AssociationName 
				AND rpt_allr.BranchNameShort = rpt_miss.Branch
				AND rpt_allr.Category = rpt_miss.Category
				AND rpt_allr.Question = rpt_miss.Question
				AND rpt_allr.ResponseText = rpt_miss.ResponseText		
)
----SELECT	rpttemp.*
--into	#rpttmp
,rpttmp as
(
SELECT	rpttemp.AssociationName,
		rpttemp.Branch,
		rpttemp.Category,
		rpttemp.Question,
		rpttemp.ResponseText,
		rpttemp.PeerGroup,
		rpttemp.BranchPercentage,
		rpttemp.AssociationPercentage,
		rpttemp.NationalPercentage,
		rpttemp.PeerPercentage,
		rpttemp.PreviousBranchPercentage,
		rpttemp.CategoryPosition,
		rpttemp.ResponseCode,
		rpttemp.QuestionNumber
		
FROM	(
		SELECT	rpt.AssociationName,
				rpt.Branch,
				rpt.Category,
				rpt.Question,
				rpt.ResponseText,
				rpt.PeerGroup,
				SUM(rpt.BranchPercentage) AS BranchPercentage,
				SUM(rpt.AssociationPercentage) AS AssociationPercentage,
				SUM(rpt.NationalPercentage) AS NationalPercentage,
				SUM(rpt.PeerPercentage) AS PeerPercentage,
				SUM(rpt.PreviousBranchPercentage) AS PreviousBranchPercentage,
				rpt.CategoryPosition,
				rpt.ResponseCode,
				rpt.QuestionNumber

		FROM	rpt
		 
		GROUP BY rpt.AssociationName,
				rpt.Branch,
				rpt.Category,
				rpt.Question,
				rpt.ResponseText,
				rpt.PeerGroup,
				rpt.CategoryPosition,
				rpt.ResponseCode,
				rpt.QuestionNumber
		)  rpttemp
--WHERE	rpttemp.AssociationName = 'YMCA of SilicON Valley'
)
,arpt AS (
SELECT	distinct
		AssociationName,
		Question,
		ResponseText,
		AssociationPercentage,
		NationalPercentage

FROM 	rpttmp

WHERE	AssociationName is not null
)
,rptrolled AS (
SELECT	rpt.AssociationName,
		Branch,
		Category,
		rpt.Question,
		rpt.ResponseText,	 
		PeerGroup,
		SUM(BranchPercentage) AS BranchPercentage,
		arpt.AssociationPercentage,
		arpt.NationalPercentage,
		SUM(PeerPercentage) AS PeerPercentage,
		SUM(PreviousBranchPercentage) AS PreviousBranchPercentage,
		CategoryPosition,
		--,QuestionPosition
		ResponseCode,
		QuestionNumber

FROM 	rpttmp rpt
		INNER JOIN	(
					SELECT	AssociationName,
							Question,
							ResponseText,
							SUM(AssociationPercentage) AS AssociationPercentage,
							SUM(NationalPercentage) AS NationalPercentage
							
					FROM	arpt
					
					GROUP BY AssociationName,
							Question,
							ResponseText
					) arpt	
			ON arpt.AssociationName = rpt.AssociationName
			AND arpt.Question = rpt.Question
			AND arpt.ResponseText = rpt.ResponseText
		
WHERE 	isnumeric(ResponseCode)=1
		AND ResponseCode <> -1 
		AND rpt.AssociationName is not null
		
GROUP BY rpt.AssociationName,
		Branch,
		Category,
		rpt.Question,
		rpt.ResponseText,	 
		PeerGroup,
		CategoryPosition,
		--,QuestionPosition
		ResponseCode,
		QuestionNumber,	
		arpt.AssociationPercentage,
		arpt.NationalPercentage

--union WITH the precalculated Net values	
UNION

SELECT	AssociationName,
		Branch,
		'Key Indicators' AS Category,	
		Question,
		'Net' AS ResponseText,	 
		NULL AS PeerGroup,
		100*BranchPercentage AS BranchPercentage,
		100*AssociationPercentage AS AssociationPercentage,
		100*NationalPercentage AS NationalPercentage,
		100*PeerGroupPercentage AS PeerPercentage,
		100*PreviousBranchPercentage AS PreviousBranchPercentage,
		CategoryPosition,
		--,QuestionNumber AS QuestionPosition
		'70' AS ResponseCode,
		QuestionNumber
		
FROM	dd.vwEmpSatBranchKPIs

WHERE 	Category not like 'Retention%'	
		AND @ACategory <> 'YUSA'
)
INSERT INTO dd.factEmpSatDetailSurvey
SELECT	AssociationName AS Association,
		Branch,
		CASE WHEN Category in ('Effectiveness', 'Engagement', 'Satisfaction') THEN 'Staff Experience'		
			WHEN Category in ('Operational Excellence', 'Impact', 'Support') THEN 'Performance Measures'
			ELSE Category
		 END AS CategoryType,
		Category,
		CategoryPosition,
		Question,
		QuestionNumber AS QuestionPosition,
		ResponseText AS Response,
		ResponseCode AS ResponsePosition,
		cast(isnull(round(BranchPercentage, 0), 99999) AS int) AS CrtPercentage,
		cast(isnull(round(PreviousBranchPercentage, 0), 99999) AS int) AS PrevPercentage,
		cast(isnull(round(NationalPercentage, 0), 99999) AS int) AS NationalPercentage,
		cast(isnull(round(AssociationPercentage, 0), 99999) AS int) AS AssociationPercentage,	
		CASE WHEN @ACategory = 'YUSA' THEN 'WellBeing'
			ELSE 'FullReport' 
		 END AS ReportType
		 
FROM 	rptrolled
	
WHERE 	AssociationName is not null
	
END
