--select	dbo.fnFilter_Datetime('Pre-Production', 'Survey Accelerator')
--select	dbo.fnFilter_Datetime('Production', 'Survey Accelerator')
CREATE FUNCTION dbo.fnFilter_Datetime (@environment varchar(25), @system_name varchar(75))
RETURNS DATETIME
AS
BEGIN
	DECLARE @filter_datetime datetime
	IF @environment = 'Production'
		SELECT	@filter_datetime = MAX(A.end_datetime)
				FROM	Seer_CTRL.dbo.Audit A
				WHERE	A.visible_indicator = 1
						AND A.system_name = @system_name
	ELSE
		SELECT	@filter_datetime = MAX(A.end_datetime)
				FROM	Seer_CTRL.dbo.Audit A
				WHERE	A.audit_status = 'Success'
						AND A.system_name = @system_name
				
	RETURN (@filter_datetime);
END
