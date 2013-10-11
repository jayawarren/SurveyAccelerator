/*
truncate table Seer_ODS.dbo.factAssociationSurveyResponse
drop procedure spPopulate_odsfactAssociationSurveyResponse
SELECT * FROM Seer_ODS.dbo.factAssociationSurveyResponse
*/
CREATE PROCEDURE spPopulate_odsfactAssociationSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	distinct
			E.QuestionResponseKey AssociationResponseKey,
			B.AssociationKey,
			B.SurveyFormKey,
			B.SurveyQuestionKey,
			E.QuestionResponseKey,
			B.batch_key,
			B.GivenDateKey,
			E.current_indicator,
			E.ResponseCount,
			ResponsePercentage = dbo.RoundToZero(CASE WHEN D.percentage_denominator = 'Survey'
														THEN CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
													ELSE
														CASE WHEN COALESCE(C.exclude_from_report_calculation,'N') = 'Y' 
															THEN CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
														ELSE CONVERT(DECIMAL(19, 6), E.ResponseCount)/CONVERT(DECIMAL(19, 6), B.QuestionCount)
														END
													END, 5),
			CONVERT(DECIMAL(19, 6), 0) [ResponsePercentageZScore]
	
	INTO	#ASR
	--SELECT	*										
	FROM	(
			SELECT	C.AssociationKey,
					A.OrganizationSurveyKey SurveyFormKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.QuestionResponseKey,
					A.current_indicator,
					SUM(A.ResponseCount) ResponseCount
				
			FROM	Seer_ODS.dbo.factBranchSurveyResponse A
					INNER JOIN
					(
					SELECT	A.organization_key BranchKey,
							B.organization_key AssociationKey,
							A.association_number,
							A.official_branch_number
							
					FROM	Seer_MDM.dbo.Organization A
							INNER JOIN
							(
							SELECT	B.organization_key,
									B.association_number
							FROM	Seer_MDM.dbo.Organization B
							WHERE	B.association_number = B.official_branch_number
							) B
							ON A.association_number = B.association_number
					) C
					ON A.BranchKey = C.BranchKey
					
			--Filter Condition added for Performance		
			WHERE	A.OrganizationSurveyKey IN (SELECT	survey_form_key
												FROM	Seer_MDM.dbo.Survey_Form
												)

			GROUP BY C.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.QuestionResponseKey,
					A.current_indicator
			) E
			INNER JOIN Seer_MDM.dbo.Survey_Response C
			ON E.QuestionResponseKey = C.survey_response_key
				AND E.SurveyQuestionKey = C.survey_question_key
			INNER JOIN
			(
			SELECT	C.AssociationKey,
					A.OrganizationSurveyKey SurveyFormKey,
					B.survey_question_key SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					SUM(CASE WHEN COALESCE(B.exclude_from_report_calculation,'N') = 'Y' THEN 0
							ELSE A.ResponseCount
						END
						) AS QuestionCount,
					SUM(A.ResponseCount) AS SurveyCount
			
			FROM	Seer_ODS.dbo.factBranchSurveyResponse A
					INNER JOIN Seer_MDM.dbo.Survey_Response B
					ON A.QuestionResponseKey = B.survey_response_key
						AND A.SurveyQuestionKey = B.survey_question_key
					INNER JOIN
					(
					SELECT	A.organization_key BranchKey,
							B.organization_key AssociationKey,
							A.association_number,
							A.official_branch_number
							
					FROM	Seer_MDM.dbo.Organization A
							INNER JOIN
							(
							SELECT	B.organization_key,
									B.association_number
							FROM	Seer_MDM.dbo.Organization B
							WHERE	B.association_number = B.official_branch_number
							) B
							ON A.association_number = B.association_number
					) C
					ON A.BranchKey = C.BranchKey
			
			--Filter Condition added for Performance		
			WHERE	A.OrganizationSurveyKey IN (SELECT	survey_form_key
												FROM	Seer_MDM.dbo.Survey_Form
												)
					
			GROUP BY C.AssociationKey,
				A.OrganizationSurveyKey,
				B.survey_question_key,
				A.batch_key,
				A.GivenDateKey,
				A.current_indicator
			) B
				ON E.AssociationKey = B.AssociationKey
					AND E.SurveyFormKey = B.SurveyFormKey
					AND E.SurveyQuestionKey = B.SurveyQuestionKey
					AND E.batch_key = B.batch_key
					AND E.GivenDateKey = B.GivenDateKey
					AND E.current_indicator = B.current_indicator
			INNER JOIN Seer_MDM.dbo.Survey_Question D
				ON B.SurveyQuestionKey = D.survey_question_key
			
	--Filter Condition added for Performance		
	WHERE	B.SurveyFormKey IN (SELECT	survey_form_key
								FROM	Seer_MDM.dbo.Survey_Form
								)
			AND B.current_indicator = 1
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
			INSERT ([AssociationResponseKey],
					[AssociationKey],
					[SurveyFormKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[batch_key],
					[GivenDateKey],
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
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationResponseKey,
					A.AssociationKey,
					A.SurveyFormKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
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
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationResponseKey],
					[AssociationKey],
					[SurveyFormKey],
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
					[AssociationResponseKey],
					[AssociationKey],
					[SurveyFormKey],
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
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationSurveyResponse]') AND name = N'ASR_INDEX_01')
	DROP INDEX [ASR_INDEX_01] ON [dbo].[factAssociationSurveyResponse] WITH ( ONLINE = OFF );

	DROP TABLE #ASR;
COMMIT TRAN
END