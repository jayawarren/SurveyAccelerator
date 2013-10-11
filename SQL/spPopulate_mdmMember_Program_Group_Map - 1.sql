/*
drop procedure spPopulate_mdmMember_Program_Group_Map
truncate table Seer_MDM.dbo.Member_Program_Group_Map
select * from Member_Program_Group_Map
*/
CREATE PROCEDURE spPopulate_mdmMember_Program_Group_Map AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Member_Program_Group_Map AS target
	USING	(
			SELECT	A.member_key,
					A.organization_key,
					A.program_group_key,
					A.survey_form_key,
					A.batch_key,
					A.current_indicator,
					A.program_category
			
			FROM	(
					SELECT	A.member_key,
							A.organization_key,
							C.program_group_key,
							F.batch_key,
							E.survey_form_key,
							A.current_indicator,
							REPLACE(REPLACE(E.survey_type, 'YMCA ', ''), ' Satisfaction Survey', '') program_category
					
					FROM	Seer_MDM.dbo.Member_Map A
							INNER JOIN Seer_MDM.dbo.Member B
								ON A.member_key = B.member_key
							INNER JOIN Seer_MDM.dbo.Program_Group C
								ON A.organization_key = C.organization_key
									AND B.program_site_location = C.program_site_location
							INNER JOIN Seer_ODS.dbo.Observation_Data D
								ON A.member_key = D.member_key
							INNER JOIN Seer_MDM.dbo.Survey_Form E
								ON REPLACE(D.form_code, '-', '') = REPLACE(E.survey_form_code, '-', '')
							INNER JOIN Seer_MDM.dbo.Batch F
								ON REPLACE(D.form_code, '-', '') = REPLACE(F.form_code, '-', '')
									AND D.batch_number = F.batch_number
									
					WHERE	A.current_indicator = 1
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
							AND E.current_indicator = 1
							AND F.current_indicator = 1
								
					GROUP BY A.member_key,
							A.organization_key,
							C.program_group_key,
							F.batch_key,
							E.survey_form_key,
							A.current_indicator,
							REPLACE(REPLACE(E.survey_type, 'YMCA ', ''), ' Satisfaction Survey', '')
							
					UNION
					
					SELECT	A.member_key,
							A.organization_key,
							C.program_group_key,
							F.batch_key,
							E.survey_form_key,
							A.current_indicator,
							REPLACE(REPLACE(E.survey_type, 'YMCA ', ''), ' Satisfaction Survey', '') program_category
							
					FROM	Seer_MDM.dbo.Member_Map A
							INNER JOIN Seer_MDM.dbo.Member B
								ON A.seer_key = B.member_cleansed_id
							INNER JOIN Seer_MDM.dbo.Program_Group C
								ON A.organization_key = C.organization_key
									AND B.program_site_location = C.program_site_location
							INNER JOIN Seer_ODS.dbo.Observation_Data D
								ON A.member_key = D.member_key
							INNER JOIN Seer_MDM.dbo.Survey_Form E
								ON REPLACE(D.form_code, '-', '') = REPLACE(E.survey_form_code, '-', '')
							INNER JOIN Seer_MDM.dbo.Batch F
								ON REPLACE(D.form_code, '-', '') = REPLACE(F.form_code, '-', '')
									AND D.batch_number = F.batch_number
									
					WHERE	A.current_indicator = 1
							AND B.current_indicator = 1
							AND C.current_indicator = 1
							AND D.current_indicator = 1
							AND E.current_indicator = 1
							AND F.current_indicator = 1
								
					GROUP BY A.member_key,
							A.organization_key,
							C.program_group_key,
							F.batch_key,
							E.survey_form_key,
							A.current_indicator,
							REPLACE(REPLACE(E.survey_type, 'YMCA ', ''), ' Satisfaction Survey', '')
					) A
			

			GROUP BY A.member_key,
					A.organization_key,
					A.program_group_key,
					A.batch_key,
					A.survey_form_key,
					A.current_indicator,
					A.program_category

			) AS source
			ON target.member_key = source.member_key
				AND target.organization_key = source.organization_key
				AND target.program_group_key = source.program_group_key
				AND target.batch_key = source.batch_key
				AND target.survey_form_key = source.survey_form_key
				AND target.program_category = source.program_category
			
	WHEN MATCHED AND (target.[current_indicator] <> source.[current_indicator]
						AND target.[current_indicator] = 1
						)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
									
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT (member_key,
					organization_key,
					program_group_key,
					survey_form_key,
					batch_key,
					program_category
					)
			VALUES (member_key,
					organization_key,
					program_group_key,
					survey_form_key,
					batch_key,
					program_category
					)			
	;
COMMIT TRAN
END