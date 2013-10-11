CREATE PROCEDURE spPopulate_mdmBatch AS
BEGIN
	MERGE	Seer_MDM.dbo.Batch AS target
	USING	(
			SELECT	SourceID source_id,
					BatchNumber batch_number,
					FormCode form_code,
					TargetDate target_date,
					ReportDate report_date,
					Enabled,
					Hidden,
					CreateDateTime create_datetime
			FROM	Seer_STG.dbo.Batch
			) AS source
			ON target.batch_number = source.batch_number
				AND target.form_code = source.form_code
			
	WHEN MATCHED AND (target.source_id <> source.source_id
				OR target.target_date <> source.target_date
				OR target.enabled <> source.enabled
				OR target.hidden <> source.hidden)
		THEN
			UPDATE	
			SET		source_id = source.source_id,
					target_date = source.target_date,
					enabled = source.enabled,
					hidden = source.hidden
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0 AND ISNUMERIC(source.batch_number) = 1 AND ISDATE(source.target_date) = 1
			AND ISDATE(source.report_date) = 1 AND ISNUMERIC(source.enabled) = 1 AND ISNUMERIC(source.hidden) = 1
		)
		THEN 
			INSERT (source_id, batch_number, form_code, target_date, report_date,
					enabled, hidden, create_datetime)
			VALUES (source_id, batch_number, form_code, target_date, report_date,
					enabled, hidden, create_datetime)
					
	;
	INSERT INTO Seer_CTRL.dbo.Batch(SourceID, BatchNumber, FormCode, TargetDate, ReportDate, Enabled,
									Hidden, CreateDatetime)
	SELECT	SourceID,
			BatchNumber,
			FormCode,
			TargetDate,
			ReportDate,
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