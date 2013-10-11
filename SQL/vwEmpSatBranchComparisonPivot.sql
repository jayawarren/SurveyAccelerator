USE [Seer_ODS]
GO
--select * from dd.vwEmpSatBranchComparisonPivot
/****** Object:  View [dd].[vwEmpSatBranchComparisonPivot]    Script Date: 08/10/2013 13:11:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 20120301
-- Description:	<Description,,>
-- =============================================
CREATE VIEW [dd].[vwEmpSatBranchComparisonPivot]	
AS
with mp as (
select 	AssociationKey,
		BranchKey,
		batch_key,
		current_indicator,
		Association,
		Branch,
		[Q010101],
		[Q010102],
		[Q010103],
		[Q010104],
		[Q010105],
		[Q010201],
		[Q010202],
		[Q010203],
		[Q010204],
		[Q010205],
		[Q010206],
		[Q010207],
		[Q010208],
		[Q010301],
		[Q010302],
		[Q010303],
		[Q010304],
		[Q010305],
		[Q010306],
		[Q010307],
		[Q010308],
		[Q010309],
		[Q010401],
		[Q010402],
		[Q010403],
		[Q010404],
		[Q010405],
		[Q010406],
		[Q010407],
		[Q010408],
		[Q010409],
		[Q020101],
		[Q020201],
		[Q020202],
		[Q020203],
		[Q020204],
		[Q020205],
		[Q020301],
		[Q020401],
		[Q030101],
		[Q030102],
		[Q030103],
		[Q030104],
		[Q030105],
		[Q030106],
		[Q030107],
		[Q030108],
		[Q030201],
		[Q030202],
		[Q030203],
		[Q030204],
		[Q030205],
		[Q030206],
		[Q030207],
		[Q030208],
		[Q030301],
		[Q030302],
		[Q030303],
		[Q030304],
		[Q030305],
		[Q030306],
		[Q030307],
		[Q030308],
		[Q030309]

from	(
		SELECT	db.AssociationKey,
				db.BranchKey,
				db.batch_key,
				db.current_indicator,
				db.AssociationName as Association,
				db.BranchNameShort as Branch,
				allq.QuestionCode,
				CASE WHEN CrtBranchValue is null or CrtBranchValue = 0 THEN '0na1'
					ELSE							
						(
							CASE WHEN NationalValue is null and PrvBranchValue is null THEN '0na1'
								ELSE isnull(dd.[GetDimensionColorAndDirection](CrtBranchValue-NationalValue, CrtBranchValue-PrvBranchValue, -3, 3, 3), '0na1')
							END 
						)													
				END as Shape					
		
		FROM	dd.factEmpSatDashboardBase db
				INNER JOIN
				(
				SELECT	distinct
						QuestionCode,
						Question,
						Association
						
				FROM	[dd].[factEmpSatBranchReport] es
				) allq
					ON allq.AssociatiON = db.AssociationName
				left join [dd].[factEmpSatBranchReport] es
					ON es.AssociatiON = db.AssociationName
						and es.Branch = db.BranchNameShort
						and allq.Question = es.Question
		) p
		pivot
		(
			MAX(Shape)			
			for QuestionCode in
			(
			[Q010101],
			[Q010102],
			[Q010103],
			[Q010104],
			[Q010105],
			[Q010201],
			[Q010202],
			[Q010203],
			[Q010204],
			[Q010205],
			[Q010206],
			[Q010207],
			[Q010208],
			[Q010301],
			[Q010302],
			[Q010303],
			[Q010304],
			[Q010305],
			[Q010306],
			[Q010307],
			[Q010308],
			[Q010309],
			[Q010401],
			[Q010402],
			[Q010403],
			[Q010404],
			[Q010405],
			[Q010406],
			[Q010407],
			[Q010408],
			[Q010409],
			[Q020101],
			[Q020201],
			[Q020202],
			[Q020203],
			[Q020204],
			[Q020205],
			[Q020301],
			[Q020401],
			[Q030101],
			[Q030102],
			[Q030103],
			[Q030104],
			[Q030105],
			[Q030106],
			[Q030107],
			[Q030108],
			[Q030201],
			[Q030202],
			[Q030203],
			[Q030204],
			[Q030205],
			[Q030206],
			[Q030207],
			[Q030208],
			[Q030301],
			[Q030302],
			[Q030303],
			[Q030304],
			[Q030305],
			[Q030306],
			[Q030307],
			[Q030308],
			[Q030309]
			)
		) AS pvt			
	)
	
	select	*
	from	mp		

GO


