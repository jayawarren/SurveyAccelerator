SELECT	A.module,
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
		