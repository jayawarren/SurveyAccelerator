USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGenerateDemoData_EmpSat]    Script Date: 08/13/2013 21:32:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		mike druta
-- Create date: 04/20/2012
-- Description:	<Description,,>
/*
declare @ADemoAssociationName varchar(100) = 'Middle Earth YMCA'
declare @ASourceAssociationName varchar(100) = 'YMCA of Silicon Valley'
declare @ADemoNoBranches smallint = 11
declare @ADemoAssocationKey int = 200001 --200002
declare @ADemoAssociationNumber varchar(5) = @DemoAssociationNumber --0002
exec [dd].[spGenerateDemoData_EmpSat] 
	@DemoAssociationName = @ADemoAssociationName
	@SourceAssociationName = @ASourceAssociationName
	@DemoNoBranches = @ADemoNoBranches
	@DemoAssociationKey = @ADemoAssociationKey
	@DemoAssociationNumber = @ADemoAssociationNumber
*/
-- =============================================
CREATE PROCEDURE [dd].[spGenerateDemoData_EmpSat] (
	 @DemoAssociationName varchar(100)
	,@SourceAssociationName varchar(100)
	,@DemoNoBranches int
	,@DemoAssociationKey int
	,@DemoAssociationNumber varchar(5)
)
AS
BEGIN
SET NOCOUNT ON
SET XACT_ABORT ON

declare @DemoBranchName1 varchar(100) 

if @DemoNoBranches = 1 
	set @DemoBranchName1 = @DemoAssociationName --for single branch associations, use the name of the association	
else 
	set @DemoBranchName1 = 'Bag End'
				
declare @DemoBranchName2 varchar(100) = 'Mordor'
declare @DemoBranchName3 varchar(100) = 'Rohan'
declare @DemoBranchName4 varchar(100) = 'Gondor'
declare @DemoBranchName5 varchar(100) = 'Fangorn'
declare @DemoBranchName6 varchar(100) = 'Harad'
declare @DemoBranchName7 varchar(100) = 'Moria'
declare @DemoBranchName8 varchar(100) = 'Rivendell'
declare @DemoBranchName9 varchar(100) = 'Edoras'
declare @DemoBranchName10 varchar(100) = 'Mirkwood'
declare @DemoBranchName11 varchar(100) = 'Rhun'

;with bns as
(
	select 
		BranchNameShort
		,ROW_NUMBER() over (partition by AssociationName order by BranchNameShort) as rn
	from 
		dd.factEmpSatDashboardBase
	where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
)
select 
	case	
		when rn = 1 then @DemoBranchName1
		when rn = 2 then @DemoBranchName2
		when rn = 3 then @DemoBranchName3
		when rn = 4 then @DemoBranchName4
		when rn = 5 then @DemoBranchName5
		when rn = 6 then @DemoBranchName6
		when rn = 7 then @DemoBranchName7
		when rn = 8 then @DemoBranchName8
		when rn = 9 then @DemoBranchName9
		when rn = 10 then @DemoBranchName10
		when rn = 11 then @DemoBranchName11
	 end as NewBranchName
	 ,BranchNameShort as PrvBranchName	
into #NewBranchNames	 
from bns
where rn <= @DemoNoBranches and rn <= 11


BEGIN TRY
	BEGIN TRANSACTION;
	
	print 'clean up...'
	delete from dd.factEmpSatDashboardBase where AssociationName = @DemoAssociationName
	delete from dd.factEmpSatBranchReport where Association = @DemoAssociationName
	delete from dd.factEmpSatDetailSurvey where Association = @DemoAssociationName
	delete from dd.factEmpSatOpenEnded where Association = @DemoAssociationName
	delete from dd.factEmpSatBranchSurveyResponders where Association = @DemoAssociationName
	delete from dd.factEmpSatAssocSurveyResponders where Association = @DemoAssociationName
	delete from dd.factEmpSatBranchComparisonPivot where Association = @DemoAssociationName
	
	print 'dd.factEmpSatDashboardBase'
	insert into dd.factEmpSatDashboardBase (AssociationKey
		  ,BranchKey
		  ,AssociationName
		  ,AssociationNameEx
		  ,OfficialBranchName
		  ,[BranchNameShort]
		  ,[GivenDateKey]
		  ,[SurveyYear]
		  ,[PrevYear]
		  ,[PrevGivenDateKey]
		  ,OfficialBranchNumber
		  ,AssociationNumber)
	select 
		  @DemoAssociationKey as AssociationKey
		  ,@DemoAssociationKey + BranchKey as BranchKey
		  ,@DemoAssociationName as AssociationName
		  ,@DemoAssociationNumber + ' - ' + @DemoAssociationName as AssociationNameEx
		  ,NewBranchName
		  ,NewBranchName as [BranchNameShort]
		  ,[GivenDateKey]
		  ,[SurveyYear]
		  ,[PrevYear]
		  ,[PrevGivenDateKey]
		  ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
		  ,@DemoAssociationNumber as AssociationNumber
	from 
		dd.factEmpSatDashboardBase
		inner join #NewBranchNames on 
			PrvBranchName = [BranchNameShort]
	where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	      
	print 'dd.factEmpSatBranchReport'      
	insert into dd.factEmpSatBranchReport ([Association]            
		  ,[Branch]
		  ,[GivenDateKey]
		  ,[PrevGivenDateKey]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[AssociationValue]
		  ,[PrvAssociationValue]
		  ,[NationalValue]
		  ,[CrtBranchValue]
		  ,[PrvBranchValue]
		  ,[ShortQuestion]
		  ,[QuestionCode])
	SELECT	
		  @DemoAssociationName as [Association]            
		  ,NewBranchName as [Branch]
		  ,[GivenDateKey]
		  ,[PrevGivenDateKey]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[AssociationValue]
		  ,[PrvAssociationValue]
		  ,[NationalValue]
		  ,[CrtBranchValue]
		  ,[PrvBranchValue]
		  ,[ShortQuestion]
		  ,[QuestionCode]
	  FROM [dd].[factEmpSatBranchReport]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]  
	  where Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
		    
	print 'dd.factEmpSatBranchDetailSurvey'
	insert into dd.factEmpSatDetailSurvey ([Association]
		  ,[Branch]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[Response]
		  ,[ResponsePosition]
		  ,[CrtPercentage]
		  ,[PrevPercentage]
		  ,[NationalPercentage]
		  ,[AssociationPercentage]
		  ,[ReportType])
	SELECT 
		  @DemoAssociationName as [Association]
		  ,NewBranchName as [Branch]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[Response]
		  ,[ResponsePosition]
		  ,[CrtPercentage]
		  ,[PrevPercentage]
		  ,[NationalPercentage]
		  ,[AssociationPercentage]
		  ,[ReportType]
	  FROM dd.factEmpSatDetailSurvey
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  where Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factEmpSatOpenEnded'
	insert into dd.factEmpSatOpenEnded ([Association]
		  ,[Branch]  		  
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryTypePosition]
		  ,[CategoryPosition]
		  ,[Response]
		  ,[Subcategory]
		  ,[CategoryPercentage])
	SELECT 
		  @DemoAssociationName as [Association]
		  ,NewBranchName as [Branch]  		  
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryTypePosition]
		  ,[CategoryPosition]
		  ,[Response]
		  ,[Subcategory]
		  ,[CategoryPercentage]
	  FROM [dd].[factEmpSatOpenEnded]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factEmpSatBranchSurveyResponders'
	insert into dd.factEmpSatBranchSurveyResponders ([Association]      
		  ,[Branch] 		  
		  ,[Sent]
		  ,[Received]
		  ,[ResponseCount]
		  ,[Question]
		  ,[Response]
		  ,[ResponsePosition]
		  ,[QuestionPosition]
		  ,[PreviousResponsePercentage]
		  ,[CurrentResponsePercentage]
		  ,[CurrentSurveyPercentage])
	SELECT 
		  @DemoAssociationName as [Association]      
		  ,NewBranchName as [Branch] 		  
		  ,[Sent]
		  ,[Received]
		  ,[ResponseCount]
		  ,[Question]
		  ,[Response]
		  ,[ResponsePosition]
		  ,[QuestionPosition]
		  ,[PreviousResponsePercentage]
		  ,[CurrentResponsePercentage]
		  ,[CurrentSurveyPercentage]
	  FROM [dd].[factEmpSatBranchSurveyResponders]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factEmpSatAssocSurveyResponders'
	insert into dd.factEmpSatAssocSurveyResponders 
		([Association]
		  ,[Sent]
		  ,[Received]
		  ,[Question]
		  ,[Response]
		  ,[ResponseCount]
		  ,[ResponsePosition]
		  ,[QuestionPosition]
		  ,[PreviousResponsePercentage]
		  ,[CurrentResponsePercentage]
		  ,[CurrentSurveyPercentage])
	SELECT 
		  @DemoAssociationName as [Association]
		  ,[Sent]
		  ,[Received]
		  ,[Question]
		  ,[Response]
		  ,[ResponseCount]
		  ,[ResponsePosition]
		  ,[QuestionPosition]
		  ,[PreviousResponsePercentage]
		  ,[CurrentResponsePercentage]
		  ,[CurrentSurveyPercentage]
	  FROM [dd].[factEmpSatAssocSurveyResponders]
	  WHERE Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factEmpSatBranchComparisonPivot'
	insert into dd.factEmpSatBranchComparisonPivot([Association]
		  ,[Branch] 
      ,[Q010101]
      ,[Q010102]
      ,[Q010103]
      ,[Q010104]
      ,[Q010105]
      ,[Q010201]
      ,[Q010202]
      ,[Q010203]
      ,[Q010204]
      ,[Q010205]
      ,[Q010206]
      ,[Q010207]
      ,[Q010208]
      ,[Q010301]
      ,[Q010302]
      ,[Q010303]
      ,[Q010304]
      ,[Q010305]
      ,[Q010306]
      ,[Q010307]
      ,[Q010308]
      ,[Q010309]
      ,[Q010401]
      ,[Q010402]
      ,[Q010403]
      ,[Q010404]
      ,[Q010405]
      ,[Q010406]
      ,[Q010407]
      ,[Q010408]
      ,[Q010409]
      ,[Q020101]
      ,[Q020201]
      ,[Q020202]
      ,[Q020203]
      ,[Q020204]
      ,[Q020205]
      ,[Q020301]
      ,[Q020401]
      ,[Q030101]
      ,[Q030102]
      ,[Q030103]
      ,[Q030104]
      ,[Q030105]
      ,[Q030106]
      ,[Q030107]
      ,[Q030108]
      ,[Q030201]
      ,[Q030202]
      ,[Q030203]
      ,[Q030204]
      ,[Q030205]
      ,[Q030206]
      ,[Q030207]
      ,[Q030208]
      ,[Q030301]
      ,[Q030302]
      ,[Q030303]
      ,[Q030304]
      ,[Q030305]
      ,[Q030306]
      ,[Q030307]
      ,[Q030308]
      ,[Q030309])
	SELECT 
		  @DemoAssociationName as [Association]
		  ,NewBranchName as [Branch] 
      ,[Q010101]
      ,[Q010102]
      ,[Q010103]
      ,[Q010104]
      ,[Q010105]
      ,[Q010201]
      ,[Q010202]
      ,[Q010203]
      ,[Q010204]
      ,[Q010205]
      ,[Q010206]
      ,[Q010207]
      ,[Q010208]
      ,[Q010301]
      ,[Q010302]
      ,[Q010303]
      ,[Q010304]
      ,[Q010305]
      ,[Q010306]
      ,[Q010307]
      ,[Q010308]
      ,[Q010309]
      ,[Q010401]
      ,[Q010402]
      ,[Q010403]
      ,[Q010404]
      ,[Q010405]
      ,[Q010406]
      ,[Q010407]
      ,[Q010408]
      ,[Q010409]
      ,[Q020101]
      ,[Q020201]
      ,[Q020202]
      ,[Q020203]
      ,[Q020204]
      ,[Q020205]
      ,[Q020301]
      ,[Q020401]
      ,[Q030101]
      ,[Q030102]
      ,[Q030103]
      ,[Q030104]
      ,[Q030105]
      ,[Q030106]
      ,[Q030107]
      ,[Q030108]
      ,[Q030201]
      ,[Q030202]
      ,[Q030203]
      ,[Q030204]
      ,[Q030205]
      ,[Q030206]
      ,[Q030207]
      ,[Q030208]
      ,[Q030301]
      ,[Q030302]
      ,[Q030303]
      ,[Q030304]
      ,[Q030305]
      ,[Q030306]
      ,[Q030307]
      ,[Q030308]
      ,[Q030309]
	  FROM [dd].[factEmpSatBranchComparisonPivot]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime  
	  
	COMMIT TRANSACTION;
	  
END TRY	  
BEGIN CATCH	
	ROLLBACK TRANSACTION;
END CATCH
  
 
DROP TABLE #NewBranchNames
END

























