/*
truncate table dd.factProgramGroupingComparisonPivot
drop proc spPopulate_factProgramGroupingComparisonPivot
SELECT * FROM dd.factProgramGroupingComparisonPivot where Grouping = 'Bay View'
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramGroupingComparisonPivot] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.ProgramGroupKey,
			A.batch_key,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.Association,
			A.Program,
			A.Grouping,
			A.Q01,
			A.Q02,
			A.Q03,
			A.Q04,
			A.Q05,
			A.Q06,
			A.Q07,
			A.Q08,
			A.Q09,
			A.Q10,
			A.Q11,
			A.Q12,
			A.Q13,
			A.Q14,
			A.Q15,
			A.Q16,
			A.Q17,
			A.Q18,
			A.Q19,
			A.Q20,
			A.Q21,
			A.Q22,
			A.Q23,
			A.Q24,
			A.Q25,
			A.Q26,
			A.Q27,
			A.Q28,
			A.Q29,
			A.Q30,
			A.Q31,
			A.Q32,
			A.Q33,
			A.Q34,
			A.Q35,
			A.Q36,
			A.Q37,
			A.Q38,
			A.Q39,
			A.Q40,
			A.Q41,
			A.Q42,
			A.Q43,
			A.Q44,
			A.Q45,
			A.Q46,
			A.Q47,
			A.Q48,
			A.Q49,
			A.Q50,
			A.Q51,
			A.Q52,
			A.Q53,
			A.Q54,
			A.Q55,
			A.Q56,
			A.Q57,
			A.Q58,
			A.Q59,
			A.Q60,
			A.Q61,
			A.Q62,
			A.Q63,
			A.Q64,
			A.Q65,
			A.Q66,
			A.Q67,
			A.Q68,
			A.Q69,
			A.Q70,
			A.Q71,
			A.Q72,
			A.Q73,
			A.Q74,
			A.Q75,
			A.Q76,
			A.Q77,
			A.Q78,
			A.Q79,
			A.Q80,
			A.Q81,
			A.Q82,
			A.Q83,
			A.Q84,
			A.Q85,
			A.Q86,
			A.Q87,
			A.Q88,
			A.Q89,
			A.Q90,
			A.Q91,
			A.Q92,
			A.Q93,
			A.Q94,
			A.Q95,
			A.Q96,
			A.Q97,
			A.Q98,
			A.Q99
			
	INTO	#PGCP

	FROM	[dd].[vwProgramGroupingComparisonPivot] A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
			
	WHERE	B.module = 'Program'
			AND B.aggregate_type = 'Association'
			AND A.Q01 IS NOT NULL;
			
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramGroupingComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Program,
					A.Grouping,
					A.Q01,
					A.Q02,
					A.Q03,
					A.Q04,
					A.Q05,
					A.Q06,
					A.Q07,
					A.Q08,
					A.Q09,
					A.Q10,
					A.Q11,
					A.Q12,
					A.Q13,
					A.Q14,
					A.Q15,
					A.Q16,
					A.Q17,
					A.Q18,
					A.Q19,
					A.Q20,
					A.Q21,
					A.Q22,
					A.Q23,
					A.Q24,
					A.Q25,
					A.Q26,
					A.Q27,
					A.Q28,
					A.Q29,
					A.Q30,
					A.Q31,
					A.Q32,
					A.Q33,
					A.Q34,
					A.Q35,
					A.Q36,
					A.Q37,
					A.Q38,
					A.Q39,
					A.Q40,
					A.Q41,
					A.Q42,
					A.Q43,
					A.Q44,
					A.Q45,
					A.Q46,
					A.Q47,
					A.Q48,
					A.Q49,
					A.Q50,
					A.Q51,
					A.Q52,
					A.Q53,
					A.Q54,
					A.Q55,
					A.Q56,
					A.Q57,
					A.Q58,
					A.Q59,
					A.Q60,
					A.Q61,
					A.Q62,
					A.Q63,
					A.Q64,
					A.Q65,
					A.Q66,
					A.Q67,
					A.Q68,
					A.Q69,
					A.Q70,
					A.Q71,
					A.Q72,
					A.Q73,
					A.Q74,
					A.Q75,
					A.Q76,
					A.Q77,
					A.Q78,
					A.Q79,
					A.Q80,
					A.Q81,
					A.Q82,
					A.Q83,
					A.Q84,
					A.Q85,
					A.Q86,
					A.Q87,
					A.Q88,
					A.Q89,
					A.Q90,
					A.Q91,
					A.Q92,
					A.Q93,
					A.Q94,
					A.Q95,
					A.Q96,
					A.Q97,
					A.Q98,
					A.Q99
					
			FROM	#PGCP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[Association] <> source.[Association]
								OR target.[Program] <> source.[Program]
								OR target.[Q01] <> source.[Q01]
								OR target.[Q02] <> source.[Q02]
								OR target.[Q03] <> source.[Q03]
								OR target.[Q04] <> source.[Q04]
								OR target.[Q05] <> source.[Q05]
								OR target.[Q06] <> source.[Q06]
								OR target.[Q07] <> source.[Q07]
								OR target.[Q08] <> source.[Q08]
								OR target.[Q09] <> source.[Q09]
								OR target.[Q10] <> source.[Q10]
								OR target.[Q11] <> source.[Q11]
								OR target.[Q12] <> source.[Q12]
								OR target.[Q13] <> source.[Q13]
								OR target.[Q14] <> source.[Q14]
								OR target.[Q15] <> source.[Q15]
								OR target.[Q16] <> source.[Q16]
								OR target.[Q17] <> source.[Q17]
								OR target.[Q18] <> source.[Q18]
								OR target.[Q19] <> source.[Q19]
								OR target.[Q20] <> source.[Q20]
								OR target.[Q21] <> source.[Q21]
								OR target.[Q22] <> source.[Q22]
								OR target.[Q23] <> source.[Q23]
								OR target.[Q24] <> source.[Q24]
								OR target.[Q25] <> source.[Q25]
								OR target.[Q26] <> source.[Q26]
								OR target.[Q27] <> source.[Q27]
								OR target.[Q28] <> source.[Q28]
								OR target.[Q29] <> source.[Q29]
								OR target.[Q30] <> source.[Q30]
								OR target.[Q31] <> source.[Q31]
								OR target.[Q32] <> source.[Q32]
								OR target.[Q33] <> source.[Q33]
								OR target.[Q34] <> source.[Q34]
								OR target.[Q35] <> source.[Q35]
								OR target.[Q36] <> source.[Q36]
								OR target.[Q37] <> source.[Q37]
								OR target.[Q38] <> source.[Q38]
								OR target.[Q39] <> source.[Q39]
								OR target.[Q40] <> source.[Q40]
								OR target.[Q41] <> source.[Q41]
								OR target.[Q42] <> source.[Q42]
								OR target.[Q43] <> source.[Q43]
								OR target.[Q44] <> source.[Q44]
								OR target.[Q45] <> source.[Q45]
								OR target.[Q46] <> source.[Q46]
								OR target.[Q47] <> source.[Q47]
								OR target.[Q48] <> source.[Q48]
								OR target.[Q49] <> source.[Q49]
								OR target.[Q50] <> source.[Q50]
								OR target.[Q51] <> source.[Q51]
								OR target.[Q52] <> source.[Q52]
								OR target.[Q53] <> source.[Q53]
								OR target.[Q54] <> source.[Q54]
								OR target.[Q55] <> source.[Q55]
								OR target.[Q56] <> source.[Q56]
								OR target.[Q57] <> source.[Q57]
								OR target.[Q58] <> source.[Q58]
								OR target.[Q59] <> source.[Q59]
								OR target.[Q60] <> source.[Q60]
								OR target.[Q61] <> source.[Q61]
								OR target.[Q62] <> source.[Q62]
								OR target.[Q63] <> source.[Q63]
								OR target.[Q64] <> source.[Q64]
								OR target.[Q65] <> source.[Q65]
								OR target.[Q66] <> source.[Q66]
								OR target.[Q67] <> source.[Q67]
								OR target.[Q68] <> source.[Q68]
								OR target.[Q69] <> source.[Q69]
								OR target.[Q70] <> source.[Q70]
								OR target.[Q71] <> source.[Q71]
								OR target.[Q72] <> source.[Q72]
								OR target.[Q73] <> source.[Q73]
								OR target.[Q74] <> source.[Q74]
								OR target.[Q75] <> source.[Q75]
								OR target.[Q76] <> source.[Q76]
								OR target.[Q77] <> source.[Q77]
								OR target.[Q78] <> source.[Q78]
								OR target.[Q79] <> source.[Q79]
								OR target.[Q80] <> source.[Q80]
								OR target.[Q81] <> source.[Q81]
								OR target.[Q82] <> source.[Q82]
								OR target.[Q83] <> source.[Q83]
								OR target.[Q84] <> source.[Q84]
								OR target.[Q85] <> source.[Q85]
								OR target.[Q86] <> source.[Q86]
								OR target.[Q87] <> source.[Q87]
								OR target.[Q88] <> source.[Q88]
								OR target.[Q89] <> source.[Q89]
								OR target.[Q90] <> source.[Q90]
								OR target.[Q91] <> source.[Q91]
								OR target.[Q92] <> source.[Q92]
								OR target.[Q93] <> source.[Q93]
								OR target.[Q94] <> source.[Q94]
								OR target.[Q95] <> source.[Q95]
								OR target.[Q96] <> source.[Q96]
								OR target.[Q97] <> source.[Q97]
								OR target.[Q98] <> source.[Q98]
								OR target.[Q99] <> source.[Q99]
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
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Q01],
					[Q02],
					[Q03],
					[Q04],
					[Q05],
					[Q06],
					[Q07],
					[Q08],
					[Q09],
					[Q10],
					[Q11],
					[Q12],
					[Q13],
					[Q14],
					[Q15],
					[Q16],
					[Q17],
					[Q18],
					[Q19],
					[Q20],
					[Q21],
					[Q22],
					[Q23],
					[Q24],
					[Q25],
					[Q26],
					[Q27],
					[Q28],
					[Q29],
					[Q30],
					[Q31],
					[Q32],
					[Q33],
					[Q34],
					[Q35],
					[Q36],
					[Q37],
					[Q38],
					[Q39],
					[Q40],
					[Q41],
					[Q42],
					[Q43],
					[Q44],
					[Q45],
					[Q46],
					[Q47],
					[Q48],
					[Q49],
					[Q50],
					[Q51],
					[Q52],
					[Q53],
					[Q54],
					[Q55],
					[Q56],
					[Q57],
					[Q58],
					[Q59],
					[Q60],
					[Q61],
					[Q62],
					[Q63],
					[Q64],
					[Q65],
					[Q66],
					[Q67],
					[Q68],
					[Q69],
					[Q70],
					[Q71],
					[Q72],
					[Q73],
					[Q74],
					[Q75],
					[Q76],
					[Q77],
					[Q78],
					[Q79],
					[Q80],
					[Q81],
					[Q82],
					[Q83],
					[Q84],
					[Q85],
					[Q86],
					[Q87],
					[Q88],
					[Q89],
					[Q90],
					[Q91],
					[Q92],
					[Q93],
					[Q94],
					[Q95],
					[Q96],
					[Q97],
					[Q98],
					[Q99]

					)
			VALUES ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Q01],
					[Q02],
					[Q03],
					[Q04],
					[Q05],
					[Q06],
					[Q07],
					[Q08],
					[Q09],
					[Q10],
					[Q11],
					[Q12],
					[Q13],
					[Q14],
					[Q15],
					[Q16],
					[Q17],
					[Q18],
					[Q19],
					[Q20],
					[Q21],
					[Q22],
					[Q23],
					[Q24],
					[Q25],
					[Q26],
					[Q27],
					[Q28],
					[Q29],
					[Q30],
					[Q31],
					[Q32],
					[Q33],
					[Q34],
					[Q35],
					[Q36],
					[Q37],
					[Q38],
					[Q39],
					[Q40],
					[Q41],
					[Q42],
					[Q43],
					[Q44],
					[Q45],
					[Q46],
					[Q47],
					[Q48],
					[Q49],
					[Q50],
					[Q51],
					[Q52],
					[Q53],
					[Q54],
					[Q55],
					[Q56],
					[Q57],
					[Q58],
					[Q59],
					[Q60],
					[Q61],
					[Q62],
					[Q63],
					[Q64],
					[Q65],
					[Q66],
					[Q67],
					[Q68],
					[Q69],
					[Q70],
					[Q71],
					[Q72],
					[Q73],
					[Q74],
					[Q75],
					[Q76],
					[Q77],
					[Q78],
					[Q79],
					[Q80],
					[Q81],
					[Q82],
					[Q83],
					[Q84],
					[Q85],
					[Q86],
					[Q87],
					[Q88],
					[Q89],
					[Q90],
					[Q91],
					[Q92],
					[Q93],
					[Q94],
					[Q95],
					[Q96],
					[Q97],
					[Q98],
					[Q99]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramGroupingComparisonPivot AS target
	USING	(
			SELECT	A.AssociationKey,
					A.ProgramGroupKey,
					A.batch_key,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.Association,
					A.Program,
					A.Grouping,
					A.Q01,
					A.Q02,
					A.Q03,
					A.Q04,
					A.Q05,
					A.Q06,
					A.Q07,
					A.Q08,
					A.Q09,
					A.Q10,
					A.Q11,
					A.Q12,
					A.Q13,
					A.Q14,
					A.Q15,
					A.Q16,
					A.Q17,
					A.Q18,
					A.Q19,
					A.Q20,
					A.Q21,
					A.Q22,
					A.Q23,
					A.Q24,
					A.Q25,
					A.Q26,
					A.Q27,
					A.Q28,
					A.Q29,
					A.Q30,
					A.Q31,
					A.Q32,
					A.Q33,
					A.Q34,
					A.Q35,
					A.Q36,
					A.Q37,
					A.Q38,
					A.Q39,
					A.Q40,
					A.Q41,
					A.Q42,
					A.Q43,
					A.Q44,
					A.Q45,
					A.Q46,
					A.Q47,
					A.Q48,
					A.Q49,
					A.Q50,
					A.Q51,
					A.Q52,
					A.Q53,
					A.Q54,
					A.Q55,
					A.Q56,
					A.Q57,
					A.Q58,
					A.Q59,
					A.Q60,
					A.Q61,
					A.Q62,
					A.Q63,
					A.Q64,
					A.Q65,
					A.Q66,
					A.Q67,
					A.Q68,
					A.Q69,
					A.Q70,
					A.Q71,
					A.Q72,
					A.Q73,
					A.Q74,
					A.Q75,
					A.Q76,
					A.Q77,
					A.Q78,
					A.Q79,
					A.Q80,
					A.Q81,
					A.Q82,
					A.Q83,
					A.Q84,
					A.Q85,
					A.Q86,
					A.Q87,
					A.Q88,
					A.Q89,
					A.Q90,
					A.Q91,
					A.Q92,
					A.Q93,
					A.Q94,
					A.Q95,
					A.Q96,
					A.Q97,
					A.Q98,
					A.Q99
					
			FROM	#PGCP A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.ProgramGroupKey = source.ProgramGroupKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Grouping = source.Grouping
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Q01],
					[Q02],
					[Q03],
					[Q04],
					[Q05],
					[Q06],
					[Q07],
					[Q08],
					[Q09],
					[Q10],
					[Q11],
					[Q12],
					[Q13],
					[Q14],
					[Q15],
					[Q16],
					[Q17],
					[Q18],
					[Q19],
					[Q20],
					[Q21],
					[Q22],
					[Q23],
					[Q24],
					[Q25],
					[Q26],
					[Q27],
					[Q28],
					[Q29],
					[Q30],
					[Q31],
					[Q32],
					[Q33],
					[Q34],
					[Q35],
					[Q36],
					[Q37],
					[Q38],
					[Q39],
					[Q40],
					[Q41],
					[Q42],
					[Q43],
					[Q44],
					[Q45],
					[Q46],
					[Q47],
					[Q48],
					[Q49],
					[Q50],
					[Q51],
					[Q52],
					[Q53],
					[Q54],
					[Q55],
					[Q56],
					[Q57],
					[Q58],
					[Q59],
					[Q60],
					[Q61],
					[Q62],
					[Q63],
					[Q64],
					[Q65],
					[Q66],
					[Q67],
					[Q68],
					[Q69],
					[Q70],
					[Q71],
					[Q72],
					[Q73],
					[Q74],
					[Q75],
					[Q76],
					[Q77],
					[Q78],
					[Q79],
					[Q80],
					[Q81],
					[Q82],
					[Q83],
					[Q84],
					[Q85],
					[Q86],
					[Q87],
					[Q88],
					[Q89],
					[Q90],
					[Q91],
					[Q92],
					[Q93],
					[Q94],
					[Q95],
					[Q96],
					[Q97],
					[Q98],
					[Q99]
					)
			VALUES ([AssociationKey],
					[ProgramGroupKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[Association],
					[Program],
					[Grouping],
					[Q01],
					[Q02],
					[Q03],
					[Q04],
					[Q05],
					[Q06],
					[Q07],
					[Q08],
					[Q09],
					[Q10],
					[Q11],
					[Q12],
					[Q13],
					[Q14],
					[Q15],
					[Q16],
					[Q17],
					[Q18],
					[Q19],
					[Q20],
					[Q21],
					[Q22],
					[Q23],
					[Q24],
					[Q25],
					[Q26],
					[Q27],
					[Q28],
					[Q29],
					[Q30],
					[Q31],
					[Q32],
					[Q33],
					[Q34],
					[Q35],
					[Q36],
					[Q37],
					[Q38],
					[Q39],
					[Q40],
					[Q41],
					[Q42],
					[Q43],
					[Q44],
					[Q45],
					[Q46],
					[Q47],
					[Q48],
					[Q49],
					[Q50],
					[Q51],
					[Q52],
					[Q53],
					[Q54],
					[Q55],
					[Q56],
					[Q57],
					[Q58],
					[Q59],
					[Q60],
					[Q61],
					[Q62],
					[Q63],
					[Q64],
					[Q65],
					[Q66],
					[Q67],
					[Q68],
					[Q69],
					[Q70],
					[Q71],
					[Q72],
					[Q73],
					[Q74],
					[Q75],
					[Q76],
					[Q77],
					[Q78],
					[Q79],
					[Q80],
					[Q81],
					[Q82],
					[Q83],
					[Q84],
					[Q85],
					[Q86],
					[Q87],
					[Q88],
					[Q89],
					[Q90],
					[Q91],
					[Q92],
					[Q93],
					[Q94],
					[Q95],
					[Q96],
					[Q97],
					[Q98],
					[Q99]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #PGCP;
	
COMMIT TRAN
	
END








