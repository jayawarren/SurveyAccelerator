SELECT	A.source_id,
		A.batch_number,
		A.form_code,
		A.target_date,
		A.report_date,
		CASE WHEN DATEPART(MM, A.report_date)%2 = 1 AND A.form_code LIKE '%NEW%' THEN REPLACE(CONVERT(VARCHAR(20), DATEADD(MM, 1, A.report_date), 112), '-', '')
			ELSE REPLACE(CONVERT(VARCHAR(20), A.report_date), '-', '')
		END date_given_key,
		enabled,
		hidden
FROM	(SELECT	CONVERT(VARCHAR(50), a.ID) source_id,
				SUBSTRING(CONVERT(VARCHAR(10), a.BatchNumber), 1, CHARINDEX('.', CONVERT(VARCHAR(10), a.BatchNumber)) + 1) batch_number,
				CASE WHEN RIGHT(a.BatchNumber, 3) = '400' AND COALESCE(b.form_code, '') = '' THEN 'NEW-0312-E'
					ELSE COALESCE(b.form_code, c.form_code, '')
				END form_code,
				CONVERT(VARCHAR(25), a.TargetDate) target_date,
				--2012-02-01 is the seed date for the field report_date for New Member
				CASE WHEN RIGHT(a.BatchNumber, 3) = '400' THEN CONVERT(VARCHAR(25), DATEADD(MM, a.BatchNumber - 121.4, '2012-02-01'), 112)	
					ELSE CONVERT(VARCHAR(25), a.TargetDate, 112)
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
				SELECT	CONVERT(DECIMAL(10, 3), a.batch_number) batch_number,
						b.SurveyFormId form_code
						
				FROM	Seer_STG.dbo.[Observation Data]  a
						INNER JOIN Seer_STG.dbo.[Survey Forms] b
							ON REPLACE(a.Form_Code, '-', '') = REPLACE(b.SurveyFormId, '-', '')
							
				WHERE	LEN(SurveyFormID) > 0
				
				GROUP BY CONVERT(DECIMAL(10, 3), a.batch_number),
						B.SurveyFormID	
				) c
				ON a.BatchNumber = c.batch_number
				
		) A
ORDER BY A.batch_number
;