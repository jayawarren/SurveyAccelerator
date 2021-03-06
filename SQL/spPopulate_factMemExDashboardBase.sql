/*
truncate table dd.factMemExDashboardBase
drop proc spPopulate_factMemExDashboardBase
SELECT * FROM factMemExDashboardBase
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExDashboardBase] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	distinct	
			db.AssociationKey,
			C.batch_key,
			bmsr.GivenDateKey,
			cast(left(bmsr.GivenDateKey, 4) AS int) yr,
			CASE WHEN C.organization_key IS NULL THEN 0
				ELSE 1
			END current_indicator
			
	INTO	#bs
				
	FROM	dbo.factBranchMemberSatisfactionReport bmsr	(nolock)
			INNER JOIN dbo.dimBranch db (nolock)
				ON db.BranchKey = bmsr.BranchKey	
				--and db.AssociationNumber = '2165'
			LEFT JOIN Seer_MDM.dbo.Batch_Map C
				ON db.BranchKey = C.organization_key
					AND bmsr.OrganizationSurveyKey = C.survey_form_key
					AND bmsr.GivenDateKey = C.date_given_key
					
	GROUP BY db.AssociationKey,
			C.batch_key,
			bmsr.GivenDateKey,
			cast(left(bmsr.GivenDateKey, 4) AS int),
			CASE WHEN C.organization_key IS NULL THEN 0
				ELSE 1
			END;
						

	SELECT	bs.AssociationKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.yr,
			bs.current_indicator,
			ROW_NUMBER() over (partition by AssociationKey order by GivenDateKey desc) rn
			
	INTO	#bsrn
	
	FROM	#bs bs;
	
	SELECT	distinct
			bmsr.BranchKey,
			bsrn.batch_key,
			bsrn.GivenDateKey,
			bsrn.current_indicator,
			bsrn.rn
			
	INTO	#bsr
	
	FROM 	dbo.factBranchMemberSatisfactionReport bmsr (nolock)
			INNER JOIN dbo.dimBranch db (nolock)
				ON db.BranchKey = bmsr.BranchKey
			INNER JOIN #bsrn bsrn
				ON bsrn.AssociationKey = db.AssociationKey
					and bmsr.GivenDateKey = bsrn.GivenDateKey;
	
	SELECT	distinct
			db.AssociationKey,
			db.BranchKey,
			bsr.batch_key,
			bsr.current_indicator,
			db.AssociationName,
			db.AssociationNumber + ' - ' + db.AssociationName AS AssociationNameEx,
			db.OfficialBranchName,
			dd.GetShortBranchName(db.OfficialBranchName) AS BranchNameShort,
			bsr.GivenDateKey,
			cast(left(bsr.GivenDateKey, 4) AS int) AS SurveyYear,	
			cast(left(bsrprv.GivenDateKey, 4) AS int) AS PrevYear,	
			bsrprv.GivenDateKey AS PrevGivenDateKey,
			db.OfficialBranchNumber,
			db.AssociationNumber
			
	INTO	#MEDB
	
	FROM 	dbo.dimBranch db (nolock)
			INNER JOIN #bsr bsr
				ON bsr.BranchKey = db.BranchKey
					and bsr.rn = 1 
			left join #bsr AS bsrprv
				ON bsrprv.BranchKey = db.BranchKey
					and bsrprv.rn=2
			--filter by those having 2012 data for now	
			INNER JOIN (SELECT	distinct
								AssociationKey
						FROM	dd.vwMemEx2012SurveyAssociations) a12
				ON a12.AssociationKey = db.AssociationKey
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExDashboardBase AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.AssociationNameEx,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.BranchNameShort,
					A.SurveyYear,
					A.PrevYear
					
			FROM	#MEDB A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[PrevGivenDateKey] <> source.[PrevGivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[AssociationNameEx] <> source.[AssociationNameEx]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[BranchNameShort] <> source.[BranchNameShort]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[PrevYear] <> source.[PrevYear]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyYear],
					[PrevYear]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyYear],
					[PrevYear]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExDashboardBase AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.AssociationNameEx,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.BranchNameShort,
					A.SurveyYear,
					A.PrevYear
					
			FROM	#MEDB A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyYear],
					[PrevYear]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyYear],
					[PrevYear]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #bs;
	DROP TABLE #bsrn;
	DROP TABLE #bsr;
	DROP TABLE #MEDB;
	
COMMIT TRAN
	
END








