USE [Seer_ODS]
GO
--select * from [dd].[vwMemExBranchComparisonPivot]
/****** Object:  View [dd].[vwMemExBranchComparisonPivot]    Script Date: 08/04/2013 17:53:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 20120301
-- Description:	<Description,,>
-- =============================================
ALTER VIEW [dd].[vwMemExBranchComparisonPivot]	
AS
WITH mp AS 
(
SELECT	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		Association,
		Branch,
		[Q010101],
		[Q010202],
		[Q010303],
		[Q010404],
		[Q010505],
		[Q010606],
		[Q020101],
		[Q020202],
		[Q020303],
		[Q020404],
		[Q020505],
		[Q020606],
		[Q020707],
		[Q020808],
		[Q030101],
		[Q030102],
		[Q030103],
		[Q030104],
		[Q030105],
		[Q030106],
		[Q030107],
		[Q030108],
		[Q030109],
		[Q030201],
		[Q030202],
		[Q030203],
		[Q030204],
		[Q030205],
		[Q030206],
		[Q030207],
		[Q030208],
		[Q030209],
		[Q030301],
		[Q030302],
		[Q030303],
		[Q030304],
		[Q030305],
		[Q030306],
		[Q030307],
		[Q030308],
		[Q030309]
		
FROM	(
		SELECT	db.AssociationKey,
				db.BranchKey,
				db.batch_key,
				db.current_indicator,
				db.AssociationName AS Association,
				db.BranchNameShort AS Branch,
				allq.QuestionCode,
				CASE WHEN CrtBranchPercentage is null or CrtBranchPercentage = 0 THEN '0na1'
					ELSE
						(CASE WHEN Category = 'Pyramid Dimensions' THEN isnull(dd.[GetDimensionColorAndDirection](CrtBranchPercentage, CrtBranchPercentage-isnull(PrevBranchPercentage, CrtBranchPercentage), -3, 3, 5), '0na1') 
							ELSE
								(
									CASE WHEN NationalPercentage is null and PrevBranchPercentage is null THEN '0na1'
										ELSE isnull(dd.[GetDimensionColorAndDirection](CrtBranchPercentage-NationalPercentage, CrtBranchPercentage-PrevBranchPercentage, -3, 3, 3), '0na1')
									END 
								)
						END
						)
				END AS Shape					
		
		FROM	dd.factMemExDashboardBase db
				INNER JOIN 
				(
				SELECT	distinct
						QuestionCode,
						Question,
						AssociationName
				FROM [dd].[factMemExBranchReportEx] es
				) allq
					ON allq.AssociationName = db.AssociationName
				LEFT JOIN [dd].[factMemExBranchReportEx] es
					ON es.AssociationName = db.AssociationName
						AND es.Branch = db.BranchNameShort
						AND allq.Question = es.Question
		) p
	pivot
	(
		MAX(Shape)			
		FOR QuestionCode in
		(
		[Q010101],
		[Q010202],
		[Q010303],
		[Q010404],
		[Q010505],
		[Q010606],
		[Q020101],
		[Q020202],
		[Q020303],
		[Q020404],
		[Q020505],
		[Q020606],
		[Q020707],
		[Q020808],
		[Q030101],
		[Q030102],
		[Q030103],
		[Q030104],
		[Q030105],
		[Q030106],
		[Q030107],
		[Q030108],
		[Q030109],
		[Q030201],
		[Q030202],
		[Q030203],
		[Q030204],
		[Q030205],
		[Q030206],
		[Q030207],
		[Q030208],
		[Q030209],
		[Q030301],
		[Q030302],
		[Q030303],
		[Q030304],
		[Q030305],
		[Q030306],
		[Q030307],
		[Q030308],
		[Q030309])
	) AS pvt			
)
	
	SELECT	*
	FROM	mp		
GO


