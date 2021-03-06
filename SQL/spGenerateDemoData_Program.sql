USE [Seer_ODS]
GO
/****** Object:  StoredProcedure [dd].[spGenerateDemoData_Program]    Script Date: 08/13/2013 21:35:28 ******/
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
declare @ASourceAssociationName varchar(100) = 'YMCA of Greater Grand Rapids'
declare @ADemoNoBranches smallint = 11
declare @ADemoAssociationKey int = 200001 --200002
declare @ADemoAssociationNumber varchar(5) = '0001' --0002
exec [dd].[spGenerateDemoData_Program] 
	@DemoAssociationName = @ADemoAssociationName
	@SourceAssociationName = @ASourceAssociationName
	@DemoNoBranches = @ADemoNoBranches
	@DemoAssociationKey = @ADemoAssociationKey
	@DemoAssociationNumber = @ADemoAssociationNumber
*/
-- =============================================
CREATE PROCEDURE [dd].[spGenerateDemoData_Program] (
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
	select	db.GroupingName
			,db.SurveyType
			,ROW_NUMBER() over (partition by db.SurveyType, AssociationName order by GroupingName) as rn
			
	from	dd.factProgramDashboardBase db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.SurveyType = sf.SurveyType
				
	where	AssociationName = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
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
	 end as NewGroupingName
	 ,GroupingName as PrvGroupingName
into #NewBranchNames	 
from bns
where rn <= @DemoNoBranches and rn <= 11


BEGIN TRY
	BEGIN TRANSACTION;

	print 'clean up...'
	delete from dd.factProgramDashboardBase where AssociationName = @DemoAssociationName
	delete from dd.factProgramGroupingReport where Association = @DemoAssociationName
	delete from dd.factProgramDetailSurvey where Association = @DemoAssociationName
	delete from dd.factProgramOpenEnded where Association = @DemoAssociationName
	delete from dd.factProgramSurveyResponders where Association = @DemoAssociationName
	delete from dd.factProgramGroupingComparisonPivot where Association = @DemoAssociationName
		
	print 'dd.factProgramDashboardBase'
	insert into dd.factProgramDashboardBase (AssociationKey		  
			,AssociationName
			,AssociationNameEx
			,Program
			,GroupingLabel
			,GroupingName		  		  		  		  		  
			,[GivenDateKey]
			,[SurveyYear]
			,[PrevYear]
			,[PrevGivenDateKey]
			,ProgramKey
			,GroupingKey
			,SurveysSent
			,SurveysReceived
			,SurveyType
			,AssociationNumber)
	select	@DemoAssociationKey as AssociationKey		  
			,@DemoAssociationName as AssociationName
			,@DemoAssociationNumber + ' - ' + @DemoAssociationName as AssociationNameEx
			,Program
			,GroupingLabel
			,NewGroupingName as GroupingName		  		  		  		  		  
			,[GivenDateKey]
			,[SurveyYear]
			,[PrevYear]
			,[PrevGivenDateKey]
			,ProgramKey
			,@DemoAssociationKey + GroupingKey as GroupingKey
			,SurveysSent
			,SurveysReceived
			,db.SurveyType
			,@DemoAssociationNumber as AssociationNumber
	
	from	dd.factProgramDashboardBase db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.SurveyType = sf.SurveyType
			inner join #NewBranchNames on 
				PrvGroupingName = [GroupingName]
				
	where	AssociationName = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime
	      
	print 'dd.factProgramGroupingReport'      
	insert into dd.factProgramGroupingReport ([Association]    
			,Program        
			,[Grouping]
			,[CategoryType]
			,[Category]		  
			,[Question]
			,[CategoryPosition]
			,[QuestionPosition]
			,[ShortQuestion]
			,[QuestionCode]
			,[AssociationValue]
			,[PrvAssociationValue]
			,[NationalValue]
			,[CrtGroupingValue]
			,[PrvGroupingValue])
	SELECT	@DemoAssociationName as [Association]    
			,Program        
			,NewGroupingName as [Grouping]
			,[CategoryType]
			,[Category]		  
			,[Question]
			,[CategoryPosition]
			,[QuestionPosition]
			,[ShortQuestion]
			,[QuestionCode]
			,[AssociationValue]
			,[PrvAssociationValue]
			,[NationalValue]
			,[CrtGroupingValue]
			,[PrvGroupingValue]	
				  		  
	  FROM	[dd].[factProgramGroupingReport] db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.Program = REPLACE(REPLACE(sf.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '')
			inner join #NewBranchNames on 
				PrvGroupingName = [Grouping]
				  
	  where	Association = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime
		    
	print 'dd.factProgramDetailSurvey'
	insert into dd.factProgramDetailSurvey ([Association]
			,Program
			,[Grouping]
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
	SELECT	@DemoAssociationName as [Association]
			,Program
			,NewGroupingName as [Grouping]
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
			
	  FROM	dd.factProgramDetailSurvey db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.Program = REPLACE(REPLACE(sf.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '')
			inner join #NewBranchNames on 
				PrvGroupingName = [Grouping]
				
	  where Association = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factProgramSurveyResponders'
	insert into dd.factProgramSurveyResponders ([Association]      
			,Program
			,[Grouping] 		  
			,[ResponseCount]
			,[Question]
			,[Response]
			,[ResponsePosition]
			,[QuestionPosition]
			,[CurrentResponsePercentage]
			,[PreviousResponsePercentage]		  
			,[CrtAssocResponsePercentage]
			,[PrvAssocResponsePercentage])
	SELECT	@DemoAssociationName as [Association]      
			,Program
			,NewGroupingName as [Grouping] 		  
			,[ResponseCount]
			,[Question]
			,[Response]
			,[ResponsePosition]
			,[QuestionPosition]
			,[CurrentResponsePercentage]
			,[PreviousResponsePercentage]		  
			,[CrtAssocResponsePercentage]
			,[PrvAssocResponsePercentage]
			
	  FROM	[dd].[factProgramSurveyResponders] db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.Program = REPLACE(REPLACE(sf.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '')
			inner join #NewBranchNames on 
				PrvGroupingName = [Grouping]
				
	  WHERE Association = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factProgramOpenEnded'
	insert into dd.factProgramOpenEnded ([Association]
			,Program
			,[Grouping]  		  
			,[OpenEndedGroup]
			,[Category]		  
			,[Subcategory]
			,[Response]
			,[CategoryPercentage])
	SELECT	@DemoAssociationName as [Association]
			,Program
			,NewGroupingName as [Grouping]  		  
			,[OpenEndedGroup]
			,[Category]		  
			,[Subcategory]
			,[Response]
			,[CategoryPercentage]
			
	  FROM	[dd].[factProgramOpenEnded] db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.Program = REPLACE(REPLACE(sf.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '')
			inner join #NewBranchNames on 
				PrvGroupingName = [Grouping]
	  
	  WHERE Association = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime
	  
	print 'dd.factProgramGroupingComparisonPivot'
	insert into dd.factProgramGroupingComparisonPivot ([Association]
			,Program
			,[Grouping]
			,[Q01], [Q02], [Q03], [Q04], [Q05], [Q06], [Q07], [Q08], [Q09], [Q10]
			,[Q11], [Q12], [Q13], [Q14], [Q15], [Q16], [Q17], [Q18], [Q19], [Q20]
			,[Q21], [Q22], [Q23], [Q24], [Q25], [Q26], [Q27], [Q28], [Q29], [Q30]
			,[Q31], [Q32], [Q33], [Q34], [Q35], [Q36], [Q37], [Q38], [Q39], [Q40]
			,[Q41], [Q42], [Q43], [Q44], [Q45], [Q46], [Q47], [Q48], [Q49], [Q50]
			,[Q51], [Q52], [Q53], [Q54], [Q55], [Q56], [Q57], [Q58], [Q59], [Q60]
			,[Q61], [Q62], [Q63], [Q64], [Q65], [Q66], [Q67], [Q68], [Q69], [Q70]
			,[Q71], [Q72], [Q73], [Q74], [Q75], [Q76], [Q77], [Q78], [Q79], [Q80]
			,[Q81], [Q82], [Q83], [Q84], [Q85], [Q86], [Q87], [Q88], [Q89], [Q90]
			 ,[Q91], [Q92], [Q93], [Q94], [Q95], [Q96], [Q97], [Q98], [Q99])
	SELECT	@DemoAssociationName as [Association]
			,Program
			,NewGroupingName as [Grouping]
			,[Q01], [Q02], [Q03], [Q04], [Q05], [Q06], [Q07], [Q08], [Q09], [Q10]
			,[Q11], [Q12], [Q13], [Q14], [Q15], [Q16], [Q17], [Q18], [Q19], [Q20]
			,[Q21], [Q22], [Q23], [Q24], [Q25], [Q26], [Q27], [Q28], [Q29], [Q30]
			,[Q31], [Q32], [Q33], [Q34], [Q35], [Q36], [Q37], [Q38], [Q39], [Q40]
			,[Q41], [Q42], [Q43], [Q44], [Q45], [Q46], [Q47], [Q48], [Q49], [Q50]
			,[Q51], [Q52], [Q53], [Q54], [Q55], [Q56], [Q57], [Q58], [Q59], [Q60]
			,[Q61], [Q62], [Q63], [Q64], [Q65], [Q66], [Q67], [Q68], [Q69], [Q70]
			,[Q71], [Q72], [Q73], [Q74], [Q75], [Q76], [Q77], [Q78], [Q79], [Q80]
			,[Q81], [Q82], [Q83], [Q84], [Q85], [Q86], [Q87], [Q88], [Q89], [Q90]
			 ,[Q91], [Q92], [Q93], [Q94], [Q95], [Q96], [Q97], [Q98], [Q99]

	FROM	[dd].[factProgramGroupingComparisonPivot] db
			inner join SeerStaging.Survey.SurveyForms sf
				on db.Program = REPLACE(REPLACE(sf.SurveyType, 'YMCA ', ''), ' Satisfaction Survey', '')
			inner join #NewBranchNames on 
				PrvGroupingName = [Grouping]
				
	WHERE	Association = @SourceAssociationName
			and sf.ProductCategory LIKE '%Program Survey%'
		and GETDATE() between change_datetime and next_change_datetime

	COMMIT TRANSACTION;
	  
END TRY	  
BEGIN CATCH	
	print 'Data processing error occurred during Generate Demo Data for Program. All Program demo transactions rolled back.'
	ROLLBACK TRANSACTION;
END CATCH
  
DROP TABLE #NewBranchNames
END





