USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dbo].[spPopulate_factProgramSiteLocationProgramReport]    Script Date: 09/05/2013 14:33:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
truncate table dbo.factProgramSiteLocationProgramReport
drop proc spPopulate_factProgramSiteLocationProgramReport
select * from factProgramSiteLocationReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramSiteLocationProgramReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	MSR.ProgramSiteLocationKey,
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
				
	WHERE	MSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
			AND MSR.current_indicator = 1
				
	GROUP BY MSR.ProgramSiteLocationKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey;

	SELECT	BS.ProgramSiteLocationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPPromoter END) AS SegmentNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPDetractor END) AS SegmentNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPNeither END) AS SegmentNPNeitherQ,
			SUM(BS.SegmentNPPromoter) AS SegmentNPPromoterS,
			SUM(BS.SegmentNPDetractor) AS SegmentNPDetractorS,
			SUM(BS.SegmentNPNeither) AS SegmentNPNeitherS
	
	INTO	#SegmentCounts
	
	FROM	#Segment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.QuestionResponseKey = DQR.QuestionResponseKey
	
	GROUP BY BS.ProgramSiteLocationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey;

	SELECT	PSR.ProgramSiteLocationKey,
			PSR.OrganizationSurveyKey SurveyFormKey,
			--DOS.SurveyType,
			PSR.batch_key,
			PSR.GivenDateKey,
			A.previous_year_date_given_key PreviousGivenDateKey
			
	INTO	#PreviousSurvey
	
	FROM	dbo.factProgramSiteLocationSurveyResponse PSR
			INNER JOIN dimProgramSiteLocation PSL
				ON PSR.ProgramSiteLocationKey = PSL.ProgramSiteLocationKey
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON PSL.AssociationKey = A.organization_key
					AND PSR.OrganizationSurveyKey = A.survey_form_key
					AND PSR.GivenDateKey = A.date_given_key
			
	--SurveyFormKey Filter is for performance						
	WHERE	PSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
			AND PSR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'Program'
			
	GROUP BY PSR.ProgramSiteLocationKey,
			PSR.OrganizationSurveyKey,
			PSR.batch_key,
			PSR.GivenDateKey,
			A.previous_year_date_given_key;
			
	SELECT	DP.ProgramSiteLocationKey,
			DP.ProgramGroupKey,
			DOS.OrganizationSurveyKey,
			DB.AssociationKey,
			DQ.SurveyQuestionKey,
			DQ.QuestionKey,
			DR.QuestionResponseKey,
			DR.ResponseKey,
			DOS.batch_key,
			DOS.GivenDateKey,
			DR.ExcludeFromReportCalculation
			
	INTO	#AOQR
			
	FROM	dimOrganizationSurvey DOS
			INNER JOIN dimBranch DB
				ON DOS.BranchKey = DB.BranchKey
			INNER JOIN dimSurveyForm SF
				ON DOS.SurveyFormKey = SF.SurveyFormKey
			INNER JOIN dimProgramSiteLocation DP
				ON DB.AssociationKey = DP.AssociationKey
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
	
	ORDER BY DP.ProgramSiteLocationKey;

	
	SELECT	A.ProgramSiteLocationKey, 
			A.OrganizationSurveyKey, 
			A.QuestionResponseKey, 
			A.SurveyQuestionKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			B.change_datetime,
			B.next_change_datetime,
			COALESCE(A.ResponseCount, 0) AS ProgramSiteLocationCount,
			COALESCE(A.ResponsePercentage, 0.0000) AS ProgramSiteLocationPercentage,
			GSR.ResponsePercentage AS ProgramGroupPercentage,
			ASR.ResponsePercentage AS AssociationPercentage, 
			OSR.ResponsePercentage AS NationalPercentage,
			PSLSR.ResponsePercentage AS PreviousProgramSiteLocationPercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterQ,0) END,0) SegmentNPPromoter,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorQ,0) END,0) SegmentNPDetractor,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherQ,0) END,0) SegmentNPNeither
	
	INTO	#PSLPR
	--select *
	FROM	dbo.factProgramSiteLocationSurveyResponse A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
			INNER JOIN #AOQR DQR  
				ON DQR.ProgramSiteLocationKey = A.ProgramSiteLocationKey
					AND DQR.OrganizationSurveyKey = A.OrganizationSurveyKey
					AND DQR.QuestionResponseKey = A.QuestionResponseKey
					AND DQR.SurveyQuestionKey = A.SurveyQuestionKey
					AND DQR.batch_key = A.batch_key
					AND DQR.GivenDateKey = A.GivenDateKey
			LEFT JOIN #Segment
				ON #Segment.ProgramSiteLocationKey = A.ProgramSiteLocationKey
					AND #Segment.OrganizationSurveyKey = A.OrganizationSurveyKey
					AND #Segment.QuestionResponseKey = A.QuestionResponseKey
					AND #Segment.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND #Segment.batch_key = A.batch_key
					AND #Segment.GivenDateKey = A.GivenDateKey
			LEFT JOIN #SegmentCounts
				ON #SegmentCounts.ProgramSiteLocationKey = A.ProgramSiteLocationKey
					AND #SegmentCounts.OrganizationSurveyKey = A.OrganizationSurveyKey
					AND #SegmentCounts.SurveyQuestionKey =	A.SurveyQuestionKey
					AND #SegmentCounts.batch_key = A.batch_key
					AND #SegmentCounts.GivenDateKey = A.GivenDateKey
			LEFT JOIN factProgramGroupSurveyResponse GSR
				ON GSR.ProgramGroupKey = DQR.ProgramGroupKey
					AND GSR.OrganizationSurveyKey = A.OrganizationSurveyKey
					AND GSR.QuestionResponseKey = A.QuestionResponseKey
					AND GSR.SurveyQuestionKey = A.SurveyQuestionKey
					AND GSR.batch_key = A.batch_key
					AND GSR.GivenDateKey = A.GivenDateKey
			LEFT JOIN factAssociationSurveyResponse ASR
				ON ASR.AssociationKey = A.AssociationKey
					AND ASR.SurveyFormKey = A.OrganizationSurveyKey
					AND ASR.QuestionResponseKey = A.QuestionResponseKey
					AND ASR.SurveyQuestionKey = A.SurveyQuestionKey
					AND ASR.batch_key = A.batch_key
					AND ASR.GivenDateKey = A.GivenDateKey
			LEFT JOIN factOrganizationSurveyResponse OSR
				ON OSR.Year = LEFT(ASR.GivenDateKey, 4) - 1
					AND OSR.SurveyFormKey = A.OrganizationSurveyKey
					AND OSR.ResponseKey = DQR.ResponseKey
					AND OSR.QuestionKey = DQR.QuestionKey
			LEFT JOIN
			(
			SELECT	PSR.ProgramSiteLocationKey,
					PSR.OrganizationSurveyKey,
					DR.ResponseKey,
					DQ.QuestionKey,
					#PreviousSurvey.batch_key,
					#PreviousSurvey.GivenDateKey,
					PSR.ResponsePercentage
			
			FROM	#PreviousSurvey
					INNER JOIN factProgramSiteLocationSurveyResponse PSR
						ON #PreviousSurvey.ProgramSiteLocationKey = PSR.ProgramSiteLocationKey
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
					AND PSR.current_indicator = 1
			) PSLSR
				ON PSLSR.ProgramSiteLocationKey = A.ProgramSiteLocationKey
				AND PSLSR.OrganizationSurveyKey = A.OrganizationSurveyKey
				AND PSLSR.ResponseKey = DQR.ResponseKey
				AND PSLSR.QuestionKey = DQR.QuestionKey
				AND PSLSR.batch_key = A.batch_key
				AND PSLSR.GivenDateKey = A.GivenDateKey
				
	WHERE	A.current_indicator = 1
			AND B.module = 'Program'
			AND B.aggregate_type = 'Association'
	
	GROUP BY A.ProgramSiteLocationKey, 
			A.OrganizationSurveyKey, 
			A.QuestionResponseKey, 
			A.SurveyQuestionKey,
			A.batch_key,
			A.GivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			COALESCE(A.ResponseCount,0),
			COALESCE(A.ResponsePercentage,0.0),
			GSR.ResponsePercentage,
			ASR.ResponsePercentage, 
			OSR.ResponsePercentage,
			PSLSR.ResponsePercentage,
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#SegmentCounts.SegmentNPPromoterQ,0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#SegmentCounts.SegmentNPDetractorQ,0) END,0),
			COALESCE(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#SegmentCounts.SegmentNPNeitherQ,0) END,0)
	;
	
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factProgramSiteLocationProgramReport AS target
	USING	(
			SELECT	A.ProgramSiteLocationKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime, 
					A.current_indicator,
					A.ProgramSiteLocationCount,
					A.ProgramSiteLocationPercentage,
					A.ProgramGroupPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousProgramSiteLocationPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#PSLPR A

			) AS source
			
			ON target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[ProgramSiteLocationCount] <> source.[ProgramSiteLocationCount]
								OR target.[ProgramSiteLocationPercentage] <> source.[ProgramSiteLocationPercentage]
								OR target.[ProgramGroupPercentage] <> source.[ProgramGroupPercentage]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PreviousProgramSiteLocationPercentage] <> source.[PreviousProgramSiteLocationPercentage]
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
			INSERT ([ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[ProgramSiteLocationCount],
					[ProgramSiteLocationPercentage],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramSiteLocationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[ProgramSiteLocationCount],
					[ProgramSiteLocationPercentage],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramSiteLocationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factProgramSiteLocationProgramReport AS target
	USING	(
			SELECT	A.ProgramSiteLocationKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime, 
					A.current_indicator,
					A.ProgramSiteLocationCount,
					A.ProgramSiteLocationPercentage,
					A.ProgramGroupPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PreviousProgramSiteLocationPercentage,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither
					
			FROM	#PSLPR A

			) AS source
			
			ON target.ProgramSiteLocationKey = source.ProgramSiteLocationKey
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
			INSERT ([ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[ProgramSiteLocationCount],
					[ProgramSiteLocationPercentage],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramSiteLocationPercentage],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither]
					)
			VALUES ([ProgramSiteLocationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[ProgramSiteLocationCount],
					[ProgramSiteLocationPercentage],
					[ProgramGroupPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PreviousProgramSiteLocationPercentage],
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
	DROP TABLE #AOQR;
	DROP TABLE #PSLPR;
	
COMMIT TRAN
	
END








