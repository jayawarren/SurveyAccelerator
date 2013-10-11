/*
truncate table Seer_ODS.dbo.factBranchSurveyResponse
drop procedure spPopulate_odsfactBranchSurveyResponse
SELECT * FROM Seer_ODS.dbo.factBranchSurveyResponse
*/
CREATE PROCEDURE spPopulate_odsfactBranchSurveyResponse AS
BEGIN

	DECLARE @change_datetime datetime
	DECLARE @next_change_datetime datetime
	SET @change_datetime = getdate()
	SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

	BEGIN TRAN
		SELECT	A.OrganizationSurveyKey,
				A.BranchKey,
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
				
		INTO	#RSLT
												
		FROM	(
				SELECT	E.OrganizationSurveyKey,
						E.BranchKey,
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
								A.BranchKey,
								A.SurveyQuestionKey,
								A.QuestionResponseKey,
								A.batch_key,
								A.GivenDateKey,
								A.current_indicator,
								COUNT(*) ResponseCount
							
						FROM	Seer_ODS.dbo.factMemberSurveyResponse A
						
						WHERE	A.ResponseCount = 1
								AND A.current_indicator = 1

						GROUP BY A.OrganizationSurveyKey,
								A.BranchKey,
								A.SurveyQuestionKey,
								A.batch_key,
								A.GivenDateKey,
								A.QuestionResponseKey,
								A.current_indicator
						) E
						INNER JOIN
						(SELECT	A.OrganizationSurveyKey,
								A.BranchKey,
								B.survey_question_key SurveyQuestionKey,
								A.batch_key,
								A.GivenDateKey,
								A.current_indicator,
								SUM(CASE WHEN COALESCE(B.exclude_from_report_calculation,'N') = 'Y' THEN 0
										ELSE A.ResponseCount
									END
									) AS QuestionCount,
								SUM(A.ResponseCount) AS SurveyCount
						
						FROM	Seer_ODS.dbo.factMemberSurveyResponse A
								INNER JOIN Seer_MDM.dbo.Survey_Response B
									ON A.QuestionResponseKey = B.survey_response_key
								
						WHERE	A.current_indicator = 1
								AND B.current_indicator = 1
								
						GROUP BY A.OrganizationSurveyKey,
							A.BranchKey,
							B.survey_question_key,
							A.batch_key,
							A.GivenDateKey,
							A.current_indicator
						) B
						ON E.OrganizationSurveyKey = B.OrganizationSurveyKey
							AND E.BranchKey = B.BranchKey
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

		SELECT	distinct
				B.BranchKey,
				B.QuestionResponseKey as BranchResponseKey,
				B.OrganizationSurveyKey,
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
				
		INTO	#BSR
																
		FROM	#RSLT B
				INNER JOIN Seer_MDM.dbo.Batch_Map C
					ON B.BranchKey = C.organization_key
						AND B.batch_key = C.batch_key
						
		WHERE	C.aggregate_type = 'Branch';
		
	COMMIT TRAN

	BEGIN TRAN
		IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factBranchSurveyResponse]') AND name = N'BSR_INDEX_01')
		DROP INDEX [BSR_INDEX_01] ON [dbo].[factBranchSurveyResponse] WITH ( ONLINE = OFF );

		CREATE INDEX BSR_INDEX_01 ON [dbo].[factBranchSurveyResponse] ([BranchKey], [OrganizationSurveyKey], [SurveyQuestionKey], [GivenDateKey], [QuestionResponseKey], [ResponseCount]) ON NDXGROUP;
	COMMIT TRAN

	BEGIN TRAN
		MERGE	Seer_ODS.dbo.factBranchSurveyResponse AS target
		USING	(
				SELECT	A.BranchResponseKey,
						A.BranchKey,
						A.OrganizationSurveyKey,
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
				FROM	#BSR A

				) AS source
				
				ON target.BranchKey = source.BranchKey
					AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
					AND target.SurveyQuestionKey = source.SurveyQuestionKey
					AND target.batch_key = source.batch_key
					AND target.GivenDateKey = source.GivenDateKey
					AND target.QuestionResponseKey = source.QuestionResponseKey
					AND target.BranchResponseKey = source.BranchResponseKey
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
				INSERT ([BranchResponseKey],
						[BranchKey],
						[OrganizationSurveyKey],
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
				VALUES ([BranchResponseKey],
						[BranchKey],
						[OrganizationSurveyKey],
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
		MERGE	Seer_ODS.dbo.factBranchSurveyResponse AS target
		USING	(
				SELECT	A.BranchResponseKey,
						A.BranchKey,
						A.OrganizationSurveyKey,
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
															
				FROM	#BSR A

				) AS source
				
				ON target.BranchKey = source.BranchKey
					AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
					AND target.SurveyQuestionKey = source.SurveyQuestionKey
					AND target.batch_key = source.batch_key
					AND target.GivenDateKey = source.GivenDateKey
					AND target.QuestionResponseKey = source.QuestionResponseKey
					AND target.BranchResponseKey = source.BranchResponseKey
					AND target.current_indicator = source.current_indicator
							
		WHEN NOT MATCHED BY target AND
			(1 = 1
			)
			THEN 
				INSERT ([BranchResponseKey],
						[BranchKey],
						[OrganizationSurveyKey],
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
				VALUES ([BranchResponseKey],
						[BranchKey],
						[OrganizationSurveyKey],
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
		IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factBranchSurveyResponse]') AND name = N'BSR_INDEX_01')
		DROP INDEX [BSR_INDEX_01] ON [dbo].[factBranchSurveyResponse] WITH ( ONLINE = OFF );
		
		DROP TABLE #RSLT;
		DROP TABLE #BSR;
	COMMIT TRAN
END