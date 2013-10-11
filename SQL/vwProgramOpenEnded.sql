USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramOpenEnded]    Script Date: 08/12/2013 12:49:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM [dd].[vwProgramOpenEnded] 
ALTER VIEW [dd].[vwProgramOpenEnded]
AS 
WITH alla AS (
SELECT	distinct
		db.AssociationKey,
		db.GroupingKey ProgramGroupKey,
		msr.GivenDateKey,
		db.batch_key,
		db.current_indicator,
		db.AssociationName,
		db.Program,
		db.GroupingName AS [Grouping],
		sq.Question,		
		qr.Category,				
        qr.ResponseText AS Subcategory,
		qr.ResponseCode,	
		oer.OpenEndResponse,		
		msr.ResponseCount,		
		CASE WHEN Question like '%you could%change%' then 'Change one thing'
			WHEN Question like '%you believe%real positive impact%life%' then 'RPI Individual - Promoter'
			WHEN Question like '%you%less%positive impact%life%' then 'RPI Individual - Detractor'
			ELSE 'Other'
		END AS OpenEndedGroup		 	 		 

FROM	dbo.factMemberSurveyResponse msr
		INNER JOIN dbo.dimProgramSiteLocation sl
			on sl.ProgramSiteLocationKey = msr.ProgramSiteLocationKey
				AND msr.OpenEndResponseKey <> -1
		INNER JOIN dd.factProgramDashboardBase db
			on sl.ProgramGroupKey = db.GroupingKey
				AND msr.GivenDateKey = db.GivenDateKey				
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
		ProgramGroupKey,
		GivenDateKey,
		batch_key,
		current_indicator,
		AssociationName,
		Program,
		[Grouping],
		Question,
		OpenEndedGroup,
		SUM(ResponseCount) AS CategoryResponseCount
		
FROM	alla

GROUP BY AssociationKey,
		ProgramGroupKey,
		batch_key,
		current_indicator,
		AssociationName,
		Program,
		[Grouping],
		Question,
		OpenEndedGroup,
		GivenDateKey
	)
SELECT	distinct
		alla.AssociationKey,
		alla.ProgramGroupKey,
		alla.batch_key,
		alla.current_indicator,
		alla.AssociationName AS Association,
		alla.Program,
		alla.[Grouping],		
		alla.OpenEndedGroup,
		alla.Category,				
		alla.Subcategory,	
		OpenEndResponse AS Response,	
		CASE WHEN allt.CategoryResponseCount <> 0 THEN 100.00 * alla.ResponseCount / allt.CategoryResponseCount
			ELSE 0
		END AS CategoryPercentage
	
FROM 	alla
		INNER JOIN allt
			ON alla.AssociationKey = allt.AssociationKey
				AND alla.ProgramGroupKey = allt.ProgramGroupKey
				AND alla.batch_key = allt.batch_key
				AND alla.GivenDateKey = allt.GivenDateKey 
				AND alla.[Program] = allt.[Program]
				AND alla.[Grouping] = allt.[Grouping] 
				AND alla.OpenEndedGroup = allt.OpenEndedGroup
				AND alla.current_indicator = allt.current_indicator





GO


