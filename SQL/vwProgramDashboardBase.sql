USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwProgramDashboardBase]    Script Date: 08/10/2013 18:44:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwProgramDashboardBase] WHERE	AssociationName = 'YMCA of Silicon Valley'
ALTER VIEW [dd].[vwProgramDashboardBase]
AS 
SELECT	F.program_group_key GroupingKey,
		F.survey_form_key ProgramKey,
		F.survey_form_key SurveyFormKey,
		F.association_key AssociationKey,
		F.batch_key,
		F.date_given_key GivenDateKey,
		F.previous_date_given_key PrevGivenDateKey,
		F.current_indicator,
		'Group' AS GroupingLabel,
		F.program_group GroupingName,
		F.program_category Program,	
		F.association_name AssociationName,
		F.association_number AssociationNumber,
		F.association_number + ' - ' + F.association_name AS AssociationNameEx,
		F.year SurveyYear,
		F.previous_year PrevYear,
		F.survey_type SurveyType,
		F.sent AS SurveysSent,
		F.received AS SurveysReceived,
		F.response_percentage ResponsePercentage
		
FROM	(
		SELECT	E.organization_key association_key,
				C.batch_key,
				C.date_given_key,
				LEFT(C.date_given_key, 4) year,
				C.previous_date_given_key,
				LEFT(C.previous_date_given_key, 4) previous_year,
				C.current_indicator,
				E.association_name,
				E.association_number,
				H.program_group_key,
				C.survey_form_key,
				D.survey_form_code,
				D.survey_type,
				H.program_group,
				H.program_category,
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
					ON C.organization_key = E.organization_key
				INNER JOIN Seer_ODS.dbo.Observation_Data F
					ON A.official_association_number = F.official_association_number
						AND A.form_code = F.form_code
						AND A.batch_number = F.batch_number	
				INNER JOIN Seer_MDM.dbo.Member_Program_Group_Map G
					ON F.member_key = G.member_key
						AND C.organization_key = G.organization_key
						AND C.survey_form_key = G.survey_form_key
				INNER JOIN Seer_MDM.dbo.Program_Group H
					ON G.program_group_key = H.program_group_key
						AND G.program_category = H.program_category
					
		WHERE	C.module = 'Program'
				AND C.aggregate_type = 'Association'
				AND F.status = 'Received'
		
		GROUP BY E.organization_key,
				C.batch_key,
				C.date_given_key,
				LEFT(C.date_given_key, 4),
				C.previous_date_given_key,
				LEFT(C.previous_date_given_key, 4),
				C.current_indicator,
				E.association_name,
				E.association_number,
				H.program_group_key,
				C.survey_form_key,
				D.survey_form_code,
				D.survey_type,
				H.program_group,
				H.program_category,
				A.sent,
				A.received,
				CONVERT(DECIMAL(10, 5), A.received/A.sent)
		) F
		
GROUP BY F.program_group_key,
		F.survey_form_key,
		F.association_key,
		F.batch_key,
		F.date_given_key,
		F.previous_date_given_key,
		F.current_indicator,
		F.program_group,
		F.program_category,	
		F.association_name,
		F.association_number,
		F.association_number + ' - ' + F.association_name,
		F.year,
		F.previous_year,
		F.survey_type,
		F.sent,
		F.received,
		F.response_percentage

GO


