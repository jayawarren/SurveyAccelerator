/*
truncate table dbo.factAssociationMemberSatisfactionReport
drop proc spPopulate_factAssociationMemberSatisfactionReport
select * from factAssociationMemberSatisfactionReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factAssociationMemberSatisfactionReport] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	DB.AssociationKey,
			MAX(OrganizationSurveyKey) OrganizationSurveyKey,
			QuestionResponseKey,
			SurveyQuestionKey,
			GivenDateKey,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') < 25 THEN 1 ELSE 0 END) AS SegmentAgeRangeU25,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 25 AND 34 THEN 1 ELSE 0 END) AS SegmentAgeRange25to34,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 35 AND 49 THEN 1 ELSE 0 END) AS SegmentAgeRange35to49,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 50 AND 64 THEN 1 ELSE 0 END) AS SegmentAgeRange50to64,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') > 64 THEN 1 ELSE 0 END) AS SegmentAgeRangeO64,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '6-7 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse7Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '4-5 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse5Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '2-3 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Once a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Week,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = '2-3 times a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Month,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Month,
			SUM(CASE WHEN DM.SurveyFrequencyOfUse = 'Less than once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUseU1Month,
			SUM(CASE WHEN DM.Gender = 'M' THEN 1 ELSE 0 END) AS SegmentGenderMale,
			SUM(CASE WHEN DM.Gender = 'F' THEN 1 ELSE 0 END) AS SegmentGenderFemale,
			SUM(CASE WHEN DM.SurveyHealthSeeker = 'Yes' THEN 1 ELSE 0 END) AS SegmentHealthSeekerYes,
			SUM(CASE WHEN DM.SurveyHealthSeeker = 'No' THEN 1 ELSE 0 END) AS SegmentHealthSeekerNo,
			SUM(CASE WHEN DM.SurveyIntentToRenew = 'Definitely will' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitely,
			SUM(CASE WHEN DM.SurveyIntentToRenew = 'Probably will' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbably,
			SUM(CASE WHEN DM.SurveyIntentToRenew = 'Might or might not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewMaybe,
			SUM(CASE WHEN DM.SurveyIntentToRenew = 'Probably not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbablyNot,
			SUM(CASE WHEN DM.SurveyIntentToRenew = 'Definitely not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitelyNot,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = 'Less than 1 year' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipU1,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = '1 year' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership1,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = '2 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership2,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = '3-5 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership3to5,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = '6-10 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership6to10,
			SUM(CASE WHEN DM.SurveyLengthOfMembership = 'Longer than 10 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipO10,
			SUM(CASE WHEN DM.SurveyLoyalty = 'Very loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltyVery,
			SUM(CASE WHEN DM.SurveyLoyalty = 'Somewhat loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltySomewhat,
			SUM(CASE WHEN DM.SurveyLoyalty = 'Not very loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltyNotVery,
			SUM(CASE WHEN DM.SurveyLoyalty = 'Not loyal at all' THEN 1 ELSE 0 END) AS SegmentLoyaltyNot,
			SUM(CASE WHEN DM.SurveyMembershipType IN ('Single Adult','More than one adult') THEN 1 ELSE 0 END) AS SegmentMembershipAdult,
			SUM(CASE WHEN DM.SurveyMembershipType = 'Family w/ kids' THEN 1 ELSE 0 END) AS SegmentMembershipFamily,
			SUM(CASE WHEN DM.SurveyMembershipType = 'Senior' THEN 1 ELSE 0 END) AS SegmentMembershipSenior,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
			SUM(CASE WHEN DM.SurveyNetPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither,
			SUM(CASE WHEN (DM.PresenceOfChildren03 = 'Y' OR DM.PresenceOfChildren46 = 'Y' OR DM.PresenceOfChildren79 = 'Y' OR DM.PresenceOfChildren1012 = 'Y' OR DM.PresenceOfChildren1318 = 'Y') THEN 1 ELSE 0 END) AS SegmentChildrenYes,
			SUM(CASE WHEN (DM.PresenceOfChildren03 <> 'Y' AND DM.PresenceOfChildren46 <> 'Y' AND DM.PresenceOfChildren79 <> 'Y' AND DM.PresenceOfChildren1012 <> 'Y' AND DM.PresenceOfChildren1318 <> 'Y') THEN 1 ELSE 0 END) AS SegmentChildrenNo,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Early morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayEarlyAM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Mid-morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidAM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Lunch' THEN 1 ELSE 0 END) AS SegmentTimeOfDayLunch,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Mid-day' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidPM,
			SUM(CASE WHEN DM.SurveyTimeOfDay = 'Evening' THEN 1 ELSE 0 END) AS SegmentTimeOfDayPM
	
	INTO	#AssociationSegment
			
	FROM	dbo.factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN (
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
										)
			AND MSR.current_indicator = 1
	
	GROUP BY DB.AssociationKey, 
			QuestionResponseKey, 
			SurveyQuestionKey, 
			GivenDateKey;

	SELECT	AssociationKey,
			MAX(OrganizationSurveyKey) OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			GivenDateKey,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRangeU25 END) AS SegmentAgeRangeU25Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange25to34 END) AS SegmentAgeRange25to34Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange35to49 END) AS SegmentAgeRange35to49Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange50to64 END) AS SegmentAgeRange50to64Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRangeO64 END) AS SegmentAgeRangeO64Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse7Week END) AS SegmentFrequencyOfUse7WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse5Week END) AS SegmentFrequencyOfUse5WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse3Week END) AS SegmentFrequencyOfUse3WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse1Week END) AS SegmentFrequencyOfUse1WeekQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse3Month END) AS SegmentFrequencyOfUse3MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUse1Month END) AS SegmentFrequencyOfUse1MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentFrequencyOfUseU1Month END) AS SegmentFrequencyOfUseU1MonthQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentGenderMale END) AS SegmentGenderMaleQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentGenderFemale END) AS SegmentGenderFemaleQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentHealthSeekerYes END) AS SegmentHealthSeekerYesQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentHealthSeekerNo END) AS SegmentHealthSeekerNoQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentIntentToRenewDefinitely END) AS SegmentIntentToRenewDefinitelyQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentIntentToRenewProbably END) AS SegmentIntentToRenewProbablyQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentIntentToRenewMaybe END) AS SegmentIntentToRenewMaybeQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentIntentToRenewProbablyNot END) AS SegmentIntentToRenewProbablyNotQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentIntentToRenewDefinitelyNot END) AS SegmentIntentToRenewDefinitelyNotQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembershipU1 END) AS SegmentLengthOfMembershipU1Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembership1 END) AS SegmentLengthOfMembership1Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembership2 END) AS SegmentLengthOfMembership2Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembership3to5 END) AS SegmentLengthOfMembership3to5Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembership6to10 END) AS SegmentLengthOfMembership6to10Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLengthOfMembershipO10 END) AS SegmentLengthOfMembershipO10Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLoyaltyVery END) AS SegmentLoyaltyVeryQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLoyaltySomewhat END) AS SegmentLoyaltySomewhatQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLoyaltyNotVery END) AS SegmentLoyaltyNotVeryQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentLoyaltyNot END) AS SegmentLoyaltyNotQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMembershipAdult END) AS SegmentMembershipAdultQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMembershipFamily END) AS SegmentMembershipFamilyQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMembershipSenior END) AS SegmentMembershipSeniorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPPromoter END) AS SegmentNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPDetractor END) AS SegmentNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentNPNeither END) AS SegmentNPNeitherQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentChildrenYes END) AS SegmentChildrenYesQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentChildrenNo END) AS SegmentChildrenNoQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayEarlyAM END) AS SegmentTimeOfDayEarlyAMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayMidAM END) AS SegmentTimeOfDayMidAMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayLunch END) AS SegmentTimeOfDayLunchQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayMidPM END) AS SegmentTimeOfDayMidPMQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentTimeOfDayPM END) AS SegmentTimeOfDayPMQ,
			SUM(SegmentAgeRangeU25) AS SegmentAgeRangeU25S,
			SUM(SegmentAgeRange25to34) AS SegmentAgeRange25to34S,
			SUM(SegmentAgeRange35to49) AS SegmentAgeRange35to49S,
			SUM(SegmentAgeRange50to64) AS SegmentAgeRange50to64S,
			SUM(SegmentAgeRangeO64) AS SegmentAgeRangeO64S,
			SUM(SegmentFrequencyOfUse7Week) AS SegmentFrequencyOfUse7WeekS,
			SUM(SegmentFrequencyOfUse5Week) AS SegmentFrequencyOfUse5WeekS,
			SUM(SegmentFrequencyOfUse3Week) AS SegmentFrequencyOfUse3WeekS,
			SUM(SegmentFrequencyOfUse1Week) AS SegmentFrequencyOfUse1WeekS,
			SUM(SegmentFrequencyOfUse3Month) AS SegmentFrequencyOfUse3MonthS,
			SUM(SegmentFrequencyOfUse1Month) AS SegmentFrequencyOfUse1MonthS,
			SUM(SegmentFrequencyOfUseU1Month) AS SegmentFrequencyOfUseU1MonthS,
			SUM(SegmentGenderMale) AS SegmentGenderMaleS,
			SUM(SegmentGenderFemale) AS SegmentGenderFemaleS,
			SUM(SegmentHealthSeekerYes) AS SegmentHealthSeekerYesS,
			SUM(SegmentHealthSeekerNo) AS SegmentHealthSeekerNoS,
			SUM(SegmentIntentToRenewDefinitely) AS SegmentIntentToRenewDefinitelyS,
			SUM(SegmentIntentToRenewProbably) AS SegmentIntentToRenewProbablyS,
			SUM(SegmentIntentToRenewMaybe) AS SegmentIntentToRenewMaybeS,
			SUM(SegmentIntentToRenewProbablyNot) AS SegmentIntentToRenewProbablyNotS,
			SUM(SegmentIntentToRenewDefinitelyNot) AS SegmentIntentToRenewDefinitelyNotS,
			SUM(SegmentLengthOfMembershipU1) AS SegmentLengthOfMembershipU1S,
			SUM(SegmentLengthOfMembership1) AS SegmentLengthOfMembership1S,
			SUM(SegmentLengthOfMembership2) AS SegmentLengthOfMembership2S,
			SUM(SegmentLengthOfMembership3to5) AS SegmentLengthOfMembership3to5S,
			SUM(SegmentLengthOfMembership6to10) AS SegmentLengthOfMembership6to10S,
			SUM(SegmentLengthOfMembershipO10) AS SegmentLengthOfMembershipO10S,
			SUM(SegmentLoyaltyVery) AS SegmentLoyaltyVeryS,
			SUM(SegmentLoyaltySomewhat) AS SegmentLoyaltySomewhatS,
			SUM(SegmentLoyaltyNotVery) AS SegmentLoyaltyNotVeryS,
			SUM(SegmentLoyaltyNot) AS SegmentLoyaltyNotS,
			SUM(SegmentMembershipAdult) AS SegmentMembershipAdultS,
			SUM(SegmentMembershipFamily) AS SegmentMembershipFamilyS,
			SUM(SegmentMembershipSenior) AS SegmentMembershipSeniorS,
			SUM(SegmentNPPromoter) AS SegmentNPPromoterS,
			SUM(SegmentNPDetractor) AS SegmentNPDetractorS,
			SUM(SegmentNPNeither) AS SegmentNPNeitherS,
			SUM(SegmentChildrenYes) AS SegmentChildrenYesS,
			SUM(SegmentChildrenNo) AS SegmentChildrenNoS,
			SUM(SegmentTimeOfDayEarlyAM) AS SegmentTimeOfDayEarlyAMS,
			SUM(SegmentTimeOfDayMidAM) AS SegmentTimeOfDayMidAMS,
			SUM(SegmentTimeOfDayLunch) AS SegmentTimeOfDayLunchS,
			SUM(SegmentTimeOfDayMidPM) AS SegmentTimeOfDayMidPMS,
			SUM(SegmentTimeOfDayPM) AS SegmentTimeOfDayPMS
	
	INTO	#AssociationSegmentCounts
	
	FROM	#AssociationSegment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND BS.QuestionResponseKey = DQR.QuestionResponseKey
				
	GROUP BY AssociationKey,
			BS.SurveyQuestionKey,
			GivenDateKey;

	SELECT	DB.AssociationKey,
			DB.OrganizationKey,
			MAX(MSR.OrganizationSurveyKey) OrganizationSurveyKey,
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
	WHERE	MSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
											)
			
			AND MSR.current_indicator = 1
	
	GROUP BY DB.AssociationKey,
			DB.OrganizationKey,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker;

	SELECT	DB.AssociationKey,
			DB.OrganizationKey,
			MAX(MSR.OrganizationSurveyKey) OrganizationSurveyKey,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker,
			DR.ResponseCode,
			COUNT(DISTINCT MSR.MemberKey) MemberCount
			
	INTO	#HealthSeekerFitnessGoalsSegment
	
	FROM	dbo.factMemberSurveyResponse MSR
			INNER JOIN dimSurveyForm DS
				ON MSR.OrganizationSurveyKey = DS.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
			INNER JOIN dimSurveyQuestion DQ
				ON MSR.SurveyQuestionKey = DQ.SurveyQuestionKey
				AND DQ.Question = 'How much has this YMCA helped you meet your health and well-being goals?'
			INNER JOIN dimQuestionResponse DR
				ON MSR.QuestionResponseKey = DR.QuestionResponseKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
											)
			AND MSR.current_indicator = 1
	
	GROUP BY DB.AssociationKey,
			DB.AssociationKey,
			DB.OrganizationKey,
			MSR.GivenDateKey,
			DM.SurveyHealthSeeker,
			DR.ResponseCode;

	SELECT	DB.AssociationKey,
			DB.OrganizationKey,
			MAX(MSR.OrganizationSurveyKey) OrganizationSurveyKey,
			MSR.GivenDateKey,
			DM.SurveyLoyalty,
			SurveyIntentToRenew,
			COUNT(DISTINCT MSR.MemberKey) MemberCount
			
	INTO	#LoyaltyIntentSegment
	
	FROM	dbo.factMemberSurveyResponse MSR
			INNER JOIN dimSurveyForm DS
				ON MSR.OrganizationSurveyKey = DS.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
				
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
											)
			AND MSR.current_indicator = 1
	
	GROUP BY DB.AssociationKey,
			DB.AssociationKey,
			DB.OrganizationKey,
			MSR.GivenDateKey,
			DM.SurveyLoyalty,
			SurveyIntentToRenew;

	SELECT	ASR.AssociationKey,
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
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
											)
			AND ASR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'Member'
	
	GROUP BY ASR.AssociationKey,
			ASR.GivenDateKey,
			A.previous_year_date_given_key;
			
	--BEGIN TRAN
	CREATE INDEX TASG_NDX_01 ON #AssociationSegment ([AssociationKey],[OrganizationSurveyKey],[QuestionResponseKey],[SurveyQuestionKey],[GivenDateKey])
		INCLUDE ([SegmentAgeRangeU25],[SegmentAgeRange25to34],[SegmentAgeRange35to49],[SegmentAgeRange50to64],[SegmentAgeRangeO64],[SegmentFrequencyOfUse7Week],[SegmentFrequencyOfUse5Week],[SegmentFrequencyOfUse3Week],[SegmentFrequencyOfUse1Week],[SegmentFrequencyOfUse3Month],[SegmentFrequencyOfUse1Month],[SegmentFrequencyOfUseU1Month],[SegmentGenderMale],[SegmentGenderFemale],[SegmentHealthSeekerYes],[SegmentHealthSeekerNo],[SegmentIntentToRenewDefinitely],[SegmentIntentToRenewProbably],[SegmentIntentToRenewMaybe],[SegmentIntentToRenewProbablyNot],[SegmentIntentToRenewDefinitelyNot],[SegmentLengthOfMembershipU1],[SegmentLengthOfMembership1],[SegmentLengthOfMembership2],[SegmentLengthOfMembership3to5],[SegmentLengthOfMembership6to10],[SegmentLengthOfMembershipO10],[SegmentLoyaltyVery],[SegmentLoyaltySomewhat],[SegmentLoyaltyNotVery],[SegmentLoyaltyNot],[SegmentMembershipAdult],[SegmentMembershipFamily],[SegmentMembershipSenior],[SegmentNPPromoter],[SegmentNPDetractor],[SegmentNPNeither],[SegmentChildrenYes],[SegmentChildrenNo],[SegmentTimeOfDayEarlyAM],[SegmentTimeOfDayMidAM],[SegmentTimeOfDayLunch],[SegmentTimeOfDayMidPM],[SegmentTimeOfDayPM])
	CREATE INDEX TASC_NDX_01 ON #AssociationSegmentCounts ([AssociationKey],[OrganizationSurveyKey],[SurveyQuestionKey],[GivenDateKey])
		INCLUDE ([SegmentAgeRangeU25Q],[SegmentAgeRange25to34Q],[SegmentAgeRange35to49Q],[SegmentAgeRange50to64Q],[SegmentAgeRangeO64Q],[SegmentFrequencyOfUse7WeekQ],[SegmentFrequencyOfUse5WeekQ],[SegmentFrequencyOfUse3WeekQ],[SegmentFrequencyOfUse1WeekQ],[SegmentFrequencyOfUse3MonthQ],[SegmentFrequencyOfUse1MonthQ],[SegmentFrequencyOfUseU1MonthQ],[SegmentGenderMaleQ],[SegmentGenderFemaleQ],[SegmentHealthSeekerYesQ],[SegmentHealthSeekerNoQ],[SegmentIntentToRenewDefinitelyQ],[SegmentIntentToRenewProbablyQ],[SegmentIntentToRenewMaybeQ],[SegmentIntentToRenewProbablyNotQ],[SegmentIntentToRenewDefinitelyNotQ],[SegmentLengthOfMembershipU1Q],[SegmentLengthOfMembership1Q],[SegmentLengthOfMembership2Q],[SegmentLengthOfMembership3to5Q],[SegmentLengthOfMembership6to10Q],[SegmentLengthOfMembershipO10Q],[SegmentLoyaltyVeryQ],[SegmentLoyaltySomewhatQ],[SegmentLoyaltyNotVeryQ],[SegmentLoyaltyNotQ],[SegmentMembershipAdultQ],[SegmentMembershipFamilyQ],[SegmentMembershipSeniorQ],[SegmentNPPromoterQ],[SegmentNPDetractorQ],[SegmentNPNeitherQ],[SegmentChildrenYesQ],[SegmentChildrenNoQ],[SegmentTimeOfDayEarlyAMQ],[SegmentTimeOfDayMidAMQ],[SegmentTimeOfDayLunchQ],[SegmentTimeOfDayMidPMQ],[SegmentTimeOfDayPMQ],[SegmentAgeRangeU25S],[SegmentAgeRange25to34S],[SegmentAgeRange35to49S],[SegmentAgeRange50to64S],[SegmentAgeRangeO64S],[SegmentFrequencyOfUse7WeekS],[SegmentFrequencyOfUse5WeekS],[SegmentFrequencyOfUse3WeekS],[SegmentFrequencyOfUse1WeekS],[SegmentFrequencyOfUse3MonthS],[SegmentFrequencyOfUse1MonthS],[SegmentFrequencyOfUseU1MonthS],[SegmentGenderMaleS],[SegmentGenderFemaleS],[SegmentHealthSeekerYesS],[SegmentHealthSeekerNoS],[SegmentIntentToRenewDefinitelyS],[SegmentIntentToRenewProbablyS],[SegmentIntentToRenewMaybeS],[SegmentIntentToRenewProbablyNotS],[SegmentIntentToRenewDefinitelyNotS],[SegmentLengthOfMembershipU1S],[SegmentLengthOfMembership1S],[SegmentLengthOfMembership2S],[SegmentLengthOfMembership3to5S],[SegmentLengthOfMembership6to10S],[SegmentLengthOfMembershipO10S],[SegmentLoyaltyVeryS],[SegmentLoyaltySomewhatS],[SegmentLoyaltyNotVeryS],[SegmentLoyaltyNotS],[SegmentMembershipAdultS],[SegmentMembershipFamilyS],[SegmentMembershipSeniorS],[SegmentNPPromoterS],[SegmentNPDetractorS],[SegmentNPNeitherS],[SegmentChildrenYesS],[SegmentChildrenNoS],[SegmentTimeOfDayEarlyAMS],[SegmentTimeOfDayMidAMS],[SegmentTimeOfDayLunchS],[SegmentTimeOfDayMidPMS],[SegmentTimeOfDayPMS]);
	--COMMIT TRAN
	
	/*
	INSERT INTO factAssociationMemberSatisfactionReport
	(
	AssociationKey,
	OrganizationSurveyKey,
	QuestionResponseKey,
	SurveyQuestionKey,
	GivenDateKey,
	Segment,
	AssociationCount,
	AssociationPercentage,
	AssociationPercentage,
	NationalPercentage,
	PeerGroupPercentage,
	PreviousAssociationPercentage,
	SegmentAgeRangeU25,
	SegmentAgeRange25to34,
	SegmentAgeRange35to49,
	SegmentAgeRange50to64,
	SegmentAgeRangeO64,
	SegmentFrequencyOfUse7Week,
	SegmentFrequencyOfUse5Week,
	SegmentFrequencyOfUse3Week,
	SegmentFrequencyOfUse1Week,
	SegmentFrequencyOfUse3Month,
	SegmentFrequencyOfUse1Month,
	SegmentFrequencyOfUseU1Month, 
	SegmentGenderMale,
	SegmentGenderFemale,
	SegmentHealthSeekerYes,
	SegmentHealthSeekerNo, 
	SegmentIntentToRenewDefinitely,
	SegmentIntentToRenewProbably,
	SegmentIntentToRenewMaybe, 
	SegmentIntentToRenewProbablyNot,
	SegmentIntentToRenewDefinitelyNot,
	SegmentLengthOfMembershipU1, 
	SegmentLengthOfMembership1,
	SegmentLengthOfMembership2,
	SegmentLengthOfMembership3to5, 
	SegmentLengthOfMembership6to10,
	SegmentLengthOfMembershipO10,
	SegmentLoyaltyVery, 
	SegmentLoyaltySomewhat,
	SegmentLoyaltyNotVery,
	SegmentLoyaltyNot,
	SegmentMembershipAdult, 
	SegmentMembershipFamily,
	SegmentMembershipSenior,
	SegmentNPPromoter,
	SegmentNPDetractor, 
	SegmentNPNeither,
	SegmentChildrenYes,
	SegmentChildrenNo,
	SegmentTimeOfDayEarlyAM,
	SegmentTimeOfDayMidAM, 
	SegmentTimeOfDayLunch,
	SegmentTimeOfDayMidPM,
	SegmentTimeOfDayPM
	)
	*/
	
	SELECT	A.AssociationKey,
			A.SurveyFormKey,
			A.QuestionResponseKey,
			A.SurveyQuestionKey,
			A.GivenDateKey,
			A.Segment,
			A.AssociationCount,
			A.AssociationPercentage,
			A.NationalPercentage,
			A.PeerGroupPercentage,
			A.PreviousAssociationPercentage,
			A.SegmentAgeRangeU25,
			A.SegmentAgeRange25to34,
			A.SegmentAgeRange35to49,
			A.SegmentAgeRange50to64,
			A.SegmentAgeRangeO64,
			A.SegmentFrequencyOfUse7Week,
			A.SegmentFrequencyOfUse5Week,
			A.SegmentFrequencyOfUse3Week,
			A.SegmentFrequencyOfUse1Week,
			A.SegmentFrequencyOfUse3Month,
			A.SegmentFrequencyOfUse1Month,
			A.SegmentFrequencyOfUseU1Month, 
			A.SegmentGenderMale,
			A.SegmentGenderFemale,
			A.SegmentHealthSeekerYes,
			A.SegmentHealthSeekerNo, 
			A.SegmentIntentToRenewDefinitely,
			A.SegmentIntentToRenewProbably,
			A.SegmentIntentToRenewMaybe, 
			A.SegmentIntentToRenewProbablyNot,
			A.SegmentIntentToRenewDefinitelyNot,
			A.SegmentLengthOfMembershipU1, 
			A.SegmentLengthOfMembership1,
			A.SegmentLengthOfMembership2,
			A.SegmentLengthOfMembership3to5, 
			A.SegmentLengthOfMembership6to10,
			A.SegmentLengthOfMembershipO10,
			A.SegmentLoyaltyVery, 
			A.SegmentLoyaltySomewhat,
			A.SegmentLoyaltyNotVery,
			A.SegmentLoyaltyNot,
			A.SegmentMembershipAdult, 
			A.SegmentMembershipFamily,
			A.SegmentMembershipSenior,
			A.SegmentNPPromoter,
			A.SegmentNPDetractor, 
			A.SegmentNPNeither,
			A.SegmentChildrenYes,
			A.SegmentChildrenNo,
			A.SegmentTimeOfDayEarlyAM,
			A.SegmentTimeOfDayMidAM, 
			A.SegmentTimeOfDayLunch,
			A.SegmentTimeOfDayMidPM,
			A.SegmentTimeOfDayPM
			
	INTO	#AMSR
	
	FROM	(
			SELECT	ASR.AssociationKey,
					ASR.SurveyFormKey, 
					ASR.QuestionResponseKey,
					ASR.SurveyQuestionKey,
					ASR.GivenDateKey,
					'' Segment,
					ASR.ResponseCount AS AssociationCount,
					ASR.ResponsePercentage AS AssociationPercentage,
					OSR.ResponsePercentage AS NationalPercentage,
					PSR.ResponsePercentage AS PeerGroupPercentage,
					PASR.ResponsePercentage AS PreviousAssociationPercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRangeU25/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU25S,0) ELSE SegmentAgeRangeU25/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU25Q,0) END,0) SegmentAgeRangeU25,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange25to34/NULLIF(#AssociationSegmentCounts.SegmentAgeRange25to34S,0) ELSE SegmentAgeRange25to34/NULLIF(#AssociationSegmentCounts.SegmentAgeRange25to34Q,0) END,0) SegmentAgeRange25to34,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange35to49/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to49S,0) ELSE SegmentAgeRange35to49/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to49Q,0) END,0) SegmentAgeRange35to49,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange50to64/NULLIF(#AssociationSegmentCounts.SegmentAgeRange50to64S,0) ELSE SegmentAgeRange50to64/NULLIF(#AssociationSegmentCounts.SegmentAgeRange50to64Q,0) END,0) SegmentAgeRange50to64,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRangeO64/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO64S,0) ELSE SegmentAgeRangeO64/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO64Q,0) END,0) SegmentAgeRangeO64,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse7Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE SegmentFrequencyOfUse7Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0) SegmentFrequencyOfUse7Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse5Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE SegmentFrequencyOfUse5Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0) SegmentFrequencyOfUse5Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse3Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE SegmentFrequencyOfUse3Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0) SegmentFrequencyOfUse3Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse1Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE SegmentFrequencyOfUse1Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0) SegmentFrequencyOfUse1Week,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse3Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE SegmentFrequencyOfUse3Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0) SegmentFrequencyOfUse3Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE SegmentFrequencyOfUse1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0) SegmentFrequencyOfUse1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUseU1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE SegmentFrequencyOfUseU1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0) SegmentFrequencyOfUseU1Month,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentGenderMale/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleS,0) ELSE SegmentGenderMale/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleQ,0) END,0) SegmentGenderMale,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentGenderFemale/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleS,0) ELSE SegmentGenderFemale/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleQ,0) END,0) SegmentGenderFemale,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentHealthSeekerYes/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesS,0) ELSE SegmentHealthSeekerYes/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesQ,0) END,0) SegmentHealthSeekerYes,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentHealthSeekerNo/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoS,0) ELSE SegmentHealthSeekerNo/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoQ,0) END,0) SegmentHealthSeekerNo,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewDefinitely/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyS,0) ELSE SegmentIntentToRenewDefinitely/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyQ,0) END,0) SegmentIntentToRenewDefinitely,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewProbably/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyS,0) ELSE SegmentIntentToRenewProbably/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyQ,0) END,0) SegmentIntentToRenewProbably,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewMaybe/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewMaybeS,0) ELSE SegmentIntentToRenewMaybe/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewMaybeQ,0) END,0) SegmentIntentToRenewMaybe,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewProbablyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyNotS,0) ELSE SegmentIntentToRenewProbablyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyNotQ,0) END,0) SegmentIntentToRenewProbablyNot,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewDefinitelyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyNotS,0) ELSE SegmentIntentToRenewDefinitelyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyNotQ,0) END,0) SegmentIntentToRenewDefinitelyNot,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembershipU1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipU1S,0) ELSE SegmentLengthOfMembershipU1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipU1Q,0) END,0) SegmentLengthOfMembershipU1,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership1S,0) ELSE SegmentLengthOfMembership1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership1Q,0) END,0) SegmentLengthOfMembership1,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership2/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership2S,0) ELSE SegmentLengthOfMembership2/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership2Q,0) END,0) SegmentLengthOfMembership2,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership3to5/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership3to5S,0) ELSE SegmentLengthOfMembership3to5/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership3to5Q,0) END,0) SegmentLengthOfMembership3to5,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership6to10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership6to10S,0) ELSE SegmentLengthOfMembership6to10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership6to10Q,0) END,0) SegmentLengthOfMembership6to10,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembershipO10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipO10S,0) ELSE SegmentLengthOfMembershipO10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipO10Q,0) END,0) SegmentLengthOfMembershipO10,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyVeryS,0) ELSE SegmentLoyaltyVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyVeryQ,0) END,0) SegmentLoyaltyVery,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltySomewhat/NULLIF(#AssociationSegmentCounts.SegmentLoyaltySomewhatS,0) ELSE SegmentLoyaltySomewhat/NULLIF(#AssociationSegmentCounts.SegmentLoyaltySomewhatQ,0) END,0) SegmentLoyaltySomewhat,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyNotVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotVeryS,0) ELSE SegmentLoyaltyNotVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotVeryQ,0) END,0) SegmentLoyaltyNotVery,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyNot/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotS,0) ELSE SegmentLoyaltyNot/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotQ,0) END,0) SegmentLoyaltyNot,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipAdult/NULLIF(#AssociationSegmentCounts.SegmentMembershipAdultS,0) ELSE SegmentMembershipAdult/NULLIF(#AssociationSegmentCounts.SegmentMembershipAdultQ,0) END,0) SegmentMembershipAdult,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipFamily/NULLIF(#AssociationSegmentCounts.SegmentMembershipFamilyS,0) ELSE SegmentMembershipFamily/NULLIF(#AssociationSegmentCounts.SegmentMembershipFamilyQ,0) END,0) SegmentMembershipFamily,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipSenior/NULLIF(#AssociationSegmentCounts.SegmentMembershipSeniorS,0) ELSE SegmentMembershipSenior/NULLIF(#AssociationSegmentCounts.SegmentMembershipSeniorQ,0) END,0) SegmentMembershipSenior,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPPromoter/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterS,0) ELSE SegmentNPPromoter/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterQ,0) END,0) SegmentNPPromoter,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPDetractor/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorS,0) ELSE SegmentNPDetractor/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorQ,0) END,0) SegmentNPDetractor,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPNeither/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherS,0) ELSE SegmentNPNeither/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherQ,0) END,0) SegmentNPNeither,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentChildrenYes/NULLIF(#AssociationSegmentCounts.SegmentChildrenYesS,0) ELSE SegmentChildrenYes/NULLIF(#AssociationSegmentCounts.SegmentChildrenYesQ,0) END,0) SegmentChildrenYes,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentChildrenNo/NULLIF(#AssociationSegmentCounts.SegmentChildrenNoS,0) ELSE SegmentChildrenNo/NULLIF(#AssociationSegmentCounts.SegmentChildrenNoQ,0) END,0) SegmentChildrenNo,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayEarlyAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE SegmentTimeOfDayEarlyAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0) SegmentTimeOfDayEarlyAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayMidAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE SegmentTimeOfDayMidAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0) SegmentTimeOfDayMidAM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayLunch/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE SegmentTimeOfDayLunch/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0) SegmentTimeOfDayLunch,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayMidPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE SegmentTimeOfDayMidPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0) SegmentTimeOfDayMidPM,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMS,0) ELSE SegmentTimeOfDayPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMQ,0) END,0) SegmentTimeOfDayPM
			
			FROM	dbo.factAssociationSurveyResponse ASR
					INNER JOIN dimBranch DB
						ON ASR.AssociationKey = DB.BranchKey
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
							AND #AssociationSegment.GivenDateKey = ASR.GivenDateKey
					LEFT OUTER JOIN #AssociationSegmentCounts
						ON #AssociationSegmentCounts.AssociationKey = #AssociationSegment.AssociationKey
							AND #AssociationSegmentCounts.OrganizationSurveyKey = #AssociationSegment.OrganizationSurveyKey
							AND #AssociationSegmentCounts.SurveyQuestionKey = #AssociationSegment.SurveyQuestionKey
							AND #AssociationSegmentCounts.GivenDateKey = #AssociationSegment.GivenDateKey
					LEFT OUTER JOIN factOrganizationSurveyResponse OSR
						ON OSR.OrganizationKey = DB.OrganizationKey
							AND OSR.Year = LEFT(ASR.GivenDateKey,4)-1
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
							DS.SurveyFormKey,
							DS.SurveyType,
							DR.ResponseKey,
							DQ.QuestionKey,
							#PreviousSurvey.GivenDateKey,
							ASR.ResponsePercentage
							
					FROM	#PreviousSurvey
							INNER JOIN factAssociationSurveyResponse ASR
								ON ASR.AssociationKey = #PreviousSurvey.AssociationKey
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
							AND PASR.SurveyFormKey = ASR.SurveyFormKey
							--AND PASR.SurveyType = DS.SurveyType
							AND PASR.ResponseKey = DR.ResponseKey
							AND PASR.QuestionKey = DQ.QuestionKey
							AND PASR.GivenDateKey = ASR.GivenDateKey
						
			--SurveyFormKey Filter is for performance						
			WHERE	ASR.SurveyFormKey IN	(
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Membership Satisfaction Survey'
											)
					AND ASR.current_indicator = 1
					
			GROUP BY ASR.AssociationKey,
					ASR.SurveyFormKey, 
					ASR.QuestionResponseKey,
					ASR.SurveyQuestionKey,
					ASR.GivenDateKey,
					ASR.ResponseCount,
					ASR.ResponsePercentage,
					OSR.ResponsePercentage,
					PSR.ResponsePercentage,
					PASR.ResponsePercentage,
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRangeU25/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU25S,0) ELSE SegmentAgeRangeU25/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU25Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange25to34/NULLIF(#AssociationSegmentCounts.SegmentAgeRange25to34S,0) ELSE SegmentAgeRange25to34/NULLIF(#AssociationSegmentCounts.SegmentAgeRange25to34Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange35to49/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to49S,0) ELSE SegmentAgeRange35to49/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to49Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRange50to64/NULLIF(#AssociationSegmentCounts.SegmentAgeRange50to64S,0) ELSE SegmentAgeRange50to64/NULLIF(#AssociationSegmentCounts.SegmentAgeRange50to64Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentAgeRangeO64/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO64S,0) ELSE SegmentAgeRangeO64/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO64Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse7Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekS,0) ELSE SegmentFrequencyOfUse7Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse7WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse5Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekS,0) ELSE SegmentFrequencyOfUse5Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse5WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse3Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekS,0) ELSE SegmentFrequencyOfUse3Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse1Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekS,0) ELSE SegmentFrequencyOfUse1Week/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1WeekQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse3Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthS,0) ELSE SegmentFrequencyOfUse3Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse3MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUse1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthS,0) ELSE SegmentFrequencyOfUse1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUse1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentFrequencyOfUseU1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthS,0) ELSE SegmentFrequencyOfUseU1Month/NULLIF(#AssociationSegmentCounts.SegmentFrequencyOfUseU1MonthQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentGenderMale/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleS,0) ELSE SegmentGenderMale/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentGenderFemale/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleS,0) ELSE SegmentGenderFemale/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentHealthSeekerYes/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesS,0) ELSE SegmentHealthSeekerYes/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerYesQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentHealthSeekerNo/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoS,0) ELSE SegmentHealthSeekerNo/NULLIF(#AssociationSegmentCounts.SegmentHealthSeekerNoQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewDefinitely/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyS,0) ELSE SegmentIntentToRenewDefinitely/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewProbably/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyS,0) ELSE SegmentIntentToRenewProbably/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewMaybe/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewMaybeS,0) ELSE SegmentIntentToRenewMaybe/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewMaybeQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewProbablyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyNotS,0) ELSE SegmentIntentToRenewProbablyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewProbablyNotQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentIntentToRenewDefinitelyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyNotS,0) ELSE SegmentIntentToRenewDefinitelyNot/NULLIF(#AssociationSegmentCounts.SegmentIntentToRenewDefinitelyNotQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembershipU1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipU1S,0) ELSE SegmentLengthOfMembershipU1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipU1Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership1S,0) ELSE SegmentLengthOfMembership1/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership1Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership2/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership2S,0) ELSE SegmentLengthOfMembership2/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership2Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership3to5/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership3to5S,0) ELSE SegmentLengthOfMembership3to5/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership3to5Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembership6to10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership6to10S,0) ELSE SegmentLengthOfMembership6to10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembership6to10Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLengthOfMembershipO10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipO10S,0) ELSE SegmentLengthOfMembershipO10/NULLIF(#AssociationSegmentCounts.SegmentLengthOfMembershipO10Q,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyVeryS,0) ELSE SegmentLoyaltyVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyVeryQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltySomewhat/NULLIF(#AssociationSegmentCounts.SegmentLoyaltySomewhatS,0) ELSE SegmentLoyaltySomewhat/NULLIF(#AssociationSegmentCounts.SegmentLoyaltySomewhatQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyNotVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotVeryS,0) ELSE SegmentLoyaltyNotVery/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotVeryQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentLoyaltyNot/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotS,0) ELSE SegmentLoyaltyNot/NULLIF(#AssociationSegmentCounts.SegmentLoyaltyNotQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipAdult/NULLIF(#AssociationSegmentCounts.SegmentMembershipAdultS,0) ELSE SegmentMembershipAdult/NULLIF(#AssociationSegmentCounts.SegmentMembershipAdultQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipFamily/NULLIF(#AssociationSegmentCounts.SegmentMembershipFamilyS,0) ELSE SegmentMembershipFamily/NULLIF(#AssociationSegmentCounts.SegmentMembershipFamilyQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentMembershipSenior/NULLIF(#AssociationSegmentCounts.SegmentMembershipSeniorS,0) ELSE SegmentMembershipSenior/NULLIF(#AssociationSegmentCounts.SegmentMembershipSeniorQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPPromoter/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterS,0) ELSE SegmentNPPromoter/NULLIF(#AssociationSegmentCounts.SegmentNPPromoterQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPDetractor/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorS,0) ELSE SegmentNPDetractor/NULLIF(#AssociationSegmentCounts.SegmentNPDetractorQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentNPNeither/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherS,0) ELSE SegmentNPNeither/NULLIF(#AssociationSegmentCounts.SegmentNPNeitherQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentChildrenYes/NULLIF(#AssociationSegmentCounts.SegmentChildrenYesS,0) ELSE SegmentChildrenYes/NULLIF(#AssociationSegmentCounts.SegmentChildrenYesQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentChildrenNo/NULLIF(#AssociationSegmentCounts.SegmentChildrenNoS,0) ELSE SegmentChildrenNo/NULLIF(#AssociationSegmentCounts.SegmentChildrenNoQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayEarlyAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMS,0) ELSE SegmentTimeOfDayEarlyAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayEarlyAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayMidAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMS,0) ELSE SegmentTimeOfDayMidAM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidAMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayLunch/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchS,0) ELSE SegmentTimeOfDayLunch/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayLunchQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayMidPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMS,0) ELSE SegmentTimeOfDayMidPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayMidPMQ,0) END,0),
					COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN SegmentTimeOfDayPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMS,0) ELSE SegmentTimeOfDayPM/NULLIF(#AssociationSegmentCounts.SegmentTimeOfDayPMQ,0) END,0)
			
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					H.GivenDateKey,
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
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
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
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
			
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.GivenDateKey
			
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyResponseKey,
					H.GivenDateKey,
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
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
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
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.GivenDateKey
			
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					H.GivenDateKey,
					'Health Seeker Fitness Goals' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'Yes' AND H.ResponseCode = '1' THEN H.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'Yes' THEN H.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'Yes' AND Previous.ResponseCode = '1' THEN Previous.MemberCount
								ELSE 0
							END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'Yes' THEN Previous.MemberCount
																		ELSE 0
																	END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
			FROM	#HealthSeekerFitnessGoalsSegment H
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' AND ResponseCode = '1' THEN MemberCount
										ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' THEN MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#HealthSeekerFitnessGoalsSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON H.AssociationKey = Ass.AssociationKey
						AND H.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' AND ResponseCode = '1' THEN MemberCount
													ELSE 0
											END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'Yes' THEN MemberCount
																						ELSE 0
																					END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#HealthSeekerFitnessGoalsSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON H.OrganizationKey = Org.OrganizationKey
						AND LEFT(H.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerFitnessGoalsSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.GivenDateKey
			
			UNION ALL
			
			SELECT	H.AssociationKey,
					H.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					H.GivenDateKey,
					'Non Health Seeker Fitness Goals' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'No' AND H.ResponseCode = '1' THEN H.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN H.SurveyHealthSeeker = 'No' THEN H.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'No' AND Previous.ResponseCode = '1' THEN Previous.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyHealthSeeker = 'No' THEN Previous.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
			FROM	#HealthSeekerFitnessGoalsSegment H
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' AND ResponseCode = '1' THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#HealthSeekerFitnessGoalsSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON H.AssociationKey = Ass.AssociationKey
						AND H.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' AND ResponseCode = '1' THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyHealthSeeker = 'No' THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#HealthSeekerFitnessGoalsSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON H.OrganizationKey = Org.OrganizationKey
						AND LEFT(H.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON H.AssociationKey = #PreviousSurvey.AssociationKey
						AND H.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #HealthSeekerFitnessGoalsSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			GROUP BY H.AssociationKey,
					H.OrganizationSurveyKey,
					H.GivenDateKey
			
			UNION ALL
			
			SELECT	L.AssociationKey,
					L.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyQuestionKey,
					L.GivenDateKey,
					'Very Loyal Likely to Renew' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN L.SurveyLoyalty = 'Very loyal' AND L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyLoyalty = 'Very loyal' AND Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
			FROM	#LoyaltyIntentSegment L
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty = 'Very loyal' AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0 
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#LoyaltyIntentSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON L.AssociationKey = Ass.AssociationKey
						AND L.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty = 'Very loyal' AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#LoyaltyIntentSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON L.OrganizationKey = Org.OrganizationKey
						AND LEFT(L.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON L.AssociationKey = #PreviousSurvey.AssociationKey
						AND L.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #LoyaltyIntentSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
						
			GROUP BY L.AssociationKey,
					L.OrganizationSurveyKey,
					L.GivenDateKey
		
			UNION ALL
			
			SELECT	L.AssociationKey,
					L.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyResponseKey,
					L.GivenDateKey,
					'Somewhat Loyal Likely to Renew' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN L.SurveyLoyalty = 'Somewhat loyal' AND L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyLoyalty = 'Somewhat loyal' AND Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
			
			FROM	#LoyaltyIntentSegment L
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty = 'Somewhat loyal' AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#LoyaltyIntentSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON L.AssociationKey = Ass.AssociationKey
						AND L.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty = 'Somewhat loyal' AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0
											END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																						ELSE 0
																					END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM #LoyaltyIntentSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON L.OrganizationKey = Org.OrganizationKey
						AND LEFT(L.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON L.AssociationKey = #PreviousSurvey.AssociationKey
						AND L.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #LoyaltyIntentSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
			
			GROUP BY L.AssociationKey,
					L.OrganizationSurveyKey,
					L.GivenDateKey

			UNION ALL
				
			SELECT	L.AssociationKey,
					L.OrganizationSurveyKey,
					-1 QuestionResponseKey,
					-1 SurveyResponseKey,
					L.GivenDateKey,
					'Not Loyal Likely to Renew' Segment,
					0 AssociationCount,
					COALESCE(CAST(SUM(CASE WHEN L.SurveyLoyalty IN ('Not very loyal','Not loyal at all') AND L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
											ELSE 0
									END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN L.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN L.MemberCount
																				ELSE 0
																			END) AS Decimal(12,2)),0),0) AS AssociationPercentage,
					
					MAX(Org.OrganizationPercentage) AS OrganizationPercentage,
					0 PeerGroupPercentage,
					COALESCE(CAST(SUM(CASE WHEN Previous.SurveyLoyalty IN ('Not very loyal','Not loyal at all') AND Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
											ELSE 0
										END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN Previous.SurveyIntentToRenew IN ('Definitely will','Probably will') THEN Previous.MemberCount
																					ELSE 0
																				END) AS Decimal(12,2)),0),0) AS PreviousAssociationPercentage,
					0 SegmentAgeRangeU25,
					0 SegmentAgeRange25to34,
					0 SegmentAgeRange35to49,
					0 SegmentAgeRange50to64,
					0 SegmentAgeRangeO64,
					0 SegmentFrequencyOfUse7Week,
					0 SegmentFrequencyOfUse5Week,
					0 SegmentFrequencyOfUse3Week,
					0 SegmentFrequencyOfUse1Week,
					0 SegmentFrequencyOfUse3Month,
					0 SegmentFrequencyOfUse1Month,
					0 SegmentFrequencyOfUseU1Month, 
					0 SegmentGenderMale,
					0 SegmentGenderFemale,
					0 SegmentHealthSeekerYes,
					0 SegmentHealthSeekerNo, 
					0 SegmentIntentToRenewDefinitely,
					0 SegmentIntentToRenewProbably,
					0 SegmentIntentToRenewMaybe, 
					0 SegmentIntentToRenewProbablyNot,
					0 SegmentIntentToRenewDefinitelyNot,
					0 SegmentLengthOfMembershipU1, 
					0 SegmentLengthOfMembership1,
					0 SegmentLengthOfMembership2,
					0 SegmentLengthOfMembership3to5, 
					0 SegmentLengthOfMembership6to10,
					0 SegmentLengthOfMembershipO10,
					0 SegmentLoyaltyVery, 
					0 SegmentLoyaltySomewhat,
					0 SegmentLoyaltyNotVery,
					0 SegmentLoyaltyNot,
					0 SegmentMembershipAdult, 
					0 SegmentMembershipFamily,
					0 SegmentMembershipSenior,
					0 SegmentNPPromoter,
					0 SegmentNPDetractor, 
					0 SegmentNPNeither,
					0 SegmentChildrenYes,
					0 SegmentChildrenNo,
					0 SegmentTimeOfDayEarlyAM,
					0 SegmentTimeOfDayMidAM, 
					0 SegmentTimeOfDayLunch,
					0 SegmentTimeOfDayMidPM,
					0 SegmentTimeOfDayPM
													
			FROM	#LoyaltyIntentSegment L
					LEFT OUTER JOIN
					(
					SELECT	AssociationKey,
							GivenDateKey,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty IN ('Not very loyal','Not loyal at all') AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS AssociationPercentage
					
					FROM	#LoyaltyIntentSegment
					
					GROUP BY AssociationKey,
							GivenDateKey
					) Ass
						ON L.AssociationKey = Ass.AssociationKey
						AND L.GivenDateKey = Ass.GivenDateKey
					LEFT OUTER JOIN
					(
					SELECT	OrganizationKey,
							LEFT(GivenDateKey,4) AS Year,
							COALESCE(CAST(SUM(CASE WHEN SurveyLoyalty IN ('Not very loyal','Not loyal at all') AND SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
													ELSE 0
												END) AS Decimal(12,2))/NULLIF(CAST(SUM(CASE WHEN SurveyIntentToRenew IN ('Definitely will','Probably will') THEN MemberCount
																							ELSE 0
																						END) AS Decimal(12,2)),0),0) AS OrganizationPercentage
					
					FROM	#LoyaltyIntentSegment
					
					GROUP BY OrganizationKey,
							LEFT(GivenDateKey,4)
					) Org
						ON L.OrganizationKey = Org.OrganizationKey
						AND LEFT(L.GivenDateKey,4) = Org.Year
					LEFT OUTER JOIN #PreviousSurvey
						ON L.AssociationKey = #PreviousSurvey.AssociationKey
						AND L.GivenDateKey = #PreviousSurvey.GivenDateKey
					LEFT OUTER JOIN #LoyaltyIntentSegment Previous
						ON #PreviousSurvey.AssociationKey = Previous.AssociationKey
						AND #PreviousSurvey.PreviousGivenDateKey = Previous.GivenDateKey
			
			GROUP BY L.AssociationKey,
					L.OrganizationSurveyKey,
					L.GivenDateKey
			) A;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationMemberSatisfactionReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.SurveyFormKey OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.GivenDateKey,
					1 current_indicator,
					A.Segment,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentAgeRangeU25,
					A.SegmentAgeRange25to34,
					A.SegmentAgeRange35to49,
					A.SegmentAgeRange50to64,
					A.SegmentAgeRangeO64,
					A.SegmentFrequencyOfUse7Week,
					A.SegmentFrequencyOfUse5Week,
					A.SegmentFrequencyOfUse3Week,
					A.SegmentFrequencyOfUse1Week,
					A.SegmentFrequencyOfUse3Month,
					A.SegmentFrequencyOfUse1Month,
					A.SegmentFrequencyOfUseU1Month, 
					A.SegmentGenderMale,
					A.SegmentGenderFemale,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo, 
					A.SegmentIntentToRenewDefinitely,
					A.SegmentIntentToRenewProbably,
					A.SegmentIntentToRenewMaybe, 
					A.SegmentIntentToRenewProbablyNot,
					A.SegmentIntentToRenewDefinitelyNot,
					A.SegmentLengthOfMembershipU1, 
					A.SegmentLengthOfMembership1,
					A.SegmentLengthOfMembership2,
					A.SegmentLengthOfMembership3to5, 
					A.SegmentLengthOfMembership6to10,
					A.SegmentLengthOfMembershipO10,
					A.SegmentLoyaltyVery, 
					A.SegmentLoyaltySomewhat,
					A.SegmentLoyaltyNotVery,
					A.SegmentLoyaltyNot,
					A.SegmentMembershipAdult, 
					A.SegmentMembershipFamily,
					A.SegmentMembershipSenior,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither,
					A.SegmentChildrenYes,
					A.SegmentChildrenNo,
					A.SegmentTimeOfDayEarlyAM,
					A.SegmentTimeOfDayMidAM, 
					A.SegmentTimeOfDayLunch,
					A.SegmentTimeOfDayMidPM,
					A.SegmentTimeOfDayPM
					
			FROM	#AMSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.GivenDateKey = source.GivenDateKey
				AND target.Segment = source.Segment
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[AssociationCount] <> source.[AssociationCount]
								 OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								 OR target.[NationalPercentage] <> source.[NationalPercentage]
								 OR target.[PeerGroupPercentage] <> source.[PeerGroupPercentage]
								 OR target.[PreviousAssociationPercentage] <> source.[PreviousAssociationPercentage]
								 OR target.[SegmentAgeRangeU25] <> source.[SegmentAgeRangeU25]
								 OR target.[SegmentAgeRange25to34] <> source.[SegmentAgeRange25to34]
								 OR target.[SegmentAgeRange35to49] <> source.[SegmentAgeRange35to49]
								 OR target.[SegmentAgeRange50to64] <> source.[SegmentAgeRange50to64]
								 OR target.[SegmentAgeRangeO64] <> source.[SegmentAgeRangeO64]
								 OR target.[SegmentFrequencyOfUse7Week] <> source.[SegmentFrequencyOfUse7Week]
								 OR target.[SegmentFrequencyOfUse5Week] <> source.[SegmentFrequencyOfUse5Week]
								 OR target.[SegmentFrequencyOfUse3Week] <> source.[SegmentFrequencyOfUse3Week]
								 OR target.[SegmentFrequencyOfUse1Week] <> source.[SegmentFrequencyOfUse1Week]
								 OR target.[SegmentFrequencyOfUse3Month] <> source.[SegmentFrequencyOfUse3Month]
								 OR target.[SegmentFrequencyOfUse1Month] <> source.[SegmentFrequencyOfUse1Month]
								 OR target.[SegmentFrequencyOfUseU1Month ] <> source.[SegmentFrequencyOfUseU1Month ]
								 OR target.[SegmentGenderMale] <> source.[SegmentGenderMale]
								 OR target.[SegmentGenderFemale] <> source.[SegmentGenderFemale]
								 OR target.[SegmentHealthSeekerYes] <> source.[SegmentHealthSeekerYes]
								 OR target.[SegmentHealthSeekerNo ] <> source.[SegmentHealthSeekerNo ]
								 OR target.[SegmentIntentToRenewDefinitely] <> source.[SegmentIntentToRenewDefinitely]
								 OR target.[SegmentIntentToRenewProbably] <> source.[SegmentIntentToRenewProbably]
								 OR target.[SegmentIntentToRenewMaybe ] <> source.[SegmentIntentToRenewMaybe ]
								 OR target.[SegmentIntentToRenewProbablyNot] <> source.[SegmentIntentToRenewProbablyNot]
								 OR target.[SegmentIntentToRenewDefinitelyNot] <> source.[SegmentIntentToRenewDefinitelyNot]
								 OR target.[SegmentLengthOfMembershipU1 ] <> source.[SegmentLengthOfMembershipU1 ]
								 OR target.[SegmentLengthOfMembership1] <> source.[SegmentLengthOfMembership1]
								 OR target.[SegmentLengthOfMembership2] <> source.[SegmentLengthOfMembership2]
								 OR target.[SegmentLengthOfMembership3to5 ] <> source.[SegmentLengthOfMembership3to5 ]
								 OR target.[SegmentLengthOfMembership6to10] <> source.[SegmentLengthOfMembership6to10]
								 OR target.[SegmentLengthOfMembershipO10] <> source.[SegmentLengthOfMembershipO10]
								 OR target.[SegmentLoyaltyVery ] <> source.[SegmentLoyaltyVery ]
								 OR target.[SegmentLoyaltySomewhat] <> source.[SegmentLoyaltySomewhat]
								 OR target.[SegmentLoyaltyNotVery] <> source.[SegmentLoyaltyNotVery]
								 OR target.[SegmentLoyaltyNot] <> source.[SegmentLoyaltyNot]
								 OR target.[SegmentMembershipAdult ] <> source.[SegmentMembershipAdult ]
								 OR target.[SegmentMembershipFamily] <> source.[SegmentMembershipFamily]
								 OR target.[SegmentMembershipSenior] <> source.[SegmentMembershipSenior]
								 OR target.[SegmentNPPromoter] <> source.[SegmentNPPromoter]
								 OR target.[SegmentNPDetractor ] <> source.[SegmentNPDetractor ]
								 OR target.[SegmentNPNeither] <> source.[SegmentNPNeither]
								 OR target.[SegmentChildrenYes] <> source.[SegmentChildrenYes]
								 OR target.[SegmentChildrenNo] <> source.[SegmentChildrenNo]
								 OR target.[SegmentTimeOfDayEarlyAM] <> source.[SegmentTimeOfDayEarlyAM]
								 OR target.[SegmentTimeOfDayMidAM ] <> source.[SegmentTimeOfDayMidAM ]
								 OR target.[SegmentTimeOfDayLunch] <> source.[SegmentTimeOfDayLunch]
								 OR target.[SegmentTimeOfDayMidPM] <> source.[SegmentTimeOfDayMidPM]
								 OR target.[SegmentTimeOfDayPM] <> source.[SegmentTimeOfDayPM]
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
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU25],
					[SegmentAgeRange25to34],
					[SegmentAgeRange35to49],
					[SegmentAgeRange50to64],
					[SegmentAgeRangeO64],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month ],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentIntentToRenewDefinitely],
					[SegmentIntentToRenewProbably],
					[SegmentIntentToRenewMaybe],
					[SegmentIntentToRenewProbablyNot],
					[SegmentIntentToRenewDefinitelyNot],
					[SegmentLengthOfMembershipU1],
					[SegmentLengthOfMembership1],
					[SegmentLengthOfMembership2],
					[SegmentLengthOfMembership3to5 ],
					[SegmentLengthOfMembership6to10],
					[SegmentLengthOfMembershipO10],
					[SegmentLoyaltyVery],
					[SegmentLoyaltySomewhat],
					[SegmentLoyaltyNotVery],
					[SegmentLoyaltyNot],
					[SegmentMembershipAdult],
					[SegmentMembershipFamily],
					[SegmentMembershipSenior],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentChildrenYes],
					[SegmentChildrenNo],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM]
					)
			VALUES ([AssociationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU25],
					[SegmentAgeRange25to34],
					[SegmentAgeRange35to49],
					[SegmentAgeRange50to64],
					[SegmentAgeRangeO64],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month ],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentIntentToRenewDefinitely],
					[SegmentIntentToRenewProbably],
					[SegmentIntentToRenewMaybe],
					[SegmentIntentToRenewProbablyNot],
					[SegmentIntentToRenewDefinitelyNot],
					[SegmentLengthOfMembershipU1],
					[SegmentLengthOfMembership1],
					[SegmentLengthOfMembership2],
					[SegmentLengthOfMembership3to5 ],
					[SegmentLengthOfMembership6to10],
					[SegmentLengthOfMembershipO10],
					[SegmentLoyaltyVery],
					[SegmentLoyaltySomewhat],
					[SegmentLoyaltyNotVery],
					[SegmentLoyaltyNot],
					[SegmentMembershipAdult],
					[SegmentMembershipFamily],
					[SegmentMembershipSenior],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentChildrenYes],
					[SegmentChildrenNo],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM]
					)		
	;
COMMIT TRAN

BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationMemberSatisfactionReport]') AND name = N'AMSR_INDEX_01')
	DROP INDEX [AMSR_INDEX_01] ON [dbo].[factAssociationMemberSatisfactionReport] WITH ( ONLINE = OFF );

	CREATE INDEX AMSR_INDEX_01 ON [dbo].[factAssociationMemberSatisfactionReport] ([AssociationKey], [OrganizationSurveyKey], [QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [Segment], [current_indicator]) ON NDXGROUP;

COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationMemberSatisfactionReport AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.SurveyFormKey OrganizationSurveyKey,
					A.QuestionResponseKey,
					A.SurveyQuestionKey,
					A.GivenDateKey,
					1 current_indicator,
					A.Segment,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentAgeRangeU25,
					A.SegmentAgeRange25to34,
					A.SegmentAgeRange35to49,
					A.SegmentAgeRange50to64,
					A.SegmentAgeRangeO64,
					A.SegmentFrequencyOfUse7Week,
					A.SegmentFrequencyOfUse5Week,
					A.SegmentFrequencyOfUse3Week,
					A.SegmentFrequencyOfUse1Week,
					A.SegmentFrequencyOfUse3Month,
					A.SegmentFrequencyOfUse1Month,
					A.SegmentFrequencyOfUseU1Month, 
					A.SegmentGenderMale,
					A.SegmentGenderFemale,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo, 
					A.SegmentIntentToRenewDefinitely,
					A.SegmentIntentToRenewProbably,
					A.SegmentIntentToRenewMaybe, 
					A.SegmentIntentToRenewProbablyNot,
					A.SegmentIntentToRenewDefinitelyNot,
					A.SegmentLengthOfMembershipU1, 
					A.SegmentLengthOfMembership1,
					A.SegmentLengthOfMembership2,
					A.SegmentLengthOfMembership3to5, 
					A.SegmentLengthOfMembership6to10,
					A.SegmentLengthOfMembershipO10,
					A.SegmentLoyaltyVery, 
					A.SegmentLoyaltySomewhat,
					A.SegmentLoyaltyNotVery,
					A.SegmentLoyaltyNot,
					A.SegmentMembershipAdult, 
					A.SegmentMembershipFamily,
					A.SegmentMembershipSenior,
					A.SegmentNPPromoter,
					A.SegmentNPDetractor, 
					A.SegmentNPNeither,
					A.SegmentChildrenYes,
					A.SegmentChildrenNo,
					A.SegmentTimeOfDayEarlyAM,
					A.SegmentTimeOfDayMidAM, 
					A.SegmentTimeOfDayLunch,
					A.SegmentTimeOfDayMidPM,
					A.SegmentTimeOfDayPM
					
			FROM	#AMSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.GivenDateKey = source.GivenDateKey
				AND target.Segment = source.Segment
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU25],
					[SegmentAgeRange25to34],
					[SegmentAgeRange35to49],
					[SegmentAgeRange50to64],
					[SegmentAgeRangeO64],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month ],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentIntentToRenewDefinitely],
					[SegmentIntentToRenewProbably],
					[SegmentIntentToRenewMaybe],
					[SegmentIntentToRenewProbablyNot],
					[SegmentIntentToRenewDefinitelyNot],
					[SegmentLengthOfMembershipU1],
					[SegmentLengthOfMembership1],
					[SegmentLengthOfMembership2],
					[SegmentLengthOfMembership3to5 ],
					[SegmentLengthOfMembership6to10],
					[SegmentLengthOfMembershipO10],
					[SegmentLoyaltyVery],
					[SegmentLoyaltySomewhat],
					[SegmentLoyaltyNotVery],
					[SegmentLoyaltyNot],
					[SegmentMembershipAdult],
					[SegmentMembershipFamily],
					[SegmentMembershipSenior],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentChildrenYes],
					[SegmentChildrenNo],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[OrganizationSurveyKey],
					[QuestionResponseKey],
					[SurveyQuestionKey],
					[GivenDateKey],
					[Segment],
					[AssociationCount],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU25],
					[SegmentAgeRange25to34],
					[SegmentAgeRange35to49],
					[SegmentAgeRange50to64],
					[SegmentAgeRangeO64],
					[SegmentFrequencyOfUse7Week],
					[SegmentFrequencyOfUse5Week],
					[SegmentFrequencyOfUse3Week],
					[SegmentFrequencyOfUse1Week],
					[SegmentFrequencyOfUse3Month],
					[SegmentFrequencyOfUse1Month],
					[SegmentFrequencyOfUseU1Month ],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo],
					[SegmentIntentToRenewDefinitely],
					[SegmentIntentToRenewProbably],
					[SegmentIntentToRenewMaybe],
					[SegmentIntentToRenewProbablyNot],
					[SegmentIntentToRenewDefinitelyNot],
					[SegmentLengthOfMembershipU1],
					[SegmentLengthOfMembership1],
					[SegmentLengthOfMembership2],
					[SegmentLengthOfMembership3to5 ],
					[SegmentLengthOfMembership6to10],
					[SegmentLengthOfMembershipO10],
					[SegmentLoyaltyVery],
					[SegmentLoyaltySomewhat],
					[SegmentLoyaltyNotVery],
					[SegmentLoyaltyNot],
					[SegmentMembershipAdult],
					[SegmentMembershipFamily],
					[SegmentMembershipSenior],
					[SegmentNPPromoter],
					[SegmentNPDetractor],
					[SegmentNPNeither],
					[SegmentChildrenYes],
					[SegmentChildrenNo],
					[SegmentTimeOfDayEarlyAM],
					[SegmentTimeOfDayMidAM],
					[SegmentTimeOfDayLunch],
					[SegmentTimeOfDayMidPM],
					[SegmentTimeOfDayPM]
					)
	;
COMMIT TRAN

BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationMemberSatisfactionReport]') AND name = N'AMSR_INDEX_01')
	DROP INDEX [AMSR_INDEX_01] ON [dbo].[factAssociationMemberSatisfactionReport] WITH ( ONLINE = OFF );
	
	DROP TABLE #AssociationSegment;
	DROP TABLE #AssociationSegmentCounts;
	DROP TABLE #PreviousSurvey;
	DROP TABLE #HealthSeekerSegment;
	DROP TABLE #HealthSeekerFitnessGoalsSegment;
	DROP TABLE #LoyaltyIntentSegment;
	DROP TABLE #AMSR;
	
COMMIT TRAN
	
END


