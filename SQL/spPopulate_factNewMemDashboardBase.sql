/*
truncate table dd.factNewMemDashboardBase
drop proc spPopulate_factNewMemDashboardBase
SELECT * FROM dd.factNewMemDashboardBase
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemDashboardBase] AS
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
			COALESCE(C.current_indicator, 0) current_indicator,
			db.AssociationName,
			db.AssociationNumber + ' - ' + db.AssociationName AS AssociationNameEx,
			db.OfficialBranchName,
			dd.GetShortBranchName(db.OfficialBranchName) AS BranchNameShort,
			bmsr.GivenDateKey,
			cast(left(bmsr.GivenDateKey, 4) AS int) AS SurveyYear,	
			cast(left(C.previous_date_given_key, 4) AS int) AS PrevYear,	
			C.previous_date_given_key AS PrevGivenDateKey,
			db.OfficialBranchNumber,
			db.AssociationNumber,
			REPLACE(CONVERT(varchar(20), E.report_date), '-', '') SurveyDate,
			1 GrpInd,
			D.date_given_key AssocGivenDateKey,
			CONVERT(int, left(D.date_given_key, 4)) AS AssocSurveyYear,	
			CONVERT(int, left(D.previous_date_given_key, 4)) AS AssocPrevYear,	
			D.previous_date_given_key AssocPrevGivenDateKey,
			REPLACE(CONVERT(varchar(20), F.report_date), '-', '') AssocSurveyDate,
			1 AssocGrpInd
			
	INTO	#BNMER

	FROM 	dbo.factBranchNewMemberExperienceReport bmsr	(nolock)
			INNER JOIN dbo.dimBranch db (nolock)
				ON db.BranchKey = bmsr.BranchKey
			--filter by those having 2012 data for now	
			INNER JOIN (SELECT	distinct
								AssociationKey
						FROM	dd.vwNewMem2012SurveyAssociations) a12
				ON a12.AssociationKey = db.AssociationKey
			LEFT JOIN Seer_MDM.dbo.Batch_Map C
				ON db.BranchKey = C.organization_key
					AND bmsr.OrganizationSurveyKey = C.survey_form_key
					AND bmsr.batch_key = C.batch_key
					AND bmsr.GivenDateKey = C.date_given_key
			LEFT JOIN Seer_MDM.dbo.Batch_Map D
				ON db.AssociationKey = D.organization_key
					AND bmsr.OrganizationSurveyKey = C.survey_form_key
					AND bmsr.batch_key = D.batch_key
					AND bmsr.GivenDateKey = C.date_given_key
			LEFT JOIN Seer_MDM.dbo.Batch E
				ON C.batch_key = E.batch_key
			LEFT JOIN Seer_MDM.dbo.Batch F
				ON D.batch_key = F.batch_key
			
	WHERE	bmsr.current_indicator = 1
			AND COALESCE(F.report_date, E.report_date) = E.report_date
			AND DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), C.date_given_key))) < GETDATE()
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemDashboardBase AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.AssocGivenDateKey,
					A.AssocPrevGivenDateKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.AssociationNameEx,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.BranchNameShort,
					A.SurveyDate,
					A.SurveyYear,
					A.PrevYear,
					A.AssocSurveyDate,
					A.AssocSurveyYear,
					A.AssocPrevYear,
					A.GrpInd,
					A.AssocGrpInd
						
			FROM	#BNMER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[PrevGivenDateKey] <> source.[PrevGivenDateKey]
								 OR target.[AssocGivenDateKey] <> source.[AssocGivenDateKey]
								 OR target.[AssocPrevGivenDateKey] <> source.[AssocPrevGivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[AssociationNameEx] <> source.[AssociationNameEx]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[BranchNameShort] <> source.[BranchNameShort]
								 OR target.[SurveyDate] <> source.[SurveyDate]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[PrevYear] <> source.[PrevYear]
								 OR target.[AssocSurveyDate] <> source.[AssocSurveyDate]
								 OR target.[AssocSurveyYear] <> source.[AssocSurveyYear]
								 OR target.[AssocPrevYear] <> source.[AssocPrevYear]
								 OR target.[GrpInd] <> source.[GrpInd]
								 OR target.[AssocGrpInd] <> source.[AssocGrpInd]
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
					[GivenDateKey],
					[PrevGivenDateKey],
					[AssocGivenDateKey],
					[AssocPrevGivenDateKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyDate],
					[SurveyYear],
					[PrevYear],
					[AssocSurveyDate],
					[AssocSurveyYear],
					[AssocPrevYear],
					[GrpInd],
					[AssocGrpInd]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[GivenDateKey],
					[PrevGivenDateKey],
					[AssocGivenDateKey],
					[AssocPrevGivenDateKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyDate],
					[SurveyYear],
					[PrevYear],
					[AssocSurveyDate],
					[AssocSurveyYear],
					[AssocPrevYear],
					[GrpInd],
					[AssocGrpInd]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemDashboardBase AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.AssocGivenDateKey,
					A.AssocPrevGivenDateKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.AssociationNameEx,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.BranchNameShort,
					A.SurveyDate,
					A.SurveyYear,
					A.PrevYear,
					A.AssocSurveyDate,
					A.AssocSurveyYear,
					A.AssocPrevYear,
					A.GrpInd,
					A.AssocGrpInd
						
			FROM	#BNMER A

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
					[GivenDateKey],
					[PrevGivenDateKey],
					[AssocGivenDateKey],
					[AssocPrevGivenDateKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyDate],
					[SurveyYear],
					[PrevYear],
					[AssocSurveyDate],
					[AssocSurveyYear],
					[AssocPrevYear],
					[GrpInd],
					[AssocGrpInd]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[GivenDateKey],
					[PrevGivenDateKey],
					[AssocGivenDateKey],
					[AssocPrevGivenDateKey],
					[batch_key],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[AssociationNameEx],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[BranchNameShort],
					[SurveyDate],
					[SurveyYear],
					[PrevYear],
					[AssocSurveyDate],
					[AssocSurveyYear],
					[AssocPrevYear],
					[GrpInd],
					[AssocGrpInd]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #BNMER;
	
COMMIT TRAN
	
END








