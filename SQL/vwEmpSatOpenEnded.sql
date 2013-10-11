USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatOpenEnded]    Script Date: 08/10/2013 16:42:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwEmpSatOpenEnded] WHERE Association like '%seattle%' and Branch = 'Auburn Valley' and CategoryType = 'net promoter employment - promoter'
ALTER VIEW [dd].[vwEmpSatOpenEnded]
AS 
WITH alla AS (
SELECT	distinct
		db.AssociationKey,
		db.BranchKey,
		db.batch_key,
		db.GivenDateKey,	
		db.current_indicator,
		db.AssociationName,
		db.BranchNameShort AS Branch,
		sq.Question,	
		qr.Category,	
		qr.ResponseText AS Subcategory,
		qr.ResponseCode,	
		oer.OpenEndResponse,	
		msr.ResponseCount,		
		CASE WHEN Question like '%you could%change%' THEN 'Change one thing'
			WHEN Question like '%so likely to recommEND%membership%' THEN 'Net Promoter Membership - Promoter'
			WHEN Question like '%you believe%real positive impact%life%' THEN 'RPI Individual - Promoter'
			WHEN Question like '%you believe%real positive impact%community%' THEN 'RPI Community - Promoter'
			WHEN Question like '%so likely to recommEND%work%' THEN 'Net Promoter Employment - Promoter'
			WHEN Question like '%less%to recommEND%membership%' THEN 'Net Promoter Membership - Detractor'
			WHEN Question like '%you%less%positive impact%life%' THEN 'RPI Individual - Detractor'
			WHEN Question like '%you%less%positive impact%community%' THEN 'RPI Community - Detractor'
			WHEN Question like '%less%to recommEND%work%' THEN 'Net Promoter Employment - Detractor'				
			ELSE 'Other'
		END AS OpenEndedGroup		 		 		 

FROM	dbo.factMemberSurveyResponse msr
		INNER JOIN dd.factEmpSatDashboardBase db
			ON msr.BranchKey = db.BranchKey
				and db.GivenDateKey = msr.GivenDateKey
				and msr.OpenEndResponseKey <> -1
		INNER JOIN dimSurveyQuestion sq
			ON msr.SurveyQuestionKey = sq.SurveyQuestionKey
				AND msr.OrganizationSurveyKey = sq.SurveyFormKey
		INNER JOIN dimQuestionResponse qr
			ON msr.QuestionResponseKey = qr.QuestionResponseKey
				AND sq.SurveyQuestionKey = qr.SurveyQuestionKey
				AND qr.ResponseCode <> '-1'
		INNER JOIN dimOpenEndResponse oer
			ON msr.OpenEndResponseKey = oer.OpenEndResponseKey		

WHERE	OpenEndResponse <> ''	
)
,allt AS (
SELECT	AssociationKey,
		BranchKey,
		GivenDateKey,
		current_indicator,
		AssociationName,
		Branch,
		Question,
		OpenEndedGroup,
		SUM(ResponseCount) AS CategoryResponseCount
		
FROM	alla

GROUP BY AssociationKey,
		BranchKey,
		GivenDateKey,
		current_indicator,
		AssociationName,
		Branch,
		Question,
		OpenEndedGroup
)
SELECT	distinct
		alla.AssociationKey,
		alla.BranchKey,
		alla.batch_key,
		--alla.GivenDateKey,
		alla.current_indicator,
		alla.AssociationName AS Association,
		alla.Branch,
		alla.OpenEndedGroup AS CategoryType,
		alla.Category,
		NULL AS CategoryTypePosition,
		NULL AS CategoryPosition,	
		OpenEndResponse AS Response,
		alla.Subcategory,
		--ResponseCount,
		--ResponseCode,
		CASE WHEN allt.CategoryResponseCount <> 0 THEN 100.00 * alla.ResponseCount / allt.CategoryResponseCount
			ELSE 0
		END AS CategoryPercentage

FROM	alla
		INNER JOIN allt
			ON alla.AssociationKey = allt.AssociationKey
				AND alla.BranchKey = allt.BranchKey
				AND alla.GivenDateKey = allt.GivenDateKey 
				AND alla.current_indicator = allt.current_indicator
				AND alla.OpenEndedGroup = allt.OpenEndedGroup
GO


