/*
truncate table dbo.factAssociationNewMemberExperienceReport
drop proc spPopulate_factAssociationNewMemberExperienceReport
select * from factAssociationNewMemberExperienceReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factAssociationNewMemberExperienceReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	DB.AssociationKey,
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
	
	INTO	#AssociationSegment
			
	FROM	factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN (
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
										)
			AND MSR.current_indicator = 1
				
	GROUP BY DB.AssociationKey,
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
			
	INTO	#AssociationSegmentCounts
				
	FROM	#AssociationSegment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.QuestionResponseKey = DQR.QuestionResponseKey
				
	GROUP BY BS.AssociationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey;
					
	SELECT	DB.AssociationKey,
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
	
	GROUP BY DB.AssociationKey,
			DB.AssociationKey,
			DB.OrganizationKey,
			MSR.OrganizationSurveyKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker;
				
	SELECT	ASR.AssociationKey,
			ASR.batch_key,
			A.previous_year_batch_key PreviousBatchKey,
			ASR.GivenDateKey,
			A.previous_year_date_given_key PreviousGivenDateKey
			
	INTO	#PreviousSurvey
		
	FROM	dbo.factAssociationSurveyResponse ASR
			INNER JOIN dimSurveyForm DOS
				ON ASR.SurveyFormKey  = dos.SurveyFormKey
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON ASR.AssociationKey = A.organization_key
					AND DOS.SurveyFormKey = A.survey_form_key
					AND ASR.GivenDateKey = A.date_given_key
	
	--SurveyFormKey Filter is for performance						
	WHERE	ASR.SurveyFormKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
											)
			AND ASR.GivenDateKey <= CONVERT(INT, REPLACE(CONVERT(VARCHAR(10), CONVERT(DATE, DATEADD(mm, -(DATEPART(MM, DATEADD(MM, 1, GETDATE()))%2 + 3), GETDATE()), 112)), '-', ''))
			AND ASR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'New Member'
			
	GROUP BY ASR.AssociationKey,
			ASR.batch_key,
			A.previous_year_batch_key,
			ASR.GivenDateKey,
			A.previous_year_date_given_key;
			
	--BEGIN TRAN
	CREATE INDEX TASG_NDX_01 ON #AssociationSegment ([AssociationKey],[OrganizationSurveyKey],[QuestionResponseKey],[SurveyQuestionKey],[GivenDateKey]);

	CREATE INDEX TASC_NDX_01 ON #AssociationSegmentCounts ([AssociationKey],[OrganizationSurveyKey],[SurveyQuestionKey],[GivenDateKey]);
		--COMMIT TRAN
	
		
	SELECT	distinct
			A.AssociationKey,
			A.OrganizationSurveyKey,
			A.QuestionResponseKey,
			A.SurveyQuestionKey,
			A.batch_key,
			A.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			A.current_indicator,
			A.Segment,
			A.AssociationCount,
			A.AssociationPercentage,
			A.NationalPercentage,
			A.PeerGroupPercentage,
			A.SegmentHealthSeekerYes,
			A.SegmentHealthSeekerNo, 
			A.PreviousAssociationPercentage,
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
			
	INTO	#ANMER
	
	FROM	(
			SELECT	ASR.AssociationKey,
					ASR.SurveyFormKey OrganizationSurveyKey, 
					ASR.QuestionResponseKey,
					ASR.SurveyQuestionKey,
					ASR.batch_key,
					ASR.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					ASR.current_indicator,
					'' Segment,
					ASR.ResponseCount AS AssociationCount,
					ASR.ResponsePercentage AS AssociationPercentage,
					OSR.ResponsePercentage AS NationalPercentage,
					PSR.ResponsePercentage AS PeerGroupPercentage,
					PASR.ResponsePercentage AS PreviousAssociationPercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesQ,0) END,0) SegmentHealthSeekerYes,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoQ,0) END,0) SegmentHealthSeekerNo,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0) SegmentFrequencyOfUse7Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0) SegmentFrequencyOfUse5Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0) SegmentFrequencyOfUse3Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0) SegmentFrequencyOfUse1Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0) SegmentFrequencyOfUse3Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0) SegmentFrequencyOfUse1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0) SegmentFrequencyOfUseU1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterQ,0) END,0) SegmentNPPromoter,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorQ,0) END,0) SegmentNPDetractor,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherQ,0) END,0) SegmentNPNeither,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0) SegmentTimeOfDayEarlyAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0) SegmentTimeOfDayMidAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0) SegmentTimeOfDayLunch,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0) SegmentTimeOfDayMidPM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMQ,0) END,0) SegmentTimeOfDayPM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesGroupS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesGroupQ,0) END,0) SegmentActivitiesGroup,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesIndividualS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesIndividualQ,0) END,0) SegmentActivitiesIndividual,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesBothS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesBothQ,0) END,0) SegmentActivitiesBoth
					
			FROM	dbo.factAssociationSurveyResponse ASR
					INNER JOIN Seer_MDM.dbo.Batch_Map B
						ON ASR.AssociationKey = B.organization_key
							AND ASR.batch_key = B.batch_key
					INNER JOIN dimBranch DB
						ON ASR.AssociationKey = DB.AssociationKey
					INNER JOIN dimSurveyForm DS
						ON ASR.SurveyFormKey = DS.SurveyFormKey
					INNER JOIN dimSurveyQuestion DQ
						ON ASR.SurveyFormKey = DQ.SurveyFormKey
							AND ASR.SurveyQuestionKey = DQ.SurveyQuestionKey
					INNER JOIN dimQuestionResponse DR
						ON ASR.SurveyQuestionKey = DR.SurveyQuestionKey
							AND ASR.QuestionResponseKey = DR.QuestionResponseKey
					LEFT OUTER JOIN #AssociationSegment
						ON #AssociationSegment.AssociationKey = ASR.AssociationKey
							AND #AssociationSegment.OrganizationSurveyKey = ASR.SurveyFormKey
							AND #AssociationSegment.QuestionResponseKey = ASR.QuestionResponseKey
							AND #AssociationSegment.SurveyQuestionKey = ASR.SurveyQuestionKey
							AND #AssociationSegment.batch_key = ASR.batch_key
							AND #AssociationSegment.GivenDateKey = ASR.GivenDateKey
					LEFT OUTER JOIN #AssociationSegmentCounts
						ON #AssociationSegmentCounts.AssociationKey = #AssociationSegment.AssociationKey
							AND #AssociationSegmentCounts.OrganizationSurveyKey = #AssociationSegment.OrganizationSurveyKey
							AND #AssociationSegmentCounts.SurveyQuestionKey = #AssociationSegment.SurveyQuestionKey
							AND #AssociationSegmentCounts.batch_key = #AssociationSegment.batch_key
							AND #AssociationSegmentCounts.GivenDateKey = #AssociationSegment.GivenDateKey
					LEFT OUTER JOIN factOrganizationSurveyResponse OSR
						ON OSR.Year = LEFT(ASR.GivenDateKey,4) - 1
							AND OSR.SurveyFormKey = DS.SurveyFormKey
							--AND OSR.SurveyType = DS.SurveyType
							AND OSR.ResponseKey = DR.ResponseKey
							AND OSR.QuestionKey = DQ.QuestionKey
					LEFT OUTER JOIN factPeerGroupSurveyResponse PSR
						ON PSR.OrganizationKey = DB.OrganizationKey
						AND PSR.PeerGroup = DB.PeerGroup
						AND PSR.Year = LEFT(ASR.GivenDateKey,4)-1
						AND PSR.SurveyFormKey = DS.SurveyFormKey
						--AND PSR.SurveyType = DS.SurveyType
						AND PSR.ResponseKey = DR.ResponseKey
						AND PSR.QuestionKey = DQ.QuestionKey
					LEFT OUTER JOIN
					(
					SELECT	ASR.AssociationKey,
							DS.SurveyType,
							DR.ResponseKey,
							DQ.QuestionKey,
							#PreviousSurvey.batch_key,
							#PreviousSurvey.GivenDateKey,
							ASR.ResponsePercentage
							
					FROM	#PreviousSurvey
							INNER JOIN factAssociationSurveyResponse ASR
								ON ASR.AssociationKey = #PreviousSurvey.AssociationKey
								AND ASR.batch_key = #PreviousSurvey.PreviousBatchKey
								AND ASR.GivenDateKey = #PreviousSurvey.PreviousGivenDateKey
							INNER JOIN dimSurveyForm DS
								ON DS.SurveyFormKey = ASR.SurveyFormKey
							INNER JOIN dimSurveyQuestion DQ
								ON DQ.SurveyQuestionKey = ASR.SurveyQuestionKey
									AND DQ.SurveyFormKey = ASR.SurveyFormKey
							INNER JOIN dimQuestionResponse DR
								ON DR.QuestionResponseKey = ASR.QuestionResponseKey
									AND DR.SurveyQuestionKey = ASR.SurveyQuestionKey
					) PASR
						ON PASR.AssociationKey = ASR.AssociationKey
						AND PASR.SurveyType = DS.SurveyType
						AND PASR.ResponseKey = DR.ResponseKey
						AND PASR.QuestionKey = DQ.QuestionKey
						AND PASR.batch_key = ASR.batch_key
						AND PASR.GivenDateKey = ASR.GivenDateKey
						
			--SurveyFormKey Filter is for performance						
			WHERE	ASR.SurveyFormKey IN	(
													SELECT	SurveyFormKey
													FROM	dimSurveyForm
													WHERE	SurveyType = 'YMCA New Member Satisfaction Survey'
													)
					AND ASR.current_indicator = 1
					AND B.aggregate_type = 'Association'
					AND B.module = 'New Member'
					
			GROUP BY ASR.AssociationKey,
					ASR.SurveyFormKey, 
					ASR.QuestionResponseKey,
					ASR.SurveyQuestionKey,
					ASR.batch_key,
					ASR.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					ASR.current_indicator,
					ASR.ResponseCount,
					ASR.ResponsePercentage,
					OSR.ResponsePercentage,
					PSR.ResponsePercentage,
					PASR.ResponsePercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerYes)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentHealthSeekerNo)/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse7Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse5Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Week)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse3Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUse1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentFrequencyOfUseU1Month)/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayEarlyAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidAM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayLunch)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayMidPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentTimeOfDayPM)/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesGroupS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesGroup)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesGroupQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesIndividualS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesIndividual)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesIndividualQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesBothS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentActivitiesBoth)/NULLIF(#AssociationSegmentCounts.SegmentActivitiesBothQ,0) END,0)
					
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					H.batch_key,
					H.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					1 current_indicator,
					'Health Seeker' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'Yes' THEN H.MemberCount
										ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker <> 'Unknown' THEN H.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'Yes' THEN Previous.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker <> 'Unknown' THEN Previous.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
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
					INNER JOIN Seer_MDM.dbo.Batch_Map B
					ON H.AssociationKey = B.organization_key
						AND H.batch_key = B.batch_key
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
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
			
			WHERE	B.aggregate_type = 'Association'
					AND B.module = 'New Member'
					
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.batch_key,
					H.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime
			
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyResponseKey,
					H.batch_key,
					H.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					1 current_indicator,
					'Non Health Seeker' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'No' THEN H.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker <> 'Unknown' THEN H.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'No' THEN Previous.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker <> 'Unknown' THEN Previous.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
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
					INNER JOIN Seer_MDM.dbo.Batch_Map B
					ON H.AssociationKey = B.organization_key
						AND H.batch_key = B.batch_key
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
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.batch_key = #PreviousSurvey.batch_key
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousBatchKey = Previous.batch_key
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			WHERE	B.aggregate_type = 'Association'
					AND B.module = 'New Member'
					
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.batch_key,
					H.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime
			) A;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dbo.factAssociationNewMemberExperienceReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.OrganizationSurveyKey SurveyFormKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Segment,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
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
					
			FROM	#ANMER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.Segment = source.Segment
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationCount] <> source.[AssociationCount]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PeerGroupPercentage] <> source.[PeerGroupPercentage]
								OR target.[PreviousAssociationPercentage] <> source.[PreviousAssociationPercentage]
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
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
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
			VALUES ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
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

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationNewMemberExperienceReport]') AND name = N'ANMER_INDEX_01')
	DROP INDEX [ANMER_INDEX_01] ON [dbo].[factAssociationNewMemberExperienceReport] WITH ( ONLINE = OFF );

	CREATE INDEX ANMER_INDEX_01 ON [dbo].[factAssociationNewMemberExperienceReport] ([AssociationKey], [SurveyFormKey], [QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [Segment], [current_indicator]) ON NDXGROUP;

COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationNewMemberExperienceReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.OrganizationSurveyKey SurveyFormKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Segment,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
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
					
			FROM	#ANMER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.SurveyFormKey = source.SurveyFormKey
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
			INSERT ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
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
			VALUES ([AssociationKey],
					[SurveyFormKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
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

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationNewMemberExperienceReport]') AND name = N'ANMER_INDEX_01')
	DROP INDEX [ANMER_INDEX_01] ON [dbo].[factAssociationNewMemberExperienceReport] WITH ( ONLINE = OFF );
	
	DROP TABLE #AssociationSegment;
	DROP TABLE #AssociationSegmentCounts;
	DROP TABLE #PreviousSurvey;
	DROP TABLE #HealthSeekerSegment;
	DROP TABLE #ANMER;
	
COMMIT TRAN
	
END


