USE [Seer_ODS]
GO

/****** Object:  View [dd].[vwAssociations]    Script Date: 09/02/2013 15:28:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--SELECT distinct AssociationNameEx FROM dd.vwAssociations
CREATE VIEW [dd].[vwAssociations]
AS 
SELECT	distinct
		'MemEx' as Module,
		db.AssociationNameEx,
		db.AssociationName,
		COUNT(*) as NoBranches,
		MAX(SurveyYear) as SurveyYear,
		MAX(PrevYear) as PrevYear

FROM	[dd].[factMemExDashboardBase] db

GROUP BY AssociationNameEx,
		AssociationName  

UNION

SELECT	distinct
		'Staff' as Module,
		db.AssociationNameEx,
		db.AssociationName,
		COUNT(*) as NoBranches,
		MAX(SurveyYear) as SurveyYear,
		MAX(PrevYear) as PrevYear

FROM	[dd].[factEmpSatDashboardBase] db

GROUP BY AssociationNameEx,
		AssociationName  

UNION

SELECT	distinct
		'NewMem' as Module,
		db.AssociationNameEx,
		db.AssociationName,
		COUNT(*) as NoBranches,
		MAX(SurveyYear) as SurveyYear,
		MAX(PrevYear) as PrevYear

FROM	[dd].[factNewMemDashboardBase] db

GROUP BY AssociationNameEx,
		AssociationName  

UNION

SELECT	a.Module,
		a.AssociationNameEx,
		a.AssociationName,
		MAX(a.NoBranches) NoBranches,
		MAX(a.SurveyYear) SurveyYear,
		MAX(a.PrevYear) PrevYear

FROM	(
		SELECT	'Programs' as Module,
				Program,
				db.AssociationNameEx,
				db.AssociationName,
				COUNT(*) as NoBranches,
				MAX(SurveyYear) as SurveyYear,
				MAX(PrevYear) as PrevYear
				
		FROM 	[dd].[factProgramDashboardBase] db
		
		GROUP BY Program,
				AssociationNameEx,
				AssociationName 
		) a 
GROUP BY a.Module,
		a.AssociationNameEx,
		a.AssociationName
GO


