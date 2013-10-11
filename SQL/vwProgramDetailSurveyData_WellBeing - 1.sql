USE [Seer_ODS]
GO

/****** Object:  View [dd].[spGetProgramDetailSurveyData_WellBeing]    Script Date: 08/12/2013 07:58:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from dd.vwProgramDetailSurveyData_WellBeing
ALTER VIEW [dd].[vwProgramDetailSurveyData_WellBeing] 
AS
WITH allagrouped AS
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
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,		
		QuestionNumber,
		ResponseCode,
		ResponseText,	
		SUM(ResponseCount) AS ResponseCount,		
		SUM(ProgramGroupPercentage)*100 AS CrtPercentage,		
		SUM(NationalPercentage)*100 AS NationalPercentage,		
		SUM(PreviousProgramGroupPercentage)*100 AS PrevPercentage,
		SUM(AssociationPercentage)*100 AS CrtAssociationPercentage,	
		SUM(PreviousAssociationPercentage)*100 AS PrvAssociationPercentage
		
--INTO	#allagrouped

FROM	(
		SELECT	distinct
				db1.AssociationKey,
				db1.GroupingKey ProgramGroupKey,
				db1.batch_key,
				db1.GivenDateKey,
				sf.SurveyFormKey,
				sq.SurveyQuestionKey,
				qr.QuestionResponseKey,
				--pg.ProgramGroupKey,
				db1.current_indicator,
				db1.AssociationName,
				db1.Program,
				db1.GroupingName AS [Grouping],
				db1.PrevGivenDateKey,
				newsq.Category,
				newsq.Question,
				newsq.CategoryPositiON CategoryPos,
				newsq.QuestionPosition,
				qr.ResponseCode ResponseCd,
				qr.ResponseText ResponseTxt,
				newsq.QuestionNumber,
				db1.ProgramKey,
				db1.GroupingKey,
				isnull(newsq.ShortQuestion, newsq.Question) AS ShortQuestion,
				CASE 	WHEN newsq.Category = 'Key Indicators' AND newsq.Question not like '%like%return%' then
							(
								CASE 
									WHEN qr.ResponseCode in ('09','10') then '9,10'
									WHEN qr.ResponseCode in ('07','08') then '7,8'					
									ELSE '0-6'
								end
							)
					ELSE qr.ResponseText
				END AS ResponseText,
				CASE	WHEN newsq.Category = 'Key Indicators' AND newsq.Question not like '%like%return%' then
							(
								CASE 
									WHEN qr.ResponseCode in ('09','10') then 69
									WHEN qr.ResponseCode in ('07','08') then 67					
									ELSE 60
								end
							)
					ELSE qr.ResponseCode
				END AS ResponseCode,
				CASE 
						WHEN newsq.Category = 'Operational Excellence' then 1
						WHEN newsq.Category = 'Impact' then 2
						WHEN newsq.Category = 'Support' then 3
						WHEN newsq.Category = 'Foundational Elements' then 1
						WHEN newsq.Category = 'Relationship Building' then 2
						ELSE newsq.CategoryPosition
				END AS CategoryPosition,		  
				CASE
						WHEN newsq.Category in ('Foundational Elements', 'Relationship Building') then 'Program Experience'		
						WHEN newsq.Category in ('Operational Excellence', 'Impact', 'Support') then 'Performance Measures'
						ELSE newsq.Category
				END AS CategoryType,
				bmsr.ProgramGroupCount,
				bmsr.ProgramGroupPercentage,
				bmsr.PreviousProgramGroupPercentage,
				bmsr.ProgramGroupCount AS ResponseCount,
				nat.NationalPercentage,
				amsr.AssociationPercentage,
				amsr.PreviousAssociationPercentage,
				RANK() over (partitiON by db1.GroupingKey order by db1.GivenDateKey desc) AS srn
				
		FROM	dbo.dimSurveyQuestion sq
				INNER JOIN dbo.dimSurveyForm sf
					ON sf.SurveyFormKey = sq.SurveyFormKey
				INNER JOIN 	
				(
				SELECT	SurveyFormKey,
						SurveyQuestionKey,	
						Category,	
						Question,
						CategoryPosition,
						QuestionPosition,
						QuestionNumber,
						ShortQuestion,	
						SurveyType,	
						ROW_NUMBER() over (partitiON by SurveyQuestionKey order by SurveyQuestionkey) AS QuestionIndex 

				FROM	dd.vwProgram2012SurveyQuestions
 
				WHERE	CategoryType = 'YUSA'
						AND Category <> 'Dosage and Classification'
						
				) newsq
					ON newsq.Question = sq.Question
						AND newsq.SurveyFormKey = sf.SurveyFormKey
				INNER JOIN dimQuestionResponse qr
					ON qr.SurveyQuestionKey = newsq.SurveyQuestionKey
						AND isnumeric(qr.ResponseCode) = 1
						AND qr.ResponseCode <> '-1'
				INNER JOIN dd.factProgramDashboardBase db1		
					ON sf.SurveyFormKey = db1.SurveyFormKey
				INNER JOIN
				(
				SELECT	amsr1.SurveyFormKey,
						--amsr1.AssociationKey,
						amsr1.SurveyQuestionKey,
						amsr1.QuestionResponseKey,
						amsr1.NationalPercentage,
						amsr1.GivenDateKey
						
				FROM	[dbo].[factAssociationProgramReport] amsr1
				
				GROUP BY amsr1.SurveyFormKey,
						--amsr1.AssociationKey,
						amsr1.SurveyQuestionKey,
						amsr1.QuestionResponseKey,
						amsr1.NationalPercentage,
						amsr1.GivenDateKey
				) nat
					ON sf.SurveyFormKey = nat.SurveyFormKey
						--AND db1.AssociationKey = nat.AssociationKey
						AND sq.SurveyQuestionKey = nat.SurveyQuestionKey
						AND qr.QuestionResponseKey = nat.QuestionResponseKey
						AND db1.GivenDateKey = nat.GivenDateKey
				INNER JOIN [dbo].[factAssociationProgramReport] amsr	  	  	  	  
					ON amsr.SurveyFormKey = sf.SurveyFormKey
						AND amsr.AssociationKey = db1.AssociationKey
						AND amsr.GivenDateKey = db1.GivenDateKey
						AND amsr.SurveyQuestionKey = sq.SurveyQuestionKey
						AND amsr.QuestionResponseKey = qr.QuestionResponseKey
				INNER JOIN [dbo].[factProgramGroupProgramReport] bmsr	 
					ON bmsr.ProgramGroupKey = db1.GroupingKey
						AND bmsr.GivenDateKey = db1.GivenDateKey 
						AND bmsr.SurveyQuestionKey = sq.SurveyQuestionKey
						AND bmsr.QuestionResponseKey = qr.QuestionResponseKey
		) alla_akki
			
GROUP BY AssociationKey,
		ProgramGroupKey,
		batch_key,
		current_indicator,
		AssociationName,
		Program,
		[Grouping],
		GivenDateKey,
		PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,		
		QuestionNumber,
		ResponseCode,
		ResponseText
)
, rpt AS
(
SELECT	AssociationKey,
		ProgramGroupKey,
		batch_key,
		current_indicator,
		Association,
		Program,
		[Grouping],
		GivenDateKey,
		PrevGivenDateKey,
		Category,
		CategoryType,
		CategoryPosition,		
		Question,
		QuestionPosition,	
		ShortQuestion,		
		QuestionNumber,
		ResponseCode,
		ResponseText,	
		CrtPercentage,		
		NationalPercentage,		
		PrevPercentage,
		CrtAssociationPercentage,	
		PrvAssociationPercentage,
		ResponseCount

FROM	allagrouped

)
SELECT	distinct
		rpt.AssociationKey,
		rpt.ProgramGroupKey,
		rpt.batch_key,
		rpt.current_indicator,
		rpt.[Association],
		rpt.Program,
		rpt.[Grouping],
		rpt.[CategoryType],     
		rpt.[Category],    
		rpt.[CategoryPosition],   
		rpt.[Question],
		rpt.QuestionNumber AS [QuestionPosition],       
		rpt.ResponseText AS Response,
		rpt.ResponseCode AS ResponsePosition,
		cast(ROUND(isnull(rpt.[CrtPercentage], 99999), 0) AS int) AS CrtPercentage,
		cast(ROUND(isnull(rpt.[PrevPercentage], 99999), 0) AS int) AS PrevPercentage,
		cast(ROUND(isnull(rpt.[NationalPercentage], 99999), 0) AS int) AS NationalPercentage,                 
		cast(ROUND(isnull(rpt.[CrtAssociationPercentage], 99999), 0) AS int) AS CrtAssociationPercentage,      
		cast(ROUND(isnull(rpt.[PrvAssociationPercentage], 99999), 0) AS int) AS PrevAssociationPercentage,      
		'WellBeing' AS ReportType,	
		rpt.ResponseCount

FROM	rpt

GO


