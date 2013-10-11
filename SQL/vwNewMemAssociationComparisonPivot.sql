USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMemAssociationComparisonPivot]    Script Date: 08/13/2013 20:09:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
--select * from dd.vwNewMemAssociationComparisonPivot
-- =============================================
-- Author:		joshua erhardt
-- Create date: 20120509
-- Description:	<Description,,>
-- =============================================
CREATE VIEW [dd].[vwNewMemAssociationComparisonPivot]	
AS
WITH mp AS 
(SELECT	[AssociationKey],
		[BranchKey],
		[batch_key],
		[current_indicator],
		[AssociationNumber],
		[AssociationName],
		[Association],
		[OfficialBranchNumber],
		[OfficialBranchName],
		[Branch],
		[Q010101],
		[Q010201],
		[Q010204],
		[Q010205],
		[Q010301],
		[Q010302],
		[Q010303],
		[Q010401],
		[Q020501],
		[Q020502],
		[Q020503],
		[Q020504],
		[Q020505],
		[Q020506],
		[Q020507],
		[Q020508],
		[Q020601],
		[Q020602],
		[Q020603],
		[Q020604],
		[Q020605],
		[Q020902],
		[Q020903],
		[Q020904],
		[Q020905],
		[Q031101],
		[Q031102]

FROM	(
				
		SELECT	db.AssociationKey,
				db.BranchKey,
				db.batch_key,
				db.current_indicator,
				db.AssociationNumber,				
				db.AssociationName + ' - ' + db.AssociationNumber AS Association,
				db.AssociationName,
				db.OfficialBranchNumber,
				db.OfficialBranchName,
				db.BranchNameShort AS Branch, 
				allq.QuestionCode,
				CASE WHEN BranchPercentage is null or BranchPercentage = 0 THEN '0na1'
					ELSE
						(
						CASE WHEN PreviousPercentage is null THEN '0na1'
							ELSE isnull(dd.[GetDimensionColorAndDirection](CurrentPercentage-PreviousPercentage, BranchPercentage-PreviousPercentage, -3, 3, 3), '0na1')
						END 
						)
				END AS Shape					
		
		FROM	dd.factNewMemDashboardBase db
				INNER JOIN 
				(
					SELECT	distinct
							QuestionCode,
							Question,
							AssociationName,
							GivenSurveyDate,
							current_indicator
							
					FROM [dd].[factNewMemBranchExperienceReport] es
				) allq
					ON allq.AssociationName = db.AssociationName
						AND allq.GivenSurveyDate = db.GivenDateKey
				LEFT JOIN [dd].[factNewMemBranchExperienceReport] es
					ON es.AssociationName = db.AssociationName
						AND es.Branch = db.BranchNameShort
						AND allq.Question = es.Question
						AND es.GivenSurveyDate = db.GivenDateKey
				)  p
			pivot
			(
				MAX(Shape)			
				for QuestionCode in
				(
				  [Q010101],
				  [Q010201],
				  [Q010204],
				  [Q010205],
				  [Q010301],
				  [Q010302],
				  [Q010303],
				  [Q010401],
				  [Q020501],
				  [Q020502],
				  [Q020503],
				  [Q020504],
				  [Q020505],
				  [Q020506],
				  [Q020507],
				  [Q020508],
				  [Q020601],
				  [Q020602],
				  [Q020603],
				  [Q020604],
				  [Q020605],
				  [Q020902],
				  [Q020903],
				  [Q020904],
				  [Q020905],
				  [Q031101],
				  [Q031102]		
				 )
			) AS pvt			
	)
	
	SELECT	*
	FROM	mp

GO


