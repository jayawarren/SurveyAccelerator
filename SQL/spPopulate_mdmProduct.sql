CREATE PROCEDURE spPopulate_mdmProduct AS
BEGIN
	MERGE	Seer_MDM.dbo.Product AS target
	USING	(
			SELECT	A.[SourceID] source_id,
					COALESCE(B.[Category], '') category,
					A.[Number] number,
					COALESCE(B.[Code], '') code,
					A.[Acronym] acronym,
					A.[Description] description,
					A.[Enabled] enabled,
					A.[ListPrice] list_price,
					COALESCE(B.[ProgramType], '') program_type,
					COALESCE(B.[SurveysOrderedFlag], '') surveys_ordered_flag,
					COALESCE(B.[SurveySampleFlag], '') survey_sample_flag
					
			 FROM	Seer_STG.dbo.Product A
					LEFT JOIN Seer_STG.dbo.[Product Categories] B
						ON A.Number = B.Code
			) AS source
			ON target.number = source.number
			
	WHEN MATCHED AND (target.enabled	 <> 	source.enabled
						OR	target.acronym	 <> 	source.acronym
						OR	target.list_price	 <> 	source.list_price
						OR	target.description	 <> 	source.description
						OR	target.source_id	 <> 	source.source_id
						OR	target.category	 <> 	source.category
						OR	target.code	 <> 	source.code
						OR	target.program_type	 <> 	source.program_type
						OR	target.surveys_ordered_flag	 <> 	source.surveys_ordered_flag
						OR  target.survey_sample_flag <> source.survey_sample_flag
					 )
		THEN
			UPDATE	
			SET		target.enabled	 = 	source.enabled,
					target.acronym	 = 	source.acronym,
					target.list_price	 = 	source.list_price,
					target.description	 =	source.description,
					target.source_id	 =	source.source_id,
					target.category	 = 	source.category,
					target.code	 = 	source.code,
					target.program_type	 = 	source.program_type,
					target.surveys_ordered_flag	 = 	source.surveys_ordered_flag,
					target.survey_sample_flag = source.survey_sample_flag
			
	WHEN NOT MATCHED BY target AND
		(LEN(source.number) > 0 
		 AND LEN(source.code) > 0
		 AND ISNUMERIC(source.list_price) = 1
		 AND (source.category NOT LIKE '%Program%'
				OR
				(source.category LIKE '%Program%' AND LEN(source.program_type) > 0)
			  )
		)
		THEN 
			INSERT (number,
					enabled,
					acronym,
					list_price,
					description,
					source_id,
					category,
					code,
					program_type,
					surveys_ordered_flag,
					survey_sample_flag
				    )
			VALUES (number,
					enabled,
					acronym,
					list_price,
					description,
					source_id,
					category,
					code,
					program_type,
					surveys_ordered_flag,
					survey_sample_flag
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.Product(Number,
										Enabled,
										Acronym,
										ListPrice,
										Description,
										SourceID
									 )
	SELECT	Number,
			Enabled,
			Acronym,
			ListPrice,
			Description,
			SourceID
			
	FROM	Seer_STG.dbo.[Product] A
			LEFT JOIN Seer_STG.dbo.[Product Categories] B
				ON A.Number = B.Code

	WHERE	(LEN(Number) = 0 
			AND ISNUMERIC(ListPrice) = 0
			AND B.Code IS NOT NULL
			)
			OR
			B.Code IS NULL
			
	GROUP BY Number,
			Enabled,
			Acronym,
			ListPrice,
			Description,
			SourceID
	;
	
	INSERT INTO Seer_CTRL.dbo.[Product Categories] (Category,
													Code,
													ProgramType,
													SurveysOrderedFlag,
													SurveySampleFlag
													)
	SELECT	COALESCE(B.[Category], '') Catgory,
			COALESCE(B.[Code], '') Code,
			COALESCE(B.[ProgramType], '') ProgramType,
			COALESCE(B.[SurveysOrderedFlag], '') SurveysOrderedFlag,
			COALESCE(B.[SurveySampleFlag], '') SurveySampleFlag
					
	FROM	Seer_STG.dbo.Product A
			LEFT JOIN Seer_STG.dbo.[Product Categories] B
				ON A.Number = B.Code
				
	WHERE	B.[Code] IS NOT NULL
			AND
			(LEN(COALESCE(B.[Category], '')) = 0
				OR
				(
				B.[Category] LIKE '%Program%' AND LEN(B.[ProgramType]) = 0
				)
			)
				
	GROUP BY COALESCE(B.[Category], ''),
			COALESCE(B.[Code], ''),
			COALESCE(B.[ProgramType], ''),
			COALESCE(B.[SurveysOrderedFlag], ''),
			COALESCE(B.[SurveySampleFlag], '')
END