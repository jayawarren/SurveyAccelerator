/*
truncate table dd.factMemExBranchPyramidDimensions
drop proc spPopulate_factMemExBranchPyramidDimensions
SELECT * FROM dd.factMemExBranchPyramidDimensions
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchPyramidDimensions] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	COALESCE(C.batch_key, 0) batch_key,
			COALESCE(C.current_indicator, 0) current_indicator,
			db.AssociationName AS Association,     
			db.BranchNameShort AS Branch,		  
			db.[GivenDateKey],
			msp.[PyramidCategory],
			msp.[Percentile],
			msp.HistoricalChangeIndex,
			db.SurveyYear	
			
	INTO	#alla		
	
	FROM	[dbo].[factMemSatPyramid] msp
			INNER JOIN dd.factMemExDashboardBase db
				ON db.BranchKey = msp.BranchKey
					AND db.GivenDateKey = msp.GivenDateKey
			LEFT JOIN Seer_MDM.dbo.Batch_Map C
				ON msp.SurveyFormKey = C.survey_form_key
					AND msp.BranchKey = C.organization_key
					AND msp.GivenDateKey = C.date_given_key
					
	WHERE	C.module = 'Member'
			AND C.aggregate_type = 'Branch'
			AND COALESCE(C.current_indicator, 1) = 1
	;
		
	SELECT	Association,
			Branch,
			PyramidCategory,									
			Percentile AS Height
			
	INTO	#heights
						
	FROM	#alla alla
	 
	WHERE	PyramidCategory in ('Facilities', 'Engagement', 'Support', 'Impact', 'Value', 'Involvement', 'Facility', 'Well Being', 'Health & Wellness', 'Service')		
	;
	
	SELECT	distinct
			alla.batch_key,
			alla.current_indicator,
			alla.Association AS AssociationName,
			alla.Branch,
			case when alla.PyramidCategory in ('Missions', 'Overall', 'Operations') then 'Overall' else 'Pyramid' end AS CategoryGroup,
			case when alla.PyramidCategory in ('Impact', 'Well Being') then 'Health & Wellness'
				when alla.PyramidCategory = 'Facilities' then 'Facility' 
				when alla.PyramidCategory = 'Support' then 'Service' 
				else alla.PyramidCategory end AS PyramidCategory,
			floor(alla.Percentile) AS CrtBranchPercentile,				
			alla.Percentile + alla.HistoricalChangeIndex AS PrevBranchPercentile,
			floor(assoc.Percentile) AS AssocPercentile,
			case
				when alla.PyramidCategory = 'Involvement' then	
					(200.00 *
						heights1.InvolvementHeight 					
					) / 225.00
				when alla.PyramidCategory in ('Impact', 'Well Being', 'Health & Wellness') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight					
					)) / 225.00
				when alla.PyramidCategory = 'Engagement' then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight 
					)) / 225.00			
				when alla.PyramidCategory in ('Support', 'Service') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight 
					)) / 225.00			
				when alla.PyramidCategory = 'Value' then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight +
						heights5.ValueHeight
						 
					)) / 225.00			
				when alla.PyramidCategory in ('Facilities', 'Facility') then
					(200.00 * (
						heights1.InvolvementHeight +
						heights2.ImpactHeight + 					
						heights3.EngagementHeight +
						heights4.SupportHeight +
						heights5.ValueHeight +
						heights6.FacilityHeight
					)) / 225.00									
			 end AS Width,		
			 heights.Height,	
			 alla.SurveyYear
			 
	INTO	#MEBPD
			 
	FROM	#alla alla
			LEFT JOIN #heights heights 
				ON heights.Association = alla.Association AND heights.Branch = alla.Branch AND heights.PyramidCategory = alla.PyramidCategory
			LEFT JOIN (SELECT Height AS InvolvementHeight, Association, Branch, PyramidCategory FROM #heights ) heights1
					ON heights1.Association = alla.Association AND heights1.Branch = alla.Branch AND heights1.Pyramidcategory = 'Involvement'				
			LEFT JOIN (SELECT Height AS ImpactHeight, Association, Branch, PyramidCategory FROM #heights ) heights2
					ON heights2.Association = alla.Association AND heights2.Branch = alla.Branch AND heights2.Pyramidcategory in ('Impact', 'Well Being', 'Health & Wellness')
			LEFT JOIN (SELECT Height AS EngagementHeight, Association, Branch, PyramidCategory FROM #heights ) heights3
					ON heights3.Association = alla.Association AND heights3.Branch = alla.Branch AND heights3.Pyramidcategory = 'Engagement'
			LEFT JOIN (SELECT Height AS SupportHeight, Association, Branch, PyramidCategory FROM #heights ) heights4
					ON heights4.Association = alla.Association AND heights4.Branch = alla.Branch AND heights4.Pyramidcategory in ('Support', 'Service')
			LEFT JOIN (SELECT Height AS ValueHeight, Association, Branch, PyramidCategory FROM #heights ) heights5
					ON heights5.Association = alla.Association AND heights5.Branch = alla.Branch AND heights5.Pyramidcategory = 'Value'
			LEFT JOIN (SELECT Height AS FacilityHeight, Association, Branch, PyramidCategory FROM #heights ) heights6
					ON heights6.Association = alla.Association AND heights6.Branch = alla.Branch AND heights6.Pyramidcategory in ('Facilities', 'Facility')
			LEFT JOIN (
						SELECT	Association,
								PyramidCategory,			
								AVG(Percentile) AS Percentile
						FROM	#alla
						GROUP BY Association,
							PyramidCategory			
			) assoc
				ON assoc.Association = alla.Association AND assoc.PyramidCategory = alla.PyramidCategory

	UNION
	SELECT	distinct
			0 batch_key,
			1 current_indicator,
			a.Association AS AssociationName,
			a.Branch,
			'Pyramid' AS CategoryGroup,
			'Dummy' AS PyramidCategory,
			0 AS CrtBranchPercentile,
			0 AS PrevBranchPercentile,
			0 AS AssocPercentile,
			0 AS Width,
			0 AS Height,
			SurveyYear
					
	FROM	#alla a
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchPyramidDimensions AS target
	USING	(
			SELECT	A.AssociationName,
					A.Branch,
					A.CategoryGroup,
					A.PyramidCategory,
					A.batch_key,
					A.current_indicator,
					A.CrtBranchPercentile,
					A.PrevBranchPercentile,
					A.AssocPercentile,
					A.Width,
					A.Height,
					A.SurveyYear
					
			FROM	#MEBPD A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.Branch = source.Branch
				AND target.CategoryGroup = source.CategoryGroup
				AND target.PyramidCategory = source.PyramidCategory
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[CrtBranchPercentile] <> source.[CrtBranchPercentile]
								 OR target.[PrevBranchPercentile] <> source.[PrevBranchPercentile]
								 OR target.[AssocPercentile] <> source.[AssocPercentile]
								 OR target.[Width] <> source.[Width]
								 OR target.[Height] <> source.[Height]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationName],
					[Branch],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[CrtBranchPercentile],
					[PrevBranchPercentile],
					[AssocPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
			VALUES ([AssociationName],
					[Branch],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[CrtBranchPercentile],
					[PrevBranchPercentile],
					[AssocPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchPyramidDimensions AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationName,
					A.Branch,
					A.CategoryGroup,
					A.PyramidCategory,
					A.batch_key,
					A.current_indicator,
					A.CrtBranchPercentile,
					A.PrevBranchPercentile,
					A.AssocPercentile,
					A.Width,
					A.Height,
					A.SurveyYear
					
			FROM	#MEBPD A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.Branch = source.Branch
				AND target.CategoryGroup = source.CategoryGroup
				AND target.PyramidCategory = source.PyramidCategory
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationName],
					[Branch],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[CrtBranchPercentile],
					[PrevBranchPercentile],
					[AssocPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationName],
					[Branch],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[CrtBranchPercentile],
					[PrevBranchPercentile],
					[AssocPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBPD;
	
COMMIT TRAN
	
END








