USE [Seer_CTRL]
GO
/****** Object:  StoredProcedure [dbo].[spPopulate_ctrlSequence]    Script Date: 08/17/2013 17:47:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPopulate_ctrlSequence]	@command_type varchar(10) = 'Begin',
													@command_datetime datetime = 'JAN 01 1900',
													@sequence_status varchar(25) = 'In Progress',
													@audit_key varchar(75) = 0,
													@sequence_name varchar(75) = '',
													@task_description varchar(255) = ''
AS
SET @command_datetime = GETDATE();

IF @audit_key = 0
	BEGIN
		SELECT	@audit_key = COALESCE(audit_key, 0)
		FROM	dbo.Audit
		WHERE	audit_status = @sequence_status;
	END

IF @command_type = 'Begin'
	BEGIN
		BEGIN TRAN
			INSERT INTO dbo.Sequence (audit_key,
									  begin_datetime,
									  end_datetime,
									  sequence_status,
									  sequence_name,
									  task_description)
			SELECT	@audit_key,
					@command_datetime,
					DATEADD(YY, 100, @command_datetime),
					@sequence_status,
					@sequence_name,
					@task_description
					
			WHERE	@audit_key <> 0;
		COMMIT TRAN
	END
	
IF @command_type = 'Fail'
	BEGIN
		BEGIN TRAN		
			UPDATE	dbo.Sequence
			SET		end_datetime = DATEADD(SS, -1, @command_datetime),
					status_indicator = 0,
					sequence_status = @command_type
			WHERE	sequence_status = @sequence_status
					AND audit_key = @audit_key
					AND sequence_name = @sequence_name
					AND task_description = @task_description;
		COMMIT TRAN
	END

IF @command_type = 'End'
	BEGIN
		UPDATE	dbo.Sequence
		SET		end_datetime = @command_datetime,
				status_indicator = 1,
				sequence_status = 'Success'
		WHERE	audit_key = @audit_key
				AND sequence_status = @sequence_status
				AND task_description = @task_description;
	END