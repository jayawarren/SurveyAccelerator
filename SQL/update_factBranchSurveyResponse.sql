create table #tempZScore (BranchResponseKey bigint, ZScore decimal(15,10));

insert into #tempZScore
select	bsr.BranchResponseKey,
		case when osr.StdDevBranchResponsePercentage = 0 then 0
			else (bsr.ResponsePercentage - osr.AvgBranchResponsePercentage)/osr.StdDevBranchResponsePercentage
		end
from	factBranchSurveyResponse bsr
		inner join dimBranch db
			on bsr.BranchKey = db.BranchKey
		inner join dimDate dd
			on bsr.GivenDateKey = dd.DateKey
		inner join dimOrganizationSurvey dos
			on bsr.OrganizationSurveyKey = dos.OrganizationSurveyKey
		inner join dimQuestionResponse dqr
			on bsr.QuestionResponseKey = dqr.QuestionResponseKey
		inner join dimSurveyQuestion dq
			on bsr.SurveyQuestionKey = dq.SurveyQuestionKey
		inner join factOrganizationSurveyResponse osr
			on osr.OrganizationKey = db.OrganizationKey
			and osr.Year = dd.Year-1
			and osr.SurveyType = dos.SurveyType
			and osr.ResponseKey = dqr.ResponseKey
			and osr.QuestionKey = dq.QuestionKey;

update	factBranchSurveyResponse
set		ResponsePercentageZScore = A.ZScore
from	(
		select	bsr.BranchResponseKey,
				case when osr.StdDevBranchResponsePercentage = 0 then 0
					else (bsr.ResponsePercentage - osr.AvgBranchResponsePercentage)/osr.StdDevBranchResponsePercentage
				end ZScore
		from	factBranchSurveyResponse bsr
				inner join dimBranch db
					on bsr.BranchKey = db.BranchKey
				inner join dimDate dd
					on bsr.GivenDateKey = dd.DateKey
				inner join dimOrganizationSurvey dos
					on bsr.OrganizationSurveyKey = dos.OrganizationSurveyKey
				inner join dimQuestionResponse dqr
					on bsr.QuestionResponseKey = dqr.QuestionResponseKey
				inner join dimSurveyQuestion dq
					on bsr.SurveyQuestionKey = dq.SurveyQuestionKey
				inner join factOrganizationSurveyResponse osr
					on osr.OrganizationKey = db.OrganizationKey
					and osr.Year = dd.Year-1
					and osr.SurveyType = dos.SurveyType
					and osr.ResponseKey = dqr.ResponseKey
					and osr.QuestionKey = dq.QuestionKey
		) A
where	factBranchSurveyResponse.BranchResponseKey = A.BranchResponseKey;

drop table #tempZScore;