USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatAssocSurveyResponders]    Script Date: 08/03/2013 18:31:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwEmpSatAssocSurveyResponders] where associationname = 'Central Connecticut Coast YMCA'
CREATE VIEW [dd].[vwEmpSatAssocSurveyResponders]
AS

SELECT	F.association_key AssociationKey,
		F.batch_key,
		G.current_indicator,
		F.association_name Association,
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
				C.batch_key,
				C.date_given_key,
				C.previous_date_given_key,
				E.association_name,
				E.association_number,
				LEFT(C.date_given_key, 4) YEAR,
				C.survey_form_key,
				A.sent,
				A.received,
				CONVERT(DECIMAL(10, 5), A.received/A.sent) response_percentage
				
		FROM	(
				SELECT	official_association_number,
						form_code,
						batch_number,
						sent,
						received
						
				FROM	(
						SELECT	A.official_association_number,
								A.form_code,
								A.batch_number,
								A.status,
								A.member_key
								
						FROM	Seer_ODS.dbo.Observation_Data A
						
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
						AND A.official_association_number = E.official_branch_number
					
		WHERE	C.module = 'Staff'
				AND C.aggregate_type = 'Association'
		
		GROUP BY E.organization_key,
				C.batch_key,
				C.date_given_key,
				C.previous_date_given_key,
				E.association_name,
				E.association_number,
				LEFT(C.date_given_key, 4),
				C.survey_form_key,
				A.sent,
				A.received
		) F
		INNER JOIN dd.factEmpSatDetailSurvey G
			ON F.association_key = G.AssociationKey
				AND F.association_key = G.BranchKey
				AND F.batch_key = G.batch_key
		INNER JOIN dbo.dimSurveyQuestion H
			ON G.Question = H.Question
				AND F.survey_form_key = H.SurveyFormKey
		INNER JOIN dbo.dimQuestionResponse I
			ON G.Response = I.ResponseText
				AND H.SurveyQuestionKey = I.SurveyQuestionKey
				
GROUP BY F.association_key,
		F.batch_key,
		G.current_indicator,
		F.association_name,
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


