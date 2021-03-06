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
	
	SELECT	PSL.AssociationKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
			SUM(CASE WHEN DM.SurveyProgramPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither
	
	INTO	#Segment
	
	FROM	dbo.factMemberSurveyResponse MSR
			INNER JOIN dimProgramSiteLocation PSL
				ON MSR.ProgramSiteLocationKey = PSL.ProgramSiteLocationKey
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND PSL.ProgramSiteLocation = DM.ProgramSiteLocation
					
	WHERE	MSR.current_indicator = 1
				
	GROUP BY PSL.AssociationKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey;

	SELECT	BS.AssociationKey,
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
	
	GROUP BY BS.AssociationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey;

	SELECT	A.AssociationKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.batch_key,
			A.PreviousBatchKey,
			A.GivenDateKey,
			A.PreviousGivenDateKey
			
	INTO	#PreviousSurvey
	
	FROM	(
			SELECT	PSR.AssociationKey,
					PSR.SurveyFormKey,
					PSR.GivenDateKey,
					A.batch_key,
					A.previous_year_batch_key PreviousBatchKey,
					A.previous_year_date_given_key PreviousGivenDateKey,
					A.module,
					A.aggregate_type
						
			FROM	dbo.factAssociationSurveyResponse PSR
					INNER JOIN dimAssociation PSL
						ON PSR.AssociationKey = PSL.AssociationKey
					INNER JOIN Seer_MDM.dbo.Batch_Map A
						ON PSL.AssociationKey = A.organization_key
							AND PSR.SurveyFormKey = A.survey_form_key
							AND PSR.GivenDateKey = A.date_given_key
							
			WHERE	PSR.current_indicator = 1
			) A
					
	WHERE	A.module = 'Program'
			AND A.aggregate_type = 'Association'
			
	GROUP BY A.AssociationKey,
			A.SurveyFormKey,
			--DOS.SurveyType,
			A.batch_key,
			A.PreviousBatchKey,
			A.GivenDateKey,
			A.PreviousGivenDateKey;

	SELECT	DQR.AssociationKey, 
			DQR.OrganizationSurveyKey SurveyFormKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.batch_key,
			DQR.GivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			COALESCE(A.ResponseCount,0) AS AssociationCount,
			COALESCE(A.ResponsePercentage,0.0000) AS AssociationPercentage,
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
					B.batch_key,
					dos.GivenDateKey,
					DR.ExcludeFromReportCalculation
					
			FROM	dimOrganizationSurvey DOS
					INNER JOIN dimBranch DB
						ON DOS.BranchKey = DB.BranchKey
					INNER JOIN Seer_MDM.dbo.Survey_Form SF
						ON DOS.SurveyFormKey = SF.survey_form_key
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
			INNER JOIN dbo.factAssociationSurveyResponse A
				ON DQR.AssociationKey = A.AssociationKey
					AND DQR.OrganizationSurveyKey = A.SurveyFormKey
					AND DQR.QuestionResponseKey = A.QuestionResponseKey
					AND DQR.SurveyQuestionKey = A.SurveyQuestionKey
					and DQR.batch_key = A.batch_key
					and DQR.GivenDateKey = A.GivenDateKey
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON DQR.AssociationKey = B.organization_key
					AND DQR.batch_key = B.batch_key
			LEFT JOIN #Segment
				ON #Segment.AssociationKey = DQR.AssociationKey
					AND #Segment.OrganizationSurveyKey = DQR.OrganizationSurveyKey
					AND #Segment.QuestionResponseKey = DQR.QuestionResponseKey
					AND #Segment.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND #Segment.batch_key = DQR.batch_key
					AND #Segment.GivenDateKey = DQR.GivenDateKey
			LEFT JOIN #SegmentCounts
				ON #SegmentCounts.AssociationKey = #Segment.AssociationKey
					AND #SegmentCounts.OrganizationSurveyKey = #Segment.OrganizationSurveyKey
					AND #SegmentCounts.SurveyQuestionKey = #Segment.SurveyQuestionKey
					AND #SegmentCounts.batch_key = #Segment.batch_key
					AND #SegmentCounts.GivenDateKey = #Segment.GivenDateKey
			LEFT JOIN factOrganizationSurveyResponse OSR
				ON OSR.Year = LEFT(DQR.GivenDateKey,4) - 1
					AND OSR.SurveyFormKey = DQR.OrganizationSurveyKey
					AND OSR.ResponseKey = DQR.ResponseKey
					AND OSR.QuestionKey = DQR.QuestionKey
			LEFT JOIN
			(
			SELECT	PSR.AssociationKey,
					PSR.SurveyFormKey,
					DR.ResponseKey,
					DQ.QuestionKey,
					#PreviousSurvey.batch_key,
					#PreviousSurvey.GivenDateKey,
					PSR.ResponsePercentage
			
			FROM	#PreviousSurvey
					INNER JOIN factAssociationSurveyResponse PSR
						ON #PreviousSurvey.AssociationKey = PSR.AssociationKey
							AND #PreviousSurvey.PreviousBatchKey = PSR.batch_key
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
				AND PSLSR.batch_key = DQR.batch_key
				AND PSLSR.GivenDateKey = DQR.GivenDateKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	DQR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
			AND B.aggregate_type = 'Association'
			AND B.module = 'Program'
			AND A.current_indicator = 1
	
	GROUP BY DQR.AssociationKey, 
			DQR.OrganizationSurveyKey, 
			DQR.QuestionResponseKey, 
			DQR.SurveyQuestionKey,
			DQR.batch_key,
			DQR.GivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
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
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
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
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationCount] <> source.[AssociationCount]
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
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
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
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
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
			SELECT	A.AssociationKey,
					A.SurveyFormKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
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
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
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
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
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








