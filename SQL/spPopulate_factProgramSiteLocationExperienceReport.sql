/*
truncate table dbo.factProgramSiteLocationReport
drop proc spPopulate_factProgramSiteLocationReport
select * from factProgramSiteLocationReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramSiteLocationReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	MSR.ProgramSiteLocationKey,
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
				
	GROUP BY MSR.ProgramSiteLocationKey,
			OrganizationSurveyKey,
			QuestionResponseKey,
			SurveyQuestionKey,
			GivenDateKey;

	SELECT	ProgramSiteLocationKey,
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
	
	GROUP BY ProgramSiteLocationKey,
			OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			GivenDateKey;

	SELECT	PSR.ProgramSiteLocationKey,
			PSR.OrganizationSurveyKey SurveyFormKey,
			--DOS.SurveyType,
			PSR.GivenDateKey,
			A.previous_year_date_given_key PreviousGivenDateKey
			
	INTO	#PreviousSurvey
	
	FROM	factProgramSiteLocationSurveyResponse PSR
			INNER JOIN dimProgramSiteLocation PSL
				ON PSR.ProgramSiteLocationKey = PSL.ProgramSiteLocationKey
			INNER JOIN dimMember DM
				ON PSL.ProgramSiteLocation = DM.ProgramSiteLocation
			INNER JOIN Seer_MDM.dbo.Member_Map MM
				ON PSL.AssociationKey = MM.organization_key
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON MM.organization_key = A.organization_key
					AND PSR.OrganizationSurveyKey = A.survey_form_key
					AND PSR.GivenDateKey = A.date_given_key
			
	--SurveyFormKey Filter is for performance						
	WHERE	PSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
			--AND PSR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'Program'
			
	GROUP BY PSR.ProgramSiteLocationKey,
			PSR.OrganizationSurveyKey,
			--DOS.SurveyType,
			PSR.GivenDateKey,
			A.previous_year_date_given_key;

	/*
	INSERT INTO factProgramSiteLocationProgramReport
	(
	ProgramSiteLocationKey,
	OrganizationSurveyKey,
	QuestionResponseKey,
	SurveyQuestionKey,
	GivenDateKey, 
	ProgramSiteLocationCount,
	ProgramSiteLocationPercentage,
	ProgramGroupPercentage,
	AssociationPercentage,
	NationalPercentage,
	PreviousProgramSiteLocationPercentage,
	SegmentNPPromoter,
	SegmentNPDetractor, 
	SegmentNPNeither
	)
	*/
	SELECT	COALESCE(PSR.ProgramSiteLocationKey,DQR.ProgramSiteLocationKey) AS ProgramSiteLocationKey, 
			COALESCE(PSR.OrganizationSurveyKey,DQR.OrganizationSurveyKey) AS OrganizationSurveyKey, 
			COALESCE(PSR.QuestionResponseKey,DQR.QuestionResponseKey) AS QuestionResponseKey, 
			COALESCE(PSR.SurveyQuestionKey,DQR.SurveyQuestionKey) AS SurveyQuestionKey,
			COALESCE(PSR.GivenDateKey,DQR.GivenDateKey) AS GivenDateKey,
			COALESCE(PSR.ResponseCount,0) AS ProgramSiteLocationCount,
			COALESCE(PSR.ResponsePercentage,0.0) AS ProgramSiteLocationPercentage,
			GSR.ResponsePercentage AS ProgramGroupPercentage,
			ASR.ResponsePercentage AS AssociationPercentage, 
			OSR.ResponsePercentage AS NationalPercentage,
			PSLSR.ResponsePercentage AS PreviousProgramSiteLocationPercentage,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPPromoter/NULLIF(#SegmentCounts.SegmentNPPromoterS,0) ELSE SegmentNPPromoter/NULLIF(#SegmentCounts.SegmentNPPromoterQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPDetractor/NULLIF(#SegmentCounts.SegmentNPDetractorS,0) ELSE SegmentNPDetractor/NULLIF(#SegmentCounts.SegmentNPDetractorQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPNeither/NULLIF(#SegmentCounts.SegmentNPNeitherS,0) ELSE SegmentNPNeither/NULLIF(#SegmentCounts.SegmentNPNeitherQ,0) END,0)
	
	--INTO	#PSLPR
	
	FROM	factProgramSiteLocationSurveyResponse PSR
			INNER JOIN dimProgramSiteLocation DPSL
				ON PSR.ProgramSiteLocationKey = DPSL.ProgramSiteLocationKey
			INNER JOIN dimAssociation DA
				ON DPSL.AssociationKey = DA.AssociationKey
			INNER JOIN dimSurveyForm DS
				ON PSR.OrganizationSurveyKey = DS.SurveyFormKey
			INNER JOIN dimSurveyQuestion DQ
				ON PSR.OrganizationSurveyKey = DQ.SurveyFormKey
					AND PSR.SurveyQuestionKey = DQ.SurveyQuestionKey
			INNER JOIN dimQuestionResponse DR
				ON PSR.SurveyQuestionKey = DR.SurveyQuestionKey
					AND PSR.QuestionResponseKey = DR.QuestionResponseKey
			RIGHT JOIN
			(
			SELECT	DP.ProgramSiteLocationKey,
					DOS.OrganizationSurveyKey,
					DR.QuestionResponseKey, 
					DQ.SurveyQuestionKey,
					dos.GivenDateKey
					
			FROM	dimOrganizationSurvey DOS
					INNER JOIN dimBranch DB
						ON DOS.BranchKey = DB.BranchKey
					INNER JOIN dimSurveyForm SF
						ON DOS.SurveyFormKey = SF.SurveyFormKey
					INNER JOIN dimAssociation DA
						ON DB.AssociationKey = DA.AssociationKey
					INNER JOIN dimProgramSiteLocation DP
						ON DA.AssociationKey = DP.AssociationKey
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
				ON PSR.ProgramSiteLocationKey = DQR.ProgramSiteLocationKey
					AND PSR.OrganizationSurveyKey = DQR.OrganizationSurveyKey
					AND PSR.QuestionResponseKey = DQR.QuestionResponseKey
					AND PSR.SurveyQuestionKey = DQR.SurveyQuestionKey
					and PSR.GivenDateKey = DQR.GivenDateKey
			LEFT JOIN #Segment
				ON #Segment.ProgramSiteLocationKey = PSR.ProgramSiteLocationKey
					AND #Segment.OrganizationSurveyKey = PSR.OrganizationSurveyKey
					AND #Segment.QuestionResponseKey = PSR.QuestionResponseKey
					AND #Segment.SurveyQuestionKey = PSR.SurveyQuestionKey
					AND #Segment.GivenDateKey = PSR.GivenDateKey
			LEFT JOIN #SegmentCounts
				ON #SegmentCounts.ProgramSiteLocationKey = #Segment.ProgramSiteLocationKey
					AND #SegmentCounts.OrganizationSurveyKey = #Segment.OrganizationSurveyKey
					AND #SegmentCounts.SurveyQuestionKey = #Segment.SurveyQuestionKey
					AND #SegmentCounts.GivenDateKey = #Segment.GivenDateKey
			LEFT JOIN factProgramGroupSurveyResponse GSR
				ON GSR.ProgramGroupKey = DPSL.ProgramGroupKey
					AND GSR.OrganizationSurveyKey = PSR.OrganizationSurveyKey
					AND GSR.QuestionResponseKey = PSR.QuestionResponseKey
					AND GSR.SurveyQuestionKey = PSR.SurveyQuestionKey
					AND GSR.GivenDateKey = PSR.GivenDateKey
			LEFT JOIN factAssociationSurveyResponse ASR
				ON ASR.AssociationKey = DPSL.AssociationKey
					AND ASR.SurveyFormKey = DS.SurveyFormKey
					AND ASR.QuestionResponseKey = PSR.QuestionResponseKey
					AND ASR.SurveyQuestionKey = PSR.SurveyQuestionKey
					AND ASR.GivenDateKey = PSR.GivenDateKey
			LEFT JOIN factOrganizationSurveyResponse OSR
				ON OSR.Year = LEFT(ASR.GivenDateKey, 4) - 1
					AND OSR.SurveyFormKey = DS.SurveyFormKey
					AND OSR.ResponseKey = DR.ResponseKey
					AND OSR.QuestionKey = DQ.QuestionKey
			LEFT JOIN
			(
			SELECT	PSR.ProgramSiteLocationKey,
					DS.SurveyType,
					DR.ResponseKey,
					DQ.QuestionKey,
					#PreviousSurvey.GivenDateKey,
					PSR.ResponsePercentage
			
			FROM	#PreviousSurvey
					INNER JOIN factProgramSiteLocationSurveyResponse PSR
						ON #PreviousSurvey.ProgramSiteLocationKey = PSR.ProgramSiteLocationKey
							AND #PreviousSurvey.PreviousGivenDateKey = PSR.GivenDateKey
					INNER JOIN dimSurveyForm DS
						ON #PreviousSurvey.SurveyFormKey = DS.SurveyFormKey
					INNER JOIN dimSurveyQuestion DQ
						ON DS.SurveyFormKey = DQ.SurveyFormKey
							AND DQ.SurveyQuestionKey = PSR.SurveyQuestionKey
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
				ON PSLSR.ProgramSiteLocationKey = PSR.ProgramSiteLocationKey
				AND PSLSR.SurveyType = DS.SurveyType
				AND PSLSR.ResponseKey = DR.ResponseKey
				AND PSLSR.QuestionKey = DQ.QuestionKey
				AND PSLSR.GivenDateKey = PSR.GivenDateKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	PSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	ProductCategory LIKE '%Program Survey%'
											)
	;
	/*		
	DROP TABLE #Segment;
	DROP TABLE #SegmentCounts;
	DROP TABLE #PreviousSurvey;
	*/
END








