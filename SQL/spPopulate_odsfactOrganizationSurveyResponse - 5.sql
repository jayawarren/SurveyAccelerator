/*
truncate table Seer_ODS.dbo.factOrganizationSurveyResponse
drop procedure spPopulate_odsfactOrganizationSurveyResponse
SELECT * FROM Seer_ODS.dbo.factOrganizationSurveyResponse
*/
CREATE PROCEDURE spPopulate_odsfactOrganizationSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.OrganizationSurveyKey,
			A.Year,
			A.OrganizationName,
			A.AssociationKey,
			A.QuestionKey,
			A.ResponseKey,
			A.AvgAssociationResponsePercentage,
			A.StdDevAssociationResponsePercentage
	
	INTO	#ASR
								
	FROM	(
			SELECT	asr.SurveyFormKey OrganizationSurveyKey,
					LEFT(asr.GivenDateKey, 4) Year,
					da.OrganizationName,
					da.AssociationKey,
					dq.QuestionKey,
					dr.ResponseKey,
					AVG(asr.ResponsePercentage) AS AvgAssociationResponsePercentage,
					CONVERT(DECIMAL(19, 6), STDEVP(asr.ResponsePercentage) OVER (PARTITION BY asr.SurveyFormKey, LEFT(asr.GivenDateKey, 4), da.AssociationKey, dq.QuestionKey)) StdDevAssociationResponsePercentage
											
			FROM 	dbo.factAssociationSurveyResponse asr
					INNER JOIN dimAssociation da
						ON asr.AssociationKey = da.AssociationKey
					INNER JOIN dimSurveyQuestion dq 
						ON asr.SurveyFormKey = dq.SurveyFormKey
							AND asr.SurveyQuestionKey = dq.SurveyQuestionKey
					INNER JOIN dimQuestionResponse dr 
						ON asr.SurveyQuestionKey = dr.SurveyQuestionKey
							AND asr.QuestionResponseKey = dr.QuestionResponseKey
					
			--Filter added for performance
			WHERE	asr.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
					AND asr.current_indicator = 1
			
			GROUP BY asr.SurveyFormKey,
					LEFT(asr.GivenDateKey, 4),
					da.OrganizationName,
					da.AssociationKey,
					dq.QuestionKey,
					dr.ResponseKey,
					asr.ResponsePercentage
			) A
			
	ORDER BY A.OrganizationSurveyKey,
			A.Year,
			A.AssociationKey;
			
	SELECT	OSR.SurveyFormKey,
			OSR.QuestionKey,
			OSR.OrganizationName,
			OSR.Year,
			SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'Y') = 'Y' THEN 0
					ELSE OSR.ResponseCount
			END) AS QuestionCount,
			SUM(OSR.ResponseCount) AS SurveyCount
			
	INTO	#OSRRSLT
			
	FROM	(
			SELECT	asr.OrganizationSurveyKey SurveyFormKey,
					dq.QuestionKey,
					dr.ResponseKey,
					asr.OrganizationName,
					LEFT(bsr.GivenDateKey, 4) Year,
					SUM(bsr.ResponseCount) ResponseCount,
					AVG(bsr.ResponsePercentage) AvgBranchResponsePercentage,
					MAX(asr.AvgAssociationResponsePercentage) AvgAssociationResponsePercentage,
					CONVERT(DECIMAL(19, 6), CASE WHEN STDEVP(bsr.ResponsePercentage) IS NULL THEN 0.000000
												ELSE STDEVP(bsr.ResponsePercentage)
											END) StdDevBranchResponsePercentage,
					MAX(asr.StdDevAssociationResponsePercentage) StdDevAssociationResponsePercentage

			FROM	dbo.factBranchSurveyResponse bsr
					inner join dimBranch db
						ON bsr.BranchKey = db.BranchKey
					INNER JOIN dimSurveyQuestion dq 
						on bsr.OrganizationSurveyKey = dq.SurveyFormKey
							AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
					INNER JOIN dimQuestionResponse dr 
						on bsr.SurveyQuestionKey = dr.SurveyQuestionKey
							AND bsr.QuestionResponseKey = dr.QuestionResponseKey
					INNER JOIN #ASR asr
						ON bsr.OrganizationSurveyKey = asr.OrganizationSurveyKey
							AND dq.QuestionKey = asr.QuestionKey
							AND dr.ResponseKey = asr.ResponseKey
							AND db.OrganizationName = asr.OrganizationName
							AND db.AssociationKey = asr.AssociationKey
							AND LEFT(bsr.GivenDateKey, 4) = asr.Year
												
			--Filter added for performance
			WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
					AND bsr.current_indicator = 1
							
			GROUP BY asr.OrganizationSurveyKey,
					dq.QuestionKey,
					dr.ResponseKey,
					asr.OrganizationName,
					LEFT(bsr.GivenDateKey, 4)
			) OSR
			LEFT OUTER JOIN
			(
			SELECT	DSF.SurveyFormKey,
					DSQ.QuestionKey,
					DQR.ResponseKey, 
					MAX(COALESCE(DQR.ExcludeFromReportCalculation,'')) AS ExcludeFromReportCalculation
					
			FROM	dimSurveyForm DSF
					INNER JOIN dimSurveyQuestion DSQ
						ON DSF.SurveyFormKey = DSQ.SurveyFormKey
					INNER JOIN dimQuestionResponse DQR
						ON DSQ.SurveyQuestionKey = DQR.SurveyQuestionKey
						
			GROUP BY DSF.SurveyFormKey,
					DSQ.QuestionKey,
					DQR.ResponseKey
			) DQR
				ON OSR.SurveyFormKey = DQR.SurveyFormKey
					AND OSR.QuestionKey = DQR.QuestionKey
					AND OSR.ResponseKey = DQR.ResponseKey
					
	--Filter added for performance
	WHERE	OSR.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
			
	GROUP BY OSR.SurveyFormKey,
			OSR.QuestionKey,
			OSR.OrganizationName,
			OSR.Year;
	
	SELECT	A.SurveyFormKey,
			A.SurveyQuestionKey,
			A.SurveyResponseKey,
			A.module,
			A.aggregate_type,
			A.SurveyYear,
			A.SurveyColumn,
			A.ResponsePercentage
			
	INTO	#TBXO
	
	FROM	(
			SELECT	D.survey_form_key SurveyFormKey,
					E.survey_question_key SurveyQuestionKey,
					F.survey_response_key SurveyResponseKey,
					A.module,
					A.aggregate_type,
					CASE WHEN DATEDIFF(MM, A.create_datetime, A.response_load_date) < 3 THEN DATEPART(YY, A.response_load_date) - 2
						ELSE DATEPART(YY, A.response_load_date) - 1
					END SurveyYear,
					E.survey_column SurveyColumn,
					RIGHT(A.measure_type, 2) ResponseCode,
					A.measure_value ResponsePercentage
					
			FROM	dbo.Top_Box A
					INNER JOIN Seer_MDM.dbo.Survey_Form D
						ON A.form_code = D.survey_form_code
					INNER JOIN Seer_MDM.dbo.Survey_Question E
						ON D.survey_form_key = E.survey_form_key
							AND (CASE WHEN LEN(A.measure_type) = 7 THEN UPPER(LEFT(A.measure_type, 4))
								ELSE UPPER(LEFT(A.measure_type, 5))
							 END
							 ) = E.survey_column
					INNER JOIN Seer_MDM.dbo.Survey_Response F
						ON	D.survey_form_key = F.survey_form_key
							AND E.survey_question_key = F.survey_question_key	
							AND RIGHT(A.measure_type, 2) = F.response_code
					INNER JOIN Seer_MDM.dbo.Batch G
						ON A.form_code = G.form_code
							AND (CASE WHEN DATEDIFF(MM, A.create_datetime, A.response_load_date) < 3 THEN DATEPART(YY, A.response_load_date) - 1
									ELSE DATEPART(YY, A.response_load_date)
								END) = LEFT(G.date_given_key, 4)

			WHERE	A.aggregate_type = 'National'
					AND A.calculation = 'average'
					--AND A.measure_value <> 0
					AND A.current_indicator = 1
					AND D.current_indicator = 1
					AND E.current_indicator = 1
					AND F.current_indicator = 1
					AND G.current_indicator = 1
					
			GROUP BY D.survey_form_key ,
					E.survey_question_key,
					F.survey_response_key,
					A.module,
					A.aggregate_type,
					CASE WHEN DATEDIFF(MM, A.create_datetime, A.response_load_date) < 3 THEN DATEPART(YY, A.response_load_date) - 2
						ELSE DATEPART(YY, A.response_load_date) - 1
					END,
					E.survey_column,
					RIGHT(A.measure_type, 2),
					A.measure_value
			) A
			
	ORDER BY A.SurveyFormKey,
			A.SurveyQuestionKey,
			A.SurveyResponseKey;
	
	SELECT	distinct
			A.SurveyFormKey,
			A.QuestionKey,
			A.ResponseKey,
			A.ResponseKey OrganizationResponseKey,
			0 OrganizationKey,
			A.OrganizationName,
			A.Year,
			E.SurveyType,
			A.ResponseCount,
			COALESCE(F.ResponsePercentage, dbo.RoundToZero(CASE WHEN COALESCE(C.PercentageDenominator,'Survey') = 'Survey' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
													ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'Y') = 'Y' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount )
															ELSE CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.QuestionCount)
														END
												END, 5)) ResponsePercentage,
			A.AvgBranchResponsePercentage,
			A.AvgAssociationResponsePercentage,
			A.StdDevBranchResponsePercentage,
			A.StdDevAssociationResponsePercentage

	INTO	#OSR
												
	FROM	(
			SELECT	asr.OrganizationSurveyKey SurveyFormKey,
					dq.QuestionKey,
					dr.ResponseKey,
					asr.OrganizationName,
					LEFT(bsr.GivenDateKey, 4) Year,
					SUM(bsr.ResponseCount) ResponseCount,
					AVG(bsr.ResponsePercentage) AvgBranchResponsePercentage,
					MAX(asr.AvgAssociationResponsePercentage) AvgAssociationResponsePercentage,
					CONVERT(DECIMAL(19, 6), STDEVP(bsr.ResponsePercentage)) StdDevBranchResponsePercentage,
					MAX(asr.StdDevAssociationResponsePercentage) StdDevAssociationResponsePercentage

			FROM	dbo.factBranchSurveyResponse bsr
					INNER JOIN dimBranch db
						ON bsr.BranchKey = db.BranchKey
					INNER JOIN dimSurveyQuestion dq 
						on bsr.OrganizationSurveyKey = dq.SurveyFormKey
							AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
					INNER JOIN dimQuestionResponse dr 
						on bsr.SurveyQuestionKey = dr.SurveyQuestionKey
							AND bsr.QuestionResponseKey = dr.QuestionResponseKey
					INNER JOIN #ASR asr
						ON bsr.OrganizationSurveyKey = asr.OrganizationSurveyKey
							AND CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), bsr.GivenDateKey), 1, 4)) = asr.Year
							AND db.OrganizationName = asr.OrganizationName
							AND db.AssociationKey = asr.AssociationKey
							AND dq.QuestionKey = asr.QuestionKey
							AND dr.ResponseKey = asr.ResponseKey
											
			--Filter added for performance
			WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
					AND bsr.current_indicator = 1
							
			GROUP BY asr.OrganizationSurveyKey,
					dq.QuestionKey,
					dr.ResponseKey,
					asr.OrganizationName,
					LEFT(bsr.GivenDateKey, 4)
			) A
			INNER JOIN dimSurveyForm E
				ON A.SurveyFormKey = E.SurveyFormKey
			INNER JOIN dimSurveyQuestion C
				ON A.SurveyFormKey = C.SurveyFormKey
				AND A.QuestionKey = C.QuestionKey
			INNER JOIN dimQuestionResponse D
				ON A.ResponseKey = D.ResponseKey
			INNER JOIN #OSRRSLT B
				ON A.SurveyFormKey = B.SurveyFormKey
					AND A.QuestionKey = B.QuestionKey
					AND A.OrganizationName = B.OrganizationName
					AND A.Year = B.Year
			LEFT JOIN #TBXO F
					ON C.SurveyFormKey = F.SurveyFormKey
						AND D.SurveyQuestionKey = F.SurveyQuestionKey
						AND D.QuestionResponseKey = F.SurveyResponseKey
						AND A.Year = F.SurveyYear
			;

COMMIT TRAN

BEGIN TRAN

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factOrganizationSurveyResponse]') AND name = N'OSR_INDEX_01')
	DROP INDEX [OSR_INDEX_01] ON [dbo].[factOrganizationSurveyResponse] WITH ( ONLINE = OFF );

	CREATE INDEX OSR_INDEX_01 ON [dbo].[factOrganizationSurveyResponse] ([SurveyFormKey], [QuestionKey], [ResponseKey], [OrganizationResponseKey], [OrganizationKey], [Year], [SurveyType]) ON NDXGROUP;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factOrganizationSurveyResponse AS target
	USING	(
			SELECT	A.SurveyFormKey,
					A.QuestionKey,
					A.ResponseKey,
					A.OrganizationResponseKey,
					A.OrganizationKey,
					A.Year,
					A.SurveyType,
					A.ResponseCount,
					A.ResponsePercentage,
					A.AvgBranchResponsePercentage,
					A.AvgAssociationResponsePercentage,
					A.StdDevBranchResponsePercentage,
					A.StdDevAssociationResponsePercentage
											
			FROM	#OSR A

			) AS source
			
			ON target.SurveyFormKey = source.SurveyFormKey
				AND target.QuestionKey = source.QuestionKey
				AND target.ResponseKey = source.ResponseKey
				AND target.OrganizationResponseKey = source.OrganizationResponseKey
				AND target.OrganizationKey = source.OrganizationKey
				AND target.Year = source.Year
				AND target.SurveyType = source.SurveyType
			
			WHEN MATCHED AND (target.[ResponseCount] <> source.[ResponseCount]
								OR target.[ResponsePercentage] <> source.[ResponsePercentage]
								OR target.[AvgBranchResponsePercentage] <> source.[AvgBranchResponsePercentage]
								OR target.[AvgAssociationResponsePercentage] <> source.[AvgAssociationResponsePercentage]
								OR target.[StdDevBranchResponsePercentage] <> source.[StdDevBranchResponsePercentage]
								OR target.[StdDevAssociationResponsePercentage] <> source.[StdDevAssociationResponsePercentage]
							)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([SurveyFormKey],
					[ResponseKey],
					[QuestionKey],
					[OrganizationResponseKey],
					[OrganizationKey],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage],
					[AvgBranchResponsePercentage],
					[AvgAssociationResponsePercentage],
					[StdDevBranchResponsePercentage],
					[StdDevAssociationResponsePercentage]
					)
			VALUES ([SurveyFormKey],
					[ResponseKey],
					[QuestionKey],
					[OrganizationResponseKey],
					[OrganizationKey],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage],
					[AvgBranchResponsePercentage],
					[AvgAssociationResponsePercentage],
					[StdDevBranchResponsePercentage],
					[StdDevAssociationResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factOrganizationSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.SurveyFormKey,
					A.QuestionKey,
					A.ResponseKey,
					A.OrganizationResponseKey,
					A.OrganizationKey,
					A.Year,
					A.SurveyType,
					A.ResponseCount,
					A.ResponsePercentage,
					A.AvgBranchResponsePercentage,
					A.AvgAssociationResponsePercentage,
					A.StdDevBranchResponsePercentage,
					A.StdDevAssociationResponsePercentage
											
			FROM	#OSR A

			) AS source
			
			ON target.SurveyFormKey = source.SurveyFormKey
				AND target.QuestionKey = source.QuestionKey
				AND target.ResponseKey = source.ResponseKey
				AND target.OrganizationResponseKey = source.OrganizationResponseKey
				AND target.OrganizationKey = source.OrganizationKey
				AND target.Year = source.Year
				AND target.SurveyType = source.SurveyType
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[SurveyFormKey],
					[ResponseKey],
					[QuestionKey],
					[OrganizationResponseKey],
					[OrganizationKey],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage],
					[AvgBranchResponsePercentage],
					[AvgAssociationResponsePercentage],
					[StdDevBranchResponsePercentage],
					[StdDevAssociationResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[SurveyFormKey],
					[ResponseKey],
					[QuestionKey],
					[OrganizationResponseKey],
					[OrganizationKey],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage],
					[AvgBranchResponsePercentage],
					[AvgAssociationResponsePercentage],
					[StdDevBranchResponsePercentage],
					[StdDevAssociationResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factOrganizationSurveyResponse]') AND name = N'OSR_INDEX_01')
	DROP INDEX [OSR_INDEX_01] ON [dbo].[factOrganizationSurveyResponse] WITH ( ONLINE = OFF );
	
	DROP TABLE #ASR;
	DROP TABLE #OSRRSLT;
	DROP TABLE #OSR;
COMMIT TRAN
/*
BEGIN TRAN
	exec dbo.spUpdate_odsfactBranchSurveyResponse;
COMMIT TRAN

BEGIN TRAN
	exec dbo.spUpdate_odsfactAssociationSurveyResponse;
COMMIT TRAN
*/
END