INSERT INTO dbo.Batch (source_id, batch_number, form_code, target_date, report_date, enabled, hidden)
SELECT	a.ID source_id,
		a.BatchNumber batch_number,
		coalesce(b.form_code, 'UNKNOWN') form_code,
		a.TargetDate target_date,
		CASE	WHEN a.BatchNumber = 121.400 THEN CONVERT(DATE, '20120201')
				WHEN a.BatchNumber = 122.400 THEN CONVERT(DATE, '20120301')
				WHEN a.BatchNumber = 123.400 THEN CONVERT(DATE, '20120401')
				WHEN a.BatchNumber = 124.400 THEN CONVERT(DATE, '20120501')
				WHEN a.BatchNumber = 125.400 THEN CONVERT(DATE, '20120601')
				WHEN a.BatchNumber = 126.400 THEN CONVERT(DATE, '20120701')
				WHEN a.BatchNumber = 127.400 THEN CONVERT(DATE, '20120801')
				WHEN a.BatchNumber = 128.400 THEN CONVERT(DATE, '20120901')
				WHEN a.BatchNumber = 129.400 THEN CONVERT(DATE, '20121001')
				WHEN a.BatchNumber = 130.400 THEN CONVERT(DATE, '20121101')
				WHEN a.BatchNumber = 131.400 THEN CONVERT(DATE, '20121201')
				WHEN a.BatchNumber = 132.400 THEN CONVERT(DATE, '20130101')
				WHEN a.BatchNumber = 133.400 THEN CONVERT(DATE, '20130201')
				WHEN a.BatchNumber = 134.400 THEN CONVERT(DATE, '20130301')
				WHEN a.BatchNumber = 135.400 THEN CONVERT(DATE, '20130401')
				WHEN a.BatchNumber = 136.400 THEN CONVERT(DATE, '20130501')
				WHEN a.BatchNumber = 137.400 THEN CONVERT(DATE, '20130601')
				WHEN a.BatchNumber = 138.400 THEN CONVERT(DATE, '20130701')
				WHEN a.BatchNumber = 139.400 THEN CONVERT(DATE, '20130801')
				WHEN a.BatchNumber = 140.400 THEN CONVERT(DATE, '20130901')
				WHEN a.BatchNumber = 141.400 THEN CONVERT(DATE, '20131001')
				WHEN a.BatchNumber = 142.400 THEN CONVERT(DATE, '20131101')
				WHEN a.BatchNumber = 143.400 THEN CONVERT(DATE, '20131201')
				WHEN a.BatchNumber = 144.400 THEN CONVERT(DATE, '20140101')
		ELSE a.TargetDate
		END report_date,
		a.Enabled enabled,
		a.Hidden hidden
from	OISDB.dbo.tblBatchDelivery a
		LEFT JOIN
		(
		SELECT	coalesce(e.BatchNumber, '-1.000') batch_number,
				coalesce(c.SurveyFormId, 'UNKNOWN') form_code
		
		FROM	[Seer_STG].[dbo].[Product] a
				LEFT JOIN [Seer_STG].[dbo].[Product Categories] b
				ON a.Number = b.Code
				LEFT JOIN [Seer_STG].[dbo].[Survey Forms] c
				ON b.Category = c.ProductCategory
				LEFT JOIN [OISDB].dbo.tblProduct d
				ON a.Number = d.Number
				LEFT JOIN [OISDB].dbo.tblOrganizationProductOrder e
				ON d.ProductID = e.ProductID
				
		GROUP BY coalesce(e.BatchNumber, '-1.000'),
				coalesce(c.SurveyFormId, 'UNKNOWN')
		) b
		ON a.BatchNumber = b.batch_number
order by BatchNumber