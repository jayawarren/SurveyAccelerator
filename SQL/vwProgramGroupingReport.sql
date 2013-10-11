USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramGroupingReport]    Script Date: 08/10/2013 21:57:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mike Druta
-- Create date: 20120424
-- Description:	<Description,,>
-- =============================================

--SELECT * FROM [dd].[vwProgramGroupingReport] WHERE Association = 'YMCA of Greater GrAND Rapids' AND Category = 'Operational Excellence' order by 6,3
ALTER VIEW [dd].[vwProgramGroupingReport]
AS
WITH newsq AS 
(			
SELECT	SurveyQuestionKey,
		SurveyFormKey,	
		Category,
		Question,
		CategoryPosition,
		QuestionPosition,
		QuestionNumber,
		ShortQuestion,
		SurveyType,
		--row number not needed here because we actually need question in more than one category
		Rank() over (partition by SurveyType order by SurveyQuestionkey, Category) AS QuestionIndex --this will be used to generate a unique question code

FROM 	dd.vwProgram2012SurveyQuestions

WHERE 	CategoryType = 'Dashboard'		
		AND (
				Category in ('Key Indicators', 'Foundational Elements', 'Relationship Building', 'Impact', 'Operational Excellence', 'Support')
			)	
)
,newsqmapped AS 
(
SELECT	distinct
		sq.SurveyQuestionKey,
		sf.SurveyFormKey,
		sf.SurveyType,
		newsq.Question,	
		newsq.Category,
		--,'' AS Category,
		newsq.CategoryPosition,
		newsq.QuestionPosition,
		newsq.SurveyQuestionKey AS NewSurveyQuestionKey,
		newsq.QuestionNumber,
		isnull(newsq.ShortQuestion, newsq.Question) AS ShortQuestion

FROM	dbo.dimSurveyQuestion sq
		INNER JOIN dbo.dimSurveyForm sf
			ON sf.SurveyFormKey = sq.SurveyFormKey
		INNER JOIN newsq
			ON newsq.Question = sq.Question
				AND newsq.SurveyFormKey = sf.SurveyFormKey

WHERE	newsq.Category <> 'Key Indicators'
)
,allr AS 
(
SELECT	newsqmapped.SurveyFormKey,
		newsqmapped.SurveyType,
		newsqmapped.NewSurveyQuestionKey,
		qr.ResponseText,
		qr.ResponseCode,
		qr.QuestionResponseKey

FROM	newsqmapped
		INNER JOIN dimQuestionResponse qr
			ON newsqmapped.NewSurveyQuestionKey = qr.SurveyQuestionKey
				AND isnumeric(ResponseCode) = 1
				AND ResponseCode <> '-1'
				
GROUP BY newsqmapped.SurveyFormKey,
		newsqmapped.SurveyType,
		newsqmapped.NewSurveyQuestionKey,
		qr.ResponseText,
		qr.ResponseCode,
		qr.QuestionResponseKey
)
--select * from allr
,rpt_allr as
(
SELECT	distinct
		pg.AssociationKey,
		pg.program_group_key ProgramGroupKey,
		pg.batch_key,
		pg.current_indicator,
		pg.AssociationName,
		pg.Program,
		pg.GroupingName AS [Grouping],
		pg.survey_form_key SurveyFormKey,
		pg.GivenDateKey,
		pg.PrevGivenDateKey,
		dsq.Category,
		dsq.Question,
		dsq.CategoryPosition,
		--,dsq.QuestionPosition,
		allr.SurveyType,
		allr.ResponseCode,
		allr.ResponseText,
		allr.QuestionResponseKey,
		dsq.QuestionNumber,
		dsq.SurveyQuestionKey AS SurveyQuestionKey,
		pg.ProgramKey,
		pg.GroupingKey,
		dsq.QuestionPosition,
		dsq.ShortQuestion

FROM	allr
		LEFT JOIN newsqmapped dsq
			ON allr.SurveyFormKey = dsq.SurveyFormKey
				AND allr.NewSurveyQuestionKey = dsq.NewSurveyQuestionKey
		/*LEFT JOIN dd.factProgramDashboardBase db1 
			ON allr.SurveyFormKey = db1.SurveyFormKey
		LEFT JOIN Seer_MDM.dbo.Member_Program_Group_Map pg
			ON allr.SurveyFormKey = pg.survey_form_key
				AND db1.AssociationKey = pg.organization_key
				AND db1.GroupingKey = pg.program_group_key
				AND	db1.Program = pg.program_category
		*/
		LEFT JOIN
		(
		SELECT	A.survey_form_key,
				A.program_group_key,
				B.batch_key,
				A.current_indicator,
				B.AssociationKey,
				B.AssociationName,
				B.Program,
				B.GroupingName,
				B.GivenDateKey,
				B.PrevGivenDateKey,
				B.ProgramKey,
				B.GroupingKey
				
		FROM	Seer_MDM.dbo.Member_Program_Group_Map A
				INNER JOIN dd.factProgramDashboardBase B
					ON A.survey_form_key = B.SurveyFormKey
						AND A.organization_key = B.AssociationKey
						AND A.program_group_key = B.GroupingKey
						AND A.program_category = B.Program
						
		GROUP BY A.survey_form_key,
				A.program_group_key,
				B.batch_key,
				A.current_indicator,
				B.AssociationKey,
				B.AssociationName,
				B.Program,
				B.GroupingName,
				B.GivenDateKey,
				B.PrevGivenDateKey,
				B.ProgramKey,
				B.GroupingKey
		) pg
			ON allr.SurveyFormKey = pg.survey_form_key
			
WHERE	ISNUMERIC(allr.ResponseCode)= 1
		AND allr.ResponseCode = '01'
		AND pg.program_group_key IS NOT NULL
)
--SELECT * FROM rpt_allr
,allakki_assoc AS (
	SELECT	ra.AssociationKey,
			ra.SurveyFormKey,		
			ra.SurveyQuestionKey,
			ra.QuestionResponseKey,
			ra.GivenDateKey,
			ra.SurveyType,
			max([NationalPercentage]) AS NationalPercentage,
			max([AssociationPercentage]) AS AssociationPercentage,
			max(PreviousAssociationPercentage) AS PreviousAssociationPercentage
			
	FROM	rpt_allr ra
			LEFT JOIN [dbo].[factAssociationProgramReport] amsr	  	  	  
				on ra.AssociationKey = amsr.AssociationKey
					AND ra.GivenDateKey = amsr.GivenDateKey 
					AND ra.SurveyQuestionKey = amsr.SurveyQuestionKey
					AND ra.QuestionResponseKey = amsr.QuestionResponseKey
					AND ra.SurveyFormKey = amsr.SurveyFormKey
				
	GROUP BY ra.SurveyFormKey,		
			ra.SurveyQuestionKey,
			ra.QuestionResponseKey,
			ra.GivenDateKey,
			ra.SurveyType,
			ra.AssociationKey			
)
,allakki AS 
(
	SELECT	distinct
			ra.AssociationKey,
			ra.ProgramGroupKey,
			ra.batch_key,
			ra.current_indicator,
			ra.AssociationName,
			ra.Program,
			ra.[Grouping],
			ra.GivenDateKey,
			ra.PrevGivenDateKey,
			ra.SurveyType,
			ra.QuestionPosition,
			ra.Question,	
			ra.ShortQuestion,	  
			QuestionNumber,
			CASE WHEN ra.Category = 'Operational Excellence' then 1
				WHEN ra.Category = 'Impact' then 2
				WHEN ra.Category = 'Support' then 3
				WHEN ra.Category = 'Foundational Elements' then 1
				WHEN ra.Category = 'Relationship Building' then 2
				ELSE CategoryPosition
			END AS CategoryPosition,			  
			ra.Category,
			CASE WHEN ra.Category in ('Foundational Elements', 'Relationship Building') then 'Program Experience'		
				WHEN ra.Category in ('Operational Excellence', 'Impact', 'Support') then 'Performance Measures'
				ELSE ra.Category
			END AS CategoryType,
			ra.ResponseText,		
			[ProgramGroupCount],
			[ProgramGroupPercentage],
			allakki_assoc.[NationalPercentage],
			[PreviousProgramGroupPercentage],
			allakki_assoc.[AssociationPercentage],
			allakki_assoc.PreviousAssociationPercentage,		
			ResponseCode, --check MemEx code if more than one response needs to be captured
			RANK() over (partition by ra.SurveyType, ra.GroupingKey order by ra.GivenDateKey desc) AS srn	
  
  FROM		rpt_allr ra
			LEFT JOIN [dbo].[factProgramGroupProgramReport] bmsr	 
				on bmsr.ProgramGroupKey = ra.ProgramGroupKey
					AND bmsr.GivenDateKey = ra.GivenDateKey 
					AND bmsr.SurveyQuestionKey = ra.SurveyQuestionKey
					AND bmsr.QuestionResponseKey = ra.QuestionResponseKey
					AND bmsr.ProgramGroupKey = ra.ProgramGroupKey
			LEFT JOIN allakki_assoc
				on allakki_assoc.AssociationKey = ra.AssociationKey
					AND allakki_assoc.GivenDateKey = ra.GivenDateKey 
					AND allakki_assoc.SurveyQuestionKey = ra.SurveyQuestionKey
					AND allakki_assoc.QuestionResponseKey = ra.QuestionResponseKey
					AND allakki_assoc.SurveyFormKey = ra.SurveyFormKey
)
,allagrouped as
(
	SELECT	AssociationKey,
			ProgramGroupKey,
			batch_key,
			current_indicator,
			AssociationName AS Association,
			Program,
			[Grouping],
			GivenDateKey,
			PrevGivenDateKey,
			SurveyType,
			Category,
			CategoryType,
			CategoryPosition,		
			Question,
			QuestionPosition,	
			ShortQuestion,		
			QuestionNumber,
			SUM(ProgramGroupPercentage*100) AS CrtPercentage,		
			SUM(NationalPercentage*100) AS NationalPercentage,		
			SUM(PreviousProgramGroupPercentage*100) AS PrevPercentage,
			SUM(AssociationPercentage*100) AS CrtAssociationPercentage,	
			SUM(PreviousAssociationPercentage*100) AS PrvAssociationPercentage	
	
	FROM  	allakki
	
	WHERE	srn=1
	
	GROUP BY AssociationKey,
			ProgramGroupKey,
			batch_key,
			current_indicator,
			AssociationName,
			Program,
			[Grouping],
			GivenDateKey,
			PrevGivenDateKey,
			SurveyType,
			Category,
			CategoryType,
			CategoryPosition,		
			Question,
			QuestionPosition,	
			ShortQuestion,
			QuestionNumber,
			ResponseCode
)
--select * from allagrouped
,rpt AS (
	SELECT	*
	
	FROM 	allagrouped
	
	--add the KPIs
	UNION
	
	SELECT	distinct
			AssociationKey,
			ProgramGroupKey,
			0 batch_key,
			current_indicator,
			Association,
			Program,
			[Grouping],
			GivenDateKey,
			PrevGivenDateKey,
			SurveyType,
			Category,
			CategoryType,
			CategoryPosition,		
			Question,		
			QuestionPosition,
			ShortQuestion,
			QuestionNumber,
			round(100.00*ProgramGroupPercentage, 0) AS ProgramGroupPercentage,
			round(100.00*NationalPercentage, 0) AS NationalPercentage,
			round(100.00*PreviousProgramGroupPercentage, 0) AS PreviousProgramGroupPercentage,
			round(100.00*AssociationPercentage, 0) AS CrtAssociationPercentage,
			round(100.00*PreviousAssociationPercentage, 0) AS PrvAssociationPercentage
	
	FROM	dd.vwProgramKPIs vkpi
)
--select * from rpt
SELECT	rpt.AssociationKey,
		rpt.ProgramGroupKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.[Association],
		rpt.Program,
		rpt.[Grouping],
		rpt.[CategoryType],
		rpt.[Category],      
		rpt.[Question],
		rpt.[CategoryPosition],            
		rpt.QuestionNumber AS [QuestionPosition], 
		rpt.ShortQuestion,
		'Q' + (
		CASE WHEN nq.QuestionIndex < 10 THEN '0' + CAST(nq.QuestionIndex AS varchar)
			ELSE CAST(nq.QuestionIndex AS varchar)
		END) AS QuestionCode,	 
		cast(ROUND(rpt.[CrtAssociationPercentage], 0) AS int) AS AssociationValue,
		cast(ROUND(rpt.[PrvAssociationPercentage], 0) AS int) AS PrvAssociationValue,
		--Begin Code
		--Jay Warren October 18, 2012
		--Hard coded Day Camp National Percentages for NPS AND RPI due to system calculation defect
		CASE WHEN rpt.QuestionNumber = 1 AND rpt.Program = 'Day Camp' THEN 53
			  WHEN rpt.QuestionNumber = 40 AND rpt.Program = 'Day Camp' THEN 19
			  ELSE cast(ROUND(rpt.[NationalPercentage], 0) AS int)
		--End Code
		END AS NationalValue,     
		cast(ROUND(rpt.[CrtPercentage], 0) AS int) AS CrtGroupingValue,                  
		cast(ROUND(rpt.[PrevPercentage], 0) AS int) AS PrvGroupingValue
                  
FROM 	rpt
		INNER JOIN 
		(
		SELECT	SurveyType,
				Category,
				Question,		
				QuestionPosition,
				ShortQuestion,
				QuestionNumber,
				QuestionIndex
				
		FROM	newsq
		
		GROUP BY SurveyType,
				Category,
				Question,		
				QuestionPosition,
				ShortQuestion,
				QuestionNumber,
				QuestionIndex
		) nq
		on nq.SurveyType = rpt.SurveyType
			AND nq.Question = rpt.Question
			AND nq.QuestionPosition = rpt.QuestionPosition
			AND nq.ShortQuestion = rpt.ShortQuestion
			AND nq.QuestionNumber = rpt.QuestionNumber

WHERE	(nq.Category = rpt.Category
		or rpt.CategoryType = 'Key Indicators')
		AND rpt.Association IS NOT NULL

GROUP BY rpt.AssociationKey,
		rpt.ProgramGroupKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.[Association],
		Program,
		[Grouping],
		[CategoryType],
		rpt.[Category],      
		rpt.[Question],
		rpt.[CategoryPosition],            
		rpt.QuestionNumber,
		rpt.ShortQuestion,
		nq.QuestionIndex,
		cast(ROUND(rpt.[CrtAssociationPercentage], 0) AS int),
		cast(ROUND(rpt.[PrvAssociationPercentage], 0) AS int),
		cast(ROUND(rpt.[NationalPercentage], 0) AS int),
		cast(ROUND(rpt.[CrtPercentage], 0) AS int),         
		cast(ROUND(rpt.[PrevPercentage], 0) AS int)
GO

