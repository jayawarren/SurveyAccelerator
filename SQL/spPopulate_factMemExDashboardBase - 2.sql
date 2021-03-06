/*
truncate table dd.factMemExDashboardBase
drop proc spPopulate_factMemExDashboardBase
SELECT * FROM dd.factMemExDashboardBase
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
			db.BranchKey,
			C.batch_key,
			C.change_datetime,
			C.next_change_datetime,
			bmsr.current_indicator,
			db.AssociationName,
			db.AssociationNumber + ' - ' + db.AssociationName AS AssociationNameEx,
			db.OfficialBranchName,
			dd.GetShortBranchName(db.OfficialBranchName) AS BranchNameShort,
			bmsr.GivenDateKey,
			cast(left(bmsr.GivenDateKey, 4) AS int) AS SurveyYear,	
			cast(left(C.previous_date_given_key, 4) AS int) AS PrevYear,	
			C.previous_date_given_key AS PrevGivenDateKey,
			db.OfficialBranchNumber,
			db.AssociationNumber
			
	INTO	#MEDB
	
	FROM 	dbo.factBranchMemberSatisfactionReport bmsr	(nolock)
			INNER JOIN dbo.dimBranch db (nolock)
				ON db.BranchKey = bmsr.BranchKey
			INNER JOIN Seer_MDM.dbo.Batch_Map C
				ON db.BranchKey = C.organization_key
					AND bmsr.OrganizationSurveyKey = C.survey_form_key
					AND bmsr.GivenDateKey = C.date_given_key
					AND bmsr.batch_key = C.batch_key
			--filter by those having 2012 data for now	
			INNER JOIN (SELECT	distinct
								AssociationKey
						FROM	dd.vwMemEx2012SurveyAssociations) a12
				ON a12.AssociationKey = db.AssociationKey
				
	WHERE	bmsr.current_indicator = 1
			AND C.module = 'Member'
			AND C.aggregate_type = 'Branch'
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
					A.change_datetime,
					A.next_change_datetime,
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
			
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[GivenDateKey] <> source.[GivenDateKey]
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
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[change_datetime],
					[next_change_datetime],
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
					[change_datetime],
					[next_change_datetime],
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
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
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
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[change_datetime],
					[next_change_datetime],
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
					[change_datetime],
					[next_change_datetime],
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

	DROP TABLE #MEDB;
	
COMMIT TRAN
	
END








