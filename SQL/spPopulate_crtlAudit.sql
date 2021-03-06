USE [Seer_CTRL]
GO
/****** Object:  StoredProcedure [dbo].[spPopulate_Audit]    Script Date: 08/17/2013 17:47:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec spPopulateAudit
CREATE PROCEDURE [dbo].[spPopulate_ctrlAudit]	@command_type varchar(10) = 'Begin',
												@command_datetime datetime = 'JAN 01 1900',
												@audit_status varchar(25) = 'In Progress',
												@job_name varchar(75) = '',
												@system_name varchar(50) = '',
												@run_type varchar(20) = ''
AS
DECLARE @audit_key INT
		
SET @command_datetime = GETDATE();
SET @audit_key = 0;

SELECT	@audit_key = COALESCE(audit_key, 0)
		FROM	dbo.Audit
		WHERE	audit_status = @audit_status;


IF @command_type = 'Begin'
	BEGIN
		BEGIN TRAN		
			EXEC	spPopulate_ctrlSequence @command_type,
											'JAN 01 1900',
											'Fail',
											@audit_key,
											'',
											'';
			
			UPDATE	dbo.Audit
			SET		end_datetime = DATEADD(SS, -1, @command_datetime),
					status_indicator = 0,
					audit_status = 'Fail'
			WHERE	audit_status = @audit_status
					AND job_name = @job_name;
		COMMIT TRAN
		
		BEGIN TRAN
			INSERT INTO dbo.Audit (begin_datetime,
									end_datetime,
									audit_status,
									job_name,
									system_name,
									run_type)
			SELECT	@command_datetime,
					DATEADD(YY, 100, @command_datetime),
					@audit_status,
					@job_name,
					@system_name,
					@run_type
		COMMIT TRAN
	END
IF @command_type = 'End'
	BEGIN
		UPDATE	dbo.Audit
		SET		end_datetime = @command_datetime,
				status_indicator = 1,
				audit_status = 'Success'
		WHERE	audit_status = @audit_status
				AND job_name = @job_name;
	END