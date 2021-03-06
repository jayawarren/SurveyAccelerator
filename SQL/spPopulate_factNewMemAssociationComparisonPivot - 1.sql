/*
truncate table dd.factNewMemAssociationComparisonPivot
drop proc spPopulate_factNewMemAssociationComparisonPivot
SELECT * FROM dd.factNewMemAssociationComparisonPivot
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemAssociationComparisonPivot] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	distinct
			A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.AssociationNumber,
			A.AssociationName,
			A.Association,
			A.OfficialBranchNumber,
			A.OfficialBranchName,
			A.Branch,
			A.Q010101,
			A.Q010201,
			A.Q010204,
			A.Q010205,
			A.Q010301,
			A.Q010302,
			A.Q010303,
			A.Q010401,
			A.Q020501,
			A.Q020502,
			A.Q020503,
			A.Q020504,
			A.Q020505,
			A.Q020506,
			A.Q020507,
			A.Q020508,
			A.Q020601,
			A.Q020602,
			A.Q020603,
			A.Q020604,
			A.Q020605,
			A.Q020902,
			A.Q020903,
			A.Q020904,
			A.Q020905,
			A.Q031101,
			A.Q031102
			
	INTO	#NMACP

	FROM	[dd].[vwNewMemAssociationComparisonPivot] A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
				
	WHERE	A.current_indicator = 1
			AND B.module = 'New Member'
			AND B.aggregate_type = 'Association'
			
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemAssociationComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Q010101,
					A.Q010201,
					A.Q010204,
					A.Q010205,
					A.Q010301,
					A.Q010302,
					A.Q010303,
					A.Q010401,
					A.Q020501,
					A.Q020502,
					A.Q020503,
					A.Q020504,
					A.Q020505,
					A.Q020506,
					A.Q020507,
					A.Q020508,
					A.Q020601,
					A.Q020602,
					A.Q020603,
					A.Q020604,
					A.Q020605,
					A.Q020902,
					A.Q020903,
					A.Q020904,
					A.Q020905,
					A.Q031101,
					A.Q031102
					
			FROM	#NMACP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[Association] <> source.[Association]
								OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								OR target.[Branch] <> source.[Branch]
								OR target.[Q010101] <> source.[Q010101]
								OR target.[Q010201] <> source.[Q010201]
								OR target.[Q010204] <> source.[Q010204]
								OR target.[Q010205] <> source.[Q010205]
								OR target.[Q010301] <> source.[Q010301]
								OR target.[Q010302] <> source.[Q010302]
								OR target.[Q010303] <> source.[Q010303]
								OR target.[Q010401] <> source.[Q010401]
								OR target.[Q020501] <> source.[Q020501]
								OR target.[Q020502] <> source.[Q020502]
								OR target.[Q020503] <> source.[Q020503]
								OR target.[Q020504] <> source.[Q020504]
								OR target.[Q020505] <> source.[Q020505]
								OR target.[Q020506] <> source.[Q020506]
								OR target.[Q020507] <> source.[Q020507]
								OR target.[Q020508] <> source.[Q020508]
								OR target.[Q020601] <> source.[Q020601]
								OR target.[Q020602] <> source.[Q020602]
								OR target.[Q020603] <> source.[Q020603]
								OR target.[Q020604] <> source.[Q020604]
								OR target.[Q020605] <> source.[Q020605]
								OR target.[Q020902] <> source.[Q020902]
								OR target.[Q020903] <> source.[Q020903]
								OR target.[Q020904] <> source.[Q020904]
								OR target.[Q020905] <> source.[Q020905]
								OR target.[Q031101] <> source.[Q031101]
								OR target.[Q031102] <> source.[Q031102]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Q010101],
					[Q010201],
					[Q010204],
					[Q010205],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010401],
					[Q020501],
					[Q020502],
					[Q020503],
					[Q020504],
					[Q020505],
					[Q020506],
					[Q020507],
					[Q020508],
					[Q020601],
					[Q020602],
					[Q020603],
					[Q020604],
					[Q020605],
					[Q020902],
					[Q020903],
					[Q020904],
					[Q020905],
					[Q031101],
					[Q031102]

					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Q010101],
					[Q010201],
					[Q010204],
					[Q010205],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010401],
					[Q020501],
					[Q020502],
					[Q020503],
					[Q020504],
					[Q020505],
					[Q020506],
					[Q020507],
					[Q020508],
					[Q020601],
					[Q020602],
					[Q020603],
					[Q020604],
					[Q020605],
					[Q020902],
					[Q020903],
					[Q020904],
					[Q020905],
					[Q031101],
					[Q031102]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemAssociationComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.Q010101,
					A.Q010201,
					A.Q010204,
					A.Q010205,
					A.Q010301,
					A.Q010302,
					A.Q010303,
					A.Q010401,
					A.Q020501,
					A.Q020502,
					A.Q020503,
					A.Q020504,
					A.Q020505,
					A.Q020506,
					A.Q020507,
					A.Q020508,
					A.Q020601,
					A.Q020602,
					A.Q020603,
					A.Q020604,
					A.Q020605,
					A.Q020902,
					A.Q020903,
					A.Q020904,
					A.Q020905,
					A.Q031101,
					A.Q031102
					
			FROM	#NMACP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Q010101],
					[Q010201],
					[Q010204],
					[Q010205],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010401],
					[Q020501],
					[Q020502],
					[Q020503],
					[Q020504],
					[Q020505],
					[Q020506],
					[Q020507],
					[Q020508],
					[Q020601],
					[Q020602],
					[Q020603],
					[Q020604],
					[Q020605],
					[Q020902],
					[Q020903],
					[Q020904],
					[Q020905],
					[Q031101],
					[Q031102]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[Q010101],
					[Q010201],
					[Q010204],
					[Q010205],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010401],
					[Q020501],
					[Q020502],
					[Q020503],
					[Q020504],
					[Q020505],
					[Q020506],
					[Q020507],
					[Q020508],
					[Q020601],
					[Q020602],
					[Q020603],
					[Q020604],
					[Q020605],
					[Q020902],
					[Q020903],
					[Q020904],
					[Q020905],
					[Q031101],
					[Q031102]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMACP;
	
COMMIT TRAN
	
END








