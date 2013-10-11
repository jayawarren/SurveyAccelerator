CREATE PROCEDURE spTruncate_odsTables @RunType AS VARCHAR(25) = ''
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
			/*TRUNCATE TABLE dbo.Aggregated_Data
			;
			TRUNCATE TABLE dbo.Close_Ends
			;*/
			TRUNCATE TABLE dbo.factAssociationMemberSatisfactionReport
			;
			TRUNCATE TABLE dbo.factAssociationNewMemberExperienceReport
			;
			TRUNCATE TABLE dbo.factAssociationProgramReport
			;
			TRUNCATE TABLE dbo.factAssociationStaffExperienceReport
			;
			/*TRUNCATE TABLE dbo.factAssociationSurveyResponse
			;*/
			TRUNCATE TABLE dbo.factBranchMemberSatisfactionReport
			;
			TRUNCATE TABLE dbo.factBranchNewMemberExperienceReport
			;
			TRUNCATE TABLE dbo.factBranchStaffExperienceReport
			;
			/*TRUNCATE TABLE dbo.factBranchSurveyResponse
			;
			TRUNCATE TABLE dbo.factMemberSurveyResponse
			;*/
			TRUNCATE TABLE dbo.factMemSatPyramid
			;
			/*TRUNCATE TABLE dbo.factOrganizationSurveyResponse
			;
			TRUNCATE TABLE dbo.factPeerGroupSurveyResponse
			;
			TRUNCATE TABLE dbo.factProgramGroupSurveyResponse
			;
			TRUNCATE TABLE dbo.factProgramSiteLocationSurveyResponse
			;*/
			TRUNCATE TABLE dbo.factProgramGroupProgramReport
			;
			TRUNCATE TABLE dbo.factProgramSiteLocationProgramReport
			;
			/*TRUNCATE TABLE dbo.Member_Data
			;
			TRUNCATE TABLE dbo.Observation_Data
			;
			TRUNCATE TABLE dbo.Open_Ends
			;
			TRUNCATE TABLE dbo.Response_Data
			;
			TRUNCATE TABLE dbo.Top_Box
			;*/
			TRUNCATE TABLE dd.factEmpSatAssocSurveyResponders
			;
			TRUNCATE TABLE dd.factEmpSatBranchComparisonPivot
			;
			TRUNCATE TABLE dd.factEmpSatBranchReport
			;
			TRUNCATE TABLE dd.factEmpSatBranchSurveyResponders
			;
			TRUNCATE TABLE dd.factEmpSatDashboardBase
			;
			TRUNCATE TABLE dd.factEmpSatDetailSurvey
			;
			TRUNCATE TABLE dd.factEmpSatOpenEnded
			;
			TRUNCATE TABLE dd.factMemExAssociationOpenEnded
			;
			TRUNCATE TABLE dd.factMemExAssociationPyramidDimensions
			;
			TRUNCATE TABLE dd.factMemExAssociationReport
			;
			TRUNCATE TABLE dd.factMemExAssociationSegment
			;
			TRUNCATE TABLE dd.factMemExAssociationSurveyResponders
			;
			TRUNCATE TABLE dd.factMemExBranchComparisonPivot
			;
			TRUNCATE TABLE dd.factMemExBranchDetailSurveyQuestions
			;
			TRUNCATE TABLE dd.factMemExBranchKPIs
			;
			TRUNCATE TABLE dd.factMemExBranchOpenEnded
			;
			TRUNCATE TABLE dd.factMemExBranchPyramidDimensions
			;
			TRUNCATE TABLE dd.factMemExBranchReport
			;
			TRUNCATE TABLE dd.factMemExBranchReportEx
			;
			TRUNCATE TABLE dd.factMemExBranchSegment
			;
			TRUNCATE TABLE dd.factMemExBranchSurveyResponders
			;
			TRUNCATE TABLE dd.factMemExDashboardBase
			;
			TRUNCATE TABLE dd.factNewMemAssociationComparison
			;
			TRUNCATE TABLE dd.factNewMemAssociationComparisonPivot
			;
			TRUNCATE TABLE dd.factNewMemAssociationExperienceReport
			;
			TRUNCATE TABLE dd.factNewMemAssociationSegment
			;
			TRUNCATE TABLE dd.factNewMemAssociationSurveyResponders
			;
			TRUNCATE TABLE dd.factNewMemBranchDetailSurveyQuestions
			;
			TRUNCATE TABLE dd.factNewMemBranchExperienceReport
			;
			TRUNCATE TABLE dd.factNewMemBranchOpenEnded
			;
			TRUNCATE TABLE dd.factNewMemBranchSegment
			;
			TRUNCATE TABLE dd.factNewMemBranchSurveyResponders
			;
			TRUNCATE TABLE dd.factNewMemDashboardBase
			;
			TRUNCATE TABLE dd.factProgramDetailSurvey
			;
			TRUNCATE TABLE dd.factProgramGroupingComparisonPivot
			;
			TRUNCATE TABLE dd.factProgramGroupingReport
			;
			TRUNCATE TABLE dd.factProgramOpenEnded
			;
			TRUNCATE TABLE dd.factProgramSurveyResponders
			;
		END
END

