/*
truncate table Seer_ODS.dbo.factProgramGroupSurveyResponse
drop procedure spPopulate_odsfactProgramGroupSurveyResponse
SELECT * FROM Seer_ODS.dbo.factProgramGroupSurveyResponse
ROLLBACK TRAN
*/
CREATE PROCEDURE spPopulate_odsfactProgramGroupSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN

SELECT	A.ProgramGroupKey ProgramGroupResponseKey,
		A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey, 
		A.SurveyQuestionKey,
		A.QuestionResponseKey,
		A.batch_key,
		A.GivenDateKey,
		A.current_indicator,
		A.ResponseCount

INTO	#PGSRR

FROM	(
		SELECT	DPG.program_group_key ProgramGroupKey,
				PSR.AssociationKey,
				PSR.OrganizationSurveyKey, 
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.batch_key,
				PSR.GivenDateKey,
				PSR.current_indicator,
				SUM(PSR.ResponseCount) ResponseCount
	
		FROM	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse PSR
				INNER JOIN Seer_MDM.dbo.Program_Group DPG
					ON PSR.ProgramSiteLocationKey = DPG.program_group_key
					
		WHERE	PSR.current_indicator = 1
				AND DPG.current_indicator = 1
					
		GROUP BY DPG.program_group_key,
				PSR.AssociationKey,
				PSR.OrganizationSurveyKey,
				PSR.QuestionResponseKey,
				PSR.SurveyQuestionKey,
				PSR.batch_key,
				PSR.GivenDateKey,
				PSR.current_indicator
		) A
		
ORDER BY A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey;
		
SELECT	A.ProgramGroupKey ProgramGroupResponseKey,
		A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey,
		A.SurveyQuestionKey,
		A.batch_key,
		A.GivenDateKey,
		A.current_indicator,
		A.QuestionCount,
		A.SurveyCount
		
INTO	#PGSRQS

FROM	(
		SELECT	A.ProgramGroupKey,
				A.AssociationKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator,
				SUM(CASE WHEN COALESCE(C.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
						ELSE A.ResponseCount
					END) AS QuestionCount,
				SUM(A.ResponseCount) AS SurveyCount
				
		FROM	(
				SELECT	DPG.program_group_key ProgramGroupKey,
						PSR.AssociationKey,
						PSR.OrganizationSurveyKey, 
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.batch_key,
						PSR.GivenDateKey,
						PSR.current_indicator,
						SUM(PSR.ResponseCount) ResponseCount
						
				FROM	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse PSR
						INNER JOIN Seer_MDM.dbo.Program_Group DPG
							ON PSR.ProgramSiteLocationKey = DPG.program_group_key
				
				WHERE	PSR.current_indicator = 1
						AND DPG.current_indicator = 1
							
				GROUP BY DPG.program_group_key,
						PSR.AssociationKey,
						PSR.OrganizationSurveyKey,
						PSR.QuestionResponseKey,
						PSR.SurveyQuestionKey,
						PSR.batch_key,
						PSR.GivenDateKey,
						PSR.current_indicator
				) A
				INNER JOIN dimSurveyQuestion B
					ON A.SurveyQuestionKey = B.SurveyQuestionKey
				INNER JOIN dimQuestionResponse C
					ON A.QuestionResponseKey = C.QuestionResponseKey
					
		GROUP BY A.ProgramGroupKey,
				A.AssociationKey,
				A.OrganizationSurveyKey,
				A.SurveyQuestionKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator
		) A

ORDER BY A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey;

SELECT	A.ProgramGroupResponseKey,
		A.ProgramGroupKey,
		A.AssociationKey,
		A.OrganizationSurveyKey,
		A.QuestionResponseKey,
		A.SurveyQuestionKey,
		A.batch_key,
		A.GivenDateKey,
		A.current_indicator,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN C.PercentageDenominator = 'Survey' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.SurveyCount
												ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.SurveyCount
															ELSE CONVERT(DECIMAL(19, 6), A.ResponseCount)/B.QuestionCount
														END
											END, 5)

INTO	#PGSR
											
FROM	#PGSRR A
		INNER JOIN #PGSRQS B
			ON A.ProgramGroupKey = B.ProgramGroupKey
				AND A.AssociationKey = B.AssociationKey
				AND A.OrganizationSurveyKey = B.OrganizationSurveyKey
				AND A.SurveyQuestionKey = B.SurveyQuestionKey
				AND A.batch_key	 = B.batch_key
				AND A.GivenDateKey = B.GivenDateKey
		INNER JOIN Seer_ODS.dbo.dimSurveyQuestion C
			ON A.SurveyQuestionKey = C.SurveyQuestionKey
		INNER JOIN Seer_ODS.dbo.dimQuestionResponse D
			ON A.QuestionResponseKey = D.QuestionResponseKey
;

COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factProgramGroupSurveyResponse]') AND name = N'PGSR_INDEX_01')
	DROP INDEX [PGSR_INDEX_01] ON [dbo].[factProgramGroupSurveyResponse] WITH ( ONLINE = OFF );

	CREATE INDEX PGSR_INDEX_01 ON [dbo].[factProgramGroupSurveyResponse] ([ProgramGroupKey], [AssociationKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [current_indicator]) ON NDXGROUP;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramGroupSurveyResponse AS target
	USING	(
			SELECT	A.ProgramGroupResponseKey,
					A.ProgramGroupKey,
					A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.ResponseCount,
					A.ResponsePercentage
														
			FROM	#PGSR A

			) AS source
			
			ON target.ProgramGroupKey = source.ProgramGroupKey
				AND target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.QuestionResponseKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[ResponseCount] <> source.[ResponseCount]
								OR target.[ResponsePercentage] <> source.[ResponsePercentage]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([ProgramGroupResponseKey],
					[ProgramGroupKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([ProgramGroupResponseKey],
					[ProgramGroupKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[ResponseCount],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramGroupSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.ProgramGroupResponseKey,
					A.ProgramGroupKey,
					A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.ResponseCount,
					A.ResponsePercentage
														
			FROM	#PGSR A

			) AS source
			
			ON target.ProgramGroupKey = source.ProgramGroupKey
				AND target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.QuestionResponseKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[ProgramGroupResponseKey],
					[ProgramGroupKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[ProgramGroupResponseKey],
					[ProgramGroupKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[ResponseCount],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factProgramGroupSurveyResponse]') AND name = N'PGSR_INDEX_01')
	DROP INDEX [PGSR_INDEX_01] ON [dbo].[factProgramGroupSurveyResponse] WITH ( ONLINE = OFF );

	DROP TABLE #PGSRR;
	DROP TABLE #PGSRQS;
	DROP TABLE #PGSR;
	
COMMIT TRAN

END