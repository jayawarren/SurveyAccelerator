/*
truncate table dbo.factProgramGroupProgramReport
drop proc spPopulate_factProgramGroupProgramReport
select * from factProgramGroupProgramReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramGroupProgramReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	PSL.ProgramGroupKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither
	
	INTO	#Segment
	
	FROM	factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
			INNER JOIN dimProgramSiteLocation PSL
				ON MSR.ProgramSiteLocationKey = PSL.ProgramSiteLocationKey
				
	WHERE	MSR.current_indicator = 1
				
	GROUP BY PSL.ProgramGroupKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey;

	SELECT	BS.ProgramGroupKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey,
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
	
	GROUP BY BS.ProgramGroupKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey;

	SELECT	A.ProgramGroupKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.batch_key,
			A.GivenDateKey,
			A.PreviousGivenDateKey
			
	INTO	#PreviousSurvey
	
	FROM	(
			SELECT	PSR.ProgramGroupKey,
					PSR.OrganizationSurveyKey SurveyFormKey,
					PSR.GivenDateKey,
					PSR.batch_key,
					A.previous_year_date_given_key PreviousGivenDateKey,
					A.module,
					A.aggregate_type
						
			FROM	factProgramGroupSurveyResponse PSR
					INNER JOIN dimProgramGroup PSL
						ON PSR.ProgramGroupKey = PSL.ProgramGroupKey
					INNER JOIN Seer_MDM.dbo.Batch_Map A
						ON PSL.AssociationKey = A.organization_key
							AND PSR.OrganizationSurveyKey = A.survey_form_key
							AND PSR.batch_key = A.batch_key
							AND PSR.GivenDateKey = A.date_given_key
			) A
			
	--Adding module to query reduces query performance					
	WHERE	A.aggregate_type = 'Association'
			
	GROUP BY A.ProgramGroupKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.batch_key,
			A.GivenDateKey,
			A.PreviousGivenDateKey;

	/*
	INSERT INTO factProgramGroupProgramReport
	(
	ProgramGroupKey,
	OrganizationSurveyKey,
	QuestionResponseKey,
	SurveyQuestionKey,
	GivenDateKey, 
	ProgramGroupCount,
	ProgramGroupPercentage,
	ProgramGroupPercentage,
	AssociationPercentage,
	NationalPercentage,
	PreviousProgramGroupPercentage,
	SegmentNPPromoter,
	SegmentNPDetractor, 
	SegmentNPNeither
	)
	*/
	SELECT	DQR.ProgramGroupKey, 
			DQR.OrganizationSurveyKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.batch_key,
			DQR.GivenDateKey,
			COALESCE(A.ResponseCount,0) AS ProgramGroupCount,
			COALESCE(A.ResponsePercentage,0.0000) AS ProgramGroupPercentage,
			ASR.ResponsePercentage AS AssociationPercentage, 
			OSR.ResponsePercentage AS NationalPercentage,
			PSLSR.ResponsePercentage AS PreviousProgramGroupPercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterQ,0) END,0) SegmentNPPromoter,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorQ,0) END,0) SegmentNPDetractor,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherQ,0) END,0) SegmentNPNeither
	
	INTO	#PGPR
	
	FROM	(
			SELECT	DP.ProgramGroupKey,
					DOS.OrganizationSurveyKey,
					DB.AssociationKey,
					DQ.SurveyQuestionKey,
					DQ.QuestionKey,
					DR.QuestionResponseKey,
					DR.ResponseKey,
					B.batch_key,
					dos.GivenDateKey,
					DR.ExcludeFromReportCalculation
					
			FROM	dimOrganizationSurvey DOS
					INNER JOIN dimBranch DB
						ON DOS.BranchKey = DB.BranchKey
					INNER JOIN Seer_MDM.dbo.Survey_Form SF
						ON DOS.SurveyFormKey = SF.survey_form_key
					INNER JOIN dimProgramGroup DP
						ON DB.AssociationKey = DP.AssociationKey
					INNER JOIN dimSurveyQuestion DQ
						ON DOS.SurveyFormKey = DQ.SurveyFormKey
					INNER JOIN dimQuestionResponse DR
						ON DQ.SurveyQuestionKey = DR.SurveyQuestionKey
					INNER JOIN Seer_MDM.dbo.Batch B
						ON SF.survey_form_code = B.form_code
							AND DOS.GivenDateKey = B.date_given_key
			
			--SurveyFormKey Filter is for performance						
			WHERE	DOS.SurveyFormKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
					AND DR.ResponseCode <> '-1'
			) DQR
			LEFT JOIN factProgramGroupSurveyResponse A
				ON DQR.ProgramGroupKey = A.ProgramGroupKey
					AND DQR.OrganizationSurveyKey = A.OrganizationSurveyKey
					AND DQR.QuestionResponseKey = A.QuestionResponseKey
					AND DQR.SurveyQuestionKey = A.SurveyQuestionKey
					AND DQR.batch_key = A.batch_key
					AND DQR.GivenDateKey = A.GivenDateKey
			LEFT JOIN #Segment
				ON #Segment.ProgramGroupKey = DQR.ProgramGroupKey
					AND #Segment.OrganizationSurveyKey = DQR.OrganizationSurveyKey
					AND #Segment.QuestionResponseKey = DQR.QuestionResponseKey
					AND #Segment.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND #Segment.batch_key = DQR.batch_key
					AND #Segment.GivenDateKey = DQR.GivenDateKey
			LEFT JOIN #SegmentCounts
				ON #SegmentCounts.ProgramGroupKey = #Segment.ProgramGroupKey
					AND #SegmentCounts.OrganizationSurveyKey = #Segment.OrganizationSurveyKey
					AND #SegmentCounts.SurveyQuestionKey = #Segment.SurveyQuestionKey
					AND #SegmentCounts.batch_key = #Segment.batch_key
					AND #SegmentCounts.GivenDateKey = #Segment.GivenDateKey
			LEFT JOIN factAssociationSurveyResponse ASR
				ON ASR.AssociationKey = DQR.AssociationKey
					AND ASR.SurveyFormKey = DQR.OrganizationSurveyKey
					AND ASR.QuestionResponseKey = DQR.QuestionResponseKey
					AND ASR.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND ASR.batch_key = DQR.batch_key
					AND ASR.GivenDateKey = DQR.GivenDateKey
			LEFT JOIN factOrganizationSurveyResponse OSR
				ON OSR.OrganizationKey = DQR.AssociationKey
					AND OSR.SurveyFormKey = DQR.OrganizationSurveyKey
					AND OSR.ResponseKey = DQR.ResponseKey
					AND OSR.QuestionKey = DQR.QuestionKey
			LEFT JOIN
			(
			SELECT	PSR.ProgramGroupKey,
					PSR.OrganizationSurveyKey,
					DR.ResponseKey,
					DQ.QuestionKey,
					#PreviousSurvey.batch_key,
					#PreviousSurvey.GivenDateKey,
					PSR.ResponsePercentage
			
			FROM	#PreviousSurvey
					INNER JOIN factProgramGroupSurveyResponse PSR
						ON #PreviousSurvey.ProgramGroupKey = PSR.ProgramGroupKey
							AND #PreviousSurvey.batch_key = PSR.batch_key
							AND #PreviousSurvey.PreviousGivenDateKey = PSR.GivenDateKey
					INNER JOIN dimSurveyQuestion DQ
						ON PSR.OrganizationSurveyKey = DQ.SurveyFormKey
							AND PSR.SurveyQuestionKey = DQ.SurveyQuestionKey
					INNER JOIN dimQuestionResponse DR
						ON PSR.SurveyQuestionKey = DR.SurveyQuestionKey
							AND PSR.QuestionResponseKey = DR.QuestionResponseKey
						
			--SurveyFormKey Filter is for performance						
			WHERE	PSR.OrganizationSurveyKey IN	(
													SELECT	SurveyFormKey
													FROM	dimSurveyForm
													WHERE	ProductCategory LIKE '%Program Survey%'
													)
			) PSLSR
				ON PSLSR.ProgramGroupKey = DQR.ProgramGroupKey
				AND PSLSR.OrganizationSurveyKey = DQR.OrganizationSurveyKey
				AND PSLSR.ResponseKey = DQR.ResponseKey
				AND PSLSR.QuestionKey = DQR.QuestionKey
				AND PSLSR.batch_key = DQR.batch_key
				AND PSLSR.GivenDateKey = DQR.GivenDateKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	DQR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
	
	GROUP BY DQR.ProgramGroupKey, 
			DQR.OrganizationSurveyKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.batch_key,
			DQR.GivenDateKey,
			COALESCE(A.ResponseCount,0),
			COALESCE(A.ResponsePercentage,0.0),
			ASR.ResponsePercentage, 
			OSR.ResponsePercentage,
			PSLSR.ResponsePercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterQ,0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorQ,0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherQ,0) END,0)
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factProgramGroupProgramReport AS target
	USING	(
			SELECT	A.ProgramGroupKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					1 current_indicator, 
					A.ProgramGroupCount,
					A.ProgramGroupPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousProgramGroupPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#PGPR A

			) AS source
			
			ON target.ProgramGroupKey = source.ProgramGroupKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[ProgramGroupCount] <> source.[ProgramGroupCount]
								 OR target.[ProgramGroupPercentage] <> source.[ProgramGroupPercentage]
								 OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								 OR target.[NationalPercentage] <> source.[NationalPercentage]
								 OR target.[PreviousProgramGroupPercentage] <> source.[PreviousProgramGroupPercentage]
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
			INSERT ([ProgramGroupKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[ProgramGroupCount],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramGroupPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([ProgramGroupKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[ProgramGroupCount],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramGroupPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramGroupProgramReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.ProgramGroupKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					1 current_indicator, 
					A.ProgramGroupCount,
					A.ProgramGroupPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousProgramGroupPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#PGPR A

			) AS source
			
			ON target.ProgramGroupKey = source.ProgramGroupKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[ProgramGroupKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[ProgramGroupCount],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramGroupPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[ProgramGroupKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[ProgramGroupCount],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramGroupPercentage],
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
	DROP TABLE #PGPR;
	
COMMIT TRAN
	
END








