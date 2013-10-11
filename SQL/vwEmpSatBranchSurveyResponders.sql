USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatBranchSurveyResponders]    Script Date: 08/03/2013 18:31:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwEmpSatBranchSurveyResponders] where associationname = 'Central Connecticut Coast YMCA'
ALTER VIEW [dd].[vwEmpSatBranchSurveyResponders]
AS

SELECT	F.association_key AssociationKey,
		F.branch_key BranchKey,
		F.batch_key,
		G.current_indicator,
		F.association_name Association,
		F.short_branch_name as Branch,
		F.sent Sent,
		F.received Received,
		COUNT(G.Response) ResponseCount,
		G.Question,
		G.QuestionPosition,
		G.Response,
		G.ResponsePosition,
		cast(round(G.CrtPercentage, 0) as int) CurrentResponsePercentage,
		cast (round(G.PrevPercentage, 0) as int) PreviousResponsePercentage,
		cast (round(F.response_percentage, 0) as int) CurrentSurveyPercentage
		
FROM	(
		SELECT	E.organization_key association_key,
				E.organization_key branch_key,
				C.batch_key,
				C.date_given_key,
				C.previous_date_given_key,
				E.association_name,
				E.association_number,
				dd.GetShortBranchName(E.official_branch_name) short_branch_name,
				E.official_branch_number,
				LEFT(C.date_given_key, 4) YEAR,
				C.survey_form_key,
				A.sent,
				A.received,
				CONVERT(DECIMAL(10, 5), A.received/A.sent) response_percentage
				
		FROM	(
				SELECT	official_association_number,
						official_branch_number,
						form_code,
						batch_number,
						sent,
						received
						
				FROM	(
						SELECT	A.official_association_number,
								A.official_branch_number,
								A.form_code,
								A.batch_number,
								A.status,
								A.member_key
								
						FROM	Seer_ODS.dbo.Observation_Data A
						
						WHERE	A.current_indicator = 1
						
						) AS SourceTable
						PIVOT
						(COUNT(member_key) FOR [status] IN ([sent], [received])
						) AS PVT
				) A
				INNER JOIN Seer_MDM.dbo.Batch B
					ON A.form_code = B.form_code
						AND A.batch_number = B.batch_number
				INNER JOIN Seer_MDM.dbo.Batch_Map C
					ON B.batch_key = C.batch_key
				INNER JOIN Seer_MDM.dbo.Survey_Form D
					ON C.survey_form_key = D.survey_form_key
				INNER JOIN Seer_MDM.dbo.Organization E
					ON A.official_association_number = E.association_number
						AND A.official_branch_number = E.official_branch_number
					
		WHERE	C.module = 'Staff'
				AND C.aggregate_type = 'Branch'
				AND B.current_indicator = 1
				AND D.current_indicator = 1
				AND E.current_indicator = 1
		
		GROUP BY E.organization_key,
				C.batch_key,
				C.date_given_key,
				C.previous_date_given_key,
				E.association_name,
				E.association_number,
				dd.GetShortBranchName(E.official_branch_name),
				E.official_branch_number,
				LEFT(C.date_given_key, 4),
				C.survey_form_key,
				A.sent,
				A.received
		) F
		INNER JOIN dd.factEmpSatDetailSurvey G
			ON F.association_key = G.AssociationKey
				AND F.branch_key = G.BranchKey
				AND F.batch_key = G.batch_key
		INNER JOIN dbo.dimSurveyQuestion H
			ON G.Question = H.Question
				AND F.survey_form_key = H.SurveyFormKey
		INNER JOIN dbo.dimQuestionResponse I
			ON G.Response = I.ResponseText
				AND H.SurveyQuestionKey = I.SurveyQuestionKey
				
WHERE	G.current_indicator = 1
				
GROUP BY F.association_key,
		F.branch_key,
		F.batch_key,
		G.current_indicator,
		F.association_name,
		F.short_branch_name,
		F.sent,
		F.received,
		G.Question,
		G.QuestionPosition,
		G.Response,
		G.ResponsePosition,
		cast(round(G.CrtPercentage, 0) as int),
		cast(round(G.PrevPercentage, 0) as int),
		cast(round(F.response_percentage, 0) as int)
GO


