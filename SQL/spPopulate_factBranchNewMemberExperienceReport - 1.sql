/*
truncate table dbo.factBranchNewMemberExperienceReport
drop proc spPopulate_factBranchNewMemberExperienceReport
select * from factBranchNewMemberExperienceReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factBranchNewMemberExperienceReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	MSR.BranchKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			SUM(CASE WHEN DM.SurveyHealthSeeker = 'Yes' THEN 1 ELSE 0 END) AS SegmentHealthSeekerYes,
			SUM(CASE WHEN DM.SurveyHealthSeeker = 'No' THEN 1 ELSE 0 END) AS SegmentHealthSeekerNo,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '6-7 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse7Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '4-5 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse5Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '2-3 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Once a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '2-3 times a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Month,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Month,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Less than once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUseU1Month,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Early morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayEarlyAM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Mid-morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidAM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Lunch' THEN 1 ELSE 0 END) AS SegmentTimeOfDayLunch,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Mid-day' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidPM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Evening' THEN 1 ELSE 0 END) AS SegmentTimeOfDayPM,
			SUM(CASE WHEN DM.SurveyGroupActivities = 'Primarily group activities' THEN 1 ELSE 0 END) AS SegmentActivitiesGroup,
			SUM(CASE WHEN DM.SurveyGroupActivities = 'Primarily individual exercise' THEN 1 ELSE 0 END) AS SegmentActivitiesIndividual,
			SUM(CASE WHEN DM.SurveyGroupActivities = 'Both to group and individual' THEN 1 ELSE 0 END) AS SegmentActivitiesBoth
	
	INTO	#BranchSegment
			
	FROM	factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN (
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
										)
			AND MSR.current_indicator = 1
				
	GROUP BY MSR.BranchKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey;

	SELECT	BS.BranchKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentHealthSeekerYes END) AS SegmentHealthSeekerYesQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentHealthSeekerNo END) AS SegmentHealthSeekerNoQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse7Week END) AS SegmentFrequencyOfUse7WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse5Week END) AS SegmentFrequencyOfUse5WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse3Week END) AS SegmentFrequencyOfUse3WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse1Week END) AS SegmentFrequencyOfUse1WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse3Month END) AS SegmentFrequencyOfUse3MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse1Month END) AS SegmentFrequencyOfUse1MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUseU1Month END) AS SegmentFrequencyOfUseU1MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPPromoter END) AS SegmentNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPDetractor END) AS SegmentNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPNeither END) AS SegmentNPNeitherQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayEarlyAM END) AS SegmentTimeOfDayEarlyAMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayMidAM END) AS SegmentTimeOfDayMidAMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayLunch END) AS SegmentTimeOfDayLunchQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayMidPM END) AS SegmentTimeOfDayMidPMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayPM END) AS SegmentTimeOfDayPMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentActivitiesGroup END) AS SegmentActivitiesGroupQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentActivitiesIndividual END) AS SegmentActivitiesIndividualQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentActivitiesBoth END) AS SegmentActivitiesBothQ,
			SUM(SegmentHealthSeekerYes) AS SegmentHealthSeekerYesS,
			SUM(SegmentHealthSeekerNo) AS SegmentHealthSeekerNoS,
			SUM(SegmentFrequencyOfUse7Week) AS SegmentFrequencyOfUse7WeekS,
			SUM(SegmentFrequencyOfUse5Week) AS SegmentFrequencyOfUse5WeekS,
			SUM(SegmentFrequencyOfUse3Week) AS SegmentFrequencyOfUse3WeekS,
			SUM(SegmentFrequencyOfUse1Week) AS SegmentFrequencyOfUse1WeekS,
			SUM(SegmentFrequencyOfUse3Month) AS SegmentFrequencyOfUse3MonthS,
			SUM(SegmentFrequencyOfUse1Month) AS SegmentFrequencyOfUse1MonthS,
			SUM(SegmentFrequencyOfUseU1Month) AS SegmentFrequencyOfUseU1MonthS,
			SUM(SegmentNPPromoter) AS SegmentNPPromoterS,
			SUM(SegmentNPDetractor) AS SegmentNPDetractorS,
			SUM(SegmentNPNeither) AS SegmentNPNeitherS,
			SUM(SegmentTimeOfDayEarlyAM) AS SegmentTimeOfDayEarlyAMS,
			SUM(SegmentTimeOfDayMidAM) AS SegmentTimeOfDayMidAMS,
			SUM(SegmentTimeOfDayLunch) AS SegmentTimeOfDayLunchS,
			SUM(SegmentTimeOfDayMidPM) AS SegmentTimeOfDayMidPMS,
			SUM(SegmentTimeOfDayPM) AS SegmentTimeOfDayPMS,
			SUM(SegmentActivitiesGroup) AS SegmentActivitiesGroupS,
			SUM(SegmentActivitiesIndividual) AS SegmentActivitiesIndividualS,
			SUM(SegmentActivitiesBoth) AS SegmentActivitiesBothS
			
	INTO	#BranchSegmentCounts
				
	FROM	#BranchSegment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.QuestionResponseKey = DQR.QuestionResponseKey
				
	GROUP BY BS.BranchKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey;
					
	SELECT	DB.BranchKey,
			DB.AssociationKey,
			DB.OrganizationKey,
			MSR.OrganizationSurveyKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker,
			COUNT(DISTINCT MSR.MemberKey) MemberCount
			
	INTO	#HealthSeekerSegment
			
	FROM	dbo.factMemberSurveyResponse MSR
			INNER JOIN dimSurveyForm DS
				ON MSR.OrganizationSurveyKey = DS.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
				
	--SurveyFormKey filter is for performance			
	WHERE	MSR.OrganizationSurveyKey IN (
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA New Membership Satisfaction Survey'
										)
			AND MSR.GivenDateKey <= CONVERT(INT, REPLACE(CONVERT(VARCHAR(10), CONVERT(DATE, DATEADD(mm, -(DATEPART(MM, DATEADD(MM, 1, GETDATE()))%2 + 3), GETDATE()), 112)), '-', ''))
			AND MSR.current_indicator = 1
	
	GROUP BY DB.BranchKey,
			DB.AssociationKey,
			DB.OrganizationKey,
			MSR.OrganizationSurveyKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker;
				
	SELECT	BSR.BranchKey,
			BSR.batch_key,
			BSR.GivenDateKey,
			A.previous_year_date_given_key PreviousGivenDateKey
			
	INTO	#PreviousSurvey
		
	FROM	dbo.factBranchSurveyResponse BSR
			INNER JOIN dimSurveyForm DOS
				ON bsr.OrganizationSurveyKey  = dos.SurveyFormKey
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON BSR.BranchKey = A.organization_key
					AND DOS.SurveyFormKey = A.survey_form_key
					AND BSR.GivenDateKey = A.date_given_key
	
	--SurveyFormKey Filter is for performance						
	WHERE	BSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
											)
			AND BSR.GivenDateKey <= CONVERT(INT, REPLACE(CONVERT(VARCHAR(10), CONVERT(DATE, DATEADD(mm, -(DATEPART(MM, DATEADD(MM, 1, GETDATE()))%2 + 3), GETDATE()), 112)), '-', ''))
			AND BSR.current_indicator = 1
			AND A.aggregate_type = 'Branch'
			AND A.module = 'New Member'
			
	GROUP BY BSR.BranchKey,
			BSR.batch_key,
			BSR.GivenDateKey,
			A.previous_year_date_given_key;
			
	--BEGIN TRAN
	CREATE INDEX TBSG_NDX_01 ON #BranchSegment ([BranchKey],[OrganizationSurveyKey],[QuestionResponseKey],[SurveyQuestionKey],[GivenDateKey]);

	CREATE INDEX TBSC_NDX_01 ON #BranchSegmentCounts ([BranchKey],[OrganizationSurveyKey],[SurveyQuestionKey],[GivenDateKey]);
		--COMMIT TRAN
	
		
	SELECT	A.BranchKey,
			A.OrganizationSurveyKey,
			A.QuestionResponseKey,
			A.SurveyQuestionKey,
			A.batch_key,
			A.GivenDateKey,
			A.Segment,
			A.BranchCount,
			A.BranchPercentage,
			A.AssociationPercentage,
			A.NationalPercentage,
			A.PeerGroupPercentage,
			A.SegmentHealthSeekerYes,
			A.SegmentHealthSeekerNo, 
			A.PreviousBranchPercentage,
			A.SegmentFrequencyOfUse7Week,
			A.SegmentFrequencyOfUse5Week,
			A.SegmentFrequencyOfUse3Week,
			A.SegmentFrequencyOfUse1Week,
			A.SegmentFrequencyOfUse3Month,
			A.SegmentFrequencyOfUse1Month,
			A.SegmentFrequencyOfUseU1Month, 
			A.SegmentNPPromoter,
			A.SegmentNPDetractor, 
			A.SegmentNPNeither,
			A.SegmentTimeOfDayEarlyAM,
			A.SegmentTimeOfDayMidAM, 
			A.SegmentTimeOfDayLunch,
			A.SegmentTimeOfDayMidPM,
			A.SegmentTimeOfDayPM,
			A.SegmentActivitiesGroup,
			A.SegmentActivitiesIndividual,
			A.SegmentActivitiesBoth
			
	INTO	#BNMER
	
	FROM	(
			SELECT	BSR.BranchKey,
					BSR.OrganizationSurveyKey, 
					BSR.QuestionResponseKey,
					BSR.SurveyQuestionKey,
					BSR.batch_key,
					BSR.GivenDateKey,
					'' Segment,
					BSR.ResponseCount AS BranchCount,
					BSR.ResponsePercentage AS BranchPercentage,
					ASR.ResponsePercentage AS AssociationPercentage,
					OSR.ResponsePercentage AS NationalPercentage,
					PSR.ResponsePercentage AS PeerGroupPercentage,
					PBSR.ResponsePercentage AS PreviousBranchPercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerYesS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerYesQ,0) END,0) SegmentHealthSeekerYes,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerNoS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerNoQ,0) END,0) SegmentHealthSeekerNo,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0) SegmentFrequencyOfUse7Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0) SegmentFrequencyOfUse5Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0) SegmentFrequencyOfUse3Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0) SegmentFrequencyOfUse1Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0) SegmentFrequencyOfUse3Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0) SegmentFrequencyOfUse1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0) SegmentFrequencyOfUseU1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#BranchSegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#BranchSegmentCounts.SegmentNPPromoterQ,0) END,0) SegmentNPPromoter,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#BranchSegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#BranchSegmentCounts.SegmentNPDetractorQ,0) END,0) SegmentNPDetractor,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#BranchSegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#BranchSegmentCounts.SegmentNPNeitherQ,0) END,0) SegmentNPNeither,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0) SegmentTimeOfDayEarlyAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0) SegmentTimeOfDayMidAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0) SegmentTimeOfDayLunch,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0) SegmentTimeOfDayMidPM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayPMQ,0) END,0) SegmentTimeOfDayPM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#BranchSegmentCounts.SegmentActivitiesGroupS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#BranchSegmentCounts.SegmentActivitiesGroupQ,0) END,0) SegmentActivitiesGroup,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#BranchSegmentCounts.SegmentActivitiesIndividualS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#BranchSegmentCounts.SegmentActivitiesIndividualQ,0) END,0) SegmentActivitiesIndividual,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#BranchSegmentCounts.SegmentActivitiesBothS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#BranchSegmentCounts.SegmentActivitiesBothQ,0) END,0) SegmentActivitiesBoth
					
			FROM	dbo.factBranchSurveyResponse BSR
					INNER JOIN dimBranch DB
						ON BSR.BranchKey = DB.BranchKey
					INNER JOIN dimSurveyForm DS
						ON BSR.OrganizationSurveyKey = DS.SurveyFormKey
					INNER JOIN dimSurveyQuestion DQ
						ON BSR.OrganizationSurveyKey = DQ.SurveyFormKey
							AND BSR.SurveyQuestionKey = DQ.SurveyQuestionKey
					INNER JOIN dimQuestionResponse DR
						ON BSR.SurveyQuestionKey = DR.SurveyQuestionKey
							AND BSR.QuestionResponseKey = DR.QuestionResponseKey
					LEFT OUTER JOIN #BranchSegment
						ON #BranchSegment.BranchKey = BSR.BranchKey
							AND #BranchSegment.OrganizationSurveyKey = BSR.OrganizationSurveyKey
							AND #BranchSegment.QuestionResponseKey = BSR.QuestionResponseKey
							AND #BranchSegment.SurveyQuestionKey = BSR.SurveyQuestionKey
							AND #BranchSegment.GivenDateKey = BSR.GivenDateKey
					LEFT OUTER JOIN #BranchSegmentCounts
						ON #BranchSegmentCounts.BranchKey = #BranchSegment.BranchKey
							AND #BranchSegmentCounts.OrganizationSurveyKey = #BranchSegment.OrganizationSurveyKey
							AND #BranchSegmentCounts.SurveyQuestionKey = #BranchSegment.SurveyQuestionKey
							AND #BranchSegmentCounts.GivenDateKey = #BranchSegment.GivenDateKey
					LEFT OUTER JOIN factAssociationSurveyResponse ASR
						ON ASR.AssociationKey = DB.AssociationKey
							AND ASR.SurveyFormKey = DS.SurveyFormKey
							AND ASR.QuestionResponseKey = DR.QuestionResponseKey
							AND ASR.SurveyQuestionKey = DQ.SurveyQuestionKey
							AND ASR.GivenDateKey = BSR.GivenDateKey
					LEFT OUTER JOIN factOrganizationSurveyResponse OSR
						ON OSR.OrganizationKey = DB.OrganizationKey
							AND OSR.Year = LEFT(BSR.GivenDateKey,4)-1
							AND OSR.SurveyFormKey = DS.SurveyFormKey
							--AND OSR.SurveyType = DS.SurveyType
							AND OSR.ResponseKey = DR.ResponseKey
							AND OSR.QuestionKey = DQ.QuestionKey
					LEFT OUTER JOIN factPeerGroupSurveyResponse PSR
						ON PSR.OrganizationKey = DB.OrganizationKey
						AND PSR.PeerGroup = DB.PeerGroup
						AND PSR.Year = LEFT(BSR.GivenDateKey,4)-1
						AND PSR.SurveyFormKey = DS.SurveyFormKey
						--AND PSR.SurveyType = DS.SurveyType
						AND PSR.ResponseKey = DR.ResponseKey
						AND PSR.QuestionKey = DQ.QuestionKey
					LEFT OUTER JOIN
					(
					SELECT	BSR.BranchKey,
							DS.SurveyType,
							DR.ResponseKey,
							DQ.QuestionKey,
							#PreviousSurvey.batch_key,
							#PreviousSurvey.GivenDateKey,
							BSR.ResponsePercentage
							
					FROM	#PreviousSurvey
							INNER JOIN factBranchSurveyResponse BSR
								ON BSR.BranchKey = #PreviousSurvey.BranchKey
								AND BSR.GivenDateKey = #PreviousSurvey.PreviousGivenDateKey
							INNER JOIN dimSurveyForm DS
								ON DS.SurveyFormKey = BSR.OrganizationSurveyKey
							INNER JOIN dimSurveyQuestion DQ
								ON DQ.SurveyQuestionKey = BSR.SurveyQuestionKey
									AND DQ.SurveyFormKey = BSR.OrganizationSurveyKey
							INNER JOIN dimQuestionResponse DR
								ON DR.QuestionResponseKey = BSR.QuestionResponseKey
									AND DR.SurveyQuestionKey = BSR.SurveyQuestionKey
					) PBSR
						ON PBSR.BranchKey = BSR.BranchKey
						AND PBSR.SurveyType = DS.SurveyType
						AND PBSR.ResponseKey = DR.ResponseKey
						AND PBSR.QuestionKey = DQ.QuestionKey
						AND PBSR.batch_key = BSR.batch_key
						AND PBSR.GivenDateKey = BSR.GivenDateKey
						
			--SurveyFormKey Filter is for performance						
			WHERE	BSR.OrganizationSurveyKey IN	(
													SELECT	SurveyFormKey
													FROM	dimSurveyForm
													WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
													)
					AND BSR.current_indicator = 1
					
			GROUP BY BSR.BranchKey,
					BSR.OrganizationSurveyKey, 
					BSR.QuestionResponseKey,
					BSR.SurveyQuestionKey,
					BSR.batch_key,
					BSR.GivenDateKey,
					BSR.ResponseCount,
					BSR.ResponsePercentage,
					ASR.ResponsePercentage,
					OSR.ResponsePercentage,
					PSR.ResponsePercentage,
					PBSR.ResponsePercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerYesS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerYesQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerNoS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#BranchSegmentCounts.SegmentHealthSeekerNoQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#BranchSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#BranchSegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#BranchSegmentCounts.SegmentNPPromoterQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#BranchSegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#BranchSegmentCounts.SegmentNPDetractorQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#BranchSegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#BranchSegmentCounts.SegmentNPNeitherQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#BranchSegmentCounts.SegmentTimeOfDayPMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#BranchSegmentCounts.SegmentActivitiesGroupS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#BranchSegmentCounts.SegmentActivitiesGroupQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#BranchSegmentCounts.SegmentActivitiesIndividualS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#BranchSegmentCounts.SegmentActivitiesIndividualQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#BranchSegmentCounts.SegmentActivitiesBothS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#BranchSegmentCounts.SegmentActivitiesBothQ,0) END,0)
					
			UNION ALL
			
			SELECT	H.BranchKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					H.batch_key,
					H.GivenDateKey,
					'Health Seeker' Segment,
					0 BranchCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'Yes' THEN H.MemberCount
										ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker <> 'Unknown' THEN H.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS BranchPercentage,
					MAX(Ass.AssociationPercentage) AS AssociationPercentage,
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'Yes' THEN Previous.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker <> 'Unknown' THEN Previous.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS PreviousBranchPercentage,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM,
					0 SegmentActivitiesGroup,
					0 SegmentActivitiesIndividual,
					0 SegmentActivitiesBoth
			
			FROM	#HealthSeekerSegment H
					LEFT OUTER JOIN
					(SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' THEN MemberCount
												ELSE 0
											END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker <> 'Unknown' THEN MemberCount
																						ELSE 0
																					END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#HealthSeekerSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON H.AssociationKey = Ass.AssociationKey
						AND H.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' THEN MemberCount
													ELSE 0
											END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker <> 'Unknown' THEN MemberCount
																							ELSE 0
																					END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#HealthSeekerSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON H.OrganizationKey = Org.OrganizationKey
						AND LEFT(H.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON H.BranchKey = #PreviousSurvey.BranchKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.BranchKey = Previous.BranchKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
			
			GROUP BY H.BranchKey,
					H.OrganizationSurveyKey,
					H.batch_key,
					H.GivenDateKey
			
			UNION ALL
			
			SELECT	H.BranchKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyResponseKey,
					H.batch_key,
					H.GivenDateKey,
					'Non Health Seeker' Segment,
					0 BranchCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'No' THEN H.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker <> 'Unknown' THEN H.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS BranchPercentage,
					MAX(Ass.AssociationPercentage) AS AssociationPercentage,
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'No' THEN Previous.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker <> 'Unknown' THEN Previous.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS PreviousBranchPercentage,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM,
					0 SegmentActivitiesGroup,
					0 SegmentActivitiesIndividual,
					0 SegmentActivitiesBoth
			
			FROM	#HealthSeekerSegment H
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker <> 'Unknown' THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#HealthSeekerSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON H.AssociationKey = Ass.AssociationKey
						AND H.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' THEN MemberCount
												ELSE 0
											END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker <> 'Unknown' THEN MemberCount
																						ELSE 0
																					END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#HealthSeekerSegment
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON H.OrganizationKey = Org.OrganizationKey
						AND LEFT(H.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON H.BranchKey = #PreviousSurvey.BranchKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.BranchKey = Previous.BranchKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			GROUP BY H.BranchKey,
					H.OrganizationSurveyKey,
					H.batch_key,
					H.GivenDateKey
			) A;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factBranchNewMemberExperienceReport AS target
	USING	(
			SELECT	A.BranchKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					1 current_indicator,
					A.Segment,
					A.BranchCount,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousBranchPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo, 
					A.SegmentFrequencyOfUse7Week,
					A.SegmentFrequencyOfUse5Week,
					A.SegmentFrequencyOfUse3Week,
					A.SegmentFrequencyOfUse1Week,
					A.SegmentFrequencyOfUse3Month,
					A.SegmentFrequencyOfUse1Month,
					A.SegmentFrequencyOfUseU1Month, 
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither,
					A.SegmentTimeOfDayEarlyAM,
					A.SegmentTimeOfDayMidAM, 
					A.SegmentTimeOfDayLunch,
					A.SegmentTimeOfDayMidPM,
					A.SegmentTimeOfDayPM,
					A.SegmentActivitiesGroup,
					A.SegmentActivitiesIndividual,
					A.SegmentActivitiesBoth
					
			FROM	#BNMER A

			) AS source
			
			ON target.BranchKey = source.BranchKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.Segment = source.Segment
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[BranchCount] <> source.[BranchCount]
								 OR target.[BranchPercentage] <> source.[BranchPercentage]
								 OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								 OR target.[NationalPercentage] <> source.[NationalPercentage]
								 OR target.[PeerGroupPercentage] <> source.[PeerGroupPercentage]
								 OR target.[PreviousBranchPercentage] <> source.[PreviousBranchPercentage]
								 OR target.[SegmentHealthSeekerYes] <> source.[SegmentHealthSeekerYes]
								 OR target.[SegmentHealthSeekerNo] <> source.[SegmentHealthSeekerNo]
								 OR target.[SegmentFrequencyOfUse7Week] <> source.[SegmentFrequencyOfUse7Week]
								 OR target.[SegmentFrequencyOfUse5Week] <> source.[SegmentFrequencyOfUse5Week]
								 OR target.[SegmentFrequencyOfUse3Week] <> source.[SegmentFrequencyOfUse3Week]
								 OR target.[SegmentFrequencyOfUse1Week] <> source.[SegmentFrequencyOfUse1Week]
								 OR target.[SegmentFrequencyOfUse3Month] <> source.[SegmentFrequencyOfUse3Month]
								 OR target.[SegmentFrequencyOfUse1Month] <> source.[SegmentFrequencyOfUse1Month]
								 OR target.[SegmentNPPromoter] <> source.[SegmentNPPromoter]
								 OR target.[SegmentNPDetractor] <> source.[SegmentNPDetractor]
								 OR target.[SegmentNPNeither] <> source.[SegmentNPNeither]
								 OR target.[SegmentTimeOfDayEarlyAM] <> source.[SegmentTimeOfDayEarlyAM]
								 OR target.[SegmentTimeOfDayMidAM] <> source.[SegmentTimeOfDayMidAM]
								 OR target.[SegmentTimeOfDayLunch] <> source.[SegmentTimeOfDayLunch]
								 OR target.[SegmentTimeOfDayMidPM] <> source.[SegmentTimeOfDayMidPM]
								 OR target.[SegmentTimeOfDayPM] <> source.[SegmentTimeOfDayPM]
								 OR target.[SegmentActivitiesGroup] <> source.[SegmentActivitiesGroup]
								 OR target.[SegmentActivitiesIndividual] <> source.[SegmentActivitiesIndividual]
								 OR target.[SegmentActivitiesBoth] <> source.[SegmentActivitiesBoth]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([BranchKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[Segment],
					[BranchCount],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM],
					[SegmentActivitiesGroup],
					[SegmentActivitiesIndividual],
					[SegmentActivitiesBoth]
					)
			VALUES ([BranchKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[Segment],
					[BranchCount],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM],
					[SegmentActivitiesGroup],
					[SegmentActivitiesIndividual],
					[SegmentActivitiesBoth]
					)		
	;
COMMIT TRAN

BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factBranchNewMemberExperienceReport]') AND name = N'BNMER_INDEX_01')
	DROP INDEX [BNMER_INDEX_01] ON [dbo].[factBranchNewMemberExperienceReport] WITH ( ONLINE = OFF );

	CREATE INDEX BNMER_INDEX_01 ON [dbo].[factBranchNewMemberExperienceReport] ([BranchKey], [OrganizationSurveyKey], [QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [Segment], [current_indicator]) ON NDXGROUP;

COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factBranchNewMemberExperienceReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.BranchKey,
					A.OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					1 current_indicator,
					A.Segment,
					A.BranchCount,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousBranchPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo, 
					A.SegmentFrequencyOfUse7Week,
					A.SegmentFrequencyOfUse5Week,
					A.SegmentFrequencyOfUse3Week,
					A.SegmentFrequencyOfUse1Week,
					A.SegmentFrequencyOfUse3Month,
					A.SegmentFrequencyOfUse1Month,
					A.SegmentFrequencyOfUseU1Month, 
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither,
					A.SegmentTimeOfDayEarlyAM,
					A.SegmentTimeOfDayMidAM, 
					A.SegmentTimeOfDayLunch,
					A.SegmentTimeOfDayMidPM,
					A.SegmentTimeOfDayPM,
					A.SegmentActivitiesGroup,
					A.SegmentActivitiesIndividual,
					A.SegmentActivitiesBoth
					
			FROM	#BNMER A

			) AS source
			
			ON target.BranchKey = source.BranchKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.Segment = source.Segment
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[BranchKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[Segment],
					[BranchCount],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM],
					[SegmentActivitiesGroup],
					[SegmentActivitiesIndividual],
					[SegmentActivitiesBoth]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[BranchKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[Segment],
					[BranchCount],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousBranchPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM],
					[SegmentActivitiesGroup],
					[SegmentActivitiesIndividual],
					[SegmentActivitiesBoth]
					)
	;
COMMIT TRAN

BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factBranchNewMemberExperienceReport]') AND name = N'BNMER_INDEX_01')
	DROP INDEX [BNMER_INDEX_01] ON [dbo].[factBranchNewMemberExperienceReport] WITH ( ONLINE = OFF );
	
	DROP TABLE #BranchSegment;
	DROP TABLE #BranchSegmentCounts;
	DROP TABLE #PreviousSurvey;
	DROP TABLE #HealthSeekerSegment;
	DROP TABLE #BNMER;
	
COMMIT TRAN
	
END


