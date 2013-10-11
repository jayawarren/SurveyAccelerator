USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramKPIs]    Script Date: 09/09/2013 22:19:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--SELECT * FROM dd.vwProgramKPIs where Association = 'YMCA of Greater Miami' and Category = 'Intent to Renew'
ALTER VIEW [dd].[vwProgramKPIs]
AS 
WITH newsq as 
(			
SELECT	SurveyFormKey,
		SurveyQuestionKey,		
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
		db1.SurveyFormKey,
		db1.AssociationKey,		
		amsr.SurveyQuestionKey,
		amsr.QuestionResponseKey,
		db1.current_indicator,
		amsr.batch_key,
		amsr.GivenDateKey,
		sf.SurveyType,
		dqr.ResponseCode,
		dqr.ResponseText,
		amsr.[NationalPercentage],
		amsr.[AssociationPercentage],
		amsr.PreviousAssociationPercentage
		
FROM	[dbo].[factAssociationProgramReport] amsr
		INNER JOIN dbo.dimSurveyForm sf
			on sf.SurveyFormKey = amsr.SurveyFormKey  	  	  
		INNER JOIN dd.factProgramDashboardBase db1
			on db1.AssociationKey = amsr.AssociationKey
				AND db1.batch_key = amsr.batch_key
				AND db1.GivenDateKey = amsr.GivenDateKey
				AND db1.SurveyFormKey = amsr.SurveyFormKey
		INNER JOIN newsq dsq
			on dsq.SurveyQuestionKey = amsr.SurveyQuestionKey
				ANd dsq.SurveyFormKey = amsr.SurveyFormKey
		INNER JOIN dbo.dimQuestionResponse dqr
			on dqr.QuestionResponseKey = amsr.QuestionResponseKey
				AND dqr.SurveyQuestionKey = amsr.SurveyQuestionKey
			
WHERE	isnumeric(dqr.ResponseCode) = 1
		AND CONVERT(int, dqr.ResponseCode) >= 0
		AND CONVERT(int, dqr.ResponseCode) <> 99
		AND amsr.current_indicator = 1
		AND db1.current_indicator = 1
)
--SELECT * FROM allakpi_assoc
,allakpi as 
(
SELECT	db1.SurveyFormKey,
		db1.AssociationKey,
		MIN(bmsr.ProgramGroupKey) ProgramGroupKey,
		db1.current_indicator,
		db1.AssociationName,
		db1.Program,
		db1.GroupingName as [Grouping],
		MAX(db1.batch_key) batch_key,
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
		bmsr.[ProgramGroupCount],
		bmsr.[ProgramGroupPercentage],
		allakpi_assoc.[NationalPercentage],
		bmsr.[PreviousProgramGroupPercentage],
		allakpi_assoc.[AssociationPercentage],
		allakpi_assoc.PreviousAssociationPercentage				

FROM	[dbo].[factProgramGroupProgramReport] bmsr
		INNER JOIN dd.factProgramDashboardBase db1
			on db1.SurveyFormKey = bmsr.OrganizationSurveyKey
				AND db1.batch_key = bmsr.batch_key
				AND db1.GivenDateKey = bmsr.GivenDateKey
				AND db1.GroupingKey = bmsr.ProgramGroupKey	
		INNER JOIN newsq dsq
			on dsq.SurveyQuestionKey = bmsr.SurveyQuestionKey
				AND dsq.SurveyFormKey = db1.SurveyFormKey
		INNER JOIN dbo.dimQuestionResponse dqr
			on dqr.QuestionResponseKey = bmsr.QuestionResponseKey
				AND dqr.SurveyQuestionKey = bmsr.SurveyQuestionKey	  
		INNER JOIN allakpi_assoc
			on allakpi_assoc.SurveyFormKey = db1.SurveyFormKey
				AND allakpi_assoc.AssociationKey = db1.AssociationKey
				AND allakpi_assoc.batch_key = db1.batch_key
				AND allakpi_assoc.GivenDateKey = db1.GivenDateKey
				AND allakpi_assoc.SurveyQuestionKey = bmsr.SurveyQuestionKey
				AND allakpi_assoc.QuestionResponseKey = bmsr.QuestionResponseKey

WHERE 	isnumeric(dqr.ResponseCode) = 1
		AND CONVERT(int, dqr.ResponseCode) >= 0
		AND CONVERT(int, dqr.ResponseCode) <> 99
		AND bmsr.current_indicator = 1
		AND db1.current_indicator = 1
		
GROUP BY db1.SurveyFormKey,
		db1.AssociationKey,
		db1.current_indicator,
		db1.AssociationName,
		db1.Program,
		db1.GroupingName,
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
)
--select * from allakpi
,allkpisgroups as 
(
SELECT	a.SurveyFormKey,
		a.ProgramGroupKey,
		a.AssociationKey,
		a.current_indicator,
		a.AssociationName,
		a.Program,
		a.[Grouping],
		a.batch_key,		
		a.GivenDateKey,
		a.PrevGivenDateKey,
		a.SurveyType,
		a.Question,
		a.QuestionPosition,			
		a.ShortQuestion,	  
		a.QuestionNumber,				
		a.CategoryPosition,			  
		a.Category,		
		a.CategoryType
		
FROM	allakpi a
			
WHERE	a.current_indicator = 1

GROUP BY a.SurveyFormKey,
		a.ProgramGroupKey,
		a.AssociationKey,
		a.current_indicator,
		a.AssociationName,
		a.Program,
		a.[Grouping],
		a.batch_key,		
		a.GivenDateKey,
		a.PrevGivenDateKey,
		a.SurveyType,
		a.Question,
		a.QuestionPosition,			
		a.ShortQuestion,	  
		a.QuestionNumber,				
		a.CategoryPosition,			  
		a.Category,		
		a.CategoryType		
)
--select * from allkpisgroups
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
--select * from promoterbase
,detractorbase as 
(
SELECT	*

FROM	allakpi

WHERE	(
			(Category in ('Net Promoter', 'Real Positive Impact - Individual'))
			 AND isnumeric(ResponseCode) = 1 
			 AND CONVERT(int, ResponseCode) <= 6
			) or
			(
			(Category = 'Intent to Renew')
			 AND isnumeric(ResponseCode) = 1 
			 AND CONVERT(int, ResponseCode) = -1	--this is dummy for intent to renew, we don't want to subtract any detractors
		)
)
--select * from detractorbase
,promoter as
(
SELECT	SurveyFormKey,
		AssociationKey,
		ProgramGroupKey,
		[AssociationName],
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		SUM(ProgramGroupPercentage) as ProgramGroupPercentage,
		SUM(PreviousProgramGroupPercentage) as PreviousProgramGroupPercentage,
		batch_key,
		GivenDateKey,
		Question
					
FROM 	promoterbase

GROUP BY SurveyFormKey,
		AssociationKey,
		ProgramGroupKey,
		AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		Question,
		batch_key,
		GivenDateKey
)
--SELECT * FROM promoter
,detractor as 
(
SELECT	SurveyFormKey,
		AssociationKey,
		ProgramGroupKey,
		AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		SUM(ProgramGroupPercentage) as ProgramGroupPercentage,
		SUM(PreviousProgramGroupPercentage) as PreviousProgramGroupPercentage,
		batch_key,
		GivenDateKey,
		Question			

FROM 	detractorbase
			
GROUP BY SurveyFormKey,
		AssociationKey,
		ProgramGroupKey,
		AssociationName,
		[current_indicator],
		[Program],
		[Grouping],
		SurveyType,
		Question,
		batch_key,
		GivenDateKey
)
--SELECT * FROM detractor
,assoc_promoterbase as 
(
SELECT	distinct 
		SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		[AssociationPercentage],
		[NationalPercentage],
		PreviousAssociationPercentage,
		batch_key,
		GivenDateKey,
		Question,
		ResponseCode			

FROM	promoterbase
)
,assoc_promoter as 
(
SELECT	SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		SUM(AssociationPercentage) as AssociationPercentage,
		SUM(NationalPercentage) as NationalPercentage,
		SUM(PreviousAssociationPercentage) as PreviousAssociationPercentage,
		batch_key,
		GivenDateKey,
		Question

FROM	assoc_promoterbase

GROUP BY SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		Question,
		batch_key,
		GivenDateKey
)
,assoc_detractorbase as
(
SELECT	distinct
		SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		AssociationPercentage,
		NationalPercentage,
		PreviousAssociationPercentage,
		batch_key,
		GivenDateKey,
		Question,
		ResponseCode
					
FROM 	detractorbase
)
,assoc_detractor as
(
SELECT	SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		SUM(AssociationPercentage) as AssociationPercentage,
		SUM(NationalPercentage) as NationalPercentage,
		SUM(PreviousAssociationPercentage) as PreviousAssociationPercentage,
		batch_key,
		GivenDateKey,
		Question
		
FROM 	assoc_detractorbase

GROUP BY SurveyFormKey,
		AssociationKey,
		AssociationName,
		[current_indicator],
		Program,
		SurveyType,
		Question,
		batch_key,
		GivenDateKey
)
SELECT	A.SurveyFormKey,
		A.AssociationKey,
		A.ProgramGroupKey,
		A.current_indicator,
		A.Association,
		A.Program,
		A.[Grouping],
		A.batch_key,
		A.GivenDateKey,
		A.PrevGivenDateKey,
		A.SurveyType,
		A.Question,
		A.QuestionPosition,			
		A.ShortQuestion,	  
		A.QuestionNumber,				
		A.CategoryPosition,			  
		A.Category,		
		A.CategoryType,	
		A.ProgramGroupPercentage,
		COALESCE(B.AssociationPercentage, A.AssociationPercentage) AssociationPercentage,
		COALESCE(B.NationalPercentage, A.NationalPercentage) NationalPercentage,
		A.PreviousProgramGroupPercentage,	
		A.PreviousAssociationPercentage
		
FROM	(
		SELECT	a.SurveyFormKey,
				a.AssociationKey,
				a.ProgramGroupKey,
				a.current_indicator,
				a.AssociationName as Association,
				a.Program,
				a.[Grouping],
				a.batch_key,
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
					ELSE (COALESCE(promoter.ProgramGroupPercentage, 0) - COALESCE(detractor.ProgramGroupPercentage, 0)) 
				 END AS ProgramGroupPercentage,
				CASE WHEN assoc_promoter.AssociationPercentage is null AND assoc_detractor.AssociationPercentage is null then null
					ELSE (COALESCE(assoc_promoter.AssociationPercentage, 0) - COALESCE(assoc_detractor.AssociationPercentage, 0)) 
				 END AS AssociationPercentage,
				CASE WHEN assoc_promoter.NationalPercentage is null AND assoc_detractor.NationalPercentage is null then null
					ELSE (COALESCE(assoc_promoter.NationalPercentage, 0) - COALESCE(assoc_detractor.NationalPercentage, 0))
				 END AS NationalPercentage,
				CASE WHEN promoter.PreviousProgramGroupPercentage is null AND detractor.PreviousProgramGroupPercentage is null then null
					ELSE (COALESCE(promoter.PreviousProgramGroupPercentage, 0) - COALESCE(detractor.PreviousProgramGroupPercentage, 0))
				 END AS PreviousProgramGroupPercentage,	
				CASE WHEN assoc_promoter.PreviousAssociationPercentage is null AND assoc_detractor.PreviousAssociationPercentage is null then null
					ELSE (COALESCE(assoc_promoter.PreviousAssociationPercentage, 0) - COALESCE(assoc_detractor.PreviousAssociationPercentage, 0)) 
				 END AS PreviousAssociationPercentage
			
		FROM	allkpisgroups a 
				LEFT JOIN promoter 
					on promoter.SurveyFormKey = a.SurveyFormKey
						AND promoter.AssociationKey = a.AssociationKey
						AND promoter.ProgramGroupKey = a.ProgramGroupKey
						AND promoter.current_indicator = a.current_indicator
						AND promoter.batch_key = a.batch_key
						AND promoter.GivenDateKey = a.GivenDateKey
						AND promoter.Question = a.Question
				LEFT JOIN detractor 
					on detractor.SurveyFormKey = a.SurveyFormKey
						AND detractor.AssociationKey = a.AssociationKey
						AND detractor.ProgramGroupKey = a.ProgramGroupKey
						AND detractor.current_indicator = a.current_indicator
						AND detractor.batch_key = a.batch_key
						AND detractor.GivenDateKey = a.GivenDateKey
						AND detractor.Question = a.Question
				LEFT JOIN assoc_promoter 
					on assoc_promoter.SurveyFormKey = a.SurveyFormKey
						AND assoc_promoter.AssociationKey = a.AssociationKey
						AND assoc_promoter.current_indicator = a.current_indicator
						AND assoc_promoter.batch_key = a.batch_key
						AND assoc_promoter.GivenDateKey = a.GivenDateKey
						AND assoc_promoter.Question = a.Question
				LEFT JOIN assoc_detractor 
					on assoc_detractor.SurveyFormKey = a.SurveyFormKey
						AND assoc_detractor.AssociationKey = a.AssociationKey
						AND assoc_detractor.current_indicator = a.current_indicator
						AND assoc_detractor.batch_key = a.batch_key
						AND assoc_detractor.GivenDateKey = a.GivenDateKey
						AND assoc_detractor.Question = a.Question
						
		) A
		LEFT JOIN
		(
		SELECT	B.SurveyFormKey,
				B.AssociationKey,
				B.batch_key,
				B.GivenDateKey,
				B.current_indicator,
				B.Category,
				B.AssociationPercentage,
				C.NationalPercentage
			
		FROM	(
				SELECT	C.organization_key AssociationKey,
						D.survey_form_key SurveyFormKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(A.measure_type, 'nps', 'Net Promoter'), 'rpi', 'Real Positive Impact - Individual') Category,
						A.measure_value AssociationPercentage

				FROM	dbo.Top_Box A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_branch_number = B.official_branch_number
						INNER JOIN Seer_MDM.dbo.Organization C
							ON A.official_association_number = C.association_number
								AND A.official_association_number = C.official_branch_number
						INNER JOIN Seer_MDM.dbo.Survey_Form D
							ON A.form_code = D.survey_form_code
						INNER JOIN Seer_MDM.dbo.Batch E
							ON A.form_code = E.form_code

				WHERE	A.calculation = 'base'
						AND A.measure_type IN ('nps', 'rpi')
						AND A.module = 'Program'
						AND A.aggregate_type = 'Association'
						AND B.current_indicator = 1
						AND C.current_indicator = 1
						AND D.current_indicator = 1
				
				GROUP BY C.organization_key,
						D.survey_form_key,
						E.batch_key,
						E.date_given_key,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(A.measure_type, 'nps', 'Net Promoter'), 'rpi', 'Real Positive Impact - Individual'),
						A.measure_value
				) B
				LEFT JOIN
				(
				SELECT	D.survey_form_key SurveyFormKey,
						0 AssociationKey,
						E.batch_key,
						E.date_given_key GivenDateKey,
						A.current_indicator,
						A.module,
						A.form_code,
						REPLACE(REPLACE(A.measure_type, 'nps', 'Net Promoter'), 'rpi', 'Real Positive Impact - Individual') Category,
						A.measure_value NationalPercentage

				FROM	dbo.Top_Box A
						INNER JOIN Seer_MDM.dbo.Survey_Form D
							ON A.form_code = D.survey_form_code
						INNER JOIN Seer_MDM.dbo.Batch E
							ON A.form_code = E.form_code

				WHERE	A.calculation = 'base'
						AND A.measure_type IN ('nps', 'rpi')
						AND A.module = 'Program'
						AND A.aggregate_type = 'National'
						AND D.current_indicator = 1
				) C
				ON B.SurveyFormKey = C.SurveyFormKey
					AND B.batch_key = C.batch_key
					AND B.Category = C.Category
			) B
			ON A.SurveyFormKey = B.SurveyFormKey
				AND A.AssociationKey = B.AssociationKey
				AND A.batch_key = B.batch_key
				AND A.Category = B.Category

GO


