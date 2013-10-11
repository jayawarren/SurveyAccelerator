USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimMember]    Script Date: 07/28/2013 22:21:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER view [dbo].[dimMember] as
select	A.member_key as MemberKey,
		COALESCE(B.organization_key, 0) OrganizationKey,
		COALESCE(B.survey_form_key, 0) SurveyFormKey,
		'' as BranchKey,
		A.member_cleansed_id as SeerKey,
		A.member_id as MemberId,
		A.family_id as FamilyId,
		A.head_of_household as HeadOfHousehold,
		A.member_first_name as MemberFirstName,
		A.member_middle_name as MemberMiddleName,
		A.member_last_name as MemberLastName,
		A.address_1 as Address1,
		A.address_2 as Address2,
		A.address_city as AddressCity,
		A.address_state as AddressState,
		A.address_postal as AddressPostal,
		A.address_country as AddressCountry,
		A.parsed_address_line_quality as AddressLineQuality,
		A.parsed_address_csz_quality as AddressCSZQuality,
		A.phone as Phone,
		A.email_address as EmailAddress,
		A.birth_date as Birthdate,
		A.exact_age as ExactAge,
		A.estimated_age as EstimatedAge,
		A.gender as Gender,
		A.estimated_household_income_amount as EstimatedHouseholdIncomeAmount,
		A.county_income_percentile as CountyIncomePercentile,
		A.marital_status as MaritalStatus,
		A.home_business_indicator as HomeBusinessIndicator,
		A.presence_of_children_03 as PresenceOfChildren03,
		A.gender_of_children_03 as GenderOfChildren03,
		A.presence_of_children_46 as PresenceOfChildren46,
		A.gender_of_children_46 as GenderOfChildren46,
		A.presence_of_children_79 as PresenceOfChildren79,
		A.gender_of_children_79 as GenderOfChildren79,
		A.presence_of_children_1012 as PresenceOfChildren1012,
		A.gender_of_children_1012 as GenderOfChildren1012,
		A.presence_of_children_1318 as PresenceOfChildren1318,
		A.gender_of_children_1318 as GenderOfChildren1318,
		A.number_of_adults_in_household as NumberOfAdultsInHousehold,
		A.home_owner as Homeowner,
		A.probable_home_owner as ProbableHomeowner,
		A.length_of_residence as LengthOfResidence,
		A.dwelling_unit_size_code as DwellingUnitSizeCode,
		A.year_built as YearBuilt,
		A.multi_codirect_mail as MultiCoDirectMail,
		A.news_and_financial as NewsAndFinancial,
		A.current_estimated_median_family_income as CurrentEstimatedMedianFamilyIncome,
		A.median_education_years_attained as MedianEducationYearsAttained,
		A.pct_occ_management as PctOccManagement,
		A.pct_occ_health_technologists as PctOccHealthTechnologists,
		A.pct_white_only as PctWhiteOnly,
		A.median_housing_value as MedianHousingValue,
		A.pct_population_under_4 as PctPopulationUnder4,
		A.pct_population_59 as PctPopulation59,
		A.pct_population_1013 as PctPopulation1013,
		A.pct_population_1417 as PctPopulation1417,
		A.pct_dwelling_owner_occupied as PctDwellingOwnerOccupied,
		A.pct_dwelling_renter_occupied as PctDwellingRenterOccupied,
		A.current_estimated_family_income_decile as CurrentEstimatedFamilyIncomeDecile,
		A.bible_devotional_religious as BibleDevotionalReligious,
		A.volunteer_work as VolunteerWork,
		A.hoh_education_flag as HOHEducationFlag,
		A.hoh_occupation_flag as HOHOccupationFlag,
		A.animal_welfare_contributions as AnimalWelfareContributions,
		A.childrens_welfare as ChildrensWelfare,
		A.cultural_welfare as CulturalWelfare,
		A.environmental as Environmental,
		A.health_related as HealthRelated,
		A.political as Political,
		A.religious_contributions as ReligiousContributions,
		A.social_services as SocialServices,
		A.use_mac_computer as UseMacComputer,
		A.own_cd_rom as OwnCDRom,
		A.use_modem as UseModem,
		A.own_computer as OwnComputer,
		A.laser_printer as LaserPrinter,
		A.color_printer as ColorPrinter,
		A.use_internet_service as UseInternetService,
		A.stock_bond_investor as StockBondInvestor,
		A.cd_money_market_investor as CDMoneyMarketInvestor,
		A.ira_investor as IRAInvestor,
		A.mutual_fund_investor as MutualFundInvestor,
		A.real_estate_investor as RealEstateInvestor,
		A.crafts as Crafts,
		A.estimated_current_home_value as EstimatedCurrentHomeValue,
		A.latitude as Latitude,
		A.longitude as Longitude,
		A.lev_lat_long as LevLatLong,
		A.fips_state_code as FipsStateCode,
		A.fips_county_code as FipsCountyCode,
		A.census_tract as CensusTract,
		A.census_block_group as CensusBlockGroup,
		A.block_id as BlockId,
		A.mcdccd_code as MCDCCDCode,
		A.cbsa_code as CBSACode,
		A.enhancement_match_type as EnhancementMatchType,
		A.census_match_level as CensusMatchLevel,
		A.current_estimated_family_income_amount as CurrentEstimatedFamilyIncomeAmount,
		'' as SourceID,
		A.membership_type as SurveyMembershipType,
		A.is_health_seeker as SurveyHealthSeeker,
		B.frequency_of_use as SurveyFrequencyOfUse,
		B.length_of_membership as SurveyLengthOfMembership,
		B.net_promoter as SurveyNetPromoter,
		B.loyalty as SurveyLoyalty,
		B.intent_to_renew as SurveyIntentToRenew,
		B.time_of_day as SurveyTimeOfDay,
		A.number_in_household as NumberInHousehold,
		A.member_name_suffix as MemberNameSuffix,
		A.ethnicity as Ethnicity,
		A.membership_date as MembershipDate,
		A.category as Category,
		A.membership_type as MembershipType,
		A.staff_type as StaffType,
		A.full_time_part_time as FullTimePartTime,
		A.hourly_salary as HourlySalary,
		A.is_primary_member as IsPrimaryMember,
		A.is_employee as IsEmployee,
		A.is_donor as IsDonor,
		A.is_program_member as IsProgramMember,
		A.is_new_member as IsNewMember,
		A.is_active as IsActive,
		A.removal_reason as RemovalReason,
		A.comments as Comments,
		COALESCE(B.employee_type, '') as SurveyEmployeeType,
		COALESCE(B.employee_work_time, '') as SurveyEmployeeWorkTime,
		COALESCE(B.employee_length_of_service, '') as SurveyEmployeeLengthOfService,
		COALESCE(B.employee_department, '') as SurveyEmployeeDepartment,
		COALESCE(B.employee_promoter, '') as SurveyEmployeePromoter,
		COALESCE(B.employee_membership_promoter, '') as SurveyEmployeeMembershipPromoter,
		'' as ProgramType,
		A.program_site_location as ProgramSiteLocation,
		COALESCE(B.group_activities, '') as SurveyGroupActivities,
		COALESCE(B.program_promoter, '') as SurveyProgramPromoter

from	Seer_MDM.dbo.Member A
		LEFT JOIN Seer_MDM.dbo.Survey_Segment B
		ON A.member_key = B.member_key

where	A.current_indicator = 1

GO


