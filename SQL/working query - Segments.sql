SELECT	*
FROM	(SELECT	B.organization_key,
				F.survey_form_key,
				F.survey_response_key,
				F.survey_question_key,
				I.batch_key,
				--REPLACE('-', '', I.report_date) given_date_key,
				--J.date_key,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') < 25 THEN 1 ELSE 0 END) AS SegmentAgeRangeU25,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 25 AND 34 THEN 1 ELSE 0 END) AS SegmentAgeRange25to34,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 35 AND 49 THEN 1 ELSE 0 END) AS SegmentAgeRange35to49,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 50 AND 64 THEN 1 ELSE 0 END) AS SegmentAgeRange50to64,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') > 64 THEN 1 ELSE 0 END) AS SegmentAgeRangeO64,
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
					
		GROUP BY B.organization_key,
				I.batch_key,
				F.survey_response_key,
				F.survey_question_key,
				F.survey_form_key
		) A
		INNER JOIN
		(SELECT	B.organization_key,
				F.survey_form_key,
				F.survey_response_key,
				F.survey_question_key,
				I.batch_key,
				--REPLACE('-', '', I.report_date) given_date_key,
				--J.date_key,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') < 25 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentAgeRangeU25,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 25 AND 34 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentAgeRange25to34,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 35 AND 49 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentAgeRange35to49,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') BETWEEN 50 AND 64 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentAgeRange50to64,
				SUM(CASE WHEN NULLIF(G.exact_age,'U') > 64 AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentAgeRangeO64,
				SUM(CASE WHEN H.frequency_of_use = '6-7 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse7Week,
				SUM(CASE WHEN H.frequency_of_use = '4-5 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse5Week,
				SUM(CASE WHEN H.frequency_of_use = '2-3 times a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Week,
				SUM(CASE WHEN H.frequency_of_use = 'Once a week' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Week,
				SUM(CASE WHEN H.frequency_of_use = '2-3 times a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse3Month,
				SUM(CASE WHEN H.frequency_of_use = 'Once a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUse1Month,
				SUM(CASE WHEN H.frequency_of_use = 'Less than once a month' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentFrequencyOfUseU1Month,
				SUM(CASE WHEN G.gender = 'M' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentGenderMale,
				SUM(CASE WHEN G.gender = 'F' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentGenderFemale,
				SUM(CASE WHEN H.health_seeker = 'Yes' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentHealthSeekerYes,
				SUM(CASE WHEN H.health_seeker = 'No' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentHealthSeekerNo,
				SUM(CASE WHEN H.intent_to_renew = 'Definitely will' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitely,
				SUM(CASE WHEN H.intent_to_renew = 'Probably will' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbably,
				SUM(CASE WHEN H.intent_to_renew = 'Might or might not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentIntentToRenewMaybe,
				SUM(CASE WHEN H.intent_to_renew = 'Probably not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentIntentToRenewProbablyNot,
				SUM(CASE WHEN H.intent_to_renew = 'Definitely not' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentIntentToRenewDefinitelyNot,
				SUM(CASE WHEN H.length_of_membership = 'Less than 1 year' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipU1,
				SUM(CASE WHEN H.length_of_membership = '1 year' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership1,
				SUM(CASE WHEN H.length_of_membership = '2 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership2,
				SUM(CASE WHEN H.length_of_membership = '3-5 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership3to5,
				SUM(CASE WHEN H.length_of_membership = '6-10 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembership6to10,
				SUM(CASE WHEN H.length_of_membership = 'Longer than 10 years' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLengthOfMembershipO10,
				SUM(CASE WHEN H.loyalty = 'Very loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLoyaltyVery,
				SUM(CASE WHEN H.loyalty = 'Somewhat loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLoyaltySomewhat,
				SUM(CASE WHEN H.loyalty = 'Not very loyal' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLoyaltyNotVery,
				SUM(CASE WHEN H.loyalty = 'Not loyal at all' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentLoyaltyNot,
				SUM(CASE WHEN H.membership_type IN ('Single Adult','More than one adult') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentMembershipAdult,
				SUM(CASE WHEN H.membership_type = 'Family w/ kids' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentMembershipFamily,
				SUM(CASE WHEN H.membership_type = 'Senior' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentMembershipSenior,
				SUM(CASE WHEN H.net_promoter = 'Promoter' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentNPPromoter,
				SUM(CASE WHEN H.net_promoter = 'Detractor' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentNPDetractor,
				SUM(CASE WHEN H.net_promoter = 'Neither' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentNPNeither,
				SUM(CASE WHEN (G.presence_of_children_03 = 'Y' OR G.presence_of_children_46 = 'Y' OR G.presence_of_children_79 = 'Y' OR G.presence_of_children_1012 = 'Y' OR G.presence_of_children_1318 = 'Y') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentChildrenYes,
				SUM(CASE WHEN (G.presence_of_children_03 <> 'Y' AND G.presence_of_children_46 <> 'Y' AND G.presence_of_children_79 <> 'Y' AND G.presence_of_children_1012 <> 'Y' AND G.presence_of_children_1318 <> 'Y') AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentChildrenNo,
				SUM(CASE WHEN H.time_of_day = 'Early morning' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentTimeOfDayEarlyAM,
				SUM(CASE WHEN H.time_of_day = 'Mid-morning' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidAM,
				SUM(CASE WHEN H.time_of_day = 'Lunch' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentTimeOfDayLunch,
				SUM(CASE WHEN H.time_of_day = 'Mid-day' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentTimeOfDayMidPM,
				SUM(CASE WHEN H.time_of_day = 'Evening' AND F.exclude_from_report_calculation <> 'Y' THEN 1 ELSE 0 END) AS SegmentTimeOfDayPM

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
				
		GROUP BY B.organization_key,
				I.batch_key,
				F.survey_response_key,
				F.survey_question_key,
				F.survey_form_key
		) B
		ON A.organization_key = B.organization_key
			AND A.batch_key = B.batch_key
			AND A.survey_response_key = B.survey_response_key
GO