USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramKPIs]    Script Date: 08/11/2013 18:53:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dd.vwProgramKPIs
ALTER VIEW [dd].[vwProgramKPIs]
AS 
WITH newsq as 
(			
SELECT	SurveyQuestionKey,		
		Question,
		QuestionPosition,
		QuestionNumber,
		ShortQuestion,
		SurveyType,
		CASE 
			WHEN Question like '%like%to recommend%' then 1
			WHEN Question like '%real positive impact%in%life%' then 2
			ELSE 3
		END AS CategoryPosition,	  
		CASE 
			WHEN Question like '%like%to recommend%' then 'Net Promoter'
			WHEN Question like '%real positive impact%in%life%' then 'Real Positive Impact - Individual'
			ELSE 'Intent to Renew'
		END AS Category,	
		'Key Indicators' as CategoryType
	
	--row number not needed here because we actually need question in more than one category
FROM 	dd.vwProgram2012SurveyQuestions 

WHERE	CategoryType = 'Dashboard'	
		AND Category = 'Key Indicators'
)
,allakpi_assoc as 
(
SELECT	distinct
		db1.AssociationKey,		
		amsr.SurveyQuestionKey,
		amsr.QuestionResponseKey,
		db1.current_indicator,
		amsr.GivenDateKey,
		sf.SurveyType,
		dqr.ResponseCode,
		dqr.ResponseText,
		[NationalPercentage],
		[AssociationPercentage],
		PreviousAssociationPercentage
		
FROM	[dbo].[factAssociationProgramReport] amsr
		INNER JOIN dbo.dimSurveyForm sf
			on sf.SurveyFormKey = amsr.SurveyFormKey  	  	  
		INNER JOIN dd.factProgramDashboardBase db1
			on db1.AssociationKey = amsr.AssociationKey
				AND db1.GivenDateKey = amsr.GivenDateKey
				AND db1.SurveyType = sf.SurveyType
		INNER JOIN newsq dsq
			on dsq.SurveyQuestionKey = amsr.SurveyQuestionKey
				AND dsq.SurveyType = sf.SurveyType
		INNER JOIN dbo.dimQuestionResponse dqr
			on dqr.QuestionResponseKey = amsr.QuestionResponseKey
				AND dqr.SurveyQuestionKey = amsr.SurveyQuestionKey
			
WHERE	isnumeric(dqr.ResponseCode) = 1
		AND CONVERT(int, dqr.ResponseCode) >= 0
		AND CONVERT(int, dqr.ResponseCode) <> 99
)
--SELECT * FROM allakpi_assoc
,allakpi as 
(
SELECT	distinct
		db1.AssociationKey,
		pg.ProgramGroupKey,
		db1.current_indicator,
		db1.AssociationName,
		db1.Program,
		db1.GroupingName as [Grouping],
		db1.GivenDateKey,
		db1.PrevGivenDateKey,
		db1.SurveyType,
		dsq.QuestionPosition,
		dsq.Question,
		dsq.ShortQuestion,	  
		dsq.QuestionNumber,				
		dsq.CategoryPosition,			  
		dsq.Category,
		dsq.CategoryType,
		dqr.ResponseCode,
		dqr.ResponseText,		
		[ProgramGroupCount],
		[ProgramGroupPercentage],
		allakpi_assoc.[NationalPercentage],
		[PreviousProgramGroupPercentage],
		allakpi_assoc.[AssociationPercentage],
		allakpi_assoc.PreviousAssociationPercentage				

FROM	[dbo].[factProgramGroupProgramReport] bmsr
		INNER JOIN dbo.dimProgramGroup pg
			on pg.ProgramGroupKey = bmsr.ProgramGroupKey	  	  
		INNER JOIN dd.factProgramDashboardBase db1
			on db1.AssociationKey = pg.AssociationKey
				AND db1.GroupingName = pg.ProgramGroup
				AND db1.Program = pg.ProgramCategory
				AND db1.GivenDateKey = bmsr.GivenDateKey			
		INNER JOIN newsq dsq
			on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
				AND dsq.SurveyType = db1.SurveyType
		INNER JOIN dbo.dimQuestionResponse dqr
			on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
				AND dqr.SurveyQuestionKey = bmsr.SurveyQuestionKey	  
		INNER JOIN allakpi_assoc
			on allakpi_assoc.AssociationKey = db1.AssociationKey
				AND allakpi_assoc.GivenDateKey = db1.GivenDateKey
				AND allakpi_assoc.SurveyQuestionKey = bmsr.SurveyQuestionKey
				AND allakpi_assoc.QuestionResponseKey = bmsr.QuestionResponseKey
				AND allakpi_assoc.SurveyType = db1.SurveyType

WHERE 	isnumeric(dqr.ResponseCode) = 1
		AND CONVERT(int, dqr.ResponseCode) >= 0
		AND CONVERT(int, dqr.ResponseCode) <> 99
)
,allkpisgroups as 
(
SELECT	distinct
		db.GroupingKey ProgramGroupKey,
		db.AssociationKey,
		db.current_indicator,
		db.AssociationName,
		db.Program,
		db.GroupingName as [Grouping],		
		db.GivenDateKey,
		db.PrevGivenDateKey,
		db.SurveyType,
		newsq.Question,
		newsq.QuestionPosition,			
		newsq.ShortQuestion,	  
		newsq.QuestionNumber,				
		newsq.CategoryPosition,			  
		newsq.Category,		
		newsq.CategoryType
		
FROM	dd.factProgramDashboardBase db
		full join newsq
			on newsq.SurveyType = db.SurveyType				
)
,promoterbase as 
(
SELECT	*
 
FROM	allakpi

WHERE	(
			(Category in ('Net Promoter', 'Real Positive Impact - Individual'))
			 AND isnumeric(ResponseCode)= 1 
			 AND CONVERT(int, ResponseCode) >= 9
		) or
		(
			(Category = 'Intent to Renew')
			 AND isnumeric(ResponseCode)= 1 
			 AND CONVERT(int, ResponseCode) = 1		
		)		
)
,detractorbase as 
(
SELECT	*

FROM	allakpi

WHERE	(
			(Category in ('Net Promoter', 'Real Positive Impact - Individual'))
			 AND isnumeric(ResponseCode)=1 
			 AND CONVERT(int, ResponseCode) <= 6
			) or
			(
			(Category = 'Intent to Renew')
			 AND isnumeric(ResponseCode)=1 
			 AND CONVERT(int, ResponseCode) = -1	--this is dummy for intent to renew, we don't want to subtract any detractors
		)
)
,promoter as
(
SELECT	[AssociationName],
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		SUM(ProgramGroupPercentage) as ProgramGroupPercentage,
		SUM(PreviousProgramGroupPercentage) as PreviousProgramGroupPercentage,
		GivenDateKey,
		Question
					
FROM 	promoterbase

GROUP BY AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		Question,
		GivenDateKey
)
--SELECT * FROM promoter
,detractor as 
(
SELECT	AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		SUM(ProgramGroupPercentage) as ProgramGroupPercentage,
		SUM(PreviousProgramGroupPercentage) as PreviousProgramGroupPercentage,
		GivenDateKey,
		Question			

FROM 	detractorbase
			
GROUP BY AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		Question,
		GivenDateKey
)
--SELECT * FROM detractor
,assoc_promoterbase as 
(
SELECT	distinct 
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		[AssociationPercentage],
		[NationalPercentage],
		PreviousAssociationPercentage,
		GivenDateKey,
		Question,
		ResponseCode			

FROM	promoterbase
)
,assoc_promoter as 
(
SELECT	AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		SUM(AssociationPercentage) as AssociationPercentage,
		SUM(NationalPercentage) as NationalPercentage,
		SUM(PreviousAssociationPercentage) as PreviousAssociationPercentage,
		GivenDateKey,
		Question

FROM	assoc_promoterbase

GROUP BY AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		Question,
		GivenDateKey
)
,assoc_detractorbase as
(
SELECT	distinct
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		AssociationPercentage,
		NationalPercentage,
		PreviousAssociationPercentage,
		GivenDateKey,
		Question,
		ResponseCode
					
FROM 	detractorbase
)
,assoc_detractor as
(
SELECT	AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		SUM(AssociationPercentage) as AssociationPercentage,
		SUM(NationalPercentage) as NationalPercentage,
		SUM(PreviousAssociationPercentage) as PreviousAssociationPercentage,
		GivenDateKey,
		Question
		
FROM 	assoc_detractorbase

GROUP BY AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		Question,
		GivenDateKey
)
SELECT	a.AssociationKey,
		a.ProgramGroupKey,
		a.current_indicator,
		a.AssociationName as Association,
		a.Program,
		a.[Grouping],
		a.GivenDateKey,
		a.PrevGivenDateKey,
		a.SurveyType,
		a.Question,
		a.QuestionPosition,			
		a.ShortQuestion,	  
		a.QuestionNumber,				
		a.CategoryPosition,			  
		a.Category,		
		a.CategoryType,	
		CASE WHEN promoter.ProgramGroupPercentage is null AND detractor.ProgramGroupPercentage is null then null
			ELSE (isnull(promoter.ProgramGroupPercentage, 0) - isnull(detractor.ProgramGroupPercentage, 0)) 
		 END AS ProgramGroupPercentage,
		CASE WHEN assoc_promoter.AssociationPercentage is null AND assoc_detractor.AssociationPercentage is null then null
			ELSE (isnull(assoc_promoter.AssociationPercentage, 0) - isnull(assoc_detractor.AssociationPercentage, 0)) 
		 END AS AssociationPercentage,
		CASE WHEN assoc_promoter.NationalPercentage is null AND assoc_detractor.NationalPercentage is null then null
			ELSE (isnull(assoc_promoter.NationalPercentage, 0) - isnull(assoc_detractor.NationalPercentage, 0))
		 END AS NationalPercentage,
		CASE WHEN promoter.PreviousProgramGroupPercentage is null AND detractor.PreviousProgramGroupPercentage is null then null
			ELSE (isnull(promoter.PreviousProgramGroupPercentage, 0) - isnull(detractor.PreviousProgramGroupPercentage, 0))
		 END AS PreviousProgramGroupPercentage,	
		CASE WHEN assoc_promoter.PreviousAssociationPercentage is null AND assoc_detractor.PreviousAssociationPercentage is null then null
			ELSE (isnull(assoc_promoter.PreviousAssociationPercentage, 0) - isnull(assoc_detractor.PreviousAssociationPercentage, 0)) 
		 END AS PreviousAssociationPercentage
	
FROM	allkpisgroups a 
		LEFT JOIN promoter 
			on promoter.AssociationName = a.AssociationName
				AND promoter.current_indicator = a.current_indicator
				AND promoter.Program = a.Program
				AND promoter.[Grouping] = a.[Grouping]
				AND promoter.SurveyType = a.SurveyType
				AND promoter.GivenDateKey = a.GivenDateKey
				AND promoter.Question = a.Question
		LEFT JOIN detractor 
			on detractor.AssociationName = a.AssociationName
				AND promoter.current_indicator = a.current_indicator
				AND detractor.Program = a.Program
				AND detractor.[Grouping] = a.[Grouping]
				AND detractor.SurveyType = a.SurveyType
				AND detractor.GivenDateKey = a.GivenDateKey
				AND detractor.Question = a.Question
		LEFT JOIN assoc_promoter 
			on assoc_promoter.AssociationName = a.AssociationName
				AND promoter.current_indicator = a.current_indicator
				AND assoc_promoter.Program = a.Program
				AND assoc_promoter.SurveyType = a.SurveyType
				AND assoc_promoter.GivenDateKey = a.GivenDateKey
				AND assoc_promoter.Question = a.Question
		LEFT JOIN assoc_detractor 
			on assoc_detractor.AssociationName = a.AssociationName
				AND promoter.current_indicator = a.current_indicator
				AND assoc_detractor.Program = a.Program
				AND assoc_detractor.SurveyType = a.SurveyType
				AND assoc_detractor.GivenDateKey = a.GivenDateKey
				AND assoc_detractor.Question = a.Question
				
WHERE	REPLACE(REPLACE(a.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '') = a.Program
GO


