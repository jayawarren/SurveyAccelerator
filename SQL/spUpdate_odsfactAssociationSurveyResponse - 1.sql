/*
drop proc spUpdate_odsfactAssociationSurveyResponse
update dbo.factAssociationSurveyResponse
set current_indicator = 1,
	next_change_datetime = DATEADD(YY, 100, change_datetime)
where current_indicator = 0
*/
CREATE PROCEDURE spUpdate_odsfactAssociationSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
SELECT	asr.AssociationSurveyResponseKey,
		asr.change_datetime,
		asr.current_indicator,
		asr.ResponsePercentage,
		osr.AvgAssociationResponsePercentage,
		osr.StdDevAssociationResponsePercentage,
		case when osr.StdDevAssociationResponsePercentage = 0 then 0.0000
			else CONVERT(DECIMAL(19, 6), (asr.ResponsePercentage - osr.AvgAssociationResponsePercentage))/osr.StdDevAssociationResponsePercentage
		end ZScore

INTO	#UASR
		
FROM	dbo.factAssociationSurveyResponse asr
		INNER JOIN dimAssociation db
			ON asr.AssociationKey = db.AssociationKey
		INNER JOIN dimSurveyQuestion dq
			ON asr.SurveyFormKey = dq.SurveyFormKey
				AND asr.SurveyQuestionKey = dq.SurveyQuestionKey
		INNER JOIN dimQuestionResponse dqr
			ON asr.SurveyQuestionKey = dqr.SurveyQuestionKey
				AND asr.QuestionResponseKey = dqr.QuestionResponseKey
		INNER JOIN Seer_MDM.dbo.Survey_Form sf
			ON asr.SurveyFormKey = sf.survey_form_key
		INNER JOIN factOrganizationSurveyResponse osr
			ON sf.survey_type = osr.SurveyType
				AND dq.QuestionKey = osr.QuestionKey
				AND db.OrganizationKey = osr.OrganizationKey
				AND CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4)) - 1 = osr.Year
		INNER JOIN Seer_MDM.dbo.Survey_Response sr
			ON osr.ResponseKey = sr.survey_response_key
				AND dqr.ResponseCode = sr.response_code
				AND dqr.ResponseText = sr.response_text
				
WHERE	asr.current_indicator = 1
		AND sf.current_indicator = 1
		AND sr.current_indicator = 1


COMMIT TRAN
BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationSurveyResponse AS target
	USING	(
			SELECT	A.AssociationSurveyResponseKey,
					A.change_datetime,
					A.current_indicator,
					A.ZScore ResponsePercentageZScore
											
			FROM	#UASR A

			) AS source
			
			ON target.AssociationSurveyResponseKey = source.AssociationSurveyResponseKey
			
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
	MERGE	Seer_ODS.dbo.factAssociationSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.current_indicator,
					A.AssociationSurveyResponseKey,
					B.AssociationResponseKey,
					B.AssociationKey,
					B.SurveyFormKey,
					B.SurveyQuestionKey,
					B.QuestionResponseKey,
					B.GivenDateKey,
					B.ResponseCount,
					B.ResponsePercentage,
					A.ZScore ResponsePercentageZScore
											
			FROM	#UASR A
					INNER JOIN Seer_ODS.dbo.factAssociationSurveyResponse B
						ON A.AssociationSurveyResponseKey = B.AssociationSurveyResponseKey

			) AS source
			
			ON target.AssociationSurveyResponseKey = source.AssociationSurveyResponseKey
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationResponseKey],
					[SurveyFormKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[GivenDateKey],
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationResponseKey],
					[SurveyFormKey],
					[SurveyQuestionKey],
					[QuestionResponseKey],
					[GivenDateKey],
					[ResponseCount],
					[ResponsePercentage],
					[ResponsePercentageZScore]
					)
	;
COMMIT TRAN
END