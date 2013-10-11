USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatBranchDetailSurveyQuestions]    Script Date: 08/04/2013 08:22:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwEmpSatBranchDetailSurveyQuestions] WHERE associationname = 'YMCA of Central Stark County' /*and Question like 'overall, how would you rate%'*/ order by 2,3,4
--SELECT * FROM [dd].[vwEmpSatBranchDetailSurveyQuestions] WHERE associationname = 'YMCA of Central Stark County' and Branch like 'Lake Community%' and Question like 'overall, how would you rate%' order by 2,3,4
--SELECT * FROM [dd].[vwEmpSatBranchDetailSurveyQuestions] WHERE associationname like '%seattle%' order by 2,3,4
ALTER VIEW [dd].[vwEmpSatBranchDetailSurveyQuestions] 
AS 
WITH newsq AS (			
SELECT	dc.SurveyQuestionKey,	
		dc.Category,
		dc.Question,
		dc.QuestionNumber,	
		dc.CategoryPosition,
		dc.QuestionPosition,	
		ROW_NUMBER() over (partitiON by dc.SurveyQuestionKey, dc.Question order by dc.CategoryPosition, dc.QuestionPosition) AS rn

FROM	dd.vwEmpSat2012SurveyQuestions dc

WHERE	--dc.CategoryType = 'Dashboard' and 
		dc.Category NOT IN ('Survey Responders')
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
		newsq.QuestionNumber

FROM	dbo.dimSurveyQuestion sq
		INNER JOIN newsq
			ON newsq.Question = sq.Question
				AND rn=1
)
,allr AS (
SELECT distinct
		newsqmapped.NewSurveyQuestionKey,
		qr.ResponseText,
		qr.ResponseCode,
		qr.QuestionResponseKey
		
FROM	newsqmapped
		INNER JOIN dimQuestionResponse qr
			ON qr.SurveyQuestionKey = newsqmapped.NewSurveyQuestionKey
				AND isnumeric(ResponseCode) = 1
				AND ResponseCode <> -1
)
,rpt_allr as
(
SELECT	distinct
		db.AssociationKey,
		db.BranchKey,
		db.batch_key,
		db.current_indicator,
		db.AssociationName,
		db.BranchNameShort,
		dsq.Category,
		dsq.Question,
		dsq.CategoryPosition,
		dsq.QuestionPosition,
		allr.ResponseCode,
		allr.ResponseText,
		allr.QuestionResponseKey,
		dsq.QuestionNumber

FROM	dbo.factBranchMemberSatisfactionReport msr
		INNER JOIN dd.factEmpSatDashboardBase db
			ON db.BranchKey = msr.BranchKey
				and db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		RIGHT JOIN allr 
			ON dsq.NewSurveyQuestionKey = allr.NewSurveyQuestionKey 

WHERE	ISNUMERIC(ResponseCode) = 1				
)
,rpt_miss AS (
SELECT	distinct
		db.AssociationKey,
		db.BranchKey,
		db.batch_key,
		db.current_indicator,
		AssociationName,
		db.BranchNameShort AS Branch,
		dsq.Category,
		dsq.Question,
		DR.ResponseText, 
		NULL AS PeerGroup,
		100*MSR.BranchPercentage AS BranchPercentage,
		100*MSR.AssociationPercentage AS AssociationPercentage,
		100*MSR.NationalPercentage AS NationalPercentage,
		100*MSR.PeerGroupPercentage AS PeerPercentage,
		100*MSR.PreviousBranchPercentage AS PreviousBranchPercentage,
		dsq.CategoryPosition,
		dsq.QuestionPosition,
		dr.ResponseCode,
		msr.QuestionResponseKey	

FROM 	dbo.factBranchMemberSatisfactionReport msr
		INNER JOIN dd.factEmpSatDashboardBase db
			ON db.BranchKey = msr.BranchKey and db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		INNER JOIN dimQuestionResponse DR
			ON MSR.QuestionResponseKey = DR.QuestionResponseKey	
				AND dsq.SurveyQuestionKey = DR.SurveyQuestionKey
				AND isnumeric(DR.ResponseCode) = 1
				AND DR.ResponseCode <> -1
)
,rpt AS (
SELECT	distinct
		rpt_allr.AssociationKey,
		rpt_allr.BranchKey,
		rpt_allr.batch_key,
		rpt_allr.current_indicator,
		rpt_allr.AssociationName,
		rpt_allr.BranchNameShort AS Branch,
		rpt_allr.Category,
		rpt_allr.Question,
		--,rpt_allr.ResponseText	 
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
		rpt_allr.QuestionPosition,
		--,rpt_allr.ResponseCode
		CASE WHEN rpt_allr.Category = 'Key Indicators' AND rpt_allr.Question not like '%still be employed%' THEN
				(
					CASE 
						WHEN rpt_allr.ResponseCode in ('09','10') THEN '69'
						WHEN rpt_allr.ResponseCode in ('07','08') THEN '67'					
						ELSE '60'
					END
				)
			ELSE rpt_allr.ResponseCode
		END AS ResponseCode,
		rpt_allr.QuestionNumber

FROM	rpt_miss				
		RIGHT JOIN rpt_allr 
			ON rpt_allr.AssociationName = rpt_miss.AssociationName 
				and rpt_allr.BranchNameShort = rpt_miss.Branch
				and rpt_allr.Category = rpt_miss.Category
				and rpt_allr.Question = rpt_miss.Question
				and rpt_allr.ResponseText = rpt_miss.ResponseText		
)
,rptrolled AS (
SELECT	rpt.AssociationKey,
		rpt.BranchKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.AssociationName,
		rpt.Branch,
		rpt.Category,
		rpt.Question,
		rpt.ResponseText,	 
		rpt.PeerGroup,
		SUM(rpt.BranchPercentage) AS BranchPercentage,
		arpt.AssociationPercentage,
		arpt.NationalPercentage,
		SUM(rpt.PeerPercentage) AS PeerPercentage,
		SUM(rpt.PreviousBranchPercentage) AS PreviousBranchPercentage,
		rpt.CategoryPosition,
		rpt.QuestionPosition,
		rpt.ResponseCode,
		rpt.QuestionNumber
		
FROM	rpt
		INNER JOIN
		(
		SELECT	AssociationName,
				Question,
				ResponseText,
				current_indicator,
				SUM(AssociationPercentage) AS AssociationPercentage,
				SUM(NationalPercentage) AS NationalPercentage
				
		FROM	rpt
		
		GROUP BY AssociationName,
				Question,
				ResponseText
					
		) arpt	
			ON rpt.AssociationName = arpt.AssociationName
				AND rpt.Question = arpt.Question
				AND rpt.ResponseText = arpt.ResponseText
				AND rpt.current_indicator = arpt.current_indicator

WHERE	isnumeric(rpt.ResponseCode) = 1
		and rpt.ResponseCode <> '-1'

GROUP BY rpt.AssociationKey,
		rpt.BranchKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.AssociationName,
		rpt.Branch,
		rpt.Category,
		rpt.Question,
		rpt.ResponseText,	 
		rpt.PeerGroup,
		rpt.CategoryPosition,
		rpt.QuestionPosition,
		rpt.ResponseCode,
		rpt.QuestionNumber,
		arpt.AssociationPercentage,
		arpt.NationalPercentage
		
	
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

WHERE 	Category NOT LIKE 'Retention%'	
)
SELECT	rptrolled.AssociationKey,
		rptrolled.BranchKey,
		rptrolled.batch_key,
		rptrolled.current_indicator,
		rptrolled.AssociationName,
		rptrolled.Branch,
		CASE WHEN rptrolled.Category in ('Effectiveness', 'Engagement', 'Satisfaction') THEN 'Staff Experience'		
			WHEN rptrolled.Category in ('Operational Excellence', 'Impact', 'Support') THEN 'Performance Measures'
			ELSE rptrolled.Category
		 END AS CategoryType,
		rptrolled.Category,
		rptrolled.CategoryPosition,
		rptrolled.Question,
		rptrolled.QuestionNumber AS QuestionPosition,	
		rptrolled.ResponseText AS Response,	 
		rptrolled.ResponseCode AS ResponsePosition,
		cast(isnull(round(rptrolled.BranchPercentage, 0), 99999) AS int) AS CrtPercentage,
		cast(isnull(round(rptrolled.PreviousBranchPercentage, 0), 99999) AS int) AS PrevPercentage,
		cast(isnull(round(rptrolled.NationalPercentage, 0), 99999) AS int) AS NationalPercentage,
		cast(isnull(round(rptrolled.AssociationPercentage, 0), 99999) AS int) AS AssociationPercentage,	
		'FullReport' AS ReportType	

FROM	rptrolled

GO


