update	factAssociationSurveyResponse
set		ResponsePercentageZScore = A.ZScore
from	(
		select	asr.AssociationResponseKey,
				case when osr.StdDevAssociationResponsePercentage = 0 then 0
					else (asr.ResponsePercentage - osr.AvgAssociationResponsePercentage)/osr.StdDevAssociationResponsePercentage
				end ZScore
		from	factAssociationSurveyResponse asr
				inner join dimAssociation da
					on asr.AssociationKey = da.AssociationKey
				inner join dimSurveyForm dsf
					on asr.SurveyFormKey = dsf.SurveyFormKey
				inner join dimQuestionResponse dqr
					on asr.QuestionResponseKey = dqr.QuestionResponseKey
				inner join dimSurveyQuestion dq
					on asr.SurveyQuestionKey = dq.SurveyQuestionKey
				inner join factOrganizationSurveyResponse osr
					on osr.OrganizationKey = da.OrganizationKey
					and osr.Year = CONVERT(INT, SUBSTRING(CONVERT(VARCHAR(20), asr.GivenDateKey), 1, 4)) - 1--dd.Year-1
					and osr.SurveyType = dsf.SurveyType
					and osr.ResponseKey = dqr.ResponseKey
					and osr.QuestionKey = dq.QuestionKey
		)A
where	factAssociationSurveyResponse.AssociationResponseKey = A.AssociationResponseKey

GO
