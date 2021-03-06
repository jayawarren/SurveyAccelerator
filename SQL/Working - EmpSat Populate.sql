USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spPrepopulateDashboardMetadata_EmpSat]    Script Date: 08/04/2013 22:33:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 20120425
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dd].[spPrepopulateDashboardMetadata_EmpSat]
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	DECLARE @Step int = 200;
	
BEGIN TRY
	BEGIN TRANSACTION;

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table dd.factEmpSatDashboardBase
	insert into dd.factEmpSatDashboardBase
	select * from dd.vwEmpSatDashboardBase

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table dd.factEmpSatDetailSurvey		
	exec [dd].[spGetEmpSatDetailSurveyData] @ACategory = 'Dashboard'
	exec [dd].[spGetEmpSatDetailSurveyData] @ACategory = 'YUSA'
	
	/*
	insert into dd.factEmpSatDetailSurvey
	select * from dd.vwEmpSatDetailSurvey
	insert into dd.factEmpSatDetailSurvey
	select * from dd.vwEmpSatDetailSurvey_WellBeing	
	*/

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table dd.factEmpSatBranchReport	
	insert into dd.factEmpSatBranchReport
	select * from dd.vwEmpSatBranchReport
	
	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)		
	truncate table dd.factEmpSatBranchComparisonPivot	
	insert into dd.factEmpSatBranchComparisonPivot	
	select * from dd.vwEmpSatBranchComparisonPivot		

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table [dd].[factEmpSatBranchSurveyResponders]	
	insert into [dd].[factEmpSatBranchSurveyResponders]
	select * from [dd].[vwEmpSatBranchSurveyResponders]	
			
	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table [dd].[factEmpSatAssocSurveyResponders]	
	insert into [dd].[factEmpSatAssocSurveyResponders]
	select * from [dd].[vwEmpSatAssocSurveyResponders]	

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	truncate table [dd].[factEmpSatOpenEnded]	
	insert into [dd].[factEmpSatOpenEnded]
	select * from [dd].[vwEmpSatOpenEnded]	

	set @Step = @Step +1
	print cast(@Step as varchar(3)) + ': ' + cast(GetDate() as varchar)
	exec [dd].[spDashboardLabelChanges_EmpSat]

	COMMIT TRANSACTION;
	  
END TRY	  
BEGIN CATCH	
	print 'Data processing error occurred at Step ' + CONVERT(VARCHAR(5), @Step) + '.  All EmpSat transactions rolled back.'
	ROLLBACK TRANSACTION;
END CATCH
	
END





















