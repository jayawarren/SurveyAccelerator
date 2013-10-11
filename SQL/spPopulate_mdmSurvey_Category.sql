CREATE PROCEDURE spPopulate_mdmSurvey_Category AS
BEGIN
	MERGE	Seer_MDM.dbo.Survey_Category AS target
	USING	(
			SELECT	B.survey_form_key,
					C.survey_question_key,
					--A.[SurveyType] survey_type,
					--A.[Description] description,
					--A.[QuestionNumber] question_number,
					--REPLACE(A.[Question], '"', '') question,
					A.[CategoryType] category_type,
					A.[Category] category,
					A.[CategoryPosition] category_position,
					A.[QuestionPosition] question_position
					
			 FROM	Seer_STG.dbo.[Survey Categories] A
					INNER JOIN Seer_MDM.dbo.Survey_Form B
						ON A.SurveyType = B.survey_type
							AND A.Description = B.description
					INNER JOIN Seer_MDM.dbo.Survey_Question C
						ON B.survey_form_key = C.survey_form_key
							AND A.QuestionNumber = C.question_number
			) AS source
			ON target.survey_form_key = source.survey_form_key
				AND target.survey_question_key = source.survey_question_key
			
	WHEN MATCHED AND (target.category_type <> source.category_type
					  OR target.category <> source.category
					  OR target.category_position <> source.category_position
					  OR target.question_position <> source.question_position
					 )
		THEN
			UPDATE	
			SET		category_type = source.category_type,
					category = source.category,
					category_position = source.category_position,
					question_position = source.question_position
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.category_type) > 0 
			 AND LEN(source.category) > 0
			 AND ISNUMERIC(source.category_position) = 1
			 AND ISNUMERIC(source.question_position) = 1
		)
		THEN 
			INSERT (survey_form_key,
					survey_question_key,
					category_type,
					category,
					category_position,
					question_position
				    )
			VALUES (survey_form_key,
					survey_question_key,
					category_type,
					category,
					category_position,
					question_position
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.[Survey Categories]([SurveyType],
													[Description],
													[QuestionNumber],
													[Question],
													[CategoryType],
													[Category],
													[CategoryPosition],
													[QuestionPosition]
												)
	SELECT	A.[SurveyType],
			A.[Description],
			A.[QuestionNumber],
			REPLACE(A.[Question], '"', '') Question,
			A.[CategoryType],
			A.[Category],
			A.[CategoryPosition],
			A.[QuestionPosition]
					
	FROM	Seer_STG.dbo.[Survey Categories] A
			LEFT JOIN Seer_MDM.dbo.Survey_Form B
				ON A.SurveyType = B.survey_type
					AND A.Description = B.description
			LEFT JOIN Seer_MDM.dbo.Survey_Question C
				ON B.survey_form_key = C.survey_form_key
					AND A.QuestionNumber = C.question_number
			
	WHERE	LEN(A.SurveyType) = 0 
			OR LEN(A.Description) = 0
			OR LEN(A.CategoryType) = 0 
			OR LEN(A.category) = 0
			OR ISNUMERIC(A.CategoryPosition) = 0
			OR ISNUMERIC(A.QuestionPosition) = 0
			OR B.survey_form_key IS NULL
			OR C.survey_question_key IS NULL
	;
END