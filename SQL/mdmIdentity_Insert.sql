SET IDENTITY_INSERT dbo.Batch ON
GO
INSERT dbo.Batch(batch_key,
					source_id,
					batch_number,
					form_code,
					target_date,
					report_date,
					date_given_key,
					enabled,
					hidden)
VALUES (0,
		'',
		'',
		'',
		'JAN 01 1900',
		'JAN 01 1900',
		NULL,
		'1',
		'0'
		)
GO
SET IDENTITY_INSERT dbo.Batch OFF
GO