/*
drop procedure spPopulate_mdmSurvey_Response
truncate table Seer_MDM.dbo.Survey_Response
truncate table Seer_CTRL.dbo.[Survey Responses]
*/
CREATE PROCEDURE spPopulate_mdmSurvey_Response AS
BEGIN
	MERGE	Seer_MDM.dbo.Survey_Response AS target
	USING	(
			SELECT	B.survey_form_key,
					C.survey_question_key,
					--A.[SurveyType] survey_type,
					--A.[Description] description,
					A.[QuestionNumber] question_number,
					REPLACE(A.[Question], '"', '') question,
					CASE WHEN LEN(A.[ResponseCode]) = 1 THEN '0' + A.[ResponseCode]
						ELSE A.[ResponseCode]
					END response_code,
					REPLACE(A.[ResponseText], '"', '') response_text,
					COALESCE(REPLACE(A.[CategoryCode], 'NULL', ''), '') category_code,
					COALESCE(REPLACE(A.[Category], 'NULL', ''), '') category,
					A.[IncludeInPyramidCalculation] include_in_pyramid_calculation,
					A.[ExcludeFromReportCalculation] exclude_from_report_calculation
					
			 FROM	Seer_STG.dbo.[Survey Responses] A
					INNER JOIN Seer_MDM.dbo.Survey_Form B
						ON A.SurveyType = B.survey_type
							AND A.Description = B.description
					INNER JOIN Seer_MDM.dbo.Survey_Question C
						ON B.survey_form_key = C.survey_form_key
							AND A.[QuestionNumber] = C.question_number
			) AS source
			ON target.survey_form_key = source.survey_form_key
				AND target.survey_question_key = source.survey_question_key
			
	WHEN MATCHED AND (target.response_code <> source.response_code
					  OR target.response_text <> source.response_text
					  OR target.category_code <> source.category_code
					  OR target.category <> source.category
					  OR target.include_in_pyramid_calculation <> source.include_in_pyramid_calculation
					  OR target.exclude_from_report_calculation <> source.exclude_from_report_calculation
					 )
		THEN
			UPDATE	
			SET		response_code = source.response_code,
					response_text = source.response_text,
					category_code = source.category_code,
					category = source.category,
					include_in_pyramid_calculation = source.include_in_pyramid_calculation,
					exclude_from_report_calculation = source.exclude_from_report_calculation
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.response_code) > 0 
			 AND LEN(source.response_text) > 0
		)
		THEN 
			INSERT (survey_form_key,
					survey_question_key,
					response_code,
					response_text,
					category_code,
					category,
					include_in_pyramid_calculation,
					exclude_from_report_calculation
				    )
			VALUES (survey_form_key,
					survey_question_key,
					response_code,
					response_text,
					category_code,
					category,
					include_in_pyramid_calculation,
					exclude_from_report_calculation
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.[Survey Responses]([SurveyType],
												 [Description],
												 [QuestionNumber],
												 [Question],
												 [ResponseCode],
												 [ResponseText],
												 [CategoryCode],
												 [Category],
												 [IncludeInPyramidCalculation],
												 [ExcludeFromReportCalculation]
												)
	SELECT	--B.survey_form_key,
			--C.survey_question_key,
			A.[SurveyType],
			A.[Description],
			A.[QuestionNumber],
			REPLACE(A.[Question], '"', '') Question,
			CASE WHEN LEN(A.[ResponseCode]) = 1 THEN '0' + A.[ResponseCode]
				ELSE A.[ResponseCode]
			END response_code,
			REPLACE(A.[ResponseText], '"', '') ResponseText,
			COALESCE(REPLACE(A.[CategoryCode], 'NULL', ''), '') CategoryCode,
			COALESCE(REPLACE(A.[Category], 'NULL', ''), '') Category,
			A.[IncludeInPyramidCalculation],
			A.[ExcludeFromReportCalculation]
			
	FROM	Seer_STG.dbo.[Survey Responses] A
			LEFT JOIN Seer_MDM.dbo.Survey_Form B
				ON A.SurveyType = B.survey_type
					AND A.Description = B.description
			LEFT JOIN Seer_MDM.dbo.Survey_Question C
				ON B.survey_form_key = C.survey_form_key
					AND A.[QuestionNumber] = C.question_number
			
	WHERE	LEN(A.SurveyType) = 0 
			OR LEN(A.Description) = 0
			OR B.survey_form_key IS NULL
			OR C.survey_question_key IS NULL
			OR ISNUMERIC(A.QuestionNumber) = 0
			OR LEN(A.ResponseCode) = 0 
			OR LEN(A.ResponseText) = 0
	;
END