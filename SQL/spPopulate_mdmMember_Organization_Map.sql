/*
drop procedure spPopulate_mdmMember_Organization_Map
truncate table Seer_MDM.dbo.Member_Organization_Map
select * from Member_Organization_Map
*/
CREATE PROCEDURE spPopulate_mdmMember_Organization_Map AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_MDM.dbo.Member_Organization_Map AS target
	USING	(
			SELECT	A.member_key,
					A.organization_key,
					A.current_indicator
			
			FROM	Seer_MDM.dbo.Member_Map A

			GROUP BY A.member_key,
					A.organization_key,
					A.current_indicator
			) AS source
			ON target.member_key = source.member_key
				AND target.organization_key = source.organization_key
			
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
					organization_key
					)
			VALUES (member_key,
					organization_key
					)			
	;
COMMIT TRAN
END