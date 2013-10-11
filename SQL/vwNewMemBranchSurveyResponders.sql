USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwNewMemBranchSurveyResponders]    Script Date: 08/03/2013 18:31:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwNewMemBranchSurveyResponders] order by OfficialBranchName --where branchname = 'Central Connecticut Coast YMCA'
ALTER VIEW [dd].[vwNewMemBranchSurveyResponders]
AS

SELECT	F.association_key AssociationKey,
		F.branch_key BranchKey,
		F.survey_form_key SurveyFormKey,
		F.batch_key,
		F.date_given_key GivenDateKey,
		F.current_indicator,
		F.current_indicator CurrentSurveyIndicator,
		F.association_name AssociationName,
		F.association_number AssociationNumber,
		F.association_name_ex Association,
		F.short_branch_name Branch,
		F.official_branch_name OfficialBranchName,
		F.official_branch_number OfficialBranchNumber,
		F.date_survey_key GivenSurveyDate,
		F.Year SurveyYear,
		F.group_date_name GivenSurveyCategory,
		F.received as Members,
		F.sent SurveysMailed,
		F.response_percentage ResponsePercentage
		
FROM	(
		SELECT	F.organization_key association_key,
				E.organization_key branch_key,
				C.batch_key,
				C.date_given_key,
				A.current_indicator,
				E.association_name,
				E.association_number,
				E.association_number + ' - ' + E.association_name AS association_name_ex,
				dd.GetShortBranchName(E.official_branch_name) short_branch_name,
				E.official_branch_number,
				E.official_branch_name,
				REPLACE(B.report_date, '-', '') date_survey_key,
				LEFT(C.date_given_key, 4) YEAR,
				C.survey_form_key,
				CASE WHEN left(right(C.date_given_key, 4), 2) IN ('01','02') then 'Feb - Jan '+ Left(C.date_given_key, 4)
					WHEN left(right(C.date_given_key, 4), 2) IN ('03','04') then 'Apr - Mar '+ Left(C.date_given_key, 4)
					WHEN left(right(C.date_given_key, 4), 2) IN ('05','06') then 'Jun - May '+ Left(C.date_given_key, 4) 
					WHEN left(right(C.date_given_key, 4), 2) IN ('07','08') then 'Aug - Jul '+ Left(C.date_given_key, 4) 
					WHEN left(right(C.date_given_key, 4), 2) IN ('09','10') then 'Oct - Sept '+ Left(C.date_given_key, 4) 
					WHEN left(right(C.date_given_key, 4), 2) IN ('11','12') then 'Dec - Nov '+ Left(C.date_given_key, 4) 
				END AS group_date_name,
				A.sent,
				A.received,
				CONVERT(DECIMAL(10, 5), A.received)/A.sent response_percentage
		--SELECT	*		
		FROM	(
				SELECT	official_association_number,
						official_branch_number,
						current_indicator,
						form_code,
						batch_number,
						sent,
						received
						
				FROM	(
						SELECT	A.official_association_number,
								A.official_branch_number,
								A.current_indicator,
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
					ON REPLACE(A.form_code, '-', '') = REPLACE(B.form_code, '-', '')
						AND A.batch_number = B.batch_number
				INNER JOIN Seer_MDM.dbo.Batch_Map C
					ON B.batch_key = C.batch_key
				INNER JOIN Seer_MDM.dbo.Survey_Form D
					ON C.survey_form_key = D.survey_form_key
				INNER JOIN Seer_MDM.dbo.Organization E
					ON A.official_association_number = E.association_number
						AND A.official_branch_number = E.official_branch_number
				INNER JOIN Seer_MDM.dbo.Organization F
					ON A.official_association_number = F.association_number
						AND A.official_association_number = F.official_branch_number
					
		WHERE	C.module = 'New Member'
				AND C.aggregate_type = 'Branch'
				AND B.current_indicator = 1
				AND C.current_indicator = 1
				AND D.current_indicator = 1
				AND E.current_indicator = 1
				AND F.current_indicator = 1
		
		GROUP BY F.organization_key,
				E.organization_key,
				C.batch_key,
				C.date_given_key,
				A.current_indicator,
				E.association_name,
				E.association_number,
				dd.GetShortBranchName(E.official_branch_name),
				E.official_branch_name,
				E.official_branch_number,
				REPLACE(B.report_date, '-', ''),
				LEFT(C.date_given_key, 4),
				C.survey_form_key,
				A.sent,
				A.received
		) F
GO


