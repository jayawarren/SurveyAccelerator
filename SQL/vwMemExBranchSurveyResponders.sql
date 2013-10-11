USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExBranchSurveyResponders]    Script Date: 08/03/2013 18:31:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemExBranchSurveyResponders] where associationname = 'Central Connecticut Coast YMCA'
ALTER VIEW [dd].[vwMemExBranchSurveyResponders]
AS

SELECT	F.association_number as AssociationNumber,
		F.association_name AssociationName,
		F.official_branch_number as OfficialBranchNumber,
		F.short_branch_name as OfficialBranchName,
		F.Year,
		F.received as Members,
		F.sent SurveysMailed,
		F.response_percentage ResponsePercentage
		
FROM	(
		SELECT	E.organization_key association_key,
				E.organization_key branch_key,
				C.batch_key,
				C.date_given_key,
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
					
		WHERE	C.module = 'Member'
				AND C.aggregate_type = 'Branch'
		
		GROUP BY E.organization_key,
				C.batch_key,
				C.date_given_key,
				E.association_name,
				E.association_number,
				dd.GetShortBranchName(E.official_branch_name),
				E.official_branch_number,
				LEFT(C.date_given_key, 4),
				C.survey_form_key,
				A.sent,
				A.received
		) F
GO


