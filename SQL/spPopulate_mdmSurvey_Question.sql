/*
drop procedure spPopulate_mdmSurvey_Question
truncate table Seer_MDM.dbo.Survey_Question
truncate table Seer_CTRL.dbo.[Survey Questions]
select * from Seer_CTRL.dbo.[Survey Questions]
*/
CREATE PROCEDURE spPopulate_mdmSurvey_Question AS
BEGIN
	MERGE	Seer_MDM.dbo.Survey_Question AS target
	USING	(
			SELECT	B.survey_form_key,
					C.question_key,
					C.question,
					C.short_question,
					--A.[SurveyType] survey_type,
					--A.[Description] description,
					A.[QuestionNumber] question_number,
					A.[PercentageDenominator] percentage_denominator,
					A.[SurveyColumn] survey_column,
					A.[SurveyOpenEndColumn] survey_open_end_column
					
			 FROM	Seer_STG.dbo.[Survey Questions] A
					INNER JOIN Seer_MDM.dbo.Survey_Form B
						ON A.SurveyType = B.survey_type
							AND A.Description = B.description
					INNER JOIN Seer_MDM.dbo.Question C
						ON RTRIM(REPLACE(A.[Question], '"', '')) = C.question
							AND RTRIM(REPLACE(A.[ShortQuestion], '"', '')) = C.short_question
			) AS source
			ON target.survey_form_key = source.survey_form_key
				AND target.question_key = source.question_key
				AND target.question_number = source.question_number
			
	WHEN MATCHED AND (target.percentage_denominator <> source.percentage_denominator
					  OR target.survey_column <> source.survey_column
					  OR target.survey_open_end_column <> source.survey_open_end_column
					 )
		THEN
			UPDATE	
			SET		percentage_denominator = source.percentage_denominator,
					survey_column = source.survey_column,
					survey_open_end_column = source.survey_open_end_column
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.question) > 0 
			 AND LEN(source.short_question) > 0
		)
		THEN 
			INSERT (survey_form_key,
					question_key,
					question_number,
					percentage_denominator,
					survey_column,
					survey_open_end_column
				    )
			VALUES (survey_form_key,
					question_key,
					question_number,
					percentage_denominator,
					survey_column,
					survey_open_end_column
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.[Survey Questions]([SurveyType],
												[Description],
												[QuestionNumber],
												[Question],
												[ShortQuestion],
												[PercentageDenominator],
												[SurveyColumn],
												[SurveyOpenEndColumn]
												)
	SELECT	A.[SurveyType],
			A.[Description],
			A.[QuestionNumber],
			A.[Question],
			A.[ShortQuestion],
			A.[PercentageDenominator],
			A.[SurveyColumn],
			A.[SurveyOpenEndColumn]

	FROM	Seer_STG.dbo.[Survey Questions] A
			LEFT JOIN Seer_MDM.dbo.Survey_Form B
				ON A.SurveyType = B.survey_type
					AND A.Description = B.description
			
	WHERE	LEN(A.SurveyType) = 0 
			OR LEN(A.Description) = 0
			OR B.survey_form_key IS NULL
			OR ISNUMERIC(A.QuestionNumber) = 0
			OR LEN(A.Question) = 0 
			OR LEN(A.ShortQuestion) = 0
	;
END