USE [Seer_CTRL]
GO
/****** Object:  StoredProcedure [dbo].[spManage_crtlAudit]    Script Date: 08/17/2013 17:47:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec spPopulateAudit
CREATE PROCEDURE [dbo].[spManage_ctrlAudit]	@command_type varchar(10) = 'Release',
															@audit_key int = 0,
															@system_name varchar(75) = ''
AS
BEGIN
	IF	@audit_key = 0
		BEGIN	
			SELECT	@audit_key = MAX(audit_key)
					FROM	dbo.Audit
					WHERE	system_name = @system_name
							AND audit_status = 'Success'
							AND visible_indicator = 0;
		END

	IF @command_type = 'Release'
		BEGIN
			BEGIN TRAN		
				UPDATE	dbo.Audit
				SET		visible_indicator = 1
				WHERE	audit_key = @audit_key
						AND system_name = @system_name;
			COMMIT TRAN
		END
			
	IF @command_type = 'Rollback'
		BEGIN
			BEGIN TRAN		
				UPDATE	dbo.Audit
				SET		visible_indicator = 0
				WHERE	audit_key = @audit_key
						AND system_name = @system_name;
			COMMIT TRAN
		END
END