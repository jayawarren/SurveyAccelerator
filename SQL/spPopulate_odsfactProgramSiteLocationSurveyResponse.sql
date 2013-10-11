/*
truncate table Seer_ODS.dbo.factProgramSiteLocationSurveyResponse
drop procedure spPopulate_odsfactProgramSiteLocationSurveyResponse
SELECT * FROM Seer_ODS.dbo.factProgramSiteLocationSurveyResponse
ROLLBACK TRAN
*/
CREATE PROCEDURE spPopulate_odsfactProgramSiteLocationSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.ProgramSiteLocationKey,
			A.AssociationKey,
			A.OrganizationSurveyKey,
			A.SurveyQuestionKey,
			A.QuestionResponseKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			A.ResponseCount
	
	INTO	#PSLRC
	
	FROM	(
			SELECT	sr.ProgramSiteLocationKey,
					a.organization_key AssociationKey,
					sr.OrganizationSurveyKey,
					sr.SurveyQuestionKey,
					sr.QuestionResponseKey,
					sr.batch_key,
					sr.GivenDateKey,
					sr.current_indicator,
					COUNT(DISTINCT sr.MemberKey) ResponseCount
					
			FROM	Seer_ODS.dbo.factMemberSurveyResponse sr
					INNER JOIN Seer_MDM.dbo.Member_Program_Group_Map a
						ON sr.MemberKey = a.member_key
							AND sr.OrganizationSurveyKey = a.survey_form_key
							AND sr.batch_key = a.batch_key
							AND sr.ProgramSiteLocationKey = a.program_group_key

			WHERE	sr.ProgramSiteLocationKey <> -1
					AND sr.current_indicator = 1
					AND a.current_indicator = 1

			GROUP BY sr.ProgramSiteLocationKey,
					a.organization_key,
					sr.OrganizationSurveyKey,
					sr.SurveyQuestionKey,
					sr.QuestionResponseKey,
					sr.batch_key,
					sr.GivenDateKey,
					sr.current_indicator
			) A
			
	ORDER BY A.ProgramSiteLocationKey;
	
	SELECT	B.ProgramSiteLocationKey,
			B.OrganizationSurveyKey,
			B.SurveyQuestionKey,
			B.batch_key,
			B.GivenDateKey,
			B.current_indicator,
			B.QuestionCount,
			B.SurveyCount
			
	INTO	#PSLQSC
			
	FROM	(
			SELECT	PSR.ProgramSiteLocationKey,
					PSR.OrganizationSurveyKey,
					PSR.SurveyQuestionKey,
					PSR.batch_key,
					PSR.GivenDateKey,
					PSR.current_indicator,
					SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
							ELSE ResponseCount
						END) AS QuestionCount,
					SUM(PSR.ResponseCount) AS SurveyCount
					
			FROM	(
					SELECT	sr.ProgramSiteLocationKey,
							sr.OrganizationSurveyKey,
							sr.QuestionResponseKey,
							sr.SurveyQuestionKey,
							sr.batch_key,
							sr.GivenDateKey,
							sr.current_indicator,
							COUNT(DISTINCT sr.MemberKey) ResponseCount
							
					FROM	Seer_ODS.dbo.factMemberSurveyResponse sr

					WHERE	sr.ProgramSiteLocationKey <> -1
							AND sr.current_indicator = 1

					GROUP BY sr.ProgramSiteLocationKey,
							sr.OrganizationSurveyKey,
							sr.SurveyQuestionKey,
							sr.QuestionResponseKey,
							sr.batch_key,
							sr.GivenDateKey,
							sr.current_indicator
					) PSR
					INNER JOIN dimQuestionResponse DQR
						ON PSR.QuestionResponseKey = DQR.QuestionResponseKey
						
			GROUP BY PSR.ProgramSiteLocationKey,
					PSR.OrganizationSurveyKey,
					PSR.SurveyQuestionKey,
					PSR.batch_key,
					PSR.GivenDateKey,
					PSR.current_indicator
			) B
			
	ORDER By B.ProgramSiteLocationKey;

	SELECT	A.ProgramSiteLocationKey ProgramSiteLocationResponseKey,
			A.ProgramSiteLocationKey,
			C.AssociationKey,
			A.OrganizationSurveyKey,
			A.SurveyQuestionKey,
			C.QuestionResponseKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			A.SurveyCount,
			C.ResponseCount,
			ResponsePercentage = dbo.RoundToZero(CASE WHEN B.PercentageDenominator = 'Survey' THEN CONVERT(DECIMAL(19, 6), C.ResponseCount)/A.SurveyCount
													ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN CONVERT(DECIMAL(19, 6), C.ResponseCount)/A.SurveyCount
															ELSE CONVERT(DECIMAL(19, 6), C.ResponseCount)/A.QuestionCount
														END
												END, 5)
	
	INTO	#PSLR
												
	FROM	#PSLQSC A
			INNER JOIN #PSLRC C
			ON A.ProgramSiteLocationKey = C.ProgramSiteLocationKey
				AND A.OrganizationSurveyKey = C.OrganizationSurveyKey
				AND A.SurveyQuestionKey = C.SurveyQuestionKey
				AND A.batch_key = C.batch_key
				AND A.GivenDateKey = C.GivenDateKey
				AND A.current_indicator = C.current_indicator
			INNER JOIN dimSurveyQuestion B
				ON C.SurveyQuestionKey = B.SurveyQuestionKey
			INNER JOIN dimQuestionResponse D
						ON C.QuestionResponseKey = D.QuestionResponseKey;

COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factProgramSiteLocationSurveyResponse]') AND name = N'PSLR_INDEX_01')
	DROP INDEX [PSLR_INDEX_01] ON [dbo].[factProgramSiteLocationSurveyResponse] WITH ( ONLINE = OFF );

	CREATE INDEX PSLR_INDEX_01 ON [dbo].[factProgramSiteLocationSurveyResponse] ([ProgramSiteLocationKey], [AssociationKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [batch_key], [GivenDateKey], [current_indicator]) ON NDXGROUP;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse AS target
	USING	(
			SELECT	A.ProgramSiteLocationKey,
					A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.SurveyCount,
					A.ResponseCount,
					A.ResponsePercentage
														
			FROM	#PSLR A

			) AS source
			
			ON target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
				AND target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[SurveyCount] <> source.[SurveyCount]
								OR target.[ResponseCount] <> source.[ResponseCount]
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
			INSERT ([ProgramSiteLocationKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[SurveyCount],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([ProgramSiteLocationKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[SurveyCount],
					[ResponseCount],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramSiteLocationSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.ProgramSiteLocationKey,
					A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.SurveyCount,
					A.ResponseCount,
					A.ResponsePercentage
														
			FROM	#PSLR A

			) AS source
			
			ON target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
				AND target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
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
					[ProgramSiteLocationKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[SurveyCount],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[ProgramSiteLocationKey],
					[AssociationKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[SurveyCount],
					[ResponseCount],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factProgramSiteLocationSurveyResponse]') AND name = N'PSLR_INDEX_01')
	DROP INDEX [PSLR_INDEX_01] ON [dbo].[factProgramSiteLocationSurveyResponse] WITH ( ONLINE = OFF );

	DROP TABLE #PSLQSC;
	DROP TABLE #PSLRC;
	DROP TABLE #PSLR;
COMMIT TRAN

END