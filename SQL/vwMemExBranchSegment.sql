USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchSegment]    Script Date: 08/04/2013 07:04:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemExBranchSegment] where Question like 'data source%'
--select * from [dd].[vwMemExBranchSegment] where associationname like '%cinci%' and category = 'Survey Responders' order by 5
CREATE VIEW [dd].[vwMemExBranchSegment]
AS
SELECT	AssociationNumber, 
		bs.AssociationName, 
		Association,
		OfficialBranchNumber, 
		OfficialBranchName, 
		bs.SurveyYear, 
		bs.GivenDateKey, 
		SUM(bs.BranchCount) AS BranchCount, 
		bs.Segment, 
		bs.Question, 
		bs.QuestionLabel, 	
		CategoryType,
		bs.Category, 
		bs.CategoryPosition, 
		QuestionPosition,
		bs.ResponseCode, 
		bs.ResponseText,	
		SUM(bs.BranchPercentage) AS BranchPercentage,
		CASE WHEN SUM(bs.PreviousBranchPercentage) is null then 99999
			ELSE SUM(bs.PreviousBranchPercentage)
		END AS PrevBranchPercentage

FROM	(
		SELECT	distinct
				'0' AS AssociationNumber, 
				DB.BranchKey,
				DB.AssociationName, 
				DB.BranchNameShort AS OfficialBranchName, 
				'' AS Association,
				'0' AS OfficialBranchNumber, 				
				LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
				MSR.GivenDateKey, 
				DQ.Question, 
				'' AS QuestionLabel, 
				DC.Category,         
				'Reporting' AS CategoryType,
				DC.CategoryPosition, 
				CASE 
					WHEN Question like 'data source%' then 0
					ELSE QuestionPosition
				END AS QuestionPosition,
				--DR.ResponseCode, 
				--DR.ResponseText,
				CASE WHEN ResponseText like '%Adult%' then '61' 
					WHEN ResponseText like '%Family%' then '62'
					WHEN ResponseText like '%Senior%' then '63'
					ELSE ResponseCode
				END AS ResponseCode,		
				CASE
					WHEN ResponseText like '%Adult%' then 'Adult' 
					WHEN ResponseText like '%Family%' then 'Family' 
					WHEN ResponseText like '%Senior%' then 'Senior' 
					ELSE ResponseText
				END AS ResponseText,
				MSR.Segment, 
				MSR.BranchCount,
				MSR.BranchPercentage,
				MSR.PreviousBranchPercentage

		FROM	dbo.factBranchMemberSatisfactionReport AS MSR 
				--INNER JOIN dbo.dimBranch AS DB 
				INNER JOIN dd.factMemExDashboardBase db
					ON MSR.BranchKey = DB.BranchKey
						AND msr.GivenDateKey = db.GivenDateKey
				INNER JOIN dbo.dimSurveyQuestion AS DQ 
					ON MSR.SurveyQuestionKey = DQ.SurveyQuestionKey 
				INNER JOIN dbo.dimQuestionCategory AS DC 
					ON DQ.SurveyQuestionKey = DC.SurveyQuestionKey 
						--AND CategoryType = 'Dashboard'
						--AND CategoryType = 'Reporting'
						AND Category = 'Survey Responders'
				INNER JOIN dbo.dimQuestionResponse AS DR 
					ON MSR.QuestionResponseKey = DR.QuestionResponseKey 
						AND DR.ResponseCode <> '-1'
		
		) bs
		
GROUP BY AssociationNumber, 
		bs.AssociationName, 
		Association,
		OfficialBranchNumber, 
		OfficialBranchName, 
		bs.SurveyYear, 
		bs.GivenDateKey, 	
		bs.Segment, 
		bs.Question, 
		bs.QuestionLabel, 	
		CategoryType,
		bs.Category, 
		bs.CategoryPosition, 
		QuestionPosition,
		bs.ResponseCode, 
		bs.ResponseText	










GO


