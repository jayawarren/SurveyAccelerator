/*
truncate table Seer_MDM.dbo.Program_Group
truncate table Seer_CTRL.dbo.[Program Group]
drop proc dbo.spPopulate_mdmProgram_Group
select * from Seer_MDM.dbo.Program_Group
select * from Seer_CTRL.dbo.[Program Group]
*/
CREATE PROCEDURE spPopulate_mdmProgram_Group AS
BEGIN
	MERGE	Seer_MDM.dbo.Program_Group AS target
	USING	(
			SELECT	B.organization_key,
					B.organization_name,
					B.official_branch_number,
					A.[Program_Type] program_type,
					A.[Program_Site_Location] program_site_location,
					A.[Group_Name] program_group,
					CASE WHEN A.[Program_Type] = 'After School' THEN 'Childcare'
						WHEN A.[Program_Type] = 'Swim Lessons' THEN 'Youth Swim Lessons'
						ELSE A.[Program_Type]
					END AS program_category
					
			FROM	Seer_STG.dbo.[Program Group] A
					INNER JOIN Seer_MDM.dbo.Organization B
						ON CASE WHEN LEN(A.OFF_BR_NUM) = 3 THEN '0' + A.OFF_BR_NUM
								ELSE A.OFF_BR_NUM
						   END = B.official_branch_number
						   AND A.ORGANIZATION_NAME = B.Organization_Name
			
			GROUP BY B.organization_key,
					B.organization_name,
					B.official_branch_number,
					A.[Program_Type],
					A.[Program_Site_Location],
					A.[Group_Name],
					CASE WHEN A.[Program_Type] = 'After School' THEN 'Childcare'
						WHEN A.[Program_Type] = 'Swim Lessons' THEN 'Youth Swim Lessons'
						ELSE A.[Program_Type]
					END
			) AS source
			ON target.program_type = source.program_type
				AND target.program_site_location = source.program_site_location
				AND target.program_group = source.program_group
				AND target.organization_key = source.organization_key
			
	WHEN MATCHED AND (target.program_category <> source.program_category
					 )
		THEN
			UPDATE	
			SET		program_category = source.program_category
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.program_type) > 0 
			 AND LEN(source.program_site_location) > 0
			 AND LEN(source.program_group) > 0
		)
		THEN 
			INSERT (organization_key,
					program_group,
					program_category,
					program_type,
					program_site_location
				    )
			VALUES (organization_key,
					program_group,
					program_category,
					program_type,
					program_site_location
				    )			
	;
	INSERT INTO Seer_CTRL.dbo.[Program Group]  (ORGANIZATION_NAME,
												OFF_BR_NUM,
												Program_Type,
												Program_Site_Location,
												Group_Name
												)
	SELECT	A.ORGANIZATION_NAME,
			A.OFF_BR_NUM,
			A.Program_Type,
			A.Program_Site_Location,
			A.Group_Name

	FROM	Seer_STG.dbo.[Program Group] A
			LEFT JOIN Seer_MDM.dbo.Organization B
				ON CASE WHEN LEN(A.OFF_BR_NUM) = 3 THEN '0' + A.OFF_BR_NUM
						ELSE A.OFF_BR_NUM
				   END = B.official_branch_number
				   AND A.ORGANIZATION_NAME = B.Organization_Name

	WHERE	((LEN(Program_Type) = 0 
			 OR LEN(Program_Site_Location) = 0
			 OR LEN(Group_Name) = 0
			 )
			 AND B.organization_key IS NOT NULL
			)
			OR
			B.organization_key IS NULL
			
	GROUP BY A.ORGANIZATION_NAME,
			A.OFF_BR_NUM,
			A.Program_Type,
			A.Program_Site_Location,
			A.Group_Name
	;
END