/*
truncate table dbo.Batch
drop procedure spPopulate_mdmBatch
truncate table Seer_CTRL.dbo.Batch
*/
CREATE PROCEDURE spPopulate_mdmBatch AS
BEGIN
	MERGE	Seer_MDM.dbo.Batch AS target
	USING	(
			SELECT	source_id,
					batch_number,
					form_code,
					target_date,
					report_date,
					CASE WHEN DATEPART(MM, report_date)%2 = 1 AND form_code = 'NEW-0312-E' THEN REPLACE(CONVERT(VARCHAR(20), DATEADD(MM, 1, report_date), 112), '-', '')
						ELSE REPLACE(CONVERT(VARCHAR(20), report_date), '-', '')
					END date_given_key,
					enabled,
					hidden
			FROM	(SELECT	CONVERT(VARCHAR(50), a.ID) source_id,
							SUBSTRING(CONVERT(VARCHAR(10), a.BatchNumber), 1, CHARINDEX('.', CONVERT(VARCHAR(10), a.BatchNumber)) + 1) batch_number,
							CASE WHEN RIGHT(a.BatchNumber, 3) = '400' THEN 'NEW-0312-E'
								ELSE COALESCE(b.form_code, c.form_code, '')
							END form_code,
							CONVERT(VARCHAR(25), a.TargetDate) target_date,
							CASE	WHEN a.BatchNumber = 121.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120201'))
									WHEN a.BatchNumber = 122.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120301'))
									WHEN a.BatchNumber = 123.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120401'))
									WHEN a.BatchNumber = 124.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120501'))
									WHEN a.BatchNumber = 125.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120601'))
									WHEN a.BatchNumber = 126.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120701'))
									WHEN a.BatchNumber = 127.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120801'))
									WHEN a.BatchNumber = 128.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20120901'))
									WHEN a.BatchNumber = 129.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20121001'))
									WHEN a.BatchNumber = 130.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20121101'))
									WHEN a.BatchNumber = 131.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20121201'))
									WHEN a.BatchNumber = 132.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130101'))
									WHEN a.BatchNumber = 133.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130201'))
									WHEN a.BatchNumber = 134.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130301'))
									WHEN a.BatchNumber = 135.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130401'))
									WHEN a.BatchNumber = 136.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130501'))
									WHEN a.BatchNumber = 137.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130601'))
									WHEN a.BatchNumber = 138.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130701'))
									WHEN a.BatchNumber = 139.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130801'))
									WHEN a.BatchNumber = 140.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20130901'))
									WHEN a.BatchNumber = 141.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20131001'))
									WHEN a.BatchNumber = 142.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20131101'))
									WHEN a.BatchNumber = 143.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20131201'))
									WHEN a.BatchNumber = 144.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140101'))
									WHEN a.BatchNumber = 145.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140201'))
									WHEN a.BatchNumber = 146.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140301'))
									WHEN a.BatchNumber = 147.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140401'))
									WHEN a.BatchNumber = 148.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140501'))
									WHEN a.BatchNumber = 149.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140601'))
									WHEN a.BatchNumber = 150.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140701'))
									WHEN a.BatchNumber = 151.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140801'))
									WHEN a.BatchNumber = 152.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20140901'))
									WHEN a.BatchNumber = 153.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20141001'))
									WHEN a.BatchNumber = 154.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20141101'))
									WHEN a.BatchNumber = 155.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20141201'))
									WHEN a.BatchNumber = 156.400 THEN CONVERT(VARCHAR(25), CONVERT(DATE, '20150101'))
							ELSE CONVERT(VARCHAR(25), a.TargetDate)
							END report_date,
							CONVERT(VARCHAR(1),a.Enabled) enabled,
							CONVERT(VARCHAR(1), a.Hidden) hidden
							
					from	OISDB.dbo.tblBatchDelivery a
							LEFT JOIN
							(
							SELECT	coalesce(e.BatchNumber, '-1.000') batch_number,
									coalesce(c.SurveyFormId, '') form_code
									
							FROM	[Seer_STG].[dbo].[Product] a
									LEFT JOIN [Seer_STG].[dbo].[Product Categories] b
									ON a.Number = b.Code
									LEFT JOIN [Seer_STG].[dbo].[Survey Forms] c
									ON b.Category = c.ProductCategory
									LEFT JOIN [OISDB].dbo.tblProduct d
									ON a.Number = d.Number
									LEFT JOIN [OISDB].dbo.tblOrganizationProductOrder e
									ON d.ProductID = e.ProductID
									
							WHERE	c.SurveyFormId IS NOT NULL
									AND e.BatchNumber IS NOT NULL
									
							GROUP BY coalesce(e.BatchNumber, '-1.000'),
									coalesce(c.SurveyFormId, '')
							) b
							ON a.BatchNumber = b.batch_number
							LEFT JOIN
							(
							SELECT	distinct
									Form_Code,
									--SUBSTRING(RIGHT(Job_Order_Num, 4), 1, 3) + '.' + SUBSTRING(RIGHT(Job_Order_Num, 4), 4, 1),
									--REPLACE(REPLACE(REPLACE(Filename, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B') Filename,
									SUBSTRING(REPLACE(REPLACE(REPLACE(Filename, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 2, 5) BatchNumber
							FROM	Seer_STG.dbo.[Program Response Data]	
							WHERE	FileName IS NOT NULL
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(Filename, '123 3', '123.3'), '122', '122.3'), 'Batch ', 'B'), 1, 1) = 'B'
							UNION
							SELECT	distinct
									Form_Code,
									--Job_Ord,
									SUBSTRING(RIGHT(Job_Ord, 4), 1, 3) + '.0' BatchNumber
							FROM	Seer_STG.dbo.[Member Response Data]
							WHERE	LEN(Job_Ord) > 10
							UNION
							SELECT	distinct
									Form_Code,
									--Filename,
									--REPLACE(REPLACE(REPLACE(REPLACE(Filename, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'),
									SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(Filename, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 2, 5) BatchNumber
							FROM	Seer_STG.dbo.[Staff Response Data]
							WHERE	FileName IS NOT NULL
									AND SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(Filename, '126.2', 'B126.2'), '124', '124.2'), 'Batch ', 'B'), 'B ', 'B'), 1, 1) = 'B'
									AND LEN(FORM_CODE) > 0
							) c
							ON a.BatchNumber = c.BatchNumber
					) A
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
		(LEN(source.form_code) > 0 AND ISNUMERIC(source.batch_number) = 1 AND ISDATE(source.target_date) = 1
			AND ISDATE(source.report_date) = 1 AND ISNUMERIC(source.enabled) = 1 AND ISNUMERIC(source.hidden) = 1
		)
		THEN 
			INSERT (source_id, batch_number, form_code, target_date, report_date,
					date_given_key, enabled, hidden)
			VALUES (source_id, batch_number, form_code, target_date, report_date,
					date_given_key, enabled, hidden)
					
	;
	INSERT INTO Seer_CTRL.dbo.Batch(SourceID, BatchNumber, FormCode, TargetDate, ReportDate, Enabled,
									DateGivenKey, Hidden, CreateDatetime)
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