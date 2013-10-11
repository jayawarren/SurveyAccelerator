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
	SELECT	distinct
			A.BranchKey,
			A.MemberResponseKey as BranchResponseKey,
			A.OrganizationSurveyKey,
			A.SurveyQuestionKey,
			A.QuestionResponseKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			E.ResponseCount,
			ResponsePercentage = dbo.RoundToZero(CASE WHEN D.percentage_denominator = 'Survey'
														THEN CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
													ELSE
														CASE WHEN COALESCE(C.exclude_from_report_calculation,'N') = 'Y' 
															THEN CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
														ELSE CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.QuestionCount)
														END
													END, 5),
			CONVERT(DECIMAL(19,6), 0) [ResponsePercentageZScore]
			
	INTO	#BSR
	--select	*														
	FROM	Seer_ODS.dbo.factMemberSurveyResponse A
			INNER JOIN
			(SELECT	A.BranchKey,
					A.OrganizationSurveyKey,
					B.survey_question_key SurveyQuestionKey,
					A.GivenDateKey,
					SUM(CASE WHEN COALESCE(B.exclude_from_report_calculation,'N') = 'Y' THEN 0
							ELSE A.ResponseCount
						END
						) AS QuestionCount,
					SUM(A.ResponseCount) AS SurveyCount
			
			FROM	Seer_ODS.dbo.factMemberSurveyResponse A
					INNER JOIN Seer_MDM.dbo.Survey_Response B
						ON A.QuestionResponseKey = B.survey_response_key
					
			WHERE	A.current_indicator = 1
					
			GROUP BY A.BranchKey,
				A.OrganizationSurveyKey,
				B.survey_question_key,
				A.GivenDateKey
			) B
				ON A.BranchKey = B.BranchKey
					AND A.OrganizationSurveyKey = B.OrganizationSurveyKey
					AND A.SurveyQuestionKey = B.SurveyQuestionKey
					AND A.GivenDateKey = B.GivenDateKey
			INNER JOIN Seer_MDM.dbo.Survey_Response C
				ON A.QuestionResponseKey = C.survey_response_key
					AND A.SurveyQuestionKey = C.survey_question_key
			INNER JOIN Seer_MDM.dbo.Survey_Question D
				ON C.survey_question_key = D.survey_question_key
			INNER JOIN
			(
			SELECT	COUNT(*) ResponseCount,
					A.BranchKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.GivenDateKey
				
			FROM	Seer_ODS.dbo.factMemberSurveyResponse A
			
			WHERE	A.ResponseCount = 1
					AND A.current_indicator = 1

			GROUP BY A.BranchKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.GivenDateKey,
					A.QuestionResponseKey
			) E
			ON A.BranchKey = E.BranchKey
				AND A.OrganizationSurveyKey = E.OrganizationSurveyKey
				AND A.SurveyQuestionKey = E.SurveyQuestionKey
				AND A.GivenDateKey = E.GivenDateKey
				AND A.QuestionResponseKey = E.QuestionResponseKey
			
	--Filter Condition added for Performance		
	WHERE	A.OrganizationSurveyKey IN (SELECT	survey_form_key
										FROM	Seer_MDM.dbo.Survey_Form
										)
			AND A.current_indicator = 1;
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
			
			WHEN MATCHED AND (target.[ResponseCount] <> source.[ResponseCount]
								OR target.[ResponsePercentage] <> source.[ResponsePercentage]
								OR target.[ResponsePercentageZScore] <> source.[ResponsePercentageZScore]
							)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
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
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factBranchSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.BranchResponseKey,
					A.BranchKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
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
			INSERT ([change_datetime],
					[next_change_datetime],
					[BranchResponseKey],
					[BranchKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[BranchResponseKey],
					[BranchKey],
					[OrganizationSurveyKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)
	;
COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factBranchSurveyResponse]') AND name = N'BSR_INDEX_01')
	DROP INDEX [BSR_INDEX_01] ON [dbo].[factBranchSurveyResponse] WITH ( ONLINE = OFF );

	DROP TABLE #BSR;
COMMIT TRAN
END