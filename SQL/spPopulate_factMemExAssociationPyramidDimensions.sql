/*
truncate table dd.factMemExAssociationPyramidDimensions
drop proc spPopulate_factMemExAssociationPyramidDimensions
SELECT * FROM dd.factMemExAssociationPyramidDimensions
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExAssociationPyramidDimensions] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	db.AssociationKey,
			db.AssociationName AS Association, 
			db.batch_key,    
			db.[GivenDateKey],
			db.current_indicator,
			msp.[PyramidCategory],
			msp.[Percentile],
			msp.HistoricalChangeIndex,
			db.SurveyYear	
			
	INTO	#alla		
	
	FROM	[dbo].[factMemSatPyramid] msp
			INNER JOIN dd.factMemExDashboardBase db
				ON db.BranchKey = msp.BranchKey
					AND db.batch_key = msp.batch_key
					AND db.GivenDateKey = msp.GivenDateKey
			INNER JOIN Seer_MDM.dbo.Batch_Map C
				ON msp.SurveyFormKey = C.survey_form_key
					AND msp.BranchKey = C.organization_key
					AND msp.batch_key = C.batch_key
					AND msp.GivenDateKey = C.date_given_key
					
	WHERE	C.module = 'Member'
			AND C.aggregate_type = 'Association'
			AND db.current_indicator = 1
	;
		
	SELECT	alla.AssociationKey,
			alla.Association,
			alla.PyramidCategory,									
			alla.Percentile AS Height,
			alla.batch_key
			
	INTO	#heights
						
	FROM	#alla alla
	 
	WHERE	PyramidCategory in ('Facilities', 'Engagement', 'Support', 'Impact', 'Value', 'Involvement', 'Facility', 'Well Being', 'Health & Wellness', 'Service')		
	;
	
	SELECT	distinct
			alla.batch_key,
			alla.current_indicator,
			alla.Association AS AssociationName,
			case when alla.PyramidCategory in ('Missions', 'Overall', 'Operations') then 'Overall' else 'Pyramid' end AS CategoryGroup,
			case when alla.PyramidCategory in ('Impact', 'Well Being') then 'Health & Wellness'
				when alla.PyramidCategory = 'Facilities' then 'Facility' 
				when alla.PyramidCategory = 'Support' then 'Service' 
				else alla.PyramidCategory end AS PyramidCategory,
			cast(round((alla.Percentile), 0) as int) as AssociationPercentile,				
			cast(round(alla.Percentile + alla.HistoricalChangeIndex, 0) as int) as PrevAssociationPercentile,
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
			 
	INTO	#MEAPD
			 
	FROM	#alla alla
			LEFT JOIN #heights heights 
				ON heights.Association = alla.Association
					AND heights.PyramidCategory = alla.PyramidCategory
					AND heights.batch_key = alla.batch_key
			LEFT JOIN (SELECT Height AS InvolvementHeight, Association, batch_key, PyramidCategory FROM #heights ) heights1
				ON heights1.Association = alla.Association
					AND heights1.Pyramidcategory = 'Involvement'
					AND heights1.batch_key = alla.batch_key				
			LEFT JOIN (SELECT Height AS ImpactHeight, Association, batch_key, PyramidCategory FROM #heights ) heights2
				ON heights2.Association = alla.Association
					AND heights2.Pyramidcategory in ('Impact', 'Well Being', 'Health & Wellness')
					AND heights2.batch_key = alla.batch_key
			LEFT JOIN (SELECT Height AS EngagementHeight, Association, batch_key, PyramidCategory FROM #heights ) heights3
				ON heights3.Association = alla.Association
					AND heights3.Pyramidcategory = 'Engagement'
					AND heights3.batch_key = alla.batch_key
			LEFT JOIN (SELECT Height AS SupportHeight, Association, batch_key, PyramidCategory FROM #heights ) heights4
				ON heights4.Association = alla.Association
					AND heights4.Pyramidcategory in ('Support', 'Service')
					AND heights4.batch_key = alla.batch_key
			LEFT JOIN (SELECT Height AS ValueHeight, Association, batch_key, PyramidCategory FROM #heights ) heights5
				ON heights5.Association = alla.Association
					AND heights5.Pyramidcategory = 'Value'
					AND heights5.batch_key = alla.batch_key
			LEFT JOIN (SELECT Height AS FacilityHeight, Association, batch_key, PyramidCategory FROM #heights ) heights6
				ON heights6.Association = alla.Association
					AND heights6.Pyramidcategory in ('Facilities', 'Facility')
					AND heights6.batch_key = alla.batch_key

	UNION
	
	SELECT	distinct
			batch_key,
			1 current_indicator,
			a.Association AS AssociationName,
			'Pyramid' AS CategoryGroup,
			'Dummy' AS PyramidCategory,
			0 AS AssociationPercentile,
			0 AS PrevAssociationPercentile,
			0 AS Width,
			0 AS Height,
			a.SurveyYear
					
	FROM	#alla a
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExAssociationPyramidDimensions AS target
	USING	(
			SELECT	A.AssociationName,
					A.CategoryGroup,
					A.PyramidCategory,
					A.batch_key,
					A.current_indicator,
					A.AssociationPercentile,
					A.PrevAssociationPercentile,
					A.Width,
					A.Height,
					A.SurveyYear
					
			FROM	#MEAPD A

			) AS source
			
			ON target.AssociationName = source.AssociationName
				AND target.CategoryGroup = source.CategoryGroup
				AND target.PyramidCategory = source.PyramidCategory
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[AssociationPercentile] <> source.[AssociationPercentile]
								 OR target.[PrevAssociationPercentile] <> source.[PrevAssociationPercentile]
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
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[AssociationPercentile],
					[PrevAssociationPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
			VALUES ([AssociationName],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[AssociationPercentile],
					[PrevAssociationPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExAssociationPyramidDimensions AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationName,
					A.CategoryGroup,
					A.PyramidCategory,
					A.batch_key,
					A.current_indicator,
					A.AssociationPercentile,
					A.PrevAssociationPercentile,
					A.Width,
					A.Height,
					A.SurveyYear
					
			FROM	#MEAPD A

			) AS source
			
			ON target.AssociationName = source.AssociationName
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
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[AssociationPercentile],
					[PrevAssociationPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationName],
					[CategoryGroup],
					[PyramidCategory],
					[batch_key],
					[current_indicator],
					[AssociationPercentile],
					[PrevAssociationPercentile],
					[Width],
					[Height],
					[SurveyYear]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #alla;
	DROP TABLE #MEAPD;
	
COMMIT TRAN
	
END








