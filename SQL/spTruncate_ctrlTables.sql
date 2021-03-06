USE [Seer_CTRL]
GO
/****** Object:  StoredProcedure [dbo].[spTruncate_ctrlTables]    Script Date: 08/23/2013 09:34:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spTruncate_ctrlTables] @RunType AS VARCHAR(25) = ''
AS
BEGIN
	DECLARE @run_type VARCHAR(25)
	SET @run_type = @RunType
	/*
	SELECT	@run_type = run_type
	FROM	dbo.Audit
	WHERE	Seer_CTRL.dbo.audit_status = 'In Progress'
	*/
	
	IF @run_type = 'Historical'
		BEGIN
			TRUNCATE TABLE [dbo].[Audit]
			;
			TRUNCATE TABLE [dbo].[Batch]
			;
			TRUNCATE TABLE [dbo].[Member]
			;
			TRUNCATE TABLE [dbo].[Member Data]
			;
			TRUNCATE TABLE [dbo].[Member Response Data]
			;
			TRUNCATE TABLE [dbo].[Member Aggregated Data]
			;
			TRUNCATE TABLE [dbo].[New Member Response Data]
			;
			TRUNCATE TABLE [dbo].[Organization]
			;
			TRUNCATE TABLE [dbo].[Product]
			;
			TRUNCATE TABLE [dbo].[Product Categories]
			;
			TRUNCATE TABLE [dbo].[Program Group]
			;
			TRUNCATE TABLE [dbo].[Program Response Data]
			;
			TRUNCATE TABLE [dbo].[Program Aggregated Data]
			;
			TRUNCATE TABLE [dbo].[Sequence]
			;
			TRUNCATE TABLE [dbo].[Staff Response Data]
			;
			TRUNCATE TABLE [dbo].[Staff Aggregated Data]
			;
			TRUNCATE TABLE [dbo].[Survey Categories]
			;
			TRUNCATE TABLE [dbo].[Survey Forms]
			;
			TRUNCATE TABLE [dbo].[Survey Questions]
			;
			TRUNCATE TABLE [dbo].[Survey Responses]
			;
		END
END

