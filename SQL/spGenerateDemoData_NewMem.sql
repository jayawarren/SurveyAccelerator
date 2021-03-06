USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGenerateDemoData_NewMem]    Script Date: 08/13/2013 21:34:15 ******/
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
declare @ASourceAssociationName varchar(100) = 'YMCA of Greater Richmond'
declare @ADemoNoBranches smallint = 10
declare @ADemoAssocationKey int = 200001 --200002
declare @ADemoAssociationNumber varchar(5) = '0001' --'0002'
exec [dd].[spGenerateDemoData_NewMem] 
	@DemoAssociationName = @ADemoAssociationName
	@SourceAssociationName = @ASourceAssociationName
	@DemoNoBranches = @ADemoNoBranches
	@DemoAssociationKey = @ADemoAssociationKey
	@DemoAssociationNumber = @ADemoAssociationNumber
*/
-- =============================================
CREATE PROCEDURE [dd].[spGenerateDemoData_NewMem] (
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
		dd.factNewMemDashboardBase
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
	delete from dd.factNewMemAssociationComparison where AssociationName = @DemoAssociationName
	delete from dd.factNewMemAssociationComparisonPivot where AssociationName = @DemoAssociationName
	delete from dd.factNewMemAssociationExperienceReport where AssociationName = @DemoAssociationName
	delete from dd.factNewMemAssociationSegment where AssociationName = @DemoAssociationName
	delete from dd.factNewMemAssociationSurveyResponders where AssociationName = @DemoAssociationName
	delete from dd.factNewMemBranchDetailSurveyQuestions where AssociationName = @DemoAssociationName
	delete from dd.factNewMemBranchExperienceReport where AssociationName = @DemoAssociationName
	delete from dd.factNewMemBranchOpenEnded where AssociationName = @DemoAssociationName
	delete from dd.factNewMemBranchSegment where AssociationName = @DemoAssociationName
	delete from dd.factNewMemBranchSurveyResponders where AssociationName = @DemoAssociationName
	delete from dd.factNewMemDashboardBase where AssociationName = @DemoAssociationName
		
	print 'dd.factNewMemDashboardBase'
	insert into dd.factNewMemDashboardBase(AssociationKey
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
		,AssociationNumber
		,[SurveyDate]
		,GrpInd
		,[AssocGivenDateKey]
        ,[AssocSurveyYear]
		,[AssocPrevYear]
		,[AssocPrevGivenDateKey]
		,[AssocSurveyDate]
		,[AssocGrpInd])	
	select 
		@DemoAssociationKey as AssociationKey
		,@DemoAssociationKey + BranchKey as BranchKey
		,@DemoAssociationName as AssociationName
		,@DemoAssociationNumber + ' - ' + @DemoAssociationName as AssociationNameEx
		,NewBranchName as OfficialBranchName
		,NewBranchName as [BranchNameShort]
		,[GivenDateKey]
		,[SurveyYear]
		,[PrevYear]
		,[PrevGivenDateKey]
		,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
		,@DemoAssociationNumber as AssociationNumber
		,[SurveyDate]
		,1 as GrpInd
		,[AssocGivenDateKey]
        ,[AssocSurveyYear]
		,[AssocPrevYear]
		,[AssocPrevGivenDateKey]
		,[AssocSurveyDate]
		,1 as [AssocGrpInd]		
	
	from 
		dd.factNewMemDashboardBase
		inner join #NewBranchNames on 
			PrvBranchName = [BranchNameShort]
	where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	      
	print 'dd.factNewMemBranchReport'      
	insert into dd.factNewMemBranchExperienceReport
		  ([GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,[Association]
      ,[AssociationName]
      ,[AssociationNumber]
      ,[Branch]
      ,[OfficialBranchName]
      ,[OfficialBranchNumber]
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[BranchCount]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[Question]
      ,[ShortQuestion]
      ,[BranchPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage])
	SELECT	
	  [GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,@DemoAssociationName as Association
      ,@DemoAssociationName as AssociationName 
      ,@DemoAssociationNumber as [AssociationNumber]
      ,NewBranchName as Branch  
      ,NewBranchName  as OfficialBranchName
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[BranchCount]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[Question]
      ,[ShortQuestion]
      ,[BranchPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage]
	  FROM [dd].[factNewMemBranchExperienceReport]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]  
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
		
	  
	print 'dd.factNewMemAssociationExperienceReport'
	insert into dd.factNewMemAssociationExperienceReport
		  ([GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,[Association]
      ,[AssociationName]
      ,[AssociationNumber]
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[AssociationCount]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[Question]
      ,[ShortQuestion]
      ,[AssociationPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage])
	SELECT 
	  [GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,@DemoAssociationName as [Association]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationNumber as [AssociationNumber]
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[AssociationCount]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[Question]
      ,[ShortQuestion]
      ,[AssociationPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage]
	  FROM [dd].[factNewMemAssociationExperienceReport]
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factNewMemBranchDetailSurveyQuestions'
	insert into dd.factNewMemBranchDetailSurveyQuestions ([GivenSurveyDate]
      ,[SurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,[AssociationName]
      ,[AssociationNumber]
      ,[OfficialBranchName]
      ,OfficialBranchNumber
      ,[Branch] 
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[ResponseText]
      ,[ResponseCode]
      ,[Question]
      ,[ShortQuestion]
      ,[BranchPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage])
	SELECT 
	  [GivenSurveyDate]
      ,[SurveyYear]
      ,[PreviousSurveyYear]
      ,[CurrentSurveyIndicator]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationNumber as [AssociationNumber]
      ,NewBranchName as [OfficialBranchName]
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,NewBranchName as [Branch] 
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[QuestionPosition]
      ,[QuestionCode]
      ,[ResponseText]
      ,[ResponseCode]
      ,[Question]
      ,[ShortQuestion]
      ,[BranchPercentage]
      ,[CurrentPercentage]
      ,[PreviousPercentage]
	  FROM [dd].[factNewMemBranchDetailSurveyQuestions]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  where AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factNewMemBranchOpenEnded'
	insert into dd.factNewMemBranchOpenEnded ([AssociationName]
      ,[OfficialBranchName]
      ,[Branch]
      ,[SurveyYear]
      ,[OpenEndedGroup]
      ,[Category]
      ,[Subcategory]
      ,[OpenEndResponse]
      ,[ResponseCount])
	SELECT 
	  @DemoAssociationName as [AssociationName]
      ,NewBranchName as [OfficialBranchName]
      ,NewBranchName as [Branch]
      ,[SurveyYear]
      ,[OpenEndedGroup]
      ,[Category]
      ,[Subcategory]
      ,[OpenEndResponse]
      ,[ResponseCount]
	  FROM [dd].[factNewMemBranchOpenEnded]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	  
	print 'dd.factNewMemBranchSegment'
	insert into dd.factNewMemBranchSegment
		  ([AssociationNumber]
      ,[AssociationName]
      ,[Association]
      ,[OfficialBranchNumber]
      ,[OfficialBranchName]
      ,[Branch]
      ,[SurveyYear]
      ,[GivenDateKey]
      ,[CurrentSurveyIndicator]
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
      ,[SegmentHealthSeekerYes]
      ,[SegmentHealthSeekerNo]
      ,[PreviousPercentage]
      ,[PreviousGivenDateKey])
	SELECT 
	  @DemoAssociationNumber as [AssociationNumber]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Association]
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,NewBranchName as [OfficialBranchName] 
      ,NewBranchName as [Branch]
      ,[SurveyYear]
      ,[GivenDateKey]
      ,[CurrentSurveyIndicator]
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
      ,[SegmentHealthSeekerYes]
      ,[SegmentHealthSeekerNo]
      ,[PreviousPercentage]
      ,[PreviousGivenDateKey]
	  FROM [dd].[factNewMemBranchSegment]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factNewMemAssociationSegment'
	insert into dd.factNewMemAssociationSegment
		 ([AssociationNumber]
      ,[AssociationName]
      ,[Association]
      ,[SurveyYear]
      ,[GivenDateKey]
      ,[CurrentSurveyIndicator]
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
      ,[SegmentHealthSeekerYes]
      ,[SegmentHealthSeekerNo]
      ,[PreviousPercentage]
      ,[PreviousGivenDateKey])
	SELECT 
	  @DemoAssociationNumber as AssociationNumber
	  ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Association]
      ,[SurveyYear]
      ,[GivenDateKey]
      ,[CurrentSurveyIndicator]
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
      ,[SegmentHealthSeekerYes]
      ,[SegmentHealthSeekerNo]
      ,[PreviousPercentage]
      ,[PreviousGivenDateKey]
	  FROM [dd].[factNewMemAssociationSegment]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factNewMemBranchSurveyResponders'
	insert into dd.factNewMemBranchSurveyResponders
		  ([GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,[AssociationNumber]
      ,[AssociationName]
      ,[Association]
      ,[OfficialBranchNumber]
      ,[OfficialBranchName]
      ,[Branch]
      ,[Members]
      ,[SurveysMailed]
      ,[ResponsePercentage])	
	SELECT 
	  [GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,@DemoAssociationNumber as [AssociationNumber]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Assocation]
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,NewBranchName as [OfficialBranchName] 
      ,NewBranchName as [Branch]
      ,[Members]
      ,[SurveysMailed]
      ,[ResponsePercentage]
	  FROM [dd].[factNewMemBranchSurveyResponders]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factNewMemAssociationSurveyResponders'
	insert into dd.factNewMemAssociationSurveyResponders
		  ([GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,[AssociationNumber]
      ,[AssociationName]
      ,[Association]
      ,[Members]
      ,[SurveysMailed]
      ,[ResponsePercentage])
	SELECT 
	  [GivenSurveyDate]
      ,[SurveyYear]
      ,[CurrentSurveyIndicator]
      ,[GivenSurveyCategory]
      ,@DemoAssociationNumber as [AssociationNumber]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Association]
      ,[Members]
      ,[SurveysMailed]
      ,[ResponsePercentage]
	  FROM [dd].[factNewMemAssociationSurveyResponders]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime

	print 'dd.factNewMemAssociationComparison'
	insert into dd.factNewMemAssociationComparison	(AssociationNumber
      ,[AssociationName]
      ,[Association]
      ,OfficialBranchNumber
      ,[OfficialBranchName]
      ,[Branch]
      ,[SurveyYear]
      ,[Question]
      ,[ShortQuestion]
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[QuestionPosition]
      ,[BranchValue]
      ,[PreviousValue]
      ,[BranchValueDelta])
	SELECT 
	   @DemoAssociationNumber
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Association]
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,NewBranchName as [OfficialBranchName]
      ,NewBranchName as [Branch]
      ,[SurveyYear]
      ,[Question]
      ,[ShortQuestion]
      ,[CategoryType]
      ,[Category]
      ,[CategoryPosition]
      ,[QuestionPosition]
      ,[BranchValue]
      ,[PreviousValue]
      ,[BranchValueDelta]
  FROM [dd].[factNewMemAssociationComparison]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime  
  
	print 'dd.factNewMemAssociationComparisonPivot'
	insert into dd.factNewMemAssociationComparisonPivot	([AssociationNumber]
      ,[AssociationName]
      ,[Association]
      ,OfficialBranchNumber
      ,[OfficialBranchName]
      ,[Branch]
      ,[Q010101]
      ,[Q010201]
      ,[Q010204]
      ,[Q010205]
      ,[Q010301]
      ,[Q010302]
      ,[Q010303]
      ,[Q010401]
      ,[Q020501]
      ,[Q020502]
      ,[Q020503]
      ,[Q020504]
      ,[Q020505]
      ,[Q020506]
      ,[Q020507]
      ,[Q020508]
      ,[Q020601]
      ,[Q020602]
      ,[Q020603]
      ,[Q020604]
      ,[Q020605]
      ,[Q020902]
      ,[Q020903]
      ,[Q020904]
      ,[Q020905]
      ,[Q031101]
      ,[Q031102])
	SELECT 
      @DemoAssociationNumber as[AssociationNumber]
      ,@DemoAssociationName as [AssociationName]
      ,@DemoAssociationName as [Association]
      ,cast(@DemoAssociationKey + cast(OfficialBranchNumber as int) as varchar) as OfficialBranchNumber
      ,NewBranchName as [OfficialBranchName]
      ,NewBranchName as [Branch]
      ,[Q010101]
      ,[Q010201]
      ,[Q010204]
      ,[Q010205]
      ,[Q010301]
      ,[Q010302]
      ,[Q010303]
      ,[Q010401]
      ,[Q020501]
      ,[Q020502]
      ,[Q020503]
      ,[Q020504]
      ,[Q020505]
      ,[Q020506]
      ,[Q020507]
      ,[Q020508]
      ,[Q020601]
      ,[Q020602]
      ,[Q020603]
      ,[Q020604]
      ,[Q020605]
      ,[Q020902]
      ,[Q020903]
      ,[Q020904]
      ,[Q020905]
      ,[Q031101]
      ,[Q031102]
	  FROM [dd].[factNewMemAssociationComparisonPivot]
		inner join #NewBranchNames on 
			PrvBranchName = [Branch]
	  WHERE AssociationName = @SourceAssociationName
		and GETDATE() between change_datetime and next_change_datetime  
	  
	COMMIT TRANSACTION;
	  
END TRY	  
BEGIN CATCH	
	ROLLBACK TRANSACTION;
END CATCH
  
DROP TABLE #NewBranchNames

END



























