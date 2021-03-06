/*
truncate table dbo.factAssociationStaffExperienceReport
drop proc spPopulate_factAssociationStaffExperienceReport
select * from factAssociationStaffExperienceReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factAssociationStaffExperienceReport] AS
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
			B.change_datetime,
			B.next_change_datetime,
			MSR.current_indicator,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') < 21 THEN 1 ELSE 0 END) AS SegmentAgeRangeU21,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 21 AND 34 THEN 1 ELSE 0 END) AS SegmentAgeRange21to34,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 35 AND 44 THEN 1 ELSE 0 END) AS SegmentAgeRange35to44,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') BETWEEN 45 AND 54 THEN 1 ELSE 0 END) AS SegmentAgeRange45to54,
			SUM(CASE WHEN NULLIF(DM.ExactAge,'U') > 55 THEN 1 ELSE 0 END) AS SegmentAgeRangeO55,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = 'Less Than 1 Year' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfServiceU1,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = '1 Year' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfService1,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = '2 Years' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfService2,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = '3-5 Years' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfService3to5,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = '6-10 Years' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfService6to10,
			SUM(CASE WHEN DM.SurveyEmployeeLengthOfService = 'Longer Than 10 Years' THEN 1 ELSE 0 END) AS SegmentEmployeeLengthOfServiceO10,
			SUM(CASE WHEN DM.SurveyEmployeeType = 'Hourly' THEN 1 ELSE 0 END) AS SegmentEmployeeTypeHourly,
			SUM(CASE WHEN DM.SurveyEmployeeType = 'Salaried' THEN 1 ELSE 0 END) AS SegmentEmployeeTypeSalary,
			SUM(CASE WHEN DM.SurveyEmployeeWorkTime = 'Full Time' THEN 1 ELSE 0 END) AS SegmentEmployeeWorkFullTime,
			SUM(CASE WHEN DM.SurveyEmployeeWorkTime = 'Part Time' THEN 1 ELSE 0 END) AS SegmentEmployeeWorkPartTime,
			SUM(CASE WHEN DM.Gender = 'M' THEN 1 ELSE 0 END) AS SegmentGenderMale,
			SUM(CASE WHEN DM.Gender = 'F' THEN 1 ELSE 0 END) AS SegmentGenderFemale,
			SUM(CASE WHEN DM.SurveyEmployeeDepartment IN ('Administrative','Maintenance') THEN 1 ELSE 0 END) AS SegmentEmployeeDepartmentAdmin,
			SUM(CASE WHEN DM.SurveyEmployeeDepartment IN ('Wellness/Fitness','Aerobics/Group Instruction') THEN 1 ELSE 0 END) AS SegmentEmployeeDepartmentWellness,
			SUM(CASE WHEN DM.SurveyEmployeeDepartment IN ('Membership','Kid''s Zone/Child Watch','Aquatics') THEN 1 ELSE 0 END) AS SegmentEmployeeDepartmentMembership,
			SUM(CASE WHEN DM.SurveyEmployeeDepartment IN ('Childcare','Camp','Youth Sports','Teen Center') THEN 1 ELSE 0 END) AS SegmentEmployeeDepartmentYouthPrograms,
			SUM(CASE WHEN DM.SurveyEmployeeDepartment IN ('Community/Social Services','Other') THEN 1 ELSE 0 END) AS SegmentEmployeeDepartmentOther,
			SUM(CASE WHEN DM.SurveyEmployeePromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentEmployeeNPPromoter,
			SUM(CASE WHEN DM.SurveyEmployeePromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentEmployeeNPDetractor,
			SUM(CASE WHEN DM.SurveyEmployeePromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentEmployeeNPNeither,
			SUM(CASE WHEN DM.SurveyEmployeeMembershipPromoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentMemberNPPromoter,
			SUM(CASE WHEN DM.SurveyEmployeeMembershipPromoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentMemberNPDetractor,
			SUM(CASE WHEN DM.SurveyEmployeeMembershipPromoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentMemberNPNeither
			
	INTO	#AssociationSegment
	
	FROM	factMemberSurveyResponse MSR
			INNER JOIN dimMember DM
				ON MSR.MemberKey = DM.MemberKey
					AND MSR.OrganizationSurveyKey = DM.SurveyFormKey
			INNER JOIN dimBranch DB
				ON MSR.BranchKey = DB.BranchKey
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON MSR.BranchKey = B.organization_key
					AND MSR.batch_key = B.batch_key
					
	--SurveyFormKey Filter is for performance						
	WHERE	MSR.OrganizationSurveyKey IN   (
											SELECT	SurveyFormKey
											FROM	dimSurveyForm
											WHERE	SurveyType = 'YMCA Standard Employee Satisfaction Survey'
											)
			AND MSR.current_indicator = 1
			AND B.module = 'Staff'
			AND B.aggregate_type = 'Branch'  --Even though this is an Association procedure, the link needs to occur at the Branch for Batch Map

	GROUP BY DB.AssociationKey,
			MSR.OrganizationSurveyKey,
			MSR.QuestionResponseKey,
			MSR.SurveyQuestionKey,
			MSR.batch_key,
			MSR.GivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			MSR.current_indicator;

	
	SELECT	BS.AssociationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey,
			BS.change_datetime,
			BS.next_change_datetime,
			BS.current_indicator,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRangeU21 END) AS SegmentAgeRangeU21Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange21to34 END) AS SegmentAgeRange21to34Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange35to44 END) AS SegmentAgeRange35to44Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRange45to54 END) AS SegmentAgeRange45to54Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentAgeRangeO55 END) AS SegmentAgeRangeO55Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfServiceU1 END) AS SegmentEmployeeLengthOfServiceU1Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfService1 END) AS SegmentEmployeeLengthOfService1Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfService2 END) AS SegmentEmployeeLengthOfService2Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfService3to5 END) AS SegmentEmployeeLengthOfService3to5Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfService6to10 END) AS SegmentEmployeeLengthOfService6to10Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeLengthOfServiceO10 END) AS SegmentEmployeeLengthOfServiceO10Q,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeTypeHourly END) AS SegmentEmployeeTypeHourlyQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeTypeSalary END) AS SegmentEmployeeTypeSalaryQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeWorkFullTime END) AS SegmentEmployeeWorkFullTimeQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeWorkPartTime END) AS SegmentEmployeeWorkPartTimeQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentGenderMale END) AS SegmentGenderMaleQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentGenderFemale END) AS SegmentGenderFemaleQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeDepartmentAdmin END) AS SegmentEmployeeDepartmentAdminQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeDepartmentWellness END) AS SegmentEmployeeDepartmentWellnessQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeDepartmentMembership END) AS SegmentEmployeeDepartmentMembershipQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeDepartmentYouthPrograms END) AS SegmentEmployeeDepartmentYouthProgramsQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeDepartmentOther END) AS SegmentEmployeeDepartmentOtherQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeNPPromoter END) AS SegmentEmployeeNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeNPDetractor END) AS SegmentEmployeeNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentEmployeeNPNeither END) AS SegmentEmployeeNPNeitherQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMemberNPPromoter END) AS SegmentMemberNPPromoterQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMemberNPDetractor END) AS SegmentMemberNPDetractorQ,
			SUM(CASE WHEN DQR.ExcludeFromReportCalculation = 'Y' THEN 0 ELSE SegmentMemberNPNeither END) AS SegmentMemberNPNeitherQ,
			SUM(SegmentAgeRangeU21) AS SegmentAgeRangeU21S,
			SUM(SegmentAgeRange21to34) AS SegmentAgeRange21to34S,
			SUM(SegmentAgeRange35to44) AS SegmentAgeRange35to44S,
			SUM(SegmentAgeRange45to54) AS SegmentAgeRange45to54S,
			SUM(SegmentAgeRangeO55) AS SegmentAgeRangeO55S,
			SUM(SegmentEmployeeLengthOfServiceU1) AS SegmentEmployeeLengthOfServiceU1S,
			SUM(SegmentEmployeeLengthOfService1) AS SegmentEmployeeLengthOfService1S,
			SUM(SegmentEmployeeLengthOfService2) AS SegmentEmployeeLengthOfService2S,
			SUM(SegmentEmployeeLengthOfService3to5) AS SegmentEmployeeLengthOfService3to5S,
			SUM(SegmentEmployeeLengthOfService6to10) AS SegmentEmployeeLengthOfService6to10S,
			SUM(SegmentEmployeeLengthOfServiceO10) AS SegmentEmployeeLengthOfServiceO10S,
			SUM(SegmentEmployeeTypeHourly) AS SegmentEmployeeTypeHourlyS,
			SUM(SegmentEmployeeTypeSalary) AS SegmentEmployeeTypeSalaryS,
			SUM(SegmentEmployeeWorkFullTime) AS SegmentEmployeeWorkFullTimeS,
			SUM(SegmentEmployeeWorkPartTime) AS SegmentEmployeeWorkPartTimeS,
			SUM(SegmentGenderMale) AS SegmentGenderMaleS,
			SUM(SegmentGenderFemale) AS SegmentGenderFemaleS,
			SUM(SegmentEmployeeDepartmentAdmin) AS SegmentEmployeeDepartmentAdminS,
			SUM(SegmentEmployeeDepartmentWellness) AS SegmentEmployeeDepartmentWellnessS,
			SUM(SegmentEmployeeDepartmentMembership) AS SegmentEmployeeDepartmentMembershipS,
			SUM(SegmentEmployeeDepartmentYouthPrograms) AS SegmentEmployeeDepartmentYouthProgramsS,
			SUM(SegmentEmployeeDepartmentOther) AS SegmentEmployeeDepartmentOtherS,
			SUM(SegmentEmployeeNPPromoter) AS SegmentEmployeeNPPromoterS,
			SUM(SegmentEmployeeNPDetractor) AS SegmentEmployeeNPDetractorS,
			SUM(SegmentEmployeeNPNeither) AS SegmentEmployeeNPNeitherS,
			SUM(SegmentMemberNPPromoter) AS SegmentMemberNPPromoterS,
			SUM(SegmentMemberNPDetractor) AS SegmentMemberNPDetractorS,
			SUM(SegmentMemberNPNeither) AS SegmentMemberNPNeitherS
			
	INTO	#AssociationSegmentCounts
	
	FROM	#AssociationSegment BS
			INNER JOIN dimQuestionResponse DQR
				ON BS.SurveyQuestionKey = DQR.SurveyQuestionKey
					AND BS.QuestionResponseKey = DQR.QuestionResponseKey
				
	GROUP BY BS.AssociationKey,
			BS.OrganizationSurveyKey,
			BS.SurveyQuestionKey,
			BS.batch_key,
			BS.GivenDateKey,
			BS.change_datetime,
			BS.next_change_datetime,
			BS.current_indicator;

	SELECT	ASR.AssociationKey,
			ASR.batch_key,
			ASR.GivenDateKey,
			A.previous_year_batch_key PreviousBatchKey,
			A.previous_year_date_given_key PreviousGivenDateKey
			
	INTO	#PreviousSurvey
		
	FROM	dbo.factAssociationSurveyResponse ASR
			INNER JOIN dimSurveyForm DOS
				ON ASR.SurveyFormKey  = dos.SurveyFormKey
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON ASR.AssociationKey = A.organization_key
					AND DOS.SurveyFormKey = A.survey_form_key
					AND ASR.batch_key = A.batch_key
					AND ASR.GivenDateKey = A.date_given_key
	
	--SurveyFormKey Filter is for performance						
	WHERE	ASR.SurveyFormKey IN   (
									SELECT	SurveyFormKey
									FROM	dimSurveyForm
									WHERE	SurveyType = 'YMCA Standard Employee Satisfaction Survey'
									)
			AND ASR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'Staff'
	
	GROUP BY ASR.AssociationKey,
			ASR.batch_key,
			ASR.GivenDateKey,
			A.previous_year_batch_key,
			A.previous_year_date_given_key;

	SELECT	ASR.AssociationKey,
			ASR.SurveyFormKey OrganizationSurveyKey, 
			ASR.QuestionResponseKey,
			ASR.SurveyQuestionKey,
			ASR.batch_key,
			ASR.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			ASR.current_indicator,
			ASR.ResponseCount AS AssociationCount,
			ASR.ResponsePercentage AS AssociationPercentage,
			OSR.ResponsePercentage AS NationalPercentage,
			PSR.ResponsePercentage AS PeerGroupPercentage,
			PASR.ResponsePercentage AS PreviousAssociationPercentage, 
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRangeU21)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU21S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRangeU21)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU21Q,0) END,0) SegmentAgeRangeU21,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange21to34)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange21to34S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange21to34)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange21to34Q,0) END,0) SegmentAgeRange21to34,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange35to44)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to44S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange35to44)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to44Q,0) END,0) SegmentAgeRange35to44,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange45to54)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange45to54S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange45to54)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange45to54Q,0) END,0) SegmentAgeRange45to54,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRangeO55)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO55S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRangeO55)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO55Q,0) END,0) SegmentAgeRangeO55,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceU1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceU1S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceU1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceU1Q,0) END,0) SegmentEmployeeLengthOfServiceU1,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService1S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService1Q,0) END,0) SegmentEmployeeLengthOfService1,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService2)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService2S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService2)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService2Q,0) END,0) SegmentEmployeeLengthOfService2,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService3to5)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService3to5S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService3to5)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService3to5Q,0) END,0) SegmentEmployeeLengthOfService3to5,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService6to10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService6to10S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService6to10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService6to10Q,0) END,0) SegmentEmployeeLengthOfService6to10,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceO10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceO10S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceO10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceO10Q,0) END,0) SegmentEmployeeLengthOfServiceO10,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeHourly)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeHourlyS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeHourly)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeHourlyQ,0) END,0) SegmentEmployeeTypeHourly,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeSalary)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeSalaryS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeSalary)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeSalaryQ,0) END,0) SegmentEmployeeTypeSalary,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkFullTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkFullTimeS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkFullTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkFullTimeQ,0) END,0) SegmentEmployeeWorkFullTime,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkPartTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkPartTimeS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkPartTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkPartTimeQ,0) END,0) SegmentEmployeeWorkPartTime,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentGenderMale)/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentGenderMale)/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleQ,0) END,0) SegmentGenderMale,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentGenderFemale)/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentGenderFemale)/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleQ,0) END,0) SegmentGenderFemale,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentAdmin)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentAdminS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentAdmin)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentAdminQ,0) END,0) SegmentEmployeeDepartmentAdmin,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentWellness)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentWellnessS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentWellness)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentWellnessQ,0) END,0) SegmentEmployeeDepartmentWellness,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentMembership)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentMembershipS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentMembership)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentMembershipQ,0) END,0) SegmentEmployeeDepartmentMembership,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentYouthPrograms)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentYouthProgramsS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentYouthPrograms)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentYouthProgramsQ,0) END,0) SegmentEmployeeDepartmentYouthPrograms,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentOther)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentOtherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentOther)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentOtherQ,0) END,0) SegmentEmployeeDepartmentOther,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPPromoterQ,0) END,0) SegmentEmployeeNPPromoter,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPDetractorQ,0) END,0) SegmentEmployeeNPDetractor,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPNeitherQ,0) END,0) SegmentEmployeeNPNeither,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPPromoterQ,0) END,0) SegmentMemberNPPromoter,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPDetractorQ,0) END,0) SegmentMemberNPDetractor,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPNeitherQ,0) END,0) SegmentMemberNPNeither
			
	INTO	#ASER
	
	FROM	dbo.factAssociationSurveyResponse ASR
			INNER JOIN Seer_MDM.dbo.Batch_Map A
				ON ASR.AssociationKey = A.organization_key
					AND ASR.batch_key = A.batch_key
			INNER JOIN dimBranch DB
				ON ASR.AssociationKey = DB.BranchKey
			INNER JOIN dimSurveyForm DS
				ON ASR.SurveyFormKey = DS.SurveyFormKey
			INNER JOIN dimSurveyQuestion DQ
				ON ASR.SurveyQuestionKey = DQ.SurveyQuestionKey
			INNER JOIN dimQuestionResponse DR
				ON ASR.QuestionResponseKey = DR.QuestionResponseKey
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
					AND PASR.SurveyFormKey = DS.SurveyFormKey
					--AND PASR.SurveyType = DS.SurveyType
					AND PASR.ResponseKey = DR.ResponseKey
					AND PASR.QuestionKey = DQ.QuestionKey
					AND PASR.GivenDateKey = ASR.GivenDateKey
					
	--SurveyFormKey Filter is for performance						
	WHERE	ASR.SurveyFormKey IN   (SELECT	SurveyFormKey
									FROM	dimSurveyForm
									WHERE	Description LIKE '%EmpSat Association%'
									)
			AND ASR.current_indicator = 1
			AND A.aggregate_type = 'Association'
			AND A.module = 'Staff'
			
	GROUP BY ASR.AssociationKey,
			ASR.SurveyFormKey, 
			ASR.QuestionResponseKey,
			ASR.SurveyQuestionKey,
			ASR.batch_key,
			ASR.GivenDateKey,
			A.change_datetime,
			A.next_change_datetime,
			ASR.current_indicator,
			ASR.ResponseCount,
			ASR.ResponsePercentage,
			ASR.ResponsePercentage,
			OSR.ResponsePercentage,
			PSR.ResponsePercentage,
			PASR.ResponsePercentage, 
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRangeU21)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU21S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRangeU21)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeU21Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange21to34)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange21to34S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange21to34)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange21to34Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange35to44)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to44S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange35to44)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange35to44Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRange45to54)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange45to54S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRange45to54)/NULLIF(#AssociationSegmentCounts.SegmentAgeRange45to54Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentAgeRangeO55)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO55S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentAgeRangeO55)/NULLIF(#AssociationSegmentCounts.SegmentAgeRangeO55Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceU1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceU1S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceU1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceU1Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService1S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService1)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService1Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService2)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService2S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService2)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService2Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService3to5)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService3to5S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService3to5)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService3to5Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService6to10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService6to10S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfService6to10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfService6to10Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceO10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceO10S,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeLengthOfServiceO10)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeLengthOfServiceO10Q,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeHourly)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeHourlyS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeHourly)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeHourlyQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeSalary)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeSalaryS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeTypeSalary)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeTypeSalaryQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkFullTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkFullTimeS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkFullTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkFullTimeQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkPartTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkPartTimeS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeWorkPartTime)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeWorkPartTimeQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentGenderMale)/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentGenderMale)/NULLIF(#AssociationSegmentCounts.SegmentGenderMaleQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentGenderFemale)/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentGenderFemale)/NULLIF(#AssociationSegmentCounts.SegmentGenderFemaleQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentAdmin)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentAdminS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentAdmin)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentAdminQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentWellness)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentWellnessS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentWellness)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentWellnessQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentMembership)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentMembershipS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentMembership)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentMembershipQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentYouthPrograms)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentYouthProgramsS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentYouthPrograms)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentYouthProgramsQ,0) END,0) ,
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentOther)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentOtherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeDepartmentOther)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeDepartmentOtherQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPPromoterQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPDetractorQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentEmployeeNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentEmployeeNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentEmployeeNPNeitherQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPPromoterS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPPromoter)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPPromoterQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPDetractorS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPDetractor)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPDetractorQ,0) END,0),
			COALESCE(CASE WHEN DR.ExcludeFromReportCalculation = 'Y' THEN CONVERT(DECIMAL(19, 6), SegmentMemberNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPNeitherS,0) ELSE CONVERT(DECIMAL(19, 6), SegmentMemberNPNeither)/NULLIF(#AssociationSegmentCounts.SegmentMemberNPNeitherQ,0) END,0);
			
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationStaffExperienceReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentAgeRangeU21,
					A.SegmentAgeRange21to34,
					A.SegmentAgeRange35to44,
					A.SegmentAgeRange45to54,
					A.SegmentAgeRangeO55, 
					A.SegmentEmployeeLengthOfServiceU1,
					A.SegmentEmployeeLengthOfService1,
					A.SegmentEmployeeLengthOfService2,
					A.SegmentEmployeeLengthOfService3to5,
					A.SegmentEmployeeLengthOfService6to10,
					A.SegmentEmployeeLengthOfServiceO10,
					A.SegmentEmployeeTypeHourly,
					A.SegmentEmployeeTypeSalary,
					A.SegmentEmployeeWorkFullTime,
					A.SegmentEmployeeWorkPartTime, 
					A.SegmentGenderMale,
					A.SegmentGenderFemale,
					A.SegmentEmployeeDepartmentAdmin SegmentDepartmentAdmin,
					A.SegmentEmployeeDepartmentWellness SegmentDepartmentWellness, 
					A.SegmentEmployeeDepartmentMembership SegmentDepartmentMembership,
					A.SegmentEmployeeDepartmentYouthPrograms SegmentDepartmentYouthPrograms,
					A.SegmentEmployeeDepartmentOther SegmentDepartmentOther, 
					A.SegmentEmployeeNPPromoter,
					A.SegmentEmployeeNPDetractor,
					A.SegmentEmployeeNPNeither,
					A.SegmentMemberNPPromoter, 
					A.SegmentMemberNPDetractor,
					A.SegmentMemberNPNeither
					
			FROM	#ASER A
			) as source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.OrganizationSurveyKey = source.OrganizationSurveyKey
				AND target.SurveyQuestionKey = source.SurveyQuestionKey
				AND target.QuestionResponseKey = source.QuestionResponseKey
				AND target.batch_key = source.batch_key
				AND target.GivenDateKey = source.GivenDateKey
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationKey] <> source.[AssociationKey]
								OR target.[OrganizationSurveyKey] <> source.[OrganizationSurveyKey]
								OR target.[QuestionResponseKey] <> source.[QuestionResponseKey]
								OR target.[SurveyQuestionKey] <> source.[SurveyQuestionKey]
								OR target.[GivenDateKey] <> source.[GivenDateKey]
								OR target.[AssociationCount] <> source.[AssociationCount]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PeerGroupPercentage] <> source.[PeerGroupPercentage]
								OR target.[PreviousAssociationPercentage] <> source.[PreviousAssociationPercentage]
								OR target.[SegmentAgeRangeU21] <> source.[SegmentAgeRangeU21]
								OR target.[SegmentAgeRange21to34] <> source.[SegmentAgeRange21to34]
								OR target.[SegmentAgeRange35to44] <> source.[SegmentAgeRange35to44]
								OR target.[SegmentAgeRange45to54] <> source.[SegmentAgeRange45to54]
								OR target.[SegmentAgeRangeO55] <> source.[SegmentAgeRangeO55]
								OR target.[SegmentEmployeeLengthOfServiceU1] <> source.[SegmentEmployeeLengthOfServiceU1]
								OR target.[SegmentEmployeeLengthOfService1] <> source.[SegmentEmployeeLengthOfService1]
								OR target.[SegmentEmployeeLengthOfService2] <> source.[SegmentEmployeeLengthOfService2]
								OR target.[SegmentEmployeeLengthOfService3to5] <> source.[SegmentEmployeeLengthOfService3to5]
								OR target.[SegmentEmployeeLengthOfService6to10] <> source.[SegmentEmployeeLengthOfService6to10]
								OR target.[SegmentEmployeeLengthOfServiceO10] <> source.[SegmentEmployeeLengthOfServiceO10]
								OR target.[SegmentEmployeeTypeHourly] <> source.[SegmentEmployeeTypeHourly]
								OR target.[SegmentEmployeeTypeSalary] <> source.[SegmentEmployeeTypeSalary]
								OR target.[SegmentEmployeeWorkFullTime] <> source.[SegmentEmployeeWorkFullTime]
								OR target.[SegmentEmployeeWorkPartTime] <> source.[SegmentEmployeeWorkPartTime]
								OR target.[SegmentGenderMale] <> source.[SegmentGenderMale]
								OR target.[SegmentGenderFemale] <> source.[SegmentGenderFemale]
								OR target.[SegmentDepartmentAdmin] <> source.[SegmentDepartmentAdmin]
								OR target.[SegmentDepartmentWellness] <> source.[SegmentDepartmentWellness]
								OR target.[SegmentDepartmentMembership] <> source.[SegmentDepartmentMembership]
								OR target.[SegmentDepartmentYouthPrograms] <> source.[SegmentDepartmentYouthPrograms]
								OR target.[SegmentDepartmentOther] <> source.[SegmentDepartmentOther]
								OR target.[SegmentEmployeeNPPromoter] <> source.[SegmentEmployeeNPPromoter]
								OR target.[SegmentEmployeeNPDetractor] <> source.[SegmentEmployeeNPDetractor]
								OR target.[SegmentEmployeeNPNeither] <> source.[SegmentEmployeeNPNeither]
								OR target.[SegmentMemberNPPromoter] <> source.[SegmentMemberNPPromoter]
								OR target.[SegmentMemberNPDetractor] <> source.[SegmentMemberNPDetractor]
								OR target.[SegmentMemberNPNeither] <> source.[SegmentMemberNPNeither]
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
					[OrganizationSurveyKey],
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
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU21],
					[SegmentAgeRange21to34],
					[SegmentAgeRange35to44],
					[SegmentAgeRange45to54],
					[SegmentAgeRangeO55],
					[SegmentEmployeeLengthOfServiceU1],
					[SegmentEmployeeLengthOfService1],
					[SegmentEmployeeLengthOfService2],
					[SegmentEmployeeLengthOfService3to5],
					[SegmentEmployeeLengthOfService6to10],
					[SegmentEmployeeLengthOfServiceO10],
					[SegmentEmployeeTypeHourly],
					[SegmentEmployeeTypeSalary],
					[SegmentEmployeeWorkFullTime],
					[SegmentEmployeeWorkPartTime],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentDepartmentAdmin],
					[SegmentDepartmentWellness],
					[SegmentDepartmentMembership],
					[SegmentDepartmentYouthPrograms],
					[SegmentDepartmentOther],
					[SegmentEmployeeNPPromoter],
					[SegmentEmployeeNPDetractor],
					[SegmentEmployeeNPNeither],
					[SegmentMemberNPPromoter],
					[SegmentMemberNPDetractor],
					[SegmentMemberNPNeither]
					)
			VALUES ([AssociationKey],
					[OrganizationSurveyKey],
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
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU21],
					[SegmentAgeRange21to34],
					[SegmentAgeRange35to44],
					[SegmentAgeRange45to54],
					[SegmentAgeRangeO55],
					[SegmentEmployeeLengthOfServiceU1],
					[SegmentEmployeeLengthOfService1],
					[SegmentEmployeeLengthOfService2],
					[SegmentEmployeeLengthOfService3to5],
					[SegmentEmployeeLengthOfService6to10],
					[SegmentEmployeeLengthOfServiceO10],
					[SegmentEmployeeTypeHourly],
					[SegmentEmployeeTypeSalary],
					[SegmentEmployeeWorkFullTime],
					[SegmentEmployeeWorkPartTime],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentDepartmentAdmin],
					[SegmentDepartmentWellness],
					[SegmentDepartmentMembership],
					[SegmentDepartmentYouthPrograms],
					[SegmentDepartmentOther],
					[SegmentEmployeeNPPromoter],
					[SegmentEmployeeNPDetractor],
					[SegmentEmployeeNPNeither],
					[SegmentMemberNPPromoter],
					[SegmentMemberNPDetractor],
					[SegmentMemberNPNeither]
					)		
	;
COMMIT TRAN
BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationStaffExperienceReport]') AND name = N'ASER_INDEX_01')
	DROP INDEX [ASER_INDEX_01] ON [dbo].[factAssociationStaffExperienceReport] WITH ( ONLINE = OFF );

	CREATE INDEX ASER_INDEX_01 ON [dbo].[factAssociationStaffExperienceReport] ([AssociationKey], [OrganizationSurveyKey], [QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [current_indicator]) ON NDXGROUP;

COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factAssociationStaffExperienceReport AS target
	USING	(
			SELECT	A.AssociationKey,
					A.OrganizationSurveyKey,
					A.SurveyQuestionKey,
					A.QuestionResponseKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationCount,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerGroupPercentage,
					A.PreviousAssociationPercentage,
					A.SegmentAgeRangeU21,
					A.SegmentAgeRange21to34,
					A.SegmentAgeRange35to44,
					A.SegmentAgeRange45to54,
					A.SegmentAgeRangeO55, 
					A.SegmentEmployeeLengthOfServiceU1,
					A.SegmentEmployeeLengthOfService1,
					A.SegmentEmployeeLengthOfService2,
					A.SegmentEmployeeLengthOfService3to5,
					A.SegmentEmployeeLengthOfService6to10,
					A.SegmentEmployeeLengthOfServiceO10,
					A.SegmentEmployeeTypeHourly,
					A.SegmentEmployeeTypeSalary,
					A.SegmentEmployeeWorkFullTime,
					A.SegmentEmployeeWorkPartTime, 
					A.SegmentGenderMale,
					A.SegmentGenderFemale,
					A.SegmentEmployeeDepartmentAdmin SegmentDepartmentAdmin,
					A.SegmentEmployeeDepartmentWellness SegmentDepartmentWellness, 
					A.SegmentEmployeeDepartmentMembership SegmentDepartmentMembership,
					A.SegmentEmployeeDepartmentYouthPrograms SegmentDepartmentYouthPrograms,
					A.SegmentEmployeeDepartmentOther SegmentDepartmentOther,
					A.SegmentEmployeeNPPromoter,
					A.SegmentEmployeeNPDetractor,
					A.SegmentEmployeeNPNeither,
					A.SegmentMemberNPPromoter, 
					A.SegmentMemberNPDetractor,
					A.SegmentMemberNPNeither
					
			FROM	#ASER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
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
			INSERT ([AssociationKey],
					[OrganizationSurveyKey],
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
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU21],
					[SegmentAgeRange21to34],
					[SegmentAgeRange35to44],
					[SegmentAgeRange45to54],
					[SegmentAgeRangeO55],
					[SegmentEmployeeLengthOfServiceU1],
					[SegmentEmployeeLengthOfService1],
					[SegmentEmployeeLengthOfService2],
					[SegmentEmployeeLengthOfService3to5],
					[SegmentEmployeeLengthOfService6to10],
					[SegmentEmployeeLengthOfServiceO10],
					[SegmentEmployeeTypeHourly],
					[SegmentEmployeeTypeSalary],
					[SegmentEmployeeWorkFullTime],
					[SegmentEmployeeWorkPartTime],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentDepartmentAdmin],
					[SegmentDepartmentWellness],
					[SegmentDepartmentMembership],
					[SegmentDepartmentYouthPrograms],
					[SegmentDepartmentOther],
					[SegmentEmployeeNPPromoter],
					[SegmentEmployeeNPDetractor],
					[SegmentEmployeeNPNeither],
					[SegmentMemberNPPromoter],
					[SegmentMemberNPDetractor],
					[SegmentMemberNPNeither]
					)
			VALUES ([AssociationKey],
					[OrganizationSurveyKey],
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
					[PeerGroupPercentage],
					[PreviousAssociationPercentage],
					[SegmentAgeRangeU21],
					[SegmentAgeRange21to34],
					[SegmentAgeRange35to44],
					[SegmentAgeRange45to54],
					[SegmentAgeRangeO55],
					[SegmentEmployeeLengthOfServiceU1],
					[SegmentEmployeeLengthOfService1],
					[SegmentEmployeeLengthOfService2],
					[SegmentEmployeeLengthOfService3to5],
					[SegmentEmployeeLengthOfService6to10],
					[SegmentEmployeeLengthOfServiceO10],
					[SegmentEmployeeTypeHourly],
					[SegmentEmployeeTypeSalary],
					[SegmentEmployeeWorkFullTime],
					[SegmentEmployeeWorkPartTime],
					[SegmentGenderMale],
					[SegmentGenderFemale],
					[SegmentDepartmentAdmin],
					[SegmentDepartmentWellness],
					[SegmentDepartmentMembership],
					[SegmentDepartmentYouthPrograms],
					[SegmentDepartmentOther],
					[SegmentEmployeeNPPromoter],
					[SegmentEmployeeNPDetractor],
					[SegmentEmployeeNPNeither],
					[SegmentMemberNPPromoter],
					[SegmentMemberNPDetractor],
					[SegmentMemberNPNeither]
					)
	;
COMMIT TRAN

BEGIN TRAN

	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factAssociationStaffExperienceReport]') AND name = N'ASER_INDEX_01')
	DROP INDEX [ASER_INDEX_01] ON [dbo].[factAssociationStaffExperienceReport] WITH ( ONLINE = OFF );
	
	DROP TABLE #AssociationSegment;
	DROP TABLE #AssociationSegmentCounts;
	DROP TABLE #PreviousSurvey;
	DROP TABLE #ASER;
	
COMMIT TRAN
	
END


