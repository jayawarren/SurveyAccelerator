/*
truncate table Seer_ODS.dbo.factAssociationSurveyResponse
drop procedure spPopulate_odsfactAssociationSurveyResponse
SELECT * FROM Seer_ODS.dbo.factAssociationSurveyResponse
ROLLBACK TRAN
*/
CREATE PROCEDURE spPopulate_odsfactAssociationSurveyResponse AS
BEGIN

	DECLARE @change_datetime datetime
	DECLARE @next_change_datetime datetime
	SET @change_datetime = getdate()
	SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

	BEGIN TRAN
		SELECT	A.OrganizationSurveyKey SurveyFormKey,
				A.AssociationKey,
				A.SurveyQuestionKey,
				A.QuestionResponseKey,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator,
				A.ResponseCount,
				A.SurveyCount,
				A.QuestionCount,
				C.exclude_from_report_calculation,
				D.percentage_denominator
				
		INTO	#RSLTA
												
		FROM	(
				SELECT	E.OrganizationSurveyKey,
						E.AssociationKey,
						E.SurveyQuestionKey,
						E.QuestionResponseKey,
						E.batch_key,
						E.GivenDateKey,
						E.current_indicator,
						E.ResponseCount,
						B.SurveyCount,
						B.QuestionCount
				
				FROM	(
						SELECT	A.OrganizationSurveyKey,
								C.organization_key AssociationKey,
								A.SurveyQuestionKey,
								A.QuestionResponseKey,
								A.batch_key,
								A.GivenDateKey,
								A.current_indicator,
								COUNT(*) ResponseCount
							
						FROM	Seer_ODS.dbo.factMemberSurveyResponse A
								INNER JOIN Seer_MDM.dbo.Organization B
									ON A.BranchKey = B.organization_key
								INNER JOIN Seer_MDM.dbo.Organization C
									ON B.association_number = C.association_number
										AND B.association_number = C.official_branch_number
						
						WHERE	A.ResponseCount = 1
								AND A.current_indicator = 1
								AND B.current_indicator = 1
								AND C.current_indicator = 1

						GROUP BY A.OrganizationSurveyKey,
								C.organization_key,
								A.SurveyQuestionKey,
								A.batch_key,
								A.GivenDateKey,
								A.QuestionResponseKey,
								A.current_indicator
						) E
						INNER JOIN
						(SELECT	A.OrganizationSurveyKey,
								C.organization_key AssociationKey,
								D.survey_question_key SurveyQuestionKey,
								A.batch_key,
								A.GivenDateKey,
								A.current_indicator,
								SUM(CASE WHEN COALESCE(D.exclude_from_report_calculation,'N') = 'Y' THEN 0
										ELSE A.ResponseCount
									END
									) AS QuestionCount,
								SUM(A.ResponseCount) AS SurveyCount
						
						FROM	Seer_ODS.dbo.factMemberSurveyResponse A
								INNER JOIN Seer_MDM.dbo.Organization B
									ON A.BranchKey = B.organization_key
								INNER JOIN Seer_MDM.dbo.Organization C
									ON B.association_number = C.association_number
										AND B.association_number = C.official_branch_number
								INNER JOIN Seer_MDM.dbo.Survey_Response D
									ON A.QuestionResponseKey = D.survey_response_key
								
						WHERE	A.ResponseCount = 1
								AND A.current_indicator = 1
								AND B.current_indicator = 1
								AND C.current_indicator = 1
								AND D.current_indicator = 1
								
						GROUP BY A.OrganizationSurveyKey,
							C.organization_key,
							D.survey_question_key,
							A.batch_key,
							A.GivenDateKey,
							A.current_indicator
						) B
						ON E.OrganizationSurveyKey = B.OrganizationSurveyKey
							AND E.AssociationKey = B.AssociationKey
							AND E.SurveyQuestionKey = B.SurveyQuestionKey
							AND E.batch_key = B.batch_key
							AND E.GivenDateKey = B.GivenDateKey
							AND E.current_indicator = B.current_indicator
				) A
				INNER JOIN Seer_MDM.dbo.Survey_Response C
					ON A.OrganizationSurveyKey = C.survey_form_key
						AND A.SurveyQuestionKey = C.survey_question_key
						AND A.QuestionResponseKey = C.survey_response_key
				INNER JOIN Seer_MDM.dbo.Survey_Question D
					ON C.survey_form_key = D.survey_form_key
						AND C.survey_question_key = D.survey_question_key
					
		--Filter Condition added for Performance		
		WHERE	A.OrganizationSurveyKey IN	(SELECT	survey_form_key
											FROM	Seer_MDM.dbo.Survey_Form
											)
				AND A.current_indicator = 1
				AND C.current_indicator = 1
				AND D.current_indicator = 1;

		SELECT	B.AssociationKey,
				B.QuestionResponseKey as AssociationResponseKey,
				B.SurveyFormKey,
				B.SurveyQuestionKey,
				B.QuestionResponseKey,
				B.batch_key,
				B.GivenDateKey,
				C.change_datetime,
				C.next_change_datetime,
				B.current_indicator,
				B.ResponseCount,
				ResponsePercentage = dbo.RoundToZero(CASE WHEN B.percentage_denominator = 'Survey'
															THEN CONVERT(DECIMAL(19, 6), B.ResponseCount)/B.SurveyCount
														ELSE
															CASE WHEN COALESCE(B.exclude_from_report_calculation,'N') = 'Y' 
																THEN CONVERT(DECIMAL(19, 6), B.ResponseCount)/B.SurveyCount
															ELSE CONVERT(DECIMAL(19, 6), B.ResponseCount)/B.QuestionCount
															END
														END, 5),
				CONVERT(DECIMAL(19,6), 0) [ResponsePercentageZScore]
				
		INTO	#ASR
																
		FROM	#RSLTA B
				INNER JOIN Seer_MDM.dbo.Batch_Map C
					ON B.AssociationKey = C.organization_key
						AND B.batch_key = C.batch_key
						
		WHERE	C.aggregate_type = 'Association';
		
	COMMIT TRAN

	BEGIN TRAN
		IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationSurveyResponse]') AND name = N'ASR_INDEX_01')
		DROP INDEX [ASR_INDEX_01] ON [dbo].[factAssociationSurveyResponse] WITH ( ONLINE = OFF );

		CREATE INDEX ASR_INDEX_01 ON [dbo].[factAssociationSurveyResponse] ([AssociationKey], [SurveyFormKey], [SurveyQuestionKey], [GivenDateKey], [QuestionResponseKey], [ResponseCount]) ON NDXGROUP;
	COMMIT TRAN

	BEGIN TRAN
		MERGE	Seer_ODS.dbo.factAssociationSurveyResponse AS target
		USING	(
				SELECT	A.AssociationResponseKey,
						A.AssociationKey,
						A.SurveyFormKey,
						A.SurveyQuestionKey,
						A.QuestionResponseKey,
						A.batch_key,
						A.GivenDateKey,
						A.change_datetime,
						A.next_change_datetime,
						A.current_indicator,
						A.ResponseCount,
						A.ResponsePercentage,
						A.ResponsePercentageZScore
				--select	*														
				FROM	#ASR A

				) AS source
				
				ON target.AssociationKey = source.AssociationKey
					AND target.SurveyFormKey = source.SurveyFormKey
					AND target.SurveyQuestionKey = source.SurveyQuestionKey
					AND target.batch_key = source.batch_key
					AND target.GivenDateKey = source.GivenDateKey
					AND target.QuestionResponseKey = source.QuestionResponseKey
					AND target.AssociationResponseKey = source.AssociationResponseKey
					AND target.current_indicator = source.current_indicator
				
				WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
									OR target.[next_change_datetime] <> source.[next_change_datetime]
									OR target.[ResponseCount] <> source.[ResponseCount]
									OR target.[ResponsePercentage] <> source.[ResponsePercentage]
									OR target.[ResponsePercentageZScore] <> source.[ResponsePercentageZScore]
								)
			THEN
				UPDATE	
				SET		[current_indicator]	 = 	0,
						[next_change_datetime] = source.next_change_datetime
							
		WHEN NOT MATCHED BY target AND
			(1 = 1
			)
			THEN 
				INSERT ([AssociationResponseKey],
						[AssociationKey],
						[SurveyFormKey],
						[SurveyQuestionKey],
						[QuestionResponseKey],
						[batch_key],
						[GivenDateKey],
						[change_datetime],
						[next_change_datetime],
						[current_indicator],
						[ResponseCount],
						[ResponsePercentage],
						[ResponsePercentageZScore]
						)
				VALUES ([AssociationResponseKey],
						[AssociationKey],
						[SurveyFormKey],
						[SurveyQuestionKey],
						[QuestionResponseKey],
						[batch_key],
						[GivenDateKey],
						[change_datetime],
						[next_change_datetime],
						[current_indicator],
						[ResponseCount],
						[ResponsePercentage],
						[ResponsePercentageZScore]
						)		
		;
	COMMIT TRAN

	BEGIN TRAN
		MERGE	Seer_ODS.dbo.factAssociationSurveyResponse AS target
		USING	(
				SELECT	A.AssociationResponseKey,
						A.AssociationKey,
						A.SurveyFormKey,
						A.SurveyQuestionKey,
						A.QuestionResponseKey,
						A.batch_key,
						A.GivenDateKey,
						A.change_datetime,
						A.next_change_datetime,
						A.current_indicator,
						A.ResponseCount,
						A.ResponsePercentage,
						A.ResponsePercentageZScore
															
				FROM	#ASR A

				) AS source
				
				ON target.AssociationKey = source.AssociationKey
					AND target.SurveyFormKey = source.SurveyFormKey
					AND target.SurveyQuestionKey = source.SurveyQuestionKey
					AND target.batch_key = source.batch_key
					AND target.GivenDateKey = source.GivenDateKey
					AND target.QuestionResponseKey = source.QuestionResponseKey
					AND target.AssociationResponseKey = source.AssociationResponseKey
					AND target.current_indicator = source.current_indicator
							
		WHEN NOT MATCHED BY target AND
			(1 = 1
			)
			THEN 
				INSERT ([AssociationResponseKey],
						[AssociationKey],
						[SurveyFormKey],
						[SurveyQuestionKey],
						[QuestionResponseKey],
						[batch_key],
						[GivenDateKey],
						[change_datetime],
						[next_change_datetime],
						[current_indicator],
						[ResponseCount],
						[ResponsePercentage],
						[ResponsePercentageZScore]
						)
				VALUES ([AssociationResponseKey],
						[AssociationKey],
						[SurveyFormKey],
						[SurveyQuestionKey],
						[QuestionResponseKey],
						[batch_key],
						[GivenDateKey],
						[change_datetime],
						[next_change_datetime],
						[current_indicator],
						[ResponseCount],
						[ResponsePercentage],
						[ResponsePercentageZScore]
						)
		;
	COMMIT TRAN

	BEGIN TRAN
		IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationSurveyResponse]') AND name = N'ASR_INDEX_01')
		DROP INDEX [ASR_INDEX_01] ON [dbo].[factAssociationSurveyResponse] WITH ( ONLINE = OFF );
		
		DROP TABLE #RSLTA;
		DROP TABLE #ASR;
	COMMIT TRAN
END