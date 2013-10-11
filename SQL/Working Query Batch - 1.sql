SELECT	CONVERT(VARCHAR(50), a.ID) SourceID,
		CONVERT(VARCHAR(10), a.BatchNumber) BatchNumber,
		CASE WHEN RIGHT(a.BatchNumber, 3) = '400' THEN 'NEW-0312-E'
			ELSE COALESCE(b.form_code, c.form_code, '')
		END FormCode,
		CONVERT(VARCHAR(25), a.TargetDate) TargetDate,
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
		ELSE CONVERT(VARCHAR(25), a.TargetDate)
		END ReportDate,
		CONVERT(VARCHAR(1),a.Enabled) Enabled,
		CONVERT(VARCHAR(1), a.Hidden) Hidden
		
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
Order by BatchNumber,
		ReportDate
go