USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGenerateDemoData_MemEx]    Script Date: 08/13/2013 21:33:29 ******/
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
declare @ADemoAssociationNumber varchar(5) = '0001' --'0002'
exec [dd].[spGenerateDemoData_MemEx] 
	@DemoAssociationName = @ADemoAssociationName
	@SourceAssociationName = @ASourceAssociationName
	@DemoNoBranches = @ADemoNoBranches
	@DemoAssociationKey = @ADemoAssociationKey
	@DemoAssociationNumber = @ADemoAssociationNumber
*/
-- =============================================
CREATE PROCEDURE [dd].[spGenerateDemoData_MemEx] (
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
		dd.factMemExDashboardBase
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
	
	print 'cleanup...'
	delete from dd.factMemExDashboardBase where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchReport where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchReportEx where AssociationName = @DemoAssociationName
	delete from dd.factMemExAssociationReport where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchDetailSurveyQuestions where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchPyramidDimensions where AssociationName = @DemoAssociationName
	delete from dd.factMemExAssociationPyramidDimensions where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchOpenEnded where AssociationName = @DemoAssociationName
	delete from dd.factMemExAssociationOpenEnded where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchSegment where AssociationName = @DemoAssociationName
	delete from dd.factMemExAssociationSegment where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchSurveyResponders where AssociationName = @DemoAssociationName
	delete from dd.factMemExAssociationSurveyResponders where AssociationName = @DemoAssociationName
	delete from dd.factMemExBranchComparisonPivot where Association = @DemoAssociationName
	
	print 'dd.factMemExDashboardBase'
	insert into dd.factMemExDashboardBase (AssociationKey
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
		dd.factMemExDashboardBase
		inner join #NewBranchNames on 
			PrvBranchName = [BranchNameShort]
	where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	      
	print 'dd.factMemExBranchReport'      
	insert into dd.factMemExBranchReport
		  ([AssociationName]            
		  ,OfficialBranchName      
		  ,[Category]
		  ,[CategoryType]
		  ,[CategoryPosition]
		  ,[SurveyYear]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[BranchCount]
		  ,[CrtBranchPercentage]
		  ,[CrtBranchPercentageYrDelta]
		  ,[NationalPercentage]
		  ,[CrtBranchPercentageNtnlDelta]
		  ,[PrevBranchPercentage]
		  ,[CrtAssociationPercentage]
		  ,[PeerGroupPercentage]
		  ,[PreviousSurveyYear]
		  ,[CurrentNumericYear]
		  ,[PreviousNumericYear]
		  ,[QuestionCode]
		  ,[ShortQuestion])
	SELECT	
		  @DemoAssociationName as [AssociationName]            
		  ,NewBranchName as OfficialBranchName      
		  ,[Category]
		  ,[CategoryType]
		  ,[CategoryPosition]
		  ,[SurveyYear]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[BranchCount]
		  ,[CrtBranchPercentage]
		  ,[CrtBranchPercentageYrDelta]
		  ,[NationalPercentage]
		  ,[CrtBranchPercentageNtnlDelta]
		  ,[PrevBranchPercentage]
		  ,[CrtAssociationPercentage]
		  ,[PeerGroupPercentage]
		  ,[PreviousSurveyYear]
		  ,[CurrentNumericYear]
		  ,[PreviousNumericYear]
		  ,[QuestionCode]
		  ,[ShortQuestion]
	  FROM [dd].[factMemExBranchReport]
		inner join #NewBranchNames on 
			PrvBranchName = [OfficialBranchName]  
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
		
	print 'dd.factMemExBranchReportEx'
	insert into dd.factMemExBranchReportEx ([AssociationName]
		  ,[Branch]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[CrtBranchPercentage]
		  ,[NationalPercentage]
		  ,[PrevBranchPercentage]
		  ,[CrtAssociationPercentage]
		  ,[QuestionCode]
		  ,[ShortQuestion])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,NewBranchName as [Branch]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[CrtBranchPercentage]
		  ,[NationalPercentage]
		  ,[PrevBranchPercentage]
		  ,[CrtAssociationPercentage]
		  ,[QuestionCode]
		  ,[ShortQuestion]
	  FROM [dd].[factMemExBranchReportEx]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]  
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factMemExAssociationReport'
	insert into dd.factMemExAssociationReport
		  ([AssociationName]      
		  ,[Category]
		  ,[CategoryType]
		  ,[CategoryPosition]
		  ,[SurveyYear]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[AssociationCount]
		  ,[CrtAssociationPercentage]
		  ,[CrtAssociationPercentageYrDelta]
		  ,[NationalPercentage]
		  ,[CrtAssociationPercentageNtnlDelta]
		  ,[PrevAssociationPercentage]
		  ,[PreviousSurveyYear]
		  ,[CurrentNumericYear]
		  ,[PreviousNumericYear]
		  ,[ShortQuestion])
	SELECT 
		  @DemoAssociationName as [AssociationName]      
		  ,[Category]
		  ,[CategoryType]
		  ,[CategoryPosition]
		  ,[SurveyYear]
		  ,[Question]
		  ,[QuestionPosition]
		  ,[AssociationCount]
		  ,[CrtAssociationPercentage]
		  ,[CrtAssociationPercentageYrDelta]
		  ,[NationalPercentage]
		  ,[CrtAssociationPercentageNtnlDelta]
		  ,[PrevAssociationPercentage]
		  ,[PreviousSurveyYear]
		  ,[CurrentNumericYear]
		  ,[PreviousNumericYear]
		  ,[ShortQuestion]
	  FROM [dd].[factMemExAssociationReport]
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factMemExBranchDetailSurveyQuestions'
	insert into dd.factMemExBranchDetailSurveyQuestions ([AssociationName]
		  ,[Branch] 
		  ,[Category]
		  ,[Question]
		  ,[ResponseText]
		  ,[PeerGroup]
		  ,[BranchPercentage]
		  ,[AssociationPercentage]
		  ,[NationalPercentage]
		  ,[PeerPercentage]
		  ,[PreviousBranchPercentage]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[QuestionNumber]
		  ,[txtBranchPercentage]
		  ,[txtAssociationPercentage]
		  ,[txtNationalPercentage]
		  ,[txtPeerPercentage]
		  ,[txtPreviousBranchPercentage]
		  ,[ReportType])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,NewBranchName as [Branch] 
		  ,[Category]
		  ,[Question]
		  ,[ResponseText]
		  ,[PeerGroup]
		  ,[BranchPercentage]
		  ,[AssociationPercentage]
		  ,[NationalPercentage]
		  ,[PeerPercentage]
		  ,[PreviousBranchPercentage]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[QuestionNumber]
		  ,[txtBranchPercentage]
		  ,[txtAssociationPercentage]
		  ,[txtNationalPercentage]
		  ,[txtPeerPercentage]
		  ,[txtPreviousBranchPercentage]
		  ,[ReportType]
	  FROM [dd].[factMemExBranchDetailSurveyQuestions]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExBranchPyramidDimensions'
	insert into dd.factMemExBranchPyramidDimensions ([AssociationName]
		  ,[Branch] 
		  ,[CategoryGroup]
		  ,[PyramidCategory]
		  ,[CrtBranchPercentile]
		  ,[PrevBranchPercentile]
		  ,[AssocPercentile]
		  ,[Width]
		  ,[Height]
		  ,[SurveyYear])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,NewBranchName as [Branch] 
		  ,[CategoryGroup]
		  ,[PyramidCategory]
		  ,[CrtBranchPercentile]
		  ,[PrevBranchPercentile]
		  ,[AssocPercentile]
		  ,[Width]
		  ,[Height]
		  ,[SurveyYear]
	  FROM [dd].[factMemExBranchPyramidDimensions]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime  

	print 'dd.factMemExAssociationPyramidDimensions'
	insert into dd.factMemExAssociationPyramidDimensions 
		([AssociationName]
		  ,[CategoryGroup]
		  ,[PyramidCategory]
		  ,[AssociationPercentile]
		  ,[PrevAssociationPercentile]
		  ,[Width]
		  ,[Height]
		  ,[SurveyYear])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,[CategoryGroup]
		  ,[PyramidCategory]
		  ,[AssociationPercentile]
		  ,[PrevAssociationPercentile]
		  ,[Width]
		  ,[Height]
		  ,[SurveyYear]
	  FROM [dd].[factMemExAssociationPyramidDimensions]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExBranchOpenEnded'
	insert into dd.factMemExBranchOpenEnded ([AssociationName]
		  ,[Branch]  
		  ,[SurveyYear]
		  ,[OpenEndedGroup]
		  ,[Category]
		  ,[Subcategory]
		  ,[OpenEndResponse]
		  ,[ResponseCount]
		  ,[CategoryPercentage])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,NewBranchName as [Branch]  
		  ,[SurveyYear]
		  ,[OpenEndedGroup]
		  ,[Category]
		  ,[Subcategory]
		  ,[OpenEndResponse]
		  ,[ResponseCount]
		  ,[CategoryPercentage]
	  FROM [dd].[factMemExBranchOpenEnded]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExAssociationOpenEnded'
	insert into dd.factMemExAssociationOpenEnded
		([AssociationName]
		  ,[SurveyYear]
		  ,[OpenEndedGroup]
		  ,[Category]
		  ,[CategoryCount]
		  ,[RowNumber]
		  ,[CategoryPercentage])	
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,[SurveyYear]
		  ,[OpenEndedGroup]
		  ,[Category]
		  ,[CategoryCount]
		  ,[RowNumber]
		  ,[CategoryPercentage]
	  FROM [dd].[factMemExAssociationOpenEnded]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factMemExBranchSegment'
	insert into dd.factMemExBranchSegment
		  ([AssociationNumber]            
		  ,[AssociationName]            
		  ,[OfficialBranchName] 
		  ,[SurveyYear]
		  ,[GivenDateKey]
		  ,[BranchCount]
		  ,[Segment]
		  ,[Question]
		  ,[QuestionLabel]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[ResponseText]
		  ,[BranchPercentage]
		  ,[PrevBranchPercentage])
	SELECT 
		  @DemoAssociationNumber as AssociationNumber
		  ,@DemoAssociationName as [AssociationName]            
		  ,NewBranchName as [OfficialBranchName] 
		  ,[SurveyYear]
		  ,[GivenDateKey]
		  ,[BranchCount]
		  ,[Segment]
		  ,[Question]
		  ,[QuestionLabel]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[ResponseText]
		  ,[BranchPercentage]
		  ,[PrevBranchPercentage]
	  FROM [dd].[factMemExBranchSegment]
		inner join #NewBranchNames on 
			PrvBranchName = [OfficialBranchName]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExAssociationSegment'
	insert into dd.factMemExAssociationSegment
		 ([AssociationName]
		  ,[Association]
		  ,[SurveyYear]
		  ,[GivenDateKey]
		  ,[AssociationCount]
		  ,[Segment]
		  ,[Question]
		  ,[QuestionLabel]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[ResponseText]
		  ,[AssociationPercentage]
		  ,[PrevAssociationPercentage])
	SELECT 
		  @DemoAssociationName as [AssociationName]
		  ,@DemoAssociationName as [Association]
		  ,[SurveyYear]
		  ,[GivenDateKey]
		  ,[AssociationCount]
		  ,[Segment]
		  ,[Question]
		  ,[QuestionLabel]
		  ,[CategoryType]
		  ,[Category]
		  ,[CategoryPosition]
		  ,[QuestionPosition]
		  ,[ResponseCode]
		  ,[ResponseText]
		  ,[AssociationPercentage]
		  ,[PrevAssociationPercentage]
	  FROM [dd].[factMemExAssociationSegment]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExBranchSurveyResponders'
	insert into dd.factMemExBranchSurveyResponders
		  ([AssociationName]      
		  ,[OfficialBranchName] 
		  ,[Year]
		  ,[Members]
		  ,[SurveysMailed]
		  ,[ResponsePercentage])	
	SELECT 
		  @DemoAssociationName as [AssociationName]      
		  ,NewBranchName as [OfficialBranchName] 
		  ,[Year]
		  ,[Members]
		  ,[SurveysMailed]
		  ,[ResponsePercentage]
	  FROM [dd].[factMemExBranchSurveyResponders]
		inner join #NewBranchNames on 
			PrvBranchName = [OfficialBranchName]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExAssociationSurveyResponders'
	insert into dd.factMemExAssociationSurveyResponders
		  ([AssociationNumber]      
		  ,[AssociationName]
		  ,[Association]      
		  ,[Year]
		  ,[Members]
		  ,[SurveysMailed]
		  ,[ResponsePercentage])
	SELECT 
		  @DemoAssociationNumber as AssociationNumber
		  ,@DemoAssociationName as [AssociationName]
		  ,@DemoAssociationName as [Association]      
		  ,[Year]
		  ,[Members]
		  ,[SurveysMailed]
		  ,[ResponsePercentage]
	  FROM [dd].[factMemExAssociationSurveyResponders]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factMemExBranchComparisonPivot'
	insert into dd.factMemExBranchComparisonPivot ([Association]
		  ,[Branch] 
      ,[Q010101]
      ,[Q010202]
      ,[Q010303]
      ,[Q010404]
      ,[Q010505]
      ,[Q010606]
      ,[Q020101]
      ,[Q020202]
      ,[Q020303]
      ,[Q020404]
      ,[Q020505]
      ,[Q020606]
      ,[Q020707]
      ,[Q020808]
      ,[Q030101]
      ,[Q030102]
      ,[Q030103]
      ,[Q030104]
      ,[Q030105]
      ,[Q030106]
      ,[Q030107]
      ,[Q030108]
      ,[Q030109]
      ,[Q030201]
      ,[Q030202]
      ,[Q030203]
      ,[Q030204]
      ,[Q030205]
      ,[Q030206]
      ,[Q030207]
      ,[Q030208]
      ,[Q030209]
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
      ,[Q010202]
      ,[Q010303]
      ,[Q010404]
      ,[Q010505]
      ,[Q010606]
      ,[Q020101]
      ,[Q020202]
      ,[Q020303]
      ,[Q020404]
      ,[Q020505]
      ,[Q020606]
      ,[Q020707]
      ,[Q020808]
      ,[Q030101]
      ,[Q030102]
      ,[Q030103]
      ,[Q030104]
      ,[Q030105]
      ,[Q030106]
      ,[Q030107]
      ,[Q030108]
      ,[Q030109]
      ,[Q030201]
      ,[Q030202]
      ,[Q030203]
      ,[Q030204]
      ,[Q030205]
      ,[Q030206]
      ,[Q030207]
      ,[Q030208]
      ,[Q030209]
      ,[Q030301]
      ,[Q030302]
      ,[Q030303]
      ,[Q030304]
      ,[Q030305]
      ,[Q030306]
      ,[Q030307]
      ,[Q030308]
      ,[Q030309]
	  FROM [dd].[factMemExBranchComparisonPivot]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE Association = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime  
	  
	COMMIT TRANSACTION;
	  
END TRY	  
BEGIN CATCH	
	ROLLBACK TRANSACTION;
END CATCH
  
  
/*
delete from dd.factMemExDashboardBase where AssociationName like '%earth%'
delete from dd.factMemExBranchReport where AssociationName like '%earth%'
delete from dd.factMemExBranchReportEx where AssociationName like '%earth%'
delete from dd.factMemExAssociationReport where AssociationName like '%earth%'
delete from dd.factMemExBranchDetailSurveyQuestions where AssociationName like '%earth%'
delete from dd.factMemExBranchPyramidDimensions where AssociationName like '%earth%'
delete from dd.factMemExAssociationPyramidDimensions where AssociationName like '%earth%'
delete from dd.factMemExBranchOpenEnded where AssociationName like '%earth%'
delete from dd.factMemExAssociationOpenEnded where AssociationName like '%earth%'
delete from dd.factMemExBranchSegment where AssociationName like '%earth%'
delete from dd.factMemExAssociationSegment where AssociationName like '%earth%'
delete from dd.factMemExBranchSurveyResponders where AssociationName like '%earth%'
delete from dd.factMemExAssociationSurveyResponders where AssociationName like '%earth%'
delete from dd.factMemExBranchComparisonPivot where Association like '%earth%'
*/  
  
DROP TABLE #NewBranchNames

END

























