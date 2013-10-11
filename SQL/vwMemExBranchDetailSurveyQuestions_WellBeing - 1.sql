USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchDetailSurveyQuestions_WellBeing]    Script Date: 08/04/2013 08:31:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions_WellBeing] WHERE associationname = 'YMCA of Central Stark County' AND Branch LIKE 'North Canton%' AND Question LIKE 'overall, how would you rate%' order by 2,3,4
--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions_WellBeing] WHERE associationname = 'YMCA of Central Stark County' AND Branch LIKE 'Lake Community%' AND Question LIKE 'overall, how would you rate%' order by 2,3,4
--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions_WellBeing] WHERE associationname = 'YMCA of the Brandywine Valley' order by 2,3,4
ALTER VIEW [dd].[vwMemExBranchDetailSurveyQuestions_WellBeing]
AS 
WITH newsq as (			
SELECT	sq.SurveyQuestionKey,	
		Category,
		Question,
		CategoryPosition,
		QuestionPosition,
		QuestionNumber,
		ROW_NUMBER() over (partitiON by sq.SurveyQuestionKey, Question order by CategoryPosition, QuestionPosition) as rn

FROM	dbo.dimSurveyQuestion sq
		INNER JOIN dbo.dimQuestionCategory dc
			ON dc.SurveyQuestionKey = sq.SurveyQuestionKey
		INNER JOIN dbo.dimSurveyForm sf
			ON sq.SurveyFormKey = sf.SurveyFormKey
				AND sf.Description LIKE '%mem%sat%'

WHERE	dc.CategoryType = 'YUSA'	
		AND Category not in ('Survey Responders')
)
,newsqmapped as (
SELECT	distinct
		sq.SurveyQuestionKey,
		newsq.Question,
		newsq.Category,
		--,'' as Category
		newsq.CategoryPosition,
		newsq.QuestionPosition,
		newsq.SurveyQuestionKey as NewSurveyQuestionKey,
		newsq.QuestionNumber

FROM	dbo.dimSurveyQuestion sq
		INNER JOIN newsq
			ON newsq.Question = sq.Question
				AND rn = 1		
)
,allr as (
SELECT	distinct
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
		INNER JOIN dd.factMemExDashboardBase db
			ON msr.BranchKey = db.BranchKey
				AND msr.batch_key = db.batch_key
				AND msr.GivenDateKey = db.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON msr.SurveyQuestionKey = dsq.SurveyQuestionKey
		RIGHT JOIN allr 
			ON dsq.NewSurveyQuestionKey = allr.NewSurveyQuestionKey
			
WHERE	ISNUMERIC(ResponseCode) = 1	
		AND msr.current_indicator = 1
		AND db.current_indicator = 1			
)
,rpt_miss as (
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

FROM	dbo.factBranchMemberSatisfactionReport msr
		INNER JOIN dd.factMemExDashboardBase db
			ON msr.BranchKey = db.BranchKey
				AND msr.batch_key = db.batch_key
				AND msr.GivenDateKey = db.GivenDateKey			
		INNER JOIN newsqmapped dsq
			ON msr.SurveyQuestionKey = dsq.SurveyQuestionKey
		INNER JOIN dimQuestionResponse DR
			ON msr.QuestionResponseKey = DR.QuestionResponseKey	
				--dsq.SurveyQuestionKey = DR.SurveyQuestionKey
				AND isnumeric(DR.ResponseCode) = 1
				AND DR.ResponseCode <> -1
				
WHERE	msr.current_indicator = 1
		AND db.current_indicator = 1
)
,rpt as (
SELECT	distinct
		rpt_allr.AssociationKey,
		rpt_allr.BranchKey,
		rpt_allr.batch_key,
		rpt_allr.current_indicator,
		rpt_allr.AssociationName,
		rpt_allr.BranchNameShort as Branch,
		rpt_allr.Category,
		rpt_allr.Question,
		rpt_allr.ResponseText,	 
		NULL as PeerGroup,
		rpt_miss.BranchPercentage,
		rpt_miss.AssociationPercentage,
		rpt_miss.NationalPercentage,
		rpt_miss.PeerPercentage,
		rpt_miss.PreviousBranchPercentage,
		rpt_allr.CategoryPosition,
		rpt_allr.QuestionPosition,
		rpt_allr.ResponseCode,
		rpt_allr.QuestionNumber

FROM	rpt_miss				
		right join rpt_allr 
			ON rpt_allr.AssociationName = rpt_miss.AssociationName 
				AND rpt_allr.BranchNameShort = rpt_miss.Branch
				AND rpt_allr.batch_key = rpt_miss.batch_key
				AND rpt_allr.Category = rpt_miss.Category
				AND rpt_allr.Question = rpt_miss.Question
				AND rpt_allr.ResponseText = rpt_miss.ResponseText		
)
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
		rpt.BranchPercentage,
		rpt.AssociationPercentage,
		rpt.NationalPercentage,
		rpt.PeerPercentage,
		rpt.PreviousBranchPercentage,
		rpt.CategoryPosition,
		rpt.QuestionPosition,
		rpt.ResponseCode,
		rpt.QuestionNumber,
		ISNULL(cast(cast(case when rpt.BranchPercentage = 0 then NULL else round(rpt.BranchPercentage, 0) end as int) as varchar(10)), 'n/a') as txtBranchPercentage,
		ISNULL(cast(cast(case when rpt.AssociationPercentage = 0 then NULL else round(rpt.AssociationPercentage, 0) end as int) as varchar(10)), 'n/a') as txtAssociationPercentage,
		ISNULL(cast(cast(case when rpt.NationalPercentage = 0 then NULL else round(rpt.NationalPercentage, 0) end as int) as varchar(10)), 'n/a') as txtNationalPercentage,
		ISNULL(cast(cast(case when rpt.PeerPercentage = 0 then NULL else round(rpt.PeerPercentage, 0) end as int) as varchar(10)), 'n/a') as txtPeerPercentage,
		ISNULL(cast(cast(case when rpt.PreviousBranchPercentage = 0 then NULL else round(rpt.PreviousBranchPercentage, 0) end as int) as varchar(10)), 'n/a') as txtPreviousBranchPercentage,
		'WellBeing' as ReportType

FROM	rpt

WHERE	isnumeric(ResponseCode) = 1
		AND ResponseCode <> -1
		AND Question NOT IN ('The Y builds strong relationships WITH its members', 
							 'The Y fosters positive character development')
GO
