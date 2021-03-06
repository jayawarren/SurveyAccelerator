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
			ResponsePercentage = dbo.RoundToZero(CASE WHEN COALESCE(C.PercentageDenominator,'Survey') = 'Survey' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount)
													ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'Y') = 'Y' THEN CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.SurveyCount )
															ELSE CONVERT(DECIMAL(19, 6), A.ResponseCount)/CONVERT(DECIMAL(19, 6), B.QuestionCount)
														END
												END, 5),
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