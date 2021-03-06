/*
truncate table dd.factEmpSatBranchComparisonPivot
drop proc spPopulate_factEmpSatBranchComparisonPivot
SELECT * FROM dd.factEmpSatBranchComparisonPivot
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatBranchComparisonPivot] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			A.current_indicator,
			A.Association,
			A.Branch,
			A.Q010101,
			A.Q010102,
			A.Q010103,
			A.Q010104,
			A.Q010105,
			A.Q010201,
			A.Q010202,
			A.Q010203,
			A.Q010204,
			A.Q010205,
			A.Q010206,
			A.Q010207,
			A.Q010208,
			A.Q010301,
			A.Q010302,
			A.Q010303,
			A.Q010304,
			A.Q010305,
			A.Q010306,
			A.Q010307,
			A.Q010308,
			A.Q010309,
			A.Q010401,
			A.Q010402,
			A.Q010403,
			A.Q010404,
			A.Q010405,
			A.Q010406,
			A.Q010407,
			A.Q010408,
			A.Q010409,
			A.Q020101,
			A.Q020201,
			A.Q020202,
			A.Q020203,
			A.Q020204,
			A.Q020205,
			A.Q020301,
			A.Q020401,
			A.Q030101,
			A.Q030102,
			A.Q030103,
			A.Q030104,
			A.Q030105,
			A.Q030106,
			A.Q030107,
			A.Q030108,
			A.Q030201,
			A.Q030202,
			A.Q030203,
			A.Q030204,
			A.Q030205,
			A.Q030206,
			A.Q030207,
			A.Q030208,
			A.Q030301,
			A.Q030302,
			A.Q030303,
			A.Q030304,
			A.Q030305,
			A.Q030306,
			A.Q030307,
			A.Q030308,
			A.Q030309
			
	INTO	#ESBCP

	FROM	[dd].[vwEmpSatBranchComparisonPivot] A
			
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatBranchComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.Q010101,
					A.Q010102,
					A.Q010103,
					A.Q010104,
					A.Q010105,
					A.Q010201,
					A.Q010202,
					A.Q010203,
					A.Q010204,
					A.Q010205,
					A.Q010206,
					A.Q010207,
					A.Q010208,
					A.Q010301,
					A.Q010302,
					A.Q010303,
					A.Q010304,
					A.Q010305,
					A.Q010306,
					A.Q010307,
					A.Q010308,
					A.Q010309,
					A.Q010401,
					A.Q010402,
					A.Q010403,
					A.Q010404,
					A.Q010405,
					A.Q010406,
					A.Q010407,
					A.Q010408,
					A.Q010409,
					A.Q020101,
					A.Q020201,
					A.Q020202,
					A.Q020203,
					A.Q020204,
					A.Q020205,
					A.Q020301,
					A.Q020401,
					A.Q030101,
					A.Q030102,
					A.Q030103,
					A.Q030104,
					A.Q030105,
					A.Q030106,
					A.Q030107,
					A.Q030108,
					A.Q030201,
					A.Q030202,
					A.Q030203,
					A.Q030204,
					A.Q030205,
					A.Q030206,
					A.Q030207,
					A.Q030208,
					A.Q030301,
					A.Q030302,
					A.Q030303,
					A.Q030304,
					A.Q030305,
					A.Q030306,
					A.Q030307,
					A.Q030308,
					A.Q030309
					
			FROM	#ESBCP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[Association] <> source.[Association]
								OR target.[Branch] <> source.[Branch]
								OR target.[Q010101] <> source.[Q010101]
								OR target.[Q010102] <> source.[Q010102]
								OR target.[Q010103] <> source.[Q010103]
								OR target.[Q010104] <> source.[Q010104]
								OR target.[Q010105] <> source.[Q010105]
								OR target.[Q010201] <> source.[Q010201]
								OR target.[Q010202] <> source.[Q010202]
								OR target.[Q010203] <> source.[Q010203]
								OR target.[Q010204] <> source.[Q010204]
								OR target.[Q010205] <> source.[Q010205]
								OR target.[Q010206] <> source.[Q010206]
								OR target.[Q010207] <> source.[Q010207]
								OR target.[Q010208] <> source.[Q010208]
								OR target.[Q010301] <> source.[Q010301]
								OR target.[Q010302] <> source.[Q010302]
								OR target.[Q010303] <> source.[Q010303]
								OR target.[Q010304] <> source.[Q010304]
								OR target.[Q010305] <> source.[Q010305]
								OR target.[Q010306] <> source.[Q010306]
								OR target.[Q010307] <> source.[Q010307]
								OR target.[Q010308] <> source.[Q010308]
								OR target.[Q010309] <> source.[Q010309]
								OR target.[Q010401] <> source.[Q010401]
								OR target.[Q010402] <> source.[Q010402]
								OR target.[Q010403] <> source.[Q010403]
								OR target.[Q010404] <> source.[Q010404]
								OR target.[Q010405] <> source.[Q010405]
								OR target.[Q010406] <> source.[Q010406]
								OR target.[Q010407] <> source.[Q010407]
								OR target.[Q010408] <> source.[Q010408]
								OR target.[Q010409] <> source.[Q010409]
								OR target.[Q020101] <> source.[Q020101]
								OR target.[Q020201] <> source.[Q020201]
								OR target.[Q020202] <> source.[Q020202]
								OR target.[Q020203] <> source.[Q020203]
								OR target.[Q020204] <> source.[Q020204]
								OR target.[Q020205] <> source.[Q020205]
								OR target.[Q020301] <> source.[Q020301]
								OR target.[Q020401] <> source.[Q020401]
								OR target.[Q030101] <> source.[Q030101]
								OR target.[Q030102] <> source.[Q030102]
								OR target.[Q030103] <> source.[Q030103]
								OR target.[Q030104] <> source.[Q030104]
								OR target.[Q030105] <> source.[Q030105]
								OR target.[Q030106] <> source.[Q030106]
								OR target.[Q030107] <> source.[Q030107]
								OR target.[Q030108] <> source.[Q030108]
								OR target.[Q030201] <> source.[Q030201]
								OR target.[Q030202] <> source.[Q030202]
								OR target.[Q030203] <> source.[Q030203]
								OR target.[Q030204] <> source.[Q030204]
								OR target.[Q030205] <> source.[Q030205]
								OR target.[Q030206] <> source.[Q030206]
								OR target.[Q030207] <> source.[Q030207]
								OR target.[Q030208] <> source.[Q030208]
								OR target.[Q030301] <> source.[Q030301]
								OR target.[Q030302] <> source.[Q030302]
								OR target.[Q030303] <> source.[Q030303]
								OR target.[Q030304] <> source.[Q030304]
								OR target.[Q030305] <> source.[Q030305]
								OR target.[Q030306] <> source.[Q030306]
								OR target.[Q030307] <> source.[Q030307]
								OR target.[Q030308] <> source.[Q030308]
								OR target.[Q030309] <> source.[Q030309]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Q010101],
					[Q010102],
					[Q010103],
					[Q010104],
					[Q010105],
					[Q010201],
					[Q010202],
					[Q010203],
					[Q010204],
					[Q010205],
					[Q010206],
					[Q010207],
					[Q010208],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010304],
					[Q010305],
					[Q010306],
					[Q010307],
					[Q010308],
					[Q010309],
					[Q010401],
					[Q010402],
					[Q010403],
					[Q010404],
					[Q010405],
					[Q010406],
					[Q010407],
					[Q010408],
					[Q010409],
					[Q020101],
					[Q020201],
					[Q020202],
					[Q020203],
					[Q020204],
					[Q020205],
					[Q020301],
					[Q020401],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030301],
					[Q030302],
					[Q030303],
					[Q030304],
					[Q030305],
					[Q030306],
					[Q030307],
					[Q030308],
					[Q030309]

					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Q010101],
					[Q010102],
					[Q010103],
					[Q010104],
					[Q010105],
					[Q010201],
					[Q010202],
					[Q010203],
					[Q010204],
					[Q010205],
					[Q010206],
					[Q010207],
					[Q010208],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010304],
					[Q010305],
					[Q010306],
					[Q010307],
					[Q010308],
					[Q010309],
					[Q010401],
					[Q010402],
					[Q010403],
					[Q010404],
					[Q010405],
					[Q010406],
					[Q010407],
					[Q010408],
					[Q010409],
					[Q020101],
					[Q020201],
					[Q020202],
					[Q020203],
					[Q020204],
					[Q020205],
					[Q020301],
					[Q020401],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030301],
					[Q030302],
					[Q030303],
					[Q030304],
					[Q030305],
					[Q030306],
					[Q030307],
					[Q030308],
					[Q030309]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factEmpSatBranchComparisonPivot AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.Q010101,
					A.Q010102,
					A.Q010103,
					A.Q010104,
					A.Q010105,
					A.Q010201,
					A.Q010202,
					A.Q010203,
					A.Q010204,
					A.Q010205,
					A.Q010206,
					A.Q010207,
					A.Q010208,
					A.Q010301,
					A.Q010302,
					A.Q010303,
					A.Q010304,
					A.Q010305,
					A.Q010306,
					A.Q010307,
					A.Q010308,
					A.Q010309,
					A.Q010401,
					A.Q010402,
					A.Q010403,
					A.Q010404,
					A.Q010405,
					A.Q010406,
					A.Q010407,
					A.Q010408,
					A.Q010409,
					A.Q020101,
					A.Q020201,
					A.Q020202,
					A.Q020203,
					A.Q020204,
					A.Q020205,
					A.Q020301,
					A.Q020401,
					A.Q030101,
					A.Q030102,
					A.Q030103,
					A.Q030104,
					A.Q030105,
					A.Q030106,
					A.Q030107,
					A.Q030108,
					A.Q030201,
					A.Q030202,
					A.Q030203,
					A.Q030204,
					A.Q030205,
					A.Q030206,
					A.Q030207,
					A.Q030208,
					A.Q030301,
					A.Q030302,
					A.Q030303,
					A.Q030304,
					A.Q030305,
					A.Q030306,
					A.Q030307,
					A.Q030308,
					A.Q030309
					
			FROM	#ESBCP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Q010101],
					[Q010102],
					[Q010103],
					[Q010104],
					[Q010105],
					[Q010201],
					[Q010202],
					[Q010203],
					[Q010204],
					[Q010205],
					[Q010206],
					[Q010207],
					[Q010208],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010304],
					[Q010305],
					[Q010306],
					[Q010307],
					[Q010308],
					[Q010309],
					[Q010401],
					[Q010402],
					[Q010403],
					[Q010404],
					[Q010405],
					[Q010406],
					[Q010407],
					[Q010408],
					[Q010409],
					[Q020101],
					[Q020201],
					[Q020202],
					[Q020203],
					[Q020204],
					[Q020205],
					[Q020301],
					[Q020401],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030301],
					[Q030302],
					[Q030303],
					[Q030304],
					[Q030305],
					[Q030306],
					[Q030307],
					[Q030308],
					[Q030309]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Q010101],
					[Q010102],
					[Q010103],
					[Q010104],
					[Q010105],
					[Q010201],
					[Q010202],
					[Q010203],
					[Q010204],
					[Q010205],
					[Q010206],
					[Q010207],
					[Q010208],
					[Q010301],
					[Q010302],
					[Q010303],
					[Q010304],
					[Q010305],
					[Q010306],
					[Q010307],
					[Q010308],
					[Q010309],
					[Q010401],
					[Q010402],
					[Q010403],
					[Q010404],
					[Q010405],
					[Q010406],
					[Q010407],
					[Q010408],
					[Q010409],
					[Q020101],
					[Q020201],
					[Q020202],
					[Q020203],
					[Q020204],
					[Q020205],
					[Q020301],
					[Q020401],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030301],
					[Q030302],
					[Q030303],
					[Q030304],
					[Q030305],
					[Q030306],
					[Q030307],
					[Q030308],
					[Q030309]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #ESBCP;
	
COMMIT TRAN
	
END








