--exec spPopulateAudit
CREATE PROCEDURE spPopulateAudit @command_type varchar(10) = 'Begin', @command_datetime datetime = 'JAN 01 1900',
								@audit_status varchar(25) = 'In Progress', @job_name varchar(75) = ''
AS
SET @command_datetime = GETDATE()

IF @command_type = 'Begin'
	BEGIN
		BEGIN TRAN
			UPDATE	dbo.Audit
			SET		end_datetime = @command_datetime,
					status_indicator = 0,
					audit_status = 'Fail'
			WHERE	audit_status = @audit_status
		COMMIT TRAN
		
		BEGIN TRAN
			INSERT INTO dbo.Audit (begin_datetime, end_datetime, audit_status, job_name)
			SELECT	@command_datetime,
					DATEADD(YY, 100, @command_datetime),
					@audit_status,
					@job_name
		COMMIT TRAN
	END
IF @command_type = 'End'
	BEGIN
		UPDATE	dbo.Audit
		SET		end_datetime = @command_datetime,
				status_indicator = 1,
				audit_status = 'Success'
		WHERE	audit_status = @audit_status
	END
IF @command_type = 'Initiate'
	BEGIN
		UPDATE	dbo.Audit
		SET		end_datetime = @command_datetime,
				status_indicator = 0,
				audit_status = 'Fail'
		WHERE	audit_status = @audit_status
	END	