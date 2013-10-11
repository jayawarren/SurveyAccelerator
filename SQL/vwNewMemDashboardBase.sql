USE [SeerDWH]
GO

/****** Object:  View [dd].[vwNewMemDashboardBase]    Script Date: 08/12/2013 18:09:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM [dd].[vwNewMemDashboardBase] where associationname = 'YMCA of Greater Seattle'
CREATE VIEW [dd].[vwNewMemDashboardBase]
AS 
WITH
core AS (
SELECT	distinct	
		bmsr.BranchKey,
		bmsr.GivenDateKey,
		cast(CASE WHEN left(right(bmsr.GivenDateKey,4),2) IN ('01','02') THEN Left(bmsr.GivenDateKey,4)+'0201' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('03','04') THEN Left(bmsr.GivenDateKey,4)+'0401' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('05','06') THEN Left(bmsr.GivenDateKey,4)+'0601' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('07','08') THEN Left(bmsr.GivenDateKey,4)+'0801' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('09','10') THEN Left(bmsr.GivenDateKey,4)+'1001' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('11','12') THEN Left(bmsr.GivenDateKey,4)+'1201' 
			END AS int) AS GivenDateKeyGrp

FROM	dbo.factBranchNewMemberExperienceReport bmsr (nolock)
		INNER JOIN dbo.dimBranch db (nolock)
			ON db.BranchKey = bmsr.BranchKey
)
,core1 AS (
SELECT	distinct	
		bmsr.AssociationKey,
		bmsr.GivenDateKey,
		cast(CASE WHEN left(right(bmsr.GivenDateKey,4),2) IN ('01','02') THEN Left(bmsr.GivenDateKey,4)+'0201' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('03','04') THEN Left(bmsr.GivenDateKey,4)+'0401' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('05','06') THEN Left(bmsr.GivenDateKey,4)+'0601' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('07','08') THEN Left(bmsr.GivenDateKey,4)+'0801' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('09','10') THEN Left(bmsr.GivenDateKey,4)+'1001' 
					WHEN left(right(bmsr.GivenDateKey,4),2) IN ('11','12') THEN Left(bmsr.GivenDateKey,4)+'1201' 
		END AS int) AS GivenDateKeyGrp


FROM	dbo.factAssociationNewMemberExperienceReport bmsr (nolock)
		INNER JOIN dbo.dimAssociation db (nolock)
			ON db.AssociationKey = bmsr.AssociationKey
)
,bs AS (
SELECT	AssociationKey,
		GivenDateKeyGrp,
		--,COUNT(distinct GivenDateKey) + 
		count(distinct CASE WHEN DATEADD(dd, -DAY(DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112))), DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112)))-5 < GETDATE() THEN GivenDateKey
						END) AS GrpInd

FROM	core1 

GROUP BY AssociationKey,
		GivenDateKeyGrp
		
HAVING count(distinct CASE WHEN DATEADD(dd, -DAY(DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112))), DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112)))-5 < GETDATE() THEN GivenDateKey END) > 0
		
)
,bs1 AS (
SELECT	BranchKey
		GivenDateKeyGrp,
		--,COUNT(distinct GivenDateKey) + 
		count(distinct CASE WHEN DATEADD(dd, -DAY(DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112))), DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112)))-5 < GETDATE() THEN GivenDateKey END) AS GrpInd		

FROM	core

GROUP BY BranchKey,
		GivenDateKeyGrp
HAVING count(distinct CASE WHEN DATEADD(dd, -DAY(DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112))), DATEADD(m,1,convert(datetime,CAST(GivenDateKeyGrp AS varchar(8)),112)))-5 < GETDATE() THEN GivenDateKey END) > 0
)
,bsrn AS (
SELECT	*,
		ROW_NUMBER() over (partition by AssociationKey order by GivenDateKeyGrp desc) rn

FROM	bs 
)
,bsrn1 AS (
SELECT	*,
		ROW_NUMBER() over (partition by BranchKey order by GivenDateKeyGrp desc) rn

FROM bs1 
)
,bsr AS (
SELECT	bmsr.BranchKey,
		bsrn1.GivenDateKeyGrp,
		max(core.GivenDateKey) AS SurveyDate,
		rn

FROM	dbo.factBranchNewMemberExperienceReport bmsr (nolock)
		INNER JOIN dbo.dimBranch db (nolock)
			on db.BranchKey = bmsr.BranchKey
		INNER JOIN bsrn1 
			on bsrn1.BranchKey = db.BranchKey
				and cast(CASE WHEN left(right(bmsr.GivenDateKey,4),2) IN ('01','02') THEN Left(bmsr.GivenDateKey,4)+'0201' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('03','04') THEN Left(bmsr.GivenDateKey,4)+'0401' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('05','06') THEN Left(bmsr.GivenDateKey,4)+'0601' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('07','08') THEN Left(bmsr.GivenDateKey,4)+'0801' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('09','10') THEN Left(bmsr.GivenDateKey,4)+'1001' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('11','12') THEN Left(bmsr.GivenDateKey,4)+'1201' 
						END AS int) = bsrn1.GivenDateKeyGrp
		INNER JOIN core
			on core.BranchKey = bmsr.BranchKey
				and core.GivenDateKey = bmsr.GivenDateKey

GROUP BY bmsr.BranchKey,
		bsrn1.GivenDateKeyGrp,
		rn
)
,bsr1 AS (
SELECT	bmsr.AssociationKey,
		bsrn.GivenDateKeyGrp,
		max(core1.GivenDateKey) AS SurveyDate,
		rn

FROM	dbo.factAssociationNewMemberExperienceReport bmsr (nolock)
		INNER JOIN dbo.dimAssociation db (nolock)
			on db.AssociationKey = bmsr.AssociationKey
		INNER JOIN bsrn 
			on bsrn.AssociationKey = db.AssociationKey
				and cast(CASE WHEN left(right(bmsr.GivenDateKey,4),2) IN ('01','02') THEN Left(bmsr.GivenDateKey,4)+'0201' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('03','04') THEN Left(bmsr.GivenDateKey,4)+'0401' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('05','06') THEN Left(bmsr.GivenDateKey,4)+'0601' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('07','08') THEN Left(bmsr.GivenDateKey,4)+'0801' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('09','10') THEN Left(bmsr.GivenDateKey,4)+'1001' 
							WHEN left(right(bmsr.GivenDateKey,4),2) IN ('11','12') THEN Left(bmsr.GivenDateKey,4)+'1201' 
						END AS int) = bsrn.GivenDateKeyGrp
		INNER JOIN core1
			on core1.AssociationKey = bmsr.AssociationKey
				and core1.GivenDateKey = bmsr.GivenDateKey

GROUP BY bmsr.AssociationKey,
		bsrn.GivenDateKeyGrp,
		rn
)
SELECT	distinct
		db.AssociationKey,
		db.BranchKey,
		db.AssociationName, 
		db.AssociationNumber + ' - ' + db.AssociationName AS AssociationNameEx,
		db.OfficialBranchName,
		dd.GetShortBranchName(db.OfficialBranchName) AS BranchNameShort,
		COALESCE(bsr.GivenDateKeyGrp, bsrprv.GivenDateKeyGrp) AS GivenDateKey,
		COALESCE(cast(left(bsr.GivenDateKeyGrp, 4) AS int), cast(left(bsrprv.GivenDateKeyGrp, 4) AS int)) AS SurveyYear,	
		CASE WHEN bsr.GivenDateKeyGrp IS NULL THEN NULL
			ELSE cast(left(bsrprv.GivenDateKeyGrp, 4) AS int)
		END AS PrevYear,	
		CASE WHEN bsr.GivenDateKeyGrp IS NULL THEN NULL
			ELSE bsrprv.GivenDateKeyGrp
		END AS PrevGivenDateKey,
		db.OfficialBranchNumber,
		db.AssociationNumber,
		bsr.SurveyDate AS SurveyDate,
		1 AS GrpInd,
		COALESCE(bsr1.GivenDateKeyGrp, bsrprv1.GivenDateKeyGrp) AS AssocGivenDateKey,
		COALESCE(cast(left(bsr1.GivenDateKeyGrp, 4) AS int), cast(left(bsrprv1.GivenDateKeyGrp, 4) AS int)) AS AssocSurveyYear,	
		CASE WHEN bsr1.GivenDateKeyGrp IS NULL THEN NULL
			ELSE cast(left(bsrprv1.GivenDateKeyGrp , 4) AS int)
		END AS AssocPrevYear,	
		CASE WHEN bsr.GivenDateKeyGrp IS NULL THEN NULL
			ELSE bsrprv1.GivenDateKeyGrp
		END AS AssocPrevGivenDateKey,
		bsr1.SurveyDate AS AssocSurveyDate,
		1 AS AssocGrpInd

FROM 	dbo.dimBranch db (nolock)
		INNER JOIN bsr
			on bsr.BranchKey = db.BranchKey
				and bsr.rn = 1 
		LEFT JOIN bsr AS bsrprv
			on bsrprv.BranchKey = db.BranchKey
				and bsrprv.rn=2
		--filter by those having 2012 data for now	
		INNER JOIN (SELECT AssociationKey FROM dd.vwNewMem2012SurveyAssociations) a12
			on a12.AssociationKey = db.AssociationKey
		LEFT JOIN bsr1
			on bsr1.AssociationKey = db.AssociationKey
				and bsr1.rn = 1
		LEFT JOIN bsr1 bsrprv1
			on bsrprv1.AssociationKey = db.AssociationKey
				and bsrprv1.rn = 2
GO


