USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwMemExDashboardBase]    Script Date: 08/01/2013 15:36:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwMemExDashboardBase] where associationname = 'YMCA of Metropolitan Dallas'
CREATE VIEW [dd].[vwMemExDashboardBase]
AS 
with 
-- code modified by mklock to only take max given date per year - per JRoutman
bs as (
	select distinct	
		db.AssociationKey
		,max(bmsr.GivenDateKey) GivenDateKey 
		,cast(left(bmsr.GivenDateKey, 4) as int) yr			
	from 
		dbo.factBranchMemberSatisfactionReport bmsr	(nolock)
		inner join dbo.dimBranch db (nolock)
			on db.BranchKey = bmsr.BranchKey	
			--and db.AssociationNumber = '2165'
	group by db.AssociationKey, cast(left(bmsr.GivenDateKey, 4) as int)
					
)
,bsrn as (
	select *
		,ROW_NUMBER() over (partition by AssociationKey order by GivenDateKey desc) rn
	from bs 
)
,bsr as (
	select distinct
		bmsr.BranchKey
		,bsrn.GivenDateKey
		,rn
	from 
		dbo.factBranchMemberSatisfactionReport bmsr (nolock)
		inner join dbo.dimBranch db (nolock)
			on db.BranchKey = bmsr.BranchKey
		inner join bsrn 
			on bsrn.AssociationKey = db.AssociationKey and bmsr.GivenDateKey = bsrn.GivenDateKey
)
select distinct
	db.AssociationKey
	,db.BranchKey
	,db.AssociationName 
	,db.AssociationNumber + ' - ' + db.AssociationName as AssociationNameEx
	,db.OfficialBranchName
	,dd.GetShortBranchName(db.OfficialBranchName) as BranchNameShort
	,bsr.GivenDateKey
	,cast(left(bsr.GivenDateKey, 4) as int) as SurveyYear	
	,cast(left(bsrprv.GivenDateKey, 4) as int) as PrevYear	
	,bsrprv.GivenDateKey as PrevGivenDateKey
	,db.OfficialBranchNumber
	,db.AssociationNumber
from 	
	dbo.dimBranch db (nolock)
	inner join bsr
		on bsr.BranchKey = db.BranchKey and bsr.rn = 1 
	left join bsr as bsrprv
		on bsrprv.BranchKey = db.BranchKey and bsrprv.rn=2
	
	--filter by those having 2012 data for now	
	inner join (select distinct AssociationKey from dd.vwMemEx2012SurveyAssociations) a12
		on a12.AssociationKey = db.AssociationKey

GO


