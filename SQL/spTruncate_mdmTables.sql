CREATE PROCEDURE spTruncate_mdmTables @RunType AS VARCHAR(25) = ''
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
			TRUNCATE TABLE Batch
			;
			TRUNCATE TABLE Batch_Map
			;
			TRUNCATE TABLE Member
			;
			TRUNCATE TABLE Member_Map
			;
			TRUNCATE TABLE Member_Organization_Map
			;
			TRUNCATE TABLE Member_Program_Group_Map
			;
			TRUNCATE TABLE Organization
			;
			TRUNCATE TABLE Product
			;
			TRUNCATE TABLE Program_Group
			;
			TRUNCATE TABLE Question
			;
			TRUNCATE TABLE Survey_Category
			;
			TRUNCATE TABLE Survey_Form
			;
			TRUNCATE TABLE Survey_Question
			;
			TRUNCATE TABLE Survey_Response
			;
			TRUNCATE TABLE Survey_Segment
			;
		END
END

