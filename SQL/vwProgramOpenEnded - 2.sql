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
		db.batch_key,
		msr.GivenDateKey,
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
		B.CategoryResponseCount,		
		CASE WHEN sq.Question like '%you could%change%' then 'Change one thing'
			WHEN sq.Question like '%you believe%real positive impact%life%' then 'RPI Individual - Promoter'
			WHEN sq.Question like '%you%less%positive impact%life%' then 'RPI Individual - Detractor'
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
		INNER JOIN
		(
		SELECT	A.AssociationKey,
				A.ProgramGroupKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator,
				A.AssociationName,
				A.Program,
				A.[Grouping],
				A.Question,
				A.OpenEndedGroup,
				SUM(A.ResponseCount) AS CategoryResponseCount
				
		FROM	(
				SELECT	distinct
						db.GroupingKey ProgramGroupKey,
						db.AssociationKey,
						db.batch_key,
						msr.GivenDateKey,
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
							on msr.ProgramSiteLocationKey = sl.ProgramSiteLocationKey
								AND msr.OpenEndResponseKey <> -1
						INNER JOIN dd.factProgramDashboardBase db
							on sl.ProgramGroupKey = db.GroupingKey
								AND msr.batch_key = db.batch_key		
								AND msr.GivenDateKey = db.GivenDateKey		
						INNER JOIN dimSurveyQuestion sq
							ON msr.SurveyQuestionKey = sq.SurveyQuestionKey
								AND msr.OrganizationSurveyKey = sq.SurveyFormKey
						INNER JOIN dimQuestionResponse qr
							ON msr.QuestionResponseKey = qr.QuestionResponseKey
								AND msr.SurveyQuestionKey = qr.SurveyQuestionKey
								AND qr.ResponseCode <> '-1'
						INNER JOIN dimOpenEndResponse oer
							ON msr.OpenEndResponseKey = oer.OpenEndResponseKey		

				WHERE	oer.OpenEndResponse <> ''
						AND msr.current_indicator = 1
				) A
		GROUP BY A.ProgramGroupKey,
				A.AssociationKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator,
				A.AssociationName,
				A.Program,
				A.[Grouping],
				A.Question,
				A.OpenEndedGroup
		) B
			ON db.GroupingKey = B.ProgramGroupKey
				AND db.AssociationKey = B.AssociationKey
				AND db.batch_key = B.batch_key
				AND msr.GivenDateKey = B.GivenDateKey 
				AND db.[Program] = B.[Program]
				AND db.[GroupingName] = B.[Grouping] 
				AND sq.Question = B.Question
				AND CASE WHEN sq.Question like '%you could%change%' then 'Change one thing'
						WHEN sq.Question like '%you believe%real positive impact%life%' then 'RPI Individual - Promoter'
						WHEN sq.Question like '%you%less%positive impact%life%' then 'RPI Individual - Detractor'
						ELSE 'Other'
					END = B.OpenEndedGroup
				AND msr.current_indicator = B.current_indicator

WHERE	oer.OpenEndResponse <> ''
		AND msr.current_indicator = 1	
)
SELECT	alla.AssociationKey,
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
		CASE WHEN alla.CategoryResponseCount <> 0 THEN 100.00 * CONVERT(DECIMAL(19, 6), alla.ResponseCount)/alla.CategoryResponseCount
			ELSE CONVERT(DECIMAL(19, 6), 0)
		END AS CategoryPercentage
	
FROM 	alla

GO


