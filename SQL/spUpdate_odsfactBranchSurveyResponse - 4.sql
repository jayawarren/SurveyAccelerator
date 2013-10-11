/*
drop proc spUpdate_odsfactBranchSurveyResponse
*/
CREATE PROCEDURE spUpdate_odsfactBranchSurveyResponse AS
BEGIN
	DECLARE @change_datetime datetime
	DECLARE @next_change_datetime datetime
	SET @change_datetime = getdate()
	SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

	BEGIN TRAN
		SELECT	bsr.BranchSurveyResponseKey,
				bsr.change_datetime,
				bsr.current_indicator,
				case when osr.StdDevBranchResponsePercentage = 0 then 0.0000
					else CONVERT(DECIMAL(19, 6), (bsr.ResponsePercentage - osr.AvgBranchResponsePercentage))/osr.StdDevBranchResponsePercentage
				end ZScore

		INTO	#UBSR
				
		FROM	dbo.factBranchSurveyResponse bsr
				INNER JOIN dimBranch db
					ON bsr.BranchKey = db.BranchKey
				INNER JOIN dimSurveyQuestion dq
					ON bsr.OrganizationSurveyKey = dq.SurveyFormKey
						AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
				INNER JOIN dimQuestionResponse dqr
					ON bsr.SurveyQuestionKey = dqr.SurveyQuestionKey
						AND bsr.QuestionResponseKey = dqr.QuestionResponseKey
				INNER JOIN factOrganizationSurveyResponse osr
					ON bsr.OrganizationSurveyKey = osr.SurveyFormKey
					AND dqr.ResponseKey = osr.ResponseKey
					AND dq.QuestionKey = osr.QuestionKey
					AND LEFT(bsr.GivenDateKey, 4) - 1 = osr.Year -- = dd.Year-1		

		WHERE	bsr.current_indicator = 1

		GROUP BY bsr.BranchSurveyResponseKey,
				bsr.change_datetime,
				bsr.current_indicator,
				case when osr.StdDevBranchResponsePercentage = 0 then 0.0000
					else CONVERT(DECIMAL(19, 6), (bsr.ResponsePercentage - osr.AvgBranchResponsePercentage))/osr.StdDevBranchResponsePercentage
				end 
	COMMIT TRAN

	BEGIN TRAN
		MERGE	Seer_ODS.dbo.factBranchSurveyResponse AS target
		USING	(
				SELECT	A.BranchSurveyResponseKey,
						A.change_datetime,
						A.current_indicator,
						A.ZScore ResponsePercentageZScore
												
				FROM	#UBSR A

				) AS source
				
				ON target.BranchSurveyResponseKey = source.BranchSurveyResponseKey
				
				WHEN MATCHED AND (target.[ResponsePercentageZScore] <> source.[ResponsePercentageZScore]
									)
			THEN
				UPDATE	
				SET		[current_indicator]	 = 	0,
						[next_change_datetime] = CASE WHEN DATEDIFF(HH, source.change_datetime, @next_change_datetime) > 12 THEN @next_change_datetime
														ELSE DATEADD(SS, -1, source.change_datetime)
												 END;
							
	COMMIT TRAN
	BEGIN TRAN
		MERGE	Seer_ODS.dbo.factBranchSurveyResponse AS target
		USING	(
				SELECT	@change_datetime change_datetime,
						DATEADD(YY, 100, @change_datetime) next_change_datetime,
						A.current_indicator,
						A.BranchSurveyResponseKey,
						B.BranchResponseKey,
						B.BranchKey,
						B.OrganizationSurveyKey,
						B.SurveyQuestionKey,
						B.QuestionResponseKey,
						B.batch_key,
						B.GivenDateKey,
						B.ResponseCount,
						B.ResponsePercentage,
						A.ZScore ResponsePercentageZScore
												
				FROM	#UBSR A
						INNER JOIN Seer_ODS.dbo.factBranchSurveyResponse B
							ON A.BranchSurveyResponseKey = B.BranchSurveyResponseKey

				) AS source
				
				ON target.BranchSurveyResponseKey = source.BranchSurveyResponseKey
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
END
