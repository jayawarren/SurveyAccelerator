/*
truncate table dbo.Batch
drop procedure spPopulate_mdmBatch
truncate table Seer_CTRL.dbo.Batch
*/
CREATE PROCEDURE spPopulate_mdmBatch AS
BEGIN
	MERGE	Seer_MDM.dbo.Batch AS target
	USING	(
			SELECT	A.SourceID source_id,
					A.BatchNumber batch_number,
					A.FormCode form_code,
					A.TargetDate target_date,
					A.ReportDate report_date,
					A.DateGivenKey date_given_key,
					A.enabled,
					A.hidden
			FROM	Seer_STG.dbo.Batch A
			) AS source
			ON target.batch_number = source.batch_number
				AND target.form_code = source.form_code
			
	WHEN MATCHED AND (target.source_id <> source.source_id
				OR target.target_date <> source.target_date
				OR target.date_given_key <> source.date_given_key
				OR target.enabled <> source.enabled
				OR target.hidden <> source.hidden)
		THEN
			UPDATE	
			SET		source_id = source.source_id,
					target_date = source.target_date,
					date_given_key = source.date_given_key,
					enabled = source.enabled,
					hidden = source.hidden
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
			AND ISNUMERIC(source.batch_number) = 1
			AND ISDATE(source.target_date) = 1
			AND ISDATE(source.report_date) = 1
			AND ISNUMERIC(source.enabled) = 1
			AND ISNUMERIC(source.hidden) = 1
		)
		THEN 
			INSERT (source_id,
					batch_number,
					form_code,
					target_date,
					report_date,
					date_given_key,
					enabled,
					hidden)
			VALUES (source_id,
					batch_number,
					form_code,
					target_date,
					report_date,
					date_given_key,
					enabled,
					hidden)
					
	;
	INSERT INTO Seer_CTRL.dbo.Batch(SourceID,
									BatchNumber,
									FormCode,
									TargetDate,
									ReportDate,
									Enabled,
									DateGivenKey,
									Hidden,
									CreateDatetime)
	SELECT	SourceID,
			BatchNumber,
			FormCode,
			TargetDate,
			ReportDate,
			DateGivenKey,
			Enabled,
			Hidden,
			CreateDatetime
			
	FROM	Seer_STG.dbo.Batch

	WHERE	LEN(FormCode) = 0
			OR ISNUMERIC(BatchNumber) <> 1
			OR ISDATE(TargetDate) <> 1
			OR ISDATE(ReportDate) <> 1
			OR ISNUMERIC(Enabled) <> 1
			OR ISNUMERIC(Hidden) <> 1
	;
END