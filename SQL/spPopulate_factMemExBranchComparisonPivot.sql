/*
truncate table dd.factMemExBranchComparisonPivot
drop proc spPopulate_factMemExBranchComparisonPivot
SELECT * FROM dd.factMemExBranchComparisonPivot
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchComparisonPivot] AS
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
			A.Q010202,
			A.Q010303,
			A.Q010404,
			A.Q010505,
			A.Q010606,
			A.Q020101,
			A.Q020202,
			A.Q020303,
			A.Q020404,
			A.Q020505,
			A.Q020606,
			A.Q020707,
			A.Q020808,
			A.Q030101,
			A.Q030102,
			A.Q030103,
			A.Q030104,
			A.Q030105,
			A.Q030106,
			A.Q030107,
			A.Q030108,
			A.Q030109,
			A.Q030201,
			A.Q030202,
			A.Q030203,
			A.Q030204,
			A.Q030205,
			A.Q030206,
			A.Q030207,
			A.Q030208,
			A.Q030209,
			A.Q030301,
			A.Q030302,
			A.Q030303,
			A.Q030304,
			A.Q030305,
			A.Q030306,
			A.Q030307,
			A.Q030308,
			A.Q030309
			
	INTO	#MEBCP

	FROM	[dd].[vwMemExBranchComparisonPivot] A
			
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.Q010101,
					A.Q010202,
					A.Q010303,
					A.Q010404,
					A.Q010505,
					A.Q010606,
					A.Q020101,
					A.Q020202,
					A.Q020303,
					A.Q020404,
					A.Q020505,
					A.Q020606,
					A.Q020707,
					A.Q020808,
					A.Q030101,
					A.Q030102,
					A.Q030103,
					A.Q030104,
					A.Q030105,
					A.Q030106,
					A.Q030107,
					A.Q030108,
					A.Q030109,
					A.Q030201,
					A.Q030202,
					A.Q030203,
					A.Q030204,
					A.Q030205,
					A.Q030206,
					A.Q030207,
					A.Q030208,
					A.Q030209,
					A.Q030301,
					A.Q030302,
					A.Q030303,
					A.Q030304,
					A.Q030305,
					A.Q030306,
					A.Q030307,
					A.Q030308,
					A.Q030309
					
			FROM	#MEBCP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[Association] <> source.[Association]
								OR target.[Branch] <> source.[Branch]
								OR target.[Q010101] <> source.[Q010101]
								OR target.[Q010202] <> source.[Q010202]
								OR target.[Q010303] <> source.[Q010303]
								OR target.[Q010404] <> source.[Q010404]
								OR target.[Q010505] <> source.[Q010505]
								OR target.[Q010606] <> source.[Q010606]
								OR target.[Q020101] <> source.[Q020101]
								OR target.[Q020202] <> source.[Q020202]
								OR target.[Q020303] <> source.[Q020303]
								OR target.[Q020404] <> source.[Q020404]
								OR target.[Q020505] <> source.[Q020505]
								OR target.[Q020606] <> source.[Q020606]
								OR target.[Q020707] <> source.[Q020707]
								OR target.[Q020808] <> source.[Q020808]
								OR target.[Q030101] <> source.[Q030101]
								OR target.[Q030102] <> source.[Q030102]
								OR target.[Q030103] <> source.[Q030103]
								OR target.[Q030104] <> source.[Q030104]
								OR target.[Q030105] <> source.[Q030105]
								OR target.[Q030106] <> source.[Q030106]
								OR target.[Q030107] <> source.[Q030107]
								OR target.[Q030108] <> source.[Q030108]
								OR target.[Q030109] <> source.[Q030109]
								OR target.[Q030201] <> source.[Q030201]
								OR target.[Q030202] <> source.[Q030202]
								OR target.[Q030203] <> source.[Q030203]
								OR target.[Q030204] <> source.[Q030204]
								OR target.[Q030205] <> source.[Q030205]
								OR target.[Q030206] <> source.[Q030206]
								OR target.[Q030207] <> source.[Q030207]
								OR target.[Q030208] <> source.[Q030208]
								OR target.[Q030209] <> source.[Q030209]
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
					[Q010202],
					[Q010303],
					[Q010404],
					[Q010505],
					[Q010606],
					[Q020101],
					[Q020202],
					[Q020303],
					[Q020404],
					[Q020505],
					[Q020606],
					[Q020707],
					[Q020808],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030109],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030209],
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
					[Q010202],
					[Q010303],
					[Q010404],
					[Q010505],
					[Q010606],
					[Q020101],
					[Q020202],
					[Q020303],
					[Q020404],
					[Q020505],
					[Q020606],
					[Q020707],
					[Q020808],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030109],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030209],
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
	MERGE	Seer_ODS.dd.factMemExBranchComparisonPivot AS target
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
					A.Q010202,
					A.Q010303,
					A.Q010404,
					A.Q010505,
					A.Q010606,
					A.Q020101,
					A.Q020202,
					A.Q020303,
					A.Q020404,
					A.Q020505,
					A.Q020606,
					A.Q020707,
					A.Q020808,
					A.Q030101,
					A.Q030102,
					A.Q030103,
					A.Q030104,
					A.Q030105,
					A.Q030106,
					A.Q030107,
					A.Q030108,
					A.Q030109,
					A.Q030201,
					A.Q030202,
					A.Q030203,
					A.Q030204,
					A.Q030205,
					A.Q030206,
					A.Q030207,
					A.Q030208,
					A.Q030209,
					A.Q030301,
					A.Q030302,
					A.Q030303,
					A.Q030304,
					A.Q030305,
					A.Q030306,
					A.Q030307,
					A.Q030308,
					A.Q030309
					
			FROM	#MEBCP A

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
					[Q010202],
					[Q010303],
					[Q010404],
					[Q010505],
					[Q010606],
					[Q020101],
					[Q020202],
					[Q020303],
					[Q020404],
					[Q020505],
					[Q020606],
					[Q020707],
					[Q020808],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030109],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030209],
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
					[Q010202],
					[Q010303],
					[Q010404],
					[Q010505],
					[Q010606],
					[Q020101],
					[Q020202],
					[Q020303],
					[Q020404],
					[Q020505],
					[Q020606],
					[Q020707],
					[Q020808],
					[Q030101],
					[Q030102],
					[Q030103],
					[Q030104],
					[Q030105],
					[Q030106],
					[Q030107],
					[Q030108],
					[Q030109],
					[Q030201],
					[Q030202],
					[Q030203],
					[Q030204],
					[Q030205],
					[Q030206],
					[Q030207],
					[Q030208],
					[Q030209],
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

	DROP TABLE #MEBCP;
	
COMMIT TRAN
	
END








