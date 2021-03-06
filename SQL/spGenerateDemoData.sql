USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGenerateDemoData]    Script Date: 08/13/2013 21:31:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 04/20/2012
-- Description:	<Description,,>
-- exec [dd].[spGenerateDemoData]
-- =============================================
CREATE PROCEDURE [dd].[spGenerateDemoData]
AS
BEGIN

declare @ADemoAssociationName_Multi varchar(100) = 'Middle Earth YMCA'
declare @ADemoNoBranches_Multi smallint = 11
declare @ADemoAssociationKey_Multi int = 200001
declare @ADemoAssociationNumber_Multi varchar(5) = '0001'

declare @ADemoAssociationName_Single varchar(100) = 'Hobbit Area YMCA'
declare @ADemoAssociationKey_Single int = 200002
declare @ADemoAssociationNumber_Single varchar(5) = '0002'

print 'memex multi'
exec [dd].[spGenerateDemoData_MemEx] 
	 @DemoAssociationName = @ADemoAssociationName_Multi
	,@SourceAssociationName = 'YMCA of Silicon Valley'
	,@DemoNoBranches = @ADemoNoBranches_Multi
	,@DemoAssociationKey = @ADemoAssociationKey_Multi
	,@DemoAssociationNumber = @ADemoAssociationNumber_Multi

print 'memex single'
exec [dd].[spGenerateDemoData_MemEx] 
	 @DemoAssociationName = @ADemoAssociationName_Single
	,@SourceAssociationName = 'YMCA of the Blue Water Area'
	,@DemoNoBranches = 1
	,@DemoAssociationKey = @ADemoAssociationKey_Single
	,@DemoAssociationNumber = @ADemoAssociationNumber_Single

print 'empsat multi'
exec [dd].[spGenerateDemoData_EmpSat] 
	 @DemoAssociationName = @ADemoAssociationName_Multi
	,@SourceAssociationName = 'YMCA of Greater Seattle'
	,@DemoNoBranches = @ADemoNoBranches_Multi
	,@DemoAssociationKey = @ADemoAssociationKey_Multi
	,@DemoAssociationNumber = @ADemoAssociationNumber_Multi

print 'empsat single'
exec [dd].[spGenerateDemoData_EmpSat] 
	 @DemoAssociationName = @ADemoAssociationName_Single
	,@SourceAssociationName = 'YMCA of the Blue Water Area'
	,@DemoNoBranches = 1
	,@DemoAssociationKey =  @ADemoAssociationKey_Single
	,@DemoAssociationNumber = @ADemoAssociationNumber_Single

print 'program multi'
exec [dd].[spGenerateDemoData_Program] 
	 @DemoAssociationName = @ADemoAssociationName_Multi
	,@SourceAssociationName = 'YMCA of Silicon Valley'
	,@DemoNoBranches = @ADemoNoBranches_Multi
	,@DemoAssociationKey = @ADemoAssociationKey_Multi
	,@DemoAssociationNumber = @ADemoAssociationNumber_Multi

print 'program single'
exec [dd].[spGenerateDemoData_EmpSat] 
	 @DemoAssociationName = @ADemoAssociationName_Single
	,@SourceAssociationName = 'Lake County YMCA'
	,@DemoNoBranches = 1
	,@DemoAssociationKey =  @ADemoAssociationKey_Single
	,@DemoAssociationNumber = @ADemoAssociationNumber_Single
	
print 'newmem multi'
exec [dd].[spGenerateDemoData_NewMem] 
	 @DemoAssociationName = @ADemoAssociationName_Multi
	,@SourceAssociationName = 'YMCA of the Brandywine Valley'
	,@DemoNoBranches = @ADemoNoBranches_Multi
	,@DemoAssociationKey = @ADemoAssociationKey_Multi
	,@DemoAssociationNumber = @ADemoAssociationNumber_Multi

print 'newmem single'
exec [dd].[spGenerateDemoData_NewMem] 
	 @DemoAssociationName = @ADemoAssociationName_Single
	,@SourceAssociationName = 'YMCA of the Treasure Coast'
	,@DemoNoBranches = 1
	,@DemoAssociationKey =  @ADemoAssociationKey_Single
	,@DemoAssociationNumber = @ADemoAssociationNumber_Single

END






















