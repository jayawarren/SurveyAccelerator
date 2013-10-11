SELECT	A.organization_key,
		C.survey_form_key,
		C.survey_response_key,
		C.survey_question_key,
		REPLACE('-', '', I.report_date) given_date_key,
		COUNT(C.survey_response_key) response_count,
		--D.response_percentage,
		D.national_percentage,
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
	
FROM	(SELECT	A.module,
				B.organization_key,
				F.survey_form_key,
				F.survey_response_key,
				F.survey_question_key,
				I.batch_key,
				--REPLACE('-', '', I.report_date) given_date_key,
				--J.date_key,
				SUM(CASE WHEN NULLIF(G.exact_age, 'U') < 25 THEN 1 ELSE 0 END) AS SegmentAgeRangeU25,
				SUM(CASE WHEN NULLIF(G.exact_age, 'U') BETWEEN 25 AND 34 THEN 1 ELSE 0 END) AS SegmentAgeRange25to34,
				SUM(CASE WHEN NULLIF(G.exact_age, 'U') BETWEEN 35 AND 49 THEN 1 ELSE 0 END) AS SegmentAgeRange35to49,
				SUM(CASE WHEN NULLIF(G.exact_age, 'U') BETWEEN 50 AND 64 THEN 1 ELSE 0 END) AS SegmentAgeRange50to64,
				SUM(CASE WHEN NULLIF(G.exact_age, 'U') > 64 THEN 1 ELSE 0 END) AS SegmentAgeRangeO64,
				SUM(CASE WHEN H.frequency_of_use = '6-7 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse7Week,
				SUM(CASE WHEN H.frequency_of_use = '4-5 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse5Week,
				SUM(CASE WHEN H.frequency_of_use = '2-3 times a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Week,
				SUM(CASE WHEN H.frequency_of_use = 'Once a week' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Week,
				SUM(CASE WHEN H.frequency_of_use = '2-3 times a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Month,
				SUM(CASE WHEN H.frequency_of_use = 'Once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Month,
				SUM(CASE WHEN H.frequency_of_use = 'Less than once a month' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUseU1Month,
				SUM(CASE WHEN G.gender = 'M' THEN 1 ELSE 0 END) AS SegmentGenderMale,
				SUM(CASE WHEN G.gender = 'F' THEN 1 ELSE 0 END) AS SegmentGenderFemale,
				SUM(CASE WHEN H.health_seeker = 'Yes' THEN 1 ELSE 0 END) AS SegmentHealthSeekerYes,
				SUM(CASE WHEN H.health_seeker = 'No' THEN 1 ELSE 0 END) AS SegmentHealthSeekerNo,
				SUM(CASE WHEN H.intent_to_renew = 'Definitely will' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitely,
				SUM(CASE WHEN H.intent_to_renew = 'Probably will' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbably,
				SUM(CASE WHEN H.intent_to_renew = 'Might or might not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewMaybe,
				SUM(CASE WHEN H.intent_to_renew = 'Probably not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbablyNot,
				SUM(CASE WHEN H.intent_to_renew = 'Definitely not' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitelyNot,
				SUM(CASE WHEN H.length_of_membership = 'Less than 1 year' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipU1,
				SUM(CASE WHEN H.length_of_membership = '1 year' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership1,
				SUM(CASE WHEN H.length_of_membership = '2 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership2,
				SUM(CASE WHEN H.length_of_membership = '3-5 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership3to5,
				SUM(CASE WHEN H.length_of_membership = '6-10 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership6to10,
				SUM(CASE WHEN H.length_of_membership = 'Longer than 10 years' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipO10,
				SUM(CASE WHEN H.loyalty = 'Very loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltyVery,
				SUM(CASE WHEN H.loyalty = 'Somewhat loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltySomewhat,
				SUM(CASE WHEN H.loyalty = 'Not very loyal' THEN 1 ELSE 0 END) AS SegmentLoyaltyNotVery,
				SUM(CASE WHEN H.loyalty = 'Not loyal at all' THEN 1 ELSE 0 END) AS SegmentLoyaltyNot,
				SUM(CASE WHEN H.membership_type IN ('Single Adult','More than one adult') THEN 1 ELSE 0 END) AS SegmentMembershipAdult,
				SUM(CASE WHEN H.membership_type = 'Family w/ kids' THEN 1 ELSE 0 END) AS SegmentMembershipFamily,
				SUM(CASE WHEN H.membership_type = 'Senior' THEN 1 ELSE 0 END) AS SegmentMembershipSenior,
				SUM(CASE WHEN H.net_promoter = 'Promoter' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
				SUM(CASE WHEN H.net_promoter = 'Detractor' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
				SUM(CASE WHEN H.net_promoter = 'Neither' THEN 1 ELSE 0 END) AS SegmentNPNeither,
				SUM(CASE WHEN (G.presence_of_children_03 = 'Y' OR G.presence_of_children_46 = 'Y' OR G.presence_of_children_79 = 'Y' OR G.presence_of_children_1012 = 'Y' OR G.presence_of_children_1318 = 'Y') THEN 1 ELSE 0 END) AS SegmentChildrenYes,
				SUM(CASE WHEN (G.presence_of_children_03 <> 'Y' AND G.presence_of_children_46 <> 'Y' AND G.presence_of_children_79 <> 'Y' AND G.presence_of_children_1012 <> 'Y' AND G.presence_of_children_1318 <> 'Y') THEN 1 ELSE 0 END) AS SegmentChildrenNo,
				SUM(CASE WHEN H.time_of_day = 'Early morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayEarlyAM,
				SUM(CASE WHEN H.time_of_day = 'Mid-morning' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidAM,
				SUM(CASE WHEN H.time_of_day = 'Lunch' THEN 1 ELSE 0 END) AS SegmentTimeOfDayLunch,
				SUM(CASE WHEN H.time_of_day = 'Mid-day' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidPM,
				SUM(CASE WHEN H.time_of_day = 'Evening' THEN 1 ELSE 0 END) AS SegmentTimeOfDayPM

		FROM	Seer_ODS.dbo.Close_Ends A
				INNER JOIN Seer_MDM.dbo.Organization B
					ON A.official_association_number = B.association_number
						AND A.official_branch_number = B.official_branch_number
				INNER JOIN Seer_MDM.dbo.Survey_Form C
					ON A.form_code = C.survey_form_code
				--INNER JOIN Seer_MDM.dbo.Question D
				--	ON A.question = D.question
				INNER JOIN Seer_MDM.dbo.Survey_Question E
					ON A.question = E.survey_column
				INNER JOIN Seer_MDM.dbo.Survey_Response F
					ON C.survey_form_key = F.survey_form_key
						AND E.survey_question_key = F.survey_question_key
				INNER JOIN Seer_MDM.dbo.Member G
					ON A.member_key = G.member_key
				INNER JOIN Seer_MDM.dbo.Survey_Segment H
					ON A.member_key = H.member_key
				INNER JOIN Seer_MDM.dbo.Batch I
					ON A.batch_number = I.batch_number
						AND A.form_code = I.form_code
				--INNER JOIN Seer_MDM.dbo.Date J
				--	ON CONVERT(DATE, I.report_date) = J.date
					
		GROUP BY A.module,
				B.organization_key,
				I.batch_key,
				F.survey_response_key,
				F.survey_question_key,
				F.survey_form_key
		) A
		INNER JOIN
		(SELECT	A.module,
				A.organization_key,
				A.survey_form_key,
				A.survey_response_key,
				A.survey_question_key,
				A.batch_key,
				SUM(A.SegmentAgeRangeU25) AS SegmentAgeRangeU25,
				SUM(A.SegmentAgeRange25to34) AS SegmentAgeRange25to34,
				SUM(A.SegmentAgeRange35to49) AS SegmentAgeRange35to49,
				SUM(A.SegmentAgeRange50to64) AS SegmentAgeRange50to64,
				SUM(A.SegmentAgeRangeO64) AS SegmentAgeRangeO64,
				SUM(A.SegmentFrequencyOfUse7Week) AS SegmentFrequencyOfUse7Week,
				SUM(A.SegmentFrequencyOfUse5Week) AS SegmentFrequencyOfUse5Week,
				SUM(A.SegmentFrequencyOfUse3Week) AS SegmentFrequencyOfUse3Week,
				SUM(A.SegmentFrequencyOfUse1Week) AS SegmentFrequencyOfUse1Week,
				SUM(A.SegmentFrequencyOfUse3Month) AS SegmentFrequencyOfUse3Month,
				SUM(A.SegmentFrequencyOfUse1Month) AS SegmentFrequencyOfUse1Month,
				SUM(A.SegmentFrequencyOfUseU1Month) AS SegmentFrequencyOfUseU1Month,
				SUM(A.SegmentGenderMale) AS SegmentGenderMale,
				SUM(A.SegmentGenderFemale) AS SegmentGenderFemale,
				SUM(A.SegmentHealthSeekerYes) AS SegmentHealthSeekerYes,
				SUM(A.SegmentHealthSeekerNo) AS SegmentHealthSeekerNo,
				SUM(A.SegmentIntentToRenewDefinitely) AS SegmentIntentToRenewDefinitely,
				SUM(A.SegmentIntentToRenewProbably) AS SegmentIntentToRenewProbably,
				SUM(A.SegmentIntentToRenewMaybe) AS SegmentIntentToRenewMaybe,
				SUM(A.SegmentIntentToRenewProbablyNot) AS SegmentIntentToRenewProbablyNot,
				SUM(A.SegmentIntentToRenewDefinitelyNot) AS SegmentIntentToRenewDefinitelyNot,
				SUM(A.SegmentLengthOfMembershipU1) AS SegmentLengthOfMembershipU1,
				SUM(A.SegmentLengthOfMembership1) AS SegmentLengthOfMembership1,
				SUM(A.SegmentLengthOfMembership2) AS SegmentLengthOfMembership2,
				SUM(A.SegmentLengthOfMembership3to5) AS SegmentLengthOfMembership3to5,
				SUM(A.SegmentLengthOfMembership6to10) AS SegmentLengthOfMembership6to10,
				SUM(A.SegmentLengthOfMembershipO10) AS SegmentLengthOfMembershipO10,
				SUM(A.SegmentLoyaltyVery) AS SegmentLoyaltyVery,
				SUM(A.SegmentLoyaltySomewhat) AS SegmentLoyaltySomewhat,
				SUM(A.SegmentLoyaltyNotVery) AS SegmentLoyaltyNotVery,
				SUM(A.SegmentLoyaltyNot) AS SegmentLoyaltyNot,
				SUM(A.SegmentMembershipAdult) AS SegmentMembershipAdult,
				SUM(A.SegmentMembershipFamily) AS SegmentMembershipFamily,
				SUM(A.SegmentMembershipSenior) AS SegmentMembershipSenior,
				SUM(A.SegmentNPPromoter) AS SegmentNPPromoter,
				SUM(A.SegmentNPDetractor) AS SegmentNPDetractor,
				SUM(A.SegmentNPNeither) AS SegmentNPNeither,
				SUM(A.SegmentChildrenYes) AS SegmentChildrenYes,
				SUM(A.SegmentChildrenNo) AS SegmentChildrenNo,
				SUM(A.SegmentTimeOfDayEarlyAM) AS SegmentTimeOfDayEarlyAM,
				SUM(A.SegmentTimeOfDayMidAM) AS SegmentTimeOfDayMidAM,
				SUM(A.SegmentTimeOfDayLunch) AS SegmentTimeOfDayLunch,
				SUM(A.SegmentTimeOfDayMidPM) AS SegmentTimeOfDayMidPM,
				SUM(A.SegmentTimeOfDayPM) AS SegmentTimeOfDayPM

		FROM	(SELECT	A.module,
						--J.aggregate_type,
						B.organization_key,
						F.survey_form_key,
						F.survey_response_key,
						F.survey_question_key,
						I.batch_key,
						--I.report_date given_date_key,
						--J.response_count),
						CASE WHEN NULLIF(G.exact_age,'U') < 25 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentAgeRangeU25,
						CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 25 AND 34 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentAgeRange25to34,
						CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 35 AND 49 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentAgeRange35to49,
						CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 50 AND 64 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentAgeRange50to64,
						CASE WHEN NULLIF(G.exact_age,'U') > 64 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentAgeRangeO64,
						CASE WHEN H.frequency_of_use = '6-7 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse7Week,
						CASE WHEN H.frequency_of_use = '4-5 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse5Week,
						CASE WHEN H.frequency_of_use = '2-3 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse3Week,
						CASE WHEN H.frequency_of_use = 'Once a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse1Week,
						CASE WHEN H.frequency_of_use = '2-3 times a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse3Month,
						CASE WHEN H.frequency_of_use = 'Once a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUse1Month,
						CASE WHEN H.frequency_of_use = 'Less than once a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentFrequencyOfUseU1Month,
						CASE WHEN G.gender = 'M' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentGenderMale,
						CASE WHEN G.gender = 'F' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentGenderFemale,
						CASE WHEN H.health_seeker = 'Yes' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentHealthSeekerYes,
						CASE WHEN H.health_seeker = 'No' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentHealthSeekerNo,
						CASE WHEN H.intent_to_renew = 'Definitely will' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentIntentToRenewDefinitely,
						CASE WHEN H.intent_to_renew = 'Probably will' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentIntentToRenewProbably,
						CASE WHEN H.intent_to_renew = 'Might or might not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentIntentToRenewMaybe,
						CASE WHEN H.intent_to_renew = 'Probably not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentIntentToRenewProbablyNot,
						CASE WHEN H.intent_to_renew = 'Definitely not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentIntentToRenewDefinitelyNot,
						CASE WHEN H.length_of_membership = 'Less than 1 year' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembershipU1,
						CASE WHEN H.length_of_membership = '1 year' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembership1,
						CASE WHEN H.length_of_membership = '2 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembership2,
						CASE WHEN H.length_of_membership = '3-5 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembership3to5,
						CASE WHEN H.length_of_membership = '6-10 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembership6to10,
						CASE WHEN H.length_of_membership = 'Longer than 10 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLengthOfMembershipO10,
						CASE WHEN H.loyalty = 'Very loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLoyaltyVery,
						CASE WHEN H.loyalty = 'Somewhat loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLoyaltySomewhat,
						CASE WHEN H.loyalty = 'Not very loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLoyaltyNotVery,
						CASE WHEN H.loyalty = 'Not loyal at all' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentLoyaltyNot,
						CASE WHEN H.membership_type IN ('Single Adult','More than one adult') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentMembershipAdult,
						CASE WHEN H.membership_type = 'Family w/ kids' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentMembershipFamily,
						CASE WHEN H.membership_type = 'Senior' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentMembershipSenior,
						CASE WHEN H.net_promoter = 'Promoter' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentNPPromoter,
						CASE WHEN H.net_promoter = 'Detractor' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentNPDetractor,
						CASE WHEN H.net_promoter = 'Neither' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentNPNeither,
						CASE WHEN (G.presence_of_children_03 = 'Y' OR G.presence_of_children_46 = 'Y' OR G.presence_of_children_79 = 'Y' OR G.presence_of_children_1012 = 'Y' OR G.presence_of_children_1318 = 'Y') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentChildrenYes,
						CASE WHEN (G.presence_of_children_03 <> 'Y' AND G.presence_of_children_46 <> 'Y' AND G.presence_of_children_79 <> 'Y' AND G.presence_of_children_1012 <> 'Y' AND G.presence_of_children_1318 <> 'Y') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentChildrenNo,
						CASE WHEN H.time_of_day = 'Early morning' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentTimeOfDayEarlyAM,
						CASE WHEN H.time_of_day = 'Mid-morning' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentTimeOfDayMidAM,
						CASE WHEN H.time_of_day = 'Lunch' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentTimeOfDayLunch,
						CASE WHEN H.time_of_day = 'Mid-day' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentTimeOfDayMidPM,
						CASE WHEN H.time_of_day = 'Evening' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END AS SegmentTimeOfDayPM

				FROM	Seer_ODS.dbo.Close_Ends A
						INNER JOIN Seer_MDM.dbo.Organization B
							ON A.official_association_number = B.association_number
								AND A.official_branch_number = B.official_branch_number
						INNER JOIN Seer_MDM.dbo.Survey_Form C
							ON A.form_code = C.survey_form_code
						INNER JOIN Seer_MDM.dbo.Survey_Question E
							ON A.question = E.survey_column
						INNER JOIN Seer_MDM.dbo.Survey_Response F
							ON C.survey_form_key = F.survey_form_key
								AND E.survey_question_key = F.survey_question_key
						INNER JOIN Seer_MDM.dbo.Member G
							ON A.member_key = G.member_key
						INNER JOIN Seer_MDM.dbo.Survey_Segment H
							ON A.member_key = H.member_key
						INNER JOIN Seer_MDM.dbo.Batch I
							ON A.batch_number = I.batch_number
								AND A.form_code = I.form_code
						--INNER JOIN Seer_ODS.dbo.Top_Box J
						--	ON A.official_association_number = J.official_association_number
						--		AND A.official_branch_number = J.official_branch_number
				) A
					
		GROUP BY A.module,
				A.organization_key,
				A.survey_form_key,
				A.survey_response_key,
				A.survey_question_key,
				A.batch_key
		) B
		ON A.module = B.module
			AND A.organization_key = B.organization_key
			AND A.batch_key = B.batch_key
			AND A.survey_response_key = B.survey_response_key
		
		INNER JOIN Seer_MDM.dbo.Survey_Response C
		ON A.survey_response_key = C.survey_response_key
		INNER JOIN Seer_ODS.dbo.Response_Data D
		ON 
GO