/*
truncate table dd.factMemExAssociationSurveyResponders
drop proc spPopulate_factMemExAssociationSurveyResponders
SELECT * FROM dd.factMemExAssociationSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExAssociationSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	F.association_key AssociationKey,
			F.batch_key,
			F.date_given_key GivenDateKey,
			F.current_indicator,
			F.association_number as AssociationNumber,
			F.association_name AssociationName,
			F.association Association,
			F.Year,
			F.received as Members,
			F.sent SurveysMailed,
			F.response_percentage ResponsePercentage
			
	INTO	#MEASR
			
	FROM	(
			SELECT	E.organization_key association_key,
					C.batch_key,
					C.date_given_key,
					A.current_indicator,
					E.association_name,
					E.association_number,
					E.association_number + ' - ' + E.association_name AS association,
					LEFT(C.date_given_key, 4) YEAR,
					C.survey_form_key,
					A.sent,
					A.received,
					CONVERT(DECIMAL(10, 5), A.received/A.sent) response_percentage
					
			FROM	(
					SELECT	official_association_number,
							current_indicator,
							form_code,
							batch_number,
							sent,
							received
							
					FROM	(
							SELECT	A.official_association_number,
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
						ON A.form_code = B.form_code
							AND A.batch_number = B.batch_number
					INNER JOIN Seer_MDM.dbo.Batch_Map C
						ON B.batch_key = C.batch_key
					INNER JOIN Seer_MDM.dbo.Survey_Form D
						ON C.survey_form_key = D.survey_form_key
					INNER JOIN Seer_MDM.dbo.Organization E
						ON A.official_association_number = E.association_number
							AND A.official_association_number = E.official_branch_number
						
			WHERE	C.module = 'Member'
					AND C.aggregate_type = 'Association'
			
			GROUP BY E.organization_key,
					C.batch_key,
					C.date_given_key,
					A.current_indicator,
					E.association_name,
					E.association_number,
					LEFT(C.date_given_key, 4),
					C.survey_form_key,
					A.sent,
					A.received
			) F 
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExAssociationSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.Year,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#MEASR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[Year] <> source.[Year]
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
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Year],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Year],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExAssociationSurveyResponders AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.Year,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#MEASR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Year],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[Year],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEASR;
	
COMMIT TRAN
	
END








