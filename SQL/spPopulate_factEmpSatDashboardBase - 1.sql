/*
truncate table dd.factEmpSatDashboardBase
drop proc spPopulate_factEmpSatDashboardBase
SELECT * FROM dd.factEmpSatDashboardBase
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatDashboardBase] AS
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
			bser.current_indicator,
			db.AssociationName,
			db.AssociationNumber + ' - ' + db.AssociationName AS AssociationNameEx,
			db.OfficialBranchName,
			dd.GetShortBranchName(db.OfficialBranchName) AS BranchNameShort,
			bser.GivenDateKey,
			cast(left(bser.GivenDateKey, 4) AS int) AS SurveyYear,	
			cast(left(C.previous_date_given_key, 4) AS int) AS PrevYear,	
			C.previous_date_given_key AS PrevGivenDateKey,
			db.OfficialBranchNumber,
			db.AssociationNumber
			
	INTO	#ESDB
	
	FROM 	dbo.factBranchStaffExperienceReport bser	(nolock)
			INNER JOIN dbo.dimBranch db (nolock)
				ON db.BranchKey = bser.BranchKey
			LEFT JOIN Seer_MDM.dbo.Batch_Map C
				ON db.BranchKey = C.organization_key
					AND bser.OrganizationSurveyKey = C.survey_form_key
					AND bser.batch_key = C.batch_key
					AND bser.GivenDateKey = C.date_given_key
			--filter by those having 2012 data for now	
			INNER JOIN (SELECT	distinct
								AssociationKey
						FROM	dd.vwEmpSat2012SurveyAssociations) a12
				ON a12.AssociationKey = db.AssociationKey
				
	WHERE	bser.current_indicator = 1
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatDashboardBase AS target
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
					
			FROM	#ESDB A

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
	MERGE	Seer_ODS.dd.factEmpSatDashboardBase AS target
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
					
			FROM	#ESDB A

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

	DROP TABLE #ESDB;
	
COMMIT TRAN
	
END








