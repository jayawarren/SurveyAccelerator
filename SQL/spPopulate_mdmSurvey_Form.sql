CREATE PROCEDURE spPopulate_mdmSurvey_Form AS
BEGIN
	MERGE	Seer_MDM.dbo.Survey_Form AS target
	USING	(
			SELECT	[SurveyType] survey_type,
					[Description] description,
					[CurrentFormFlag] current_form_flag,
					[SurveyFormId] survey_form_code,
					[SurveyLanguage] survey_language,
					[SurveyCutoffDays] survey_cut_off_days,
					[ProductCategory] product_category,
					REPLACE(REPLACE(RTRIM(SUBSTRING([ProductCategory], 1, CHARINDEX(' ', [ProductCategory]))), 'New', 'New Member'), 'Employee', 'Staff') module
						
			 FROM	Seer_STG.dbo.[Survey Forms]
			) AS source
			ON target.survey_type = source.survey_type
				AND target.description = source.description
			
	WHEN MATCHED AND (target.current_form_flag <> source.current_form_flag
					  OR target.survey_form_code <> source.survey_form_code
					  OR target.survey_language <> source.survey_language
					  OR target.survey_cut_off_days <> source.survey_cut_off_days
					  OR target.product_category <> source.product_category
					  OR target.module <> source.module
					 )
		THEN
			UPDATE	
			SET		current_form_flag = source.current_form_flag,
					survey_form_code = source.survey_form_code,
					survey_language = source.survey_language,
					survey_cut_off_days = source.survey_cut_off_days,
					product_category = source.product_category,
					module = source.module
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.survey_type) > 0 
			 AND LEN(source.description) > 0
		)
		THEN 
			INSERT (survey_type,
					description,
					current_form_flag,
					survey_form_code,
					survey_language,
					survey_cut_off_days,
					product_category,
					module
				    )
			VALUES (survey_type,
					description,
					current_form_flag,
					survey_form_code,
					survey_language,
					survey_cut_off_days,
					product_category,
					module
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.[Survey Forms]   ([SurveyType],
												[Description],
												[CurrentFormFlag],
												[SurveyFormId],
												[SurveyLanguage],
												[SurveyCutoffDays],
												[ProductCategory]
												)
	SELECT	[SurveyType],
			[Description],
			[CurrentFormFlag],
			[SurveyFormId],
			[SurveyLanguage],
			[SurveyCutoffDays],
			[ProductCategory]

	FROM	Seer_STG.dbo.[Survey Forms]
			
	WHERE	LEN(SurveyType) = 0 
			OR LEN(Description) = 0
	;
END