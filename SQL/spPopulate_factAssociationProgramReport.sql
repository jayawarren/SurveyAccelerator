/*
truncate table dbo.factAssociationProgramReport
drop proc spPopulate_factAssociationProgramReport
select * from factAssociationProgramReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factAssociationProgramReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	DB.AssociationKey,
			OrganizationSurveyKey,
			QuestionResponseKey,
			SurveyQuestionKey,
			GivenDateKey,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither
	
	INTO	#Segment
	
	FROM	factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
					
	WHERE	MSR.current_indicator = 1
				
	GROUP BY DB.AssociationKey,
			OrganizationSurveyKey,
			QuestionResponseKey,
			SurveyQuestionKey,
			GivenDateKey;

	SELECT	AssociationKey,
			OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			GivenDateKey,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPPromoter END) AS SegmentNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPDetractor END) AS SegmentNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPNeither END) AS SegmentNPNeitherQ,
			SUM(SegmentNPPromoter) AS SegmentNPPromoterS,
			SUM(SegmentNPDetractor) AS SegmentNPDetractorS,
			SUM(SegmentNPNeither) AS SegmentNPNeitherS
	
	INTO	#SegmentCounts
	
	FROM	#Segment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.QuestionResponseKey = DQR.QuestionResponseKey
	
	GROUP BY AssociationKey,
			OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			GivenDateKey;

	SELECT	A.AssociationKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.GivenDateKey,
			A.PreviousGivenDateKey
			
	INTO	#PreviousSurvey
	
	FROM	(
			SELECT	PSR.AssociationKey,
					PSR.SurveyFormKey,
					PSR.GivenDateKey,
					A.previous_year_date_given_key PreviousGivenDateKey,
					A.module,
					A.aggregate_type
						
			FROM	factAssociationSurveyResponse PSR
					INNER JOIN dimAssociation PSL
						ON PSR.AssociationKey = PSL.AssociationKey
					INNER JOIN Seer_MDM.dbo.Batch_Map A
						ON PSL.AssociationKey = A.organization_key
							AND PSR.SurveyFormKey = A.survey_form_key
							AND PSR.GivenDateKey = A.date_given_key
			) A
					
	WHERE	A.module = 'Program'
			AND A.aggregate_type = 'Association'
			
	GROUP BY A.AssociationKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.GivenDateKey,
			A.PreviousGivenDateKey;

	/*
	INSERT INTO factAssociationProgramReport
	(
	AssociationKey,
	OrganizationSurveyKey,
	QuestionResponseKey,
	SurveyQuestionKey,
	GivenDateKey, 
	AssociationCount,
	AssociationPercentage,
	NationalPercentage,
	PreviousAssociationPercentage,
	SegmentNPPromoter,
	SegmentNPDetractor, 
	SegmentNPNeither
	)
	*/
	SELECT	DQR.AssociationKey, 
			DQR.OrganizationSurveyKey SurveyFormKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.GivenDateKey,
			COALESCE(A.ResponseCount,0) AS AssociationCount,
			COALESCE(A.ResponsePercentage,0.0) AS AssociationPercentage,
			OSR.ResponsePercentage AS NationalPercentage,
			PSLSR.ResponsePercentage AS PreviousAssociationPercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPPromoterS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPPromoterQ),0) END,0) SegmentNPPromoter,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPDetractorS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPDetractorQ),0) END,0) SegmentNPDetractor,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPNeitherS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPNeitherQ),0) END,0) SegmentNPNeither
	
	INTO	#APR
	
	FROM	(
			SELECT	DB.AssociationKey,
					DOS.OrganizationSurveyKey,
					DQ.SurveyQuestionKey,
					DQ.QuestionKey,
					DR.QuestionResponseKey,
					DR.ResponseKey,
					dos.GivenDateKey,
					DR.ExcludeFromReportCalculation
					
			FROM	dimOrganizationSurvey DOS
					INNER JOIN dimBranch DB
						ON DOS.BranchKey = DB.BranchKey
					INNER JOIN dimSurveyForm SF
						ON DOS.SurveyFormKey = SF.SurveyFormKey
					INNER JOIN dimSurveyQuestion DQ
						ON DOS.SurveyFormKey = DQ.SurveyFormKey
					INNER JOIN dimQuestionResponse DR
						ON DQ.SurveyQuestionKey = DR.SurveyQuestionKey
			
			--SurveyFormKey Filter is for performance						
			WHERE	DOS.SurveyFormKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
					AND DR.ResponseCode <> '-1'
			) DQR
			LEFT JOIN factAssociationSurveyResponse A
				ON DQR.AssociationKey = A.AssociationKey
					AND DQR.OrganizationSurveyKey = A.SurveyFormKey
					AND DQR.QuestionResponseKey = A.QuestionResponseKey
					AND DQR.SurveyQuestionKey = A.SurveyQuestionKey
					and DQR.GivenDateKey = A.GivenDateKey
			LEFT JOIN #Segment
				ON #Segment.AssociationKey = DQR.AssociationKey
					AND #Segment.OrganizationSurveyKey = DQR.OrganizationSurveyKey
					AND #Segment.QuestionResponseKey = DQR.QuestionResponseKey
					AND #Segment.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND #Segment.GivenDateKey = DQR.GivenDateKey
			LEFT JOIN #SegmentCounts
				ON #SegmentCounts.AssociationKey = #Segment.AssociationKey
					AND #SegmentCounts.OrganizationSurveyKey = #Segment.OrganizationSurveyKey
					AND #SegmentCounts.SurveyQuestionKey = #Segment.SurveyQuestionKey
					AND #SegmentCounts.GivenDateKey = #Segment.GivenDateKey
			LEFT JOIN factOrganizationSurveyResponse OSR
				ON OSR.OrganizationKey = DQR.AssociationKey
					AND OSR.SurveyFormKey = DQR.OrganizationSurveyKey
					AND OSR.ResponseKey = DQR.ResponseKey
					AND OSR.QuestionKey = DQR.QuestionKey
			LEFT JOIN
			(
			SELECT	PSR.AssociationKey,
					PSR.SurveyFormKey,
					DR.ResponseKey,
					DQ.QuestionKey,
					#PreviousSurvey.GivenDateKey,
					PSR.ResponsePercentage
			
			FROM	#PreviousSurvey
					INNER JOIN factAssociationSurveyResponse PSR
						ON #PreviousSurvey.AssociationKey = PSR.AssociationKey
							AND #PreviousSurvey.PreviousGivenDateKey = PSR.GivenDateKey
					INNER JOIN dimSurveyQuestion DQ
						ON PSR.SurveyFormKey = DQ.SurveyFormKey
							AND PSR.SurveyQuestionKey = DQ.SurveyQuestionKey
					INNER JOIN dimQuestionResponse DR
						ON PSR.SurveyQuestionKey = DR.SurveyQuestionKey
							AND PSR.QuestionResponseKey = DR.QuestionResponseKey
						
			--SurveyFormKey Filter is for performance						
			WHERE	PSR.SurveyFormKey IN	(
													SELECT	SurveyFormKey
													FROM	dimSurveyForm
													WHERE	ProductCategory LIKE '%Program Survey%'
													)
			) PSLSR
				ON PSLSR.AssociationKey = DQR.AssociationKey
				AND PSLSR.SurveyFormKey = DQR.OrganizationSurveyKey
				AND PSLSR.ResponseKey = DQR.ResponseKey
				AND PSLSR.QuestionKey = DQR.QuestionKey
				AND PSLSR.GivenDateKey = DQR.GivenDateKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	DQR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
	
	GROUP BY DQR.AssociationKey, 
			DQR.OrganizationSurveyKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.GivenDateKey,
			COALESCE(A.ResponseCount,0),
			COALESCE(A.ResponsePercentage,0.0),
			OSR.ResponsePercentage,
			PSLSR.ResponsePercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPPromoterS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPPromoterQ),0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPDetractorS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPDetractorQ),0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPNeitherS),0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(CONVERT(DECIMAL(19, 6), #SegmentCounts.SegmentNPNeitherQ),0) END,0)
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factAssociationProgramReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.SurveyFormKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.GivenDateKey,
					1 current_indicator, 
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#APR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[AssociationCount] <> source.[AssociationCount]
								 OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								 OR target.[NationalPercentage] <> source.[NationalPercentage]
								 OR target.[PreviousAssociationPercentage] <> source.[PreviousAssociationPercentage]
								 OR target.[SegmentNPPromoter] <> source.[SegmentNPPromoter]
								 OR target.[SegmentNPDetractor] <> source.[SegmentNPDetractor]
								 OR target.[SegmentNPNeither] <> source.[SegmentNPNeither]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousAssociationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousAssociationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationProgramReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.SurveyFormKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.GivenDateKey,
					1 current_indicator, 
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#APR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousAssociationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousAssociationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #Segment;
	DROP TABLE #SegmentCounts;
	DROP TABLE #PreviousSurvey;
	DROP TABLE #APR;
	
COMMIT TRAN
	
END








