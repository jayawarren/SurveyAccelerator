USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwEmpSatDashboardBase]    Script Date: 08/05/2013 08:06:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from [dd].[vwEmpSatDashboardBase] where associationname = 'YMCA of Greater Seattle'
CREATE VIEW [dd].[vwEmpSatDashboardBase]
AS 
with 
-- code modified by mklock to only take max given date per year - per JRoutman
bs as (
	select distinct	
		db.AssociationKey
		,max(bmsr.GivenDateKey) GivenDateKey 
		,cast(left(bmsr.GivenDateKey, 4) as int) yr		
	from 
		dbo.factBranchStaffExperienceReport bmsr (nolock)
		inner join dbo.dimBranch db (nolock)
			on db.BranchKey = bmsr.BranchKey
			group by db.AssociationKey, cast(left(bmsr.GivenDateKey, 4) as int)
/*			
	--filter by those having 2012 data for now	
	inner join (select AssociationKey, GivenDateKey from dd.vwEmpSat2012SurveyAssociations) a12
		on a12.AssociationKey = db.AssociationKey and a12.GivenDateKey = bmsr.GivenDateKey
*/			
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
		dbo.factBranchStaffExperienceReport bmsr (nolock)
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
	,COALESCE(bsr.GivenDateKey, bsrprv.GivenDateKey) as GivenDateKey
	,COALESCE(cast(left(bsr.GivenDateKey, 4) as int), cast(left(bsrprv.GivenDateKey, 4) as int)) as SurveyYear	
	,CASE WHEN bsr.GivenDateKey IS NULL THEN NULL
		ELSE cast(left(bsrprv.GivenDateKey, 4) as int)
	END as PrevYear	
	,CASE WHEN bsr.GivenDateKey IS NULL THEN NULL
		ELSE bsrprv.GivenDateKey
	END as PrevGivenDateKey
	,db.OfficialBranchNumber
	,db.AssociationNumber
from 	
	dbo.dimBranch db (nolock)
	inner join bsr
		on bsr.BranchKey = db.BranchKey and bsr.rn = 1 
	left join bsr as bsrprv
		on bsrprv.BranchKey = db.BranchKey and bsrprv.rn=2
	--filter by those having 2012 data for now	
	inner join (select AssociationKey from dd.vwEmpSat2012SurveyAssociations) a12
		on a12.AssociationKey = db.AssociationKey










GO


