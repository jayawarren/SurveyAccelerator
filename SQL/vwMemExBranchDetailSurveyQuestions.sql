USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchDetailSurveyQuestions]    Script Date: 08/04/2013 08:22:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions] WHERE associationname = 'YMCA of Central Stark County' /*and Question like 'overall, how would you rate%'*/ order by 2,3,4
--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions] WHERE associationname = 'YMCA of Central Stark County' and Branch like 'Lake Community%' and Question like 'overall, how would you rate%' order by 2,3,4
--SELECT * FROM [dd].[vwMemExBranchDetailSurveyQuestions] WHERE associationname like '%seattle%' order by 2,3,4
ALTER VIEW [dd].[vwMemExBranchDetailSurveyQuestions] 
AS 
WITH newsq AS (			
SELECT	dc.SurveyQuestionKey,	
		dc.Category,
		dc.Question,
		dc.QuestionNumber,	
		dc.CategoryPosition,
		dc.QuestionPosition,	
		ROW_NUMBER() over (partition by dc.SurveyQuestionKey, dc.Question order by dc.CategoryPosition, dc.QuestionPosition) AS rn

FROM	dd.vwMemEx2012SurveyQuestions dc

WHERE	--dc.CategoryType = 'Dashboard' and 
		Category NOT IN ('Survey Responders')
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
		INNER JOIN dd.factMemExDashboardBase db
			on db.BranchKey = msr.BranchKey
				and db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			on dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		right join allr 
			on dsq.NewSurveyQuestionKey = allr.NewSurveyQuestionKey 

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
		INNER JOIN dd.factMemExDashboardBase db
			on db.BranchKey = msr.BranchKey and db.GivenDateKey = msr.GivenDateKey			
		INNER JOIN newsqmapped dsq
			on dsq.SurveyQuestionKey = msr.SurveyQuestionKey
		INNER JOIN dimQuestionResponse DR
			ON MSR.QuestionResponseKey = DR.QuestionResponseKey	
				--dsq.SurveyQuestionKey = DR.SurveyQuestionKey
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
		CASE 
			WHEN 
				(
					rpt_allr.Question like '%would you recommend%friends%' or 
					rpt_allr.Question like '%extent%making a real positive impact in your life%' or
					rpt_allr.Question like '%extent%making a real positive impact in your%community%'
				) then
				(
					CASE 
						WHEN rpt_allr.ResponseCode in ('09','10') then '9,10'
						WHEN rpt_allr.ResponseCode in ('07','08') then '7,8'					
						else '0-6'
					end
				)
			else rpt_allr.ResponseText
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
		CASE 
			WHEN 
				(
					rpt_allr.Question like '%would you recommend%friends%' or 
					rpt_allr.Question like '%extent%making a real positive impact in your life%' or
					rpt_allr.Question like '%extent%making a real positive impact in your%community%'
				) then
				(
					CASE 
						WHEN rpt_allr.ResponseCode in ('09','10') then '69'
						WHEN rpt_allr.ResponseCode in ('07','08') then '67'					
						else '60'
					end
				)
			else rpt_allr.ResponseCode
		END AS ResponseCode	, 
		rpt_allr.QuestionNumber

FROM	rpt_miss				
		right join rpt_allr 
			on rpt_allr.AssociationName = rpt_miss.AssociationName 
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
		SUM(rpt.AssociationPercentage) AS AssociationPercentage,
		SUM(rpt.NationalPercentage) AS NationalPercentage,
		SUM(rpt.PeerPercentage) AS PeerPercentage,
		SUM(rpt.PreviousBranchPercentage) AS PreviousBranchPercentage,
		rpt.CategoryPosition,
		rpt.QuestionPosition,
		rpt.ResponseCode,
		rpt.QuestionNumber
		
FROM	rpt

WHERE	isnumeric(ResponseCode)=1
		and ResponseCode <> -1

group by rpt.AssociationKey,
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
		rpt.QuestionNumber
	
union

SELECT	AssociationKey,
		BranchKey,
		0 batch_key,
		1 current_indicator,
		AssociationName,
		Branch,
		'Key Indicators' AS Category,	
		CASE 
			WHEN Category = 'Net Outcome - Community' then 'To what extent do you believe the Y is making a real positive impact in your neighborhood and community?'
			WHEN Category = 'Net Outcome - Individual' then 'To what extent do you believe the Y is making a real positive impact in your life?'
			WHEN Category = 'Net Promoter' then 'If asked, would you recommend the YMCA to your friends?'
		END AS Question,
		'Net' AS ResponseText,	 
		NULL AS PeerGroup,
		100*BranchPercentage AS BranchPercentage,
		100*AssociationPercentage AS AssociationPercentage,
		100*NationalPercentage AS NationalPercentage,
		100*PeerGroupPercentage AS PeerPercentage,
		100*PreviousBranchPercentage AS PreviousBranchPercentage,
		CategoryPosition,
		CASE 
			WHEN Category = 'Net Outcome - Community' then 6
			WHEN Category = 'Net Outcome - Individual' then 7
			WHEN Category = 'Net Promoter' then 9
		END AS QuestionPosition,
		'70' AS ResponseCode,
		CASE 
			WHEN Category = 'Net Outcome - Community' then 32
			WHEN Category = 'Net Outcome - Individual' then 35
			WHEN Category = 'Net Promoter' then 46
		 END AS QuestionNumber

FROM	dd.vwMemExBranchKPIs

WHERE	Category like 'Net%'	
)
SELECT	rptrolled.AssociationKey,
		rptrolled.BranchKey,
		rptrolled.batch_key,
		rptrolled.current_indicator,
		rptrolled.AssociationName,
		rptrolled.Branch,
		rptrolled.Category,
		rptrolled.Question,
		rptrolled.ResponseText,	 
		rptrolled.PeerGroup,
		rptrolled.BranchPercentage,
		rptrolled.AssociationPercentage,
		rptrolled.NationalPercentage,
		rptrolled.PeerPercentage,
		rptrolled.PreviousBranchPercentage,
		rptrolled.CategoryPosition,
		rptrolled.QuestionPosition,
		rptrolled.ResponseCode,
		rptrolled.QuestionNumber,	
		ISNULL(cast(cast(CASE WHEN rptrolled.BranchPercentage = 0 then NULL else round(rptrolled.BranchPercentage, 0) END AS int) AS varchar(10)), 'n/a') AS txtBranchPercentage,
		ISNULL(cast(cast(CASE WHEN rptrolled.AssociationPercentage = 0 then NULL else round(rptrolled.AssociationPercentage, 0) END AS int) AS varchar(10)), 'n/a') AS txtAssociationPercentage,
		ISNULL(cast(cast(CASE WHEN rptrolled.NationalPercentage = 0 then NULL else round(rptrolled.NationalPercentage, 0) END AS int) AS varchar(10)), 'n/a') AS txtNationalPercentage,
		ISNULL(cast(cast(CASE WHEN rptrolled.PeerPercentage = 0 then NULL else round(rptrolled.PeerPercentage, 0) END AS int) AS varchar(10)), 'n/a') AS txtPeerPercentage,
		ISNULL(cast(cast(CASE WHEN rptrolled.PreviousBranchPercentage = 0 then NULL else round(rptrolled.PreviousBranchPercentage, 0) END AS int) AS varchar(10)), 'n/a') AS txtPreviousBranchPercentage,
		'FullReport' AS ReportType	

FROM	rptrolled

GO


