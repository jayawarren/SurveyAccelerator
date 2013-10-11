USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramGroupingComparisonPivot]    Script Date: 08/12/2013 07:29:09 ******/
SET ANSI_NULLS ON
GO
--select * from [dd].[vwProgramGroupingComparisonPivot]
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 20120501
-- SELECT * FROM [dd].[vwProgramGroupingComparisonPivot]	
-- =============================================
ALTER VIEW [dd].[vwProgramGroupingComparisonPivot]	
AS
WITH mp as 
(
SELECT 	AssociationKey,
		ProgramGroupKey,
		batch_key,
		current_indicator,
		Association,
		Program,
		[Grouping],
		[Q01],
		[Q02],
		[Q03],
		[Q04],
		[Q05],
		[Q06],
		[Q07],
		[Q08],
		[Q09],
		[Q10],
		[Q11],
		[Q12],
		[Q13],
		[Q14],
		[Q15],
		[Q16],
		[Q17],
		[Q18],
		[Q19],
		[Q20],
		[Q21],
		[Q22],
		[Q23],
		[Q24],
		[Q25],
		[Q26],
		[Q27],
		[Q28],
		[Q29],
		[Q30],
		[Q31],
		[Q32],
		[Q33],
		[Q34],
		[Q35],
		[Q36],
		[Q37],
		[Q38],
		[Q39],
		[Q40],
		[Q41],
		[Q42],
		[Q43],
		[Q44],
		[Q45],
		[Q46],
		[Q47],
		[Q48],
		[Q49],
		[Q50],
		[Q51],
		[Q52],
		[Q53],
		[Q54],
		[Q55],
		[Q56],
		[Q57],
		[Q58],
		[Q59],
		[Q60],
		[Q61],
		[Q62],
		[Q63],
		[Q64],
		[Q65],
		[Q66],
		[Q67],
		[Q68],
		[Q69],
		[Q70],
		[Q71],
		[Q72],
		[Q73],
		[Q74],
		[Q75],
		[Q76],
		[Q77],
		[Q78],
		[Q79],
		[Q80],
		[Q81],
		[Q82],
		[Q83],
		[Q84],
		[Q85],
		[Q86],
		[Q87],
		[Q88],
		[Q89],
		[Q90],
		[Q91],
		[Q92],
		[Q93],
		[Q94],
		[Q95],
		[Q96],
		[Q97],
		[Q98],
		[Q99]

FROM	(
		SELECT	db.AssociationKey,
				db.GroupingKey ProgramGroupKey,
				db.batch_key,
				db.current_indicator,
				db.AssociationName as Association,
				db.Program,
				db.GroupingName as [Grouping],
				allq.QuestionCode,
				CASE WHEN (CrtGroupingValue is null or CrtGroupingValue = 0) then '0na1'
					ELSE							
						(
							CASE WHEN NationalValue is null and PrvGroupingValue is null then '0na1'
								ELSE isnull(dd.[GetDimensionColorAndDirection](CrtGroupingValue-NationalValue, CrtGroupingValue-PrvGroupingValue, -3, 3, 3), '0na1')
							END 
						)													
				END as Shape
								
		FROM	dd.factProgramDashboardBase db
				INNER JOIN 
				(
				SELECT	distinct
						QuestionCode,
						Question,
						Association
						
				FROM [dd].[factProgramGroupingReport] es
				) allq
					on allq.Association = db.AssociationName
				INNER JOIN [dd].[factProgramGroupingReport] es
					on es.Association = db.AssociationName 
						and es.Program = db.Program 
						and es.[Grouping] = db.GroupingName 							
						and allq.Question = es.Question
				) p
			pivot
				(
				MAX(Shape)			
				for QuestionCode in
				(
				[Q01],
				[Q02],
				[Q03],
				[Q04],
				[Q05],
				[Q06],
				[Q07],
				[Q08],
				[Q09],
				[Q10],
				[Q11],
				[Q12],
				[Q13],
				[Q14],
				[Q15],
				[Q16],
				[Q17],
				[Q18],
				[Q19],
				[Q20],
				[Q21],
				[Q22],
				[Q23],
				[Q24],
				[Q25],
				[Q26],
				[Q27],
				[Q28],
				[Q29],
				[Q30],
				[Q31],
				[Q32],
				[Q33],
				[Q34],
				[Q35],
				[Q36],
				[Q37],
				[Q38],
				[Q39],
				[Q40],
				[Q41],
				[Q42],
				[Q43],
				[Q44],
				[Q45],
				[Q46],
				[Q47],
				[Q48],
				[Q49],
				[Q50],
				[Q51],
				[Q52],
				[Q53],
				[Q54],
				[Q55],
				[Q56],
				[Q57],
				[Q58],
				[Q59],
				[Q60],
				[Q61],
				[Q62],
				[Q63],
				[Q64],
				[Q65],
				[Q66],
				[Q67],
				[Q68],
				[Q69],
				[Q70],
				[Q71],
				[Q72],
				[Q73],
				[Q74],
				[Q75],
				[Q76],
				[Q77],
				[Q78],
				[Q79],
				[Q80],
				[Q81],
				[Q82],
				[Q83],
				[Q84],
				[Q85],
				[Q86],
				[Q87],
				[Q88],
				[Q89],
				[Q90],
				[Q91],
				[Q92],
				[Q93],
				[Q94],
				[Q95],
				[Q96],
				[Q97],
				[Q98],
				[Q99]
				)
			) AS pvt			
		)
	
SELECT	* 

FROM	mp		









GO


