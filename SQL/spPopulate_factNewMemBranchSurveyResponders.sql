/*
truncate table dd.factNewMemBranchSurveyResponders
drop proc spPopulate_factNewMemBranchSurveyResponders
SELECT * FROM dd.factNewMemBranchSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemBranchSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	F.association_key AssociationKey,
			F.branch_key BranchKey,
			F.batch_key,
			F.date_given_key GivenDateKey,
			F.current_indicator,
			F.current_indicator CurrentSurveyIndicator,
			F.association_number as AssociationNumber,
			F.association_name AssociationName,
			F.association_name_ex Association,
			F.official_branch_number as OfficialBranchNumber,
			F.official_branch_name OfficialBranchName,
			F.short_branch_name as Branch,
			F.group_date_name GivenSurveyCategory,
			F.given_survey_date GivenSurveyDate,
			F.Year SurveyYear,
			F.received as Members,
			F.sent SurveysMailed,
			F.response_percentage ResponsePercentage
			
	INTO	#NMBSR
			
	FROM	(
			SELECT	E.organization_key association_key,
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
					REPLACE(B.report_date, '-', '') given_survey_date,
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
					CONVERT(DECIMAL(10, 5), A.received/A.sent) response_percentage
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
						
			WHERE	C.module = 'New Member'
					AND C.aggregate_type = 'Branch'
					AND B.current_indicator = 1
					AND C.current_indicator = 1
					AND D.current_indicator = 1
					AND E.current_indicator = 1
			
			GROUP BY E.organization_key,
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
			
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), F.date_given_key))) < GETDATE() 
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemBranchSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[GivenSurveyDate] <> source.[GivenSurveyDate]				 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[Association] <> source.[Association]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[Members] <> source.[Members]
								 OR target.[SurveysMailed] <> source.[SurveysMailed]
								 OR target.[ResponsePercentage] <> source.[ResponsePercentage]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemBranchSurveyResponders AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMBSR;
	
COMMIT TRAN
	
END








