/*
drop procedure spPopulate_mdmQuestion
truncate table Seer_MDM.dbo.Question
select * from Seer_MDM.dbo.Question
*/
CREATE PROCEDURE spPopulate_mdmQuestion AS
BEGIN
	MERGE	Seer_MDM.dbo.Question AS target
	USING	(
			SELECT	RTRIM(REPLACE(A.[Question], '"', '')) question,
					RTRIM(REPLACE(A.[ShortQuestion], '"', '')) short_question
					
			FROM	Seer_STG.dbo.[Survey Questions] A
			
			--WHERE	LEN(REPLACE(A.[Question], '"', '')) = 0 
			--		OR LEN(REPLACE(A.[ShortQuestion], '"', '')) = 0
			
			GROUP BY REPLACE(A.[Question], '"', ''),
					REPLACE(A.[ShortQuestion], '"', '')
			) AS source
			ON target.question = source.question
			
	WHEN MATCHED AND (target.short_question <> source.short_question
					 )
		THEN
			UPDATE	
			SET		short_question = source.short_question
			
	WHEN NOT MATCHED BY target AND
		(
		LEN(source.question) > 0 
			 AND LEN(source.short_question) > 0
		)
		THEN 
			INSERT (question,
					short_question
				    )
			VALUES (question,
					short_question
				    )			
	;
END