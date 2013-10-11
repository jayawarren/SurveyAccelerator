/*
--truncate table Seer_ODS.dbo.Aggregated_Data
truncate table Seer_CTRL.dbo.[Program Aggregated Data]
drop procedure spPopulate_odsAggregated_Program
select * from Seer_ODS.dbo.Aggregated_Data
select * from Seer_CTRL.dbo.[Program Aggregated Data]
*/
CREATE PROCEDURE spPopulate_odsAggregated_Program AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Aggregated_Data AS target
	USING	(
			SELECT	1 current_indicator,
					'Program' module,
					A.[Aggregate_Type] [aggregate_type],
					A.[Response_Load_Date] [response_load_date],
					A.[Form_Code] [form_code],
					CASE WHEN LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'National' THEN '0000'
						ELSE A.[OFF_ASSOC_NUM]
					END [official_association_number],
					CASE WHEN A.[Aggregate_Type] = 'National' THEN 'All Associations'
						ELSE REPLACE(A.[ASSOCIATION_NAME], '"', '')
					END [association_name],
					/*
					CASE WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) <> 3 THEN A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'National' THEN '0000'
						 WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
						 ELSE COALESCE(A.[OFF_BR_Num], '')
					END [official_branch_number],
					CASE WHEN A.[Aggregate_Type] = 'Association' THEN REPLACE(A.[ASSOCIATION_NAME], '"', '')
						 WHEN A.[Aggregate_Type] = 'National' THEN 'All Associations'
						 WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
						 ELSE COALESCE(A.[BRANCH_NAME], '')
					END [branch_name],
					*/
					CASE WHEN LEN(COALESCE(A.[Response_Count], '')) = 0 THEN 0
						ELSE A.Response_Count
					END  [response_count],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_00] END [avg_q_01_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_01] END [avg_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_02] END [avg_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_03] END [avg_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_04] END [avg_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_05] END [avg_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_06] END [avg_q_01_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_07] END [avg_q_01_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_08] END [avg_q_01_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_09] END [avg_q_01_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_10] END [avg_q_01_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_00] END [avg_q_02_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_01] END [avg_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_02] END [avg_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_03] END [avg_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_04] END [avg_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_05] END [avg_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_06] END [avg_q_02_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_07] END [avg_q_02_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_08] END [avg_q_02_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_09] END [avg_q_02_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_10] END [avg_q_02_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_00] END [avg_q_03_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_01] END [avg_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_02] END [avg_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_03] END [avg_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_04] END [avg_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_05] END [avg_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_06] END [avg_q_03_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_07] END [avg_q_03_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_08] END [avg_q_03_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_09] END [avg_q_03_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_10] END [avg_q_03_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_00] END [avg_q_04_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_01] END [avg_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_02] END [avg_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_03] END [avg_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_04] END [avg_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_05] END [avg_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_06] END [avg_q_04_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_07] END [avg_q_04_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_08] END [avg_q_04_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_09] END [avg_q_04_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_10] END [avg_q_04_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_00] END [avg_q_05_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_01] END [avg_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_02] END [avg_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_03] END [avg_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_04] END [avg_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_05] END [avg_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_06] END [avg_q_05_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_07] END [avg_q_05_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_08] END [avg_q_05_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_09] END [avg_q_05_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_10] END [avg_q_05_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_00] END [avg_q_06_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_01] END [avg_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_02] END [avg_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_03] END [avg_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_04] END [avg_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_05] END [avg_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_06] END [avg_q_06_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_07] END [avg_q_06_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_08] END [avg_q_06_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_09] END [avg_q_06_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_10] END [avg_q_06_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_00] END [avg_q_07_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_01] END [avg_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_02] END [avg_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_03] END [avg_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_04] END [avg_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_05] END [avg_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_06] END [avg_q_07_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_07] END [avg_q_07_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_08] END [avg_q_07_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_09] END [avg_q_07_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_10] END [avg_q_07_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_00] END [avg_q_08_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_01] END [avg_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_02] END [avg_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_03] END [avg_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_04] END [avg_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_05] END [avg_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_06] END [avg_q_08_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_07] END [avg_q_08_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_08] END [avg_q_08_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_09] END [avg_q_08_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_10] END [avg_q_08_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_00] END [avg_q_09_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_01] END [avg_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_02] END [avg_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_03] END [avg_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_04] END [avg_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_05] END [avg_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_06] END [avg_q_09_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_07] END [avg_q_09_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_08] END [avg_q_09_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_09] END [avg_q_09_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_10] END [avg_q_09_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_00] END [avg_q_10_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_01] END [avg_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_02] END [avg_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_03] END [avg_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_04] END [avg_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_05] END [avg_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_06] END [avg_q_10_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_07] END [avg_q_10_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_08] END [avg_q_10_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_09] END [avg_q_10_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_10] END [avg_q_10_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_00] END [avg_q_11_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_01] END [avg_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_02] END [avg_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_03] END [avg_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_04] END [avg_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_05] END [avg_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_06] END [avg_q_11_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_07] END [avg_q_11_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_08] END [avg_q_11_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_09] END [avg_q_11_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_10] END [avg_q_11_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_00] END [avg_q_12_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_01] END [avg_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_02] END [avg_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_03] END [avg_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_04] END [avg_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_05] END [avg_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_06] END [avg_q_12_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_07] END [avg_q_12_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_08] END [avg_q_12_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_09] END [avg_q_12_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_10] END [avg_q_12_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_00] END [avg_q_13_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_01] END [avg_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_02] END [avg_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_03] END [avg_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_04] END [avg_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_05] END [avg_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_06] END [avg_q_13_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_07] END [avg_q_13_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_08] END [avg_q_13_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_09] END [avg_q_13_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_10] END [avg_q_13_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_00] END [avg_q_14_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_01] END [avg_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_02] END [avg_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_03] END [avg_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_04] END [avg_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_05] END [avg_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_06] END [avg_q_14_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_07] END [avg_q_14_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_08] END [avg_q_14_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_09] END [avg_q_14_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_10] END [avg_q_14_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_00] END [avg_q_15_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_01] END [avg_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_02] END [avg_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_03] END [avg_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_04] END [avg_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_05] END [avg_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_06] END [avg_q_15_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_07] END [avg_q_15_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_08] END [avg_q_15_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_09] END [avg_q_15_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_10] END [avg_q_15_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_00] END [avg_q_16_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_01] END [avg_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_02] END [avg_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_03] END [avg_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_04] END [avg_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_05] END [avg_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_06] END [avg_q_16_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_07] END [avg_q_16_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_08] END [avg_q_16_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_09] END [avg_q_16_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_10] END [avg_q_16_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_00] END [avg_q_17_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_01] END [avg_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_02] END [avg_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_03] END [avg_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_04] END [avg_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_05] END [avg_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_06] END [avg_q_17_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_07] END [avg_q_17_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_08] END [avg_q_17_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_09] END [avg_q_17_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_10] END [avg_q_17_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_00] END [avg_q_18_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_01] END [avg_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_02] END [avg_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_03] END [avg_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_04] END [avg_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_05] END [avg_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_06] END [avg_q_18_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_07] END [avg_q_18_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_08] END [avg_q_18_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_09] END [avg_q_18_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_10] END [avg_q_18_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_00] END [avg_q_19_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_01] END [avg_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_02] END [avg_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_03] END [avg_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_04] END [avg_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_05] END [avg_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_06] END [avg_q_19_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_07] END [avg_q_19_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_08] END [avg_q_19_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_09] END [avg_q_19_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_10] END [avg_q_19_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_00] END [avg_q_20_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_01] END [avg_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_02] END [avg_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_03] END [avg_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_04] END [avg_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_05] END [avg_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_06] END [avg_q_20_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_07] END [avg_q_20_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_08] END [avg_q_20_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_09] END [avg_q_20_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_10] END [avg_q_20_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_00] END [avg_q_21_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_01] END [avg_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_02] END [avg_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_03] END [avg_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_04] END [avg_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_05] END [avg_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_06] END [avg_q_21_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_07] END [avg_q_21_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_08] END [avg_q_21_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_09] END [avg_q_21_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_10] END [avg_q_21_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_00] END [avg_q_22_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_01] END [avg_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_02] END [avg_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_03] END [avg_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_04] END [avg_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_05] END [avg_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_06] END [avg_q_22_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_07] END [avg_q_22_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_08] END [avg_q_22_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_09] END [avg_q_22_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_10] END [avg_q_22_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_00] END [avg_q_23_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_01] END [avg_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_02] END [avg_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_03] END [avg_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_04] END [avg_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_05] END [avg_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_06] END [avg_q_23_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_07] END [avg_q_23_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_08] END [avg_q_23_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_09] END [avg_q_23_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_10] END [avg_q_23_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_00] END [avg_q_24_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_01] END [avg_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_02] END [avg_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_03] END [avg_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_04] END [avg_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_05] END [avg_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_06] END [avg_q_24_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_07] END [avg_q_24_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_08] END [avg_q_24_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_09] END [avg_q_24_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_10] END [avg_q_24_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_00] END [avg_q_25_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_01] END [avg_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_02] END [avg_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_03] END [avg_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_04] END [avg_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_05] END [avg_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_06] END [avg_q_25_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_07] END [avg_q_25_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_08] END [avg_q_25_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_09] END [avg_q_25_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_10] END [avg_q_25_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_00] END [avg_q_26_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_01] END [avg_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_02] END [avg_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_03] END [avg_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_04] END [avg_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_05] END [avg_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_06] END [avg_q_26_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_07] END [avg_q_26_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_08] END [avg_q_26_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_09] END [avg_q_26_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_10] END [avg_q_26_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_00] END [avg_q_27_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_01] END [avg_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_02] END [avg_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_03] END [avg_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_04] END [avg_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_05] END [avg_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_06] END [avg_q_27_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_07] END [avg_q_27_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_08] END [avg_q_27_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_09] END [avg_q_27_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_10] END [avg_q_27_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_00] END [avg_q_28_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_01] END [avg_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_02] END [avg_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_03] END [avg_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_04] END [avg_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_05] END [avg_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_06] END [avg_q_28_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_07] END [avg_q_28_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_08] END [avg_q_28_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_09] END [avg_q_28_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_10] END [avg_q_28_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_00] END [avg_q_29_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_01] END [avg_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_02] END [avg_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_03] END [avg_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_04] END [avg_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_05] END [avg_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_06] END [avg_q_29_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_07] END [avg_q_29_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_08] END [avg_q_29_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_09] END [avg_q_29_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_10] END [avg_q_29_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_00] END [avg_q_30_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_01] END [avg_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_02] END [avg_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_03] END [avg_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_04] END [avg_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_05] END [avg_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_06] END [avg_q_30_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_07] END [avg_q_30_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_08] END [avg_q_30_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_09] END [avg_q_30_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_10] END [avg_q_30_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_00] END [avg_q_31_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_01] END [avg_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_02] END [avg_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_03] END [avg_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_04] END [avg_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_05] END [avg_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_06] END [avg_q_31_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_07] END [avg_q_31_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_08] END [avg_q_31_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_09] END [avg_q_31_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_10] END [avg_q_31_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_00] END [avg_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_01] END [avg_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_02] END [avg_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_03] END [avg_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_04] END [avg_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_05] END [avg_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_06] END [avg_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_07] END [avg_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_08] END [avg_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_09] END [avg_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_10] END [avg_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_00] END [avg_q_33_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_01] END [avg_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_02] END [avg_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_03] END [avg_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_04] END [avg_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_05] END [avg_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_06] END [avg_q_33_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_07] END [avg_q_33_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_08] END [avg_q_33_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_09] END [avg_q_33_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_10] END [avg_q_33_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_00] END [avg_q_34_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_01] END [avg_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_02] END [avg_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_03] END [avg_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_04] END [avg_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_05] END [avg_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_06] END [avg_q_34_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_07] END [avg_q_34_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_08] END [avg_q_34_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_09] END [avg_q_34_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_10] END [avg_q_34_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_00] END [avg_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_01] END [avg_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_02] END [avg_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_03] END [avg_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_04] END [avg_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_05] END [avg_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_06] END [avg_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_07] END [avg_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_08] END [avg_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_09] END [avg_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_10] END [avg_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_00] END [avg_q_36_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_01] END [avg_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_02] END [avg_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_03] END [avg_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_04] END [avg_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_05] END [avg_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_06] END [avg_q_36_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_07] END [avg_q_36_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_08] END [avg_q_36_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_09] END [avg_q_36_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_10] END [avg_q_36_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_00] END [avg_q_37_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_01] END [avg_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_02] END [avg_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_03] END [avg_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_04] END [avg_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_05] END [avg_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_06] END [avg_q_37_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_07] END [avg_q_37_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_08] END [avg_q_37_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_09] END [avg_q_37_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_10] END [avg_q_37_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_00] END [avg_q_38_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_01] END [avg_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_02] END [avg_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_03] END [avg_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_04] END [avg_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_05] END [avg_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_06] END [avg_q_38_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_07] END [avg_q_38_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_08] END [avg_q_38_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_09] END [avg_q_38_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_10] END [avg_q_38_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_00] END [avg_q_39_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_01] END [avg_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_02] END [avg_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_03] END [avg_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_04] END [avg_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_05] END [avg_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_06] END [avg_q_39_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_07] END [avg_q_39_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_08] END [avg_q_39_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_09] END [avg_q_39_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_10] END [avg_q_39_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_00] END [avg_q_40_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_01] END [avg_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_02] END [avg_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_03] END [avg_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_04] END [avg_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_05] END [avg_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_06] END [avg_q_40_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_07] END [avg_q_40_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_08] END [avg_q_40_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_09] END [avg_q_40_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_10] END [avg_q_40_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_00] END [avg_q_41_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_01] END [avg_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_02] END [avg_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_03] END [avg_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_04] END [avg_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_05] END [avg_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_06] END [avg_q_41_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_07] END [avg_q_41_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_08] END [avg_q_41_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_09] END [avg_q_41_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_10] END [avg_q_41_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_00] END [avg_q_42_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_01] END [avg_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_02] END [avg_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_03] END [avg_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_04] END [avg_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_05] END [avg_q_42_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_06] END [avg_q_42_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_07] END [avg_q_42_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_08] END [avg_q_42_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_09] END [avg_q_42_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_10] END [avg_q_42_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_00] END [avg_q_43_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_01] END [avg_q_43_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_02] END [avg_q_43_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_03] END [avg_q_43_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_04] END [avg_q_43_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_05] END [avg_q_43_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_06] END [avg_q_43_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_07] END [avg_q_43_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_08] END [avg_q_43_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_09] END [avg_q_43_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_10] END [avg_q_43_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_00] END [avg_q_44_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_01] END [avg_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_02] END [avg_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_03] END [avg_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_04] END [avg_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_05] END [avg_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_06] END [avg_q_44_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_07] END [avg_q_44_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_08] END [avg_q_44_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_09] END [avg_q_44_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_10] END [avg_q_44_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_00] END [avg_q_45_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_01] END [avg_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_02] END [avg_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_03] END [avg_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_04] END [avg_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_05] END [avg_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_06] END [avg_q_45_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_07] END [avg_q_45_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_08] END [avg_q_45_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_09] END [avg_q_45_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_10] END [avg_q_45_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_00] END [avg_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_01] END [avg_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_02] END [avg_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_03] END [avg_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_04] END [avg_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_05] END [avg_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_06] END [avg_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_07] END [avg_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_08] END [avg_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_09] END [avg_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_10] END [avg_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_00] END [avg_q_47_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_01] END [avg_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_02] END [avg_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_03] END [avg_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_04] END [avg_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_05] END [avg_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_06] END [avg_q_47_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_07] END [avg_q_47_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_08] END [avg_q_47_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_09] END [avg_q_47_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_10] END [avg_q_47_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_00] END [avg_q_48_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_01] END [avg_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_02] END [avg_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_03] END [avg_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_04] END [avg_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_05] END [avg_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_06] END [avg_q_48_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_07] END [avg_q_48_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_08] END [avg_q_48_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_09] END [avg_q_48_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_10] END [avg_q_48_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_00] END [avg_q_49_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_01] END [avg_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_02] END [avg_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_03] END [avg_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_04] END [avg_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_05] END [avg_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_06] END [avg_q_49_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_07] END [avg_q_49_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_08] END [avg_q_49_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_09] END [avg_q_49_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_10] END [avg_q_49_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_00] END [avg_q_50_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_01] END [avg_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_02] END [avg_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_03] END [avg_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_04] END [avg_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_05] END [avg_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_06] END [avg_q_50_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_07] END [avg_q_50_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_08] END [avg_q_50_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_09] END [avg_q_50_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_10] END [avg_q_50_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_00] END [avg_q_51_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_01] END [avg_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_02] END [avg_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_03] END [avg_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_04] END [avg_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_05] END [avg_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_06] END [avg_q_51_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_07] END [avg_q_51_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_08] END [avg_q_51_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_09] END [avg_q_51_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_10] END [avg_q_51_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_00] END [avg_q_52_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_01] END [avg_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_02] END [avg_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_03] END [avg_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_04] END [avg_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_05] END [avg_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_06] END [avg_q_52_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_07] END [avg_q_52_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_08] END [avg_q_52_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_09] END [avg_q_52_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_10] END [avg_q_52_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_00] END [avg_q_53_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_01] END [avg_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_02] END [avg_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_03] END [avg_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_04] END [avg_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_05] END [avg_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_06] END [avg_q_53_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_07] END [avg_q_53_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_08] END [avg_q_53_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_09] END [avg_q_53_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_10] END [avg_q_53_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_00] END [avg_q_54_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_01] END [avg_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_02] END [avg_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_03] END [avg_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_04] END [avg_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_05] END [avg_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_06] END [avg_q_54_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_07] END [avg_q_54_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_08] END [avg_q_54_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_09] END [avg_q_54_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_10] END [avg_q_54_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_00] END [avg_q_55_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_01] END [avg_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_02] END [avg_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_03] END [avg_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_04] END [avg_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_05] END [avg_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_06] END [avg_q_55_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_07] END [avg_q_55_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_08] END [avg_q_55_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_09] END [avg_q_55_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_10] END [avg_q_55_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_00] END [avg_q_56_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_01] END [avg_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_02] END [avg_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_03] END [avg_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_04] END [avg_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_05] END [avg_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_06] END [avg_q_56_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_07] END [avg_q_56_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_08] END [avg_q_56_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_09] END [avg_q_56_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_10] END [avg_q_56_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_00] END [avg_q_57_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_01] END [avg_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_02] END [avg_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_03] END [avg_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_04] END [avg_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_05] END [avg_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_06] END [avg_q_57_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_07] END [avg_q_57_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_08] END [avg_q_57_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_09] END [avg_q_57_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_10] END [avg_q_57_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_00] END [avg_q_58_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_01] END [avg_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_02] END [avg_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_03] END [avg_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_04] END [avg_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_05] END [avg_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_06] END [avg_q_58_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_07] END [avg_q_58_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_08] END [avg_q_58_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_09] END [avg_q_58_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_10] END [avg_q_58_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_00] END [avg_q_59_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_01] END [avg_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_02] END [avg_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_03] END [avg_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_04] END [avg_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_05] END [avg_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_06] END [avg_q_59_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_07] END [avg_q_59_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_08] END [avg_q_59_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_09] END [avg_q_59_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_10] END [avg_q_59_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_00] END [avg_q_60_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_01] END [avg_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_02] END [avg_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_03] END [avg_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_04] END [avg_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_05] END [avg_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_06] END [avg_q_60_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_07] END [avg_q_60_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_08] END [avg_q_60_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_09] END [avg_q_60_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_10] END [avg_q_60_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_00] END [avg_q_61_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_01] END [avg_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_02] END [avg_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_03] END [avg_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_04] END [avg_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_05] END [avg_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_06] END [avg_q_61_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_07] END [avg_q_61_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_08] END [avg_q_61_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_09] END [avg_q_61_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_10] END [avg_q_61_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_00] END [avg_q_62_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_01] END [avg_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_02] END [avg_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_03] END [avg_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_04] END [avg_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_05] END [avg_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_06] END [avg_q_62_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_07] END [avg_q_62_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_08] END [avg_q_62_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_09] END [avg_q_62_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_10] END [avg_q_62_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_00] END [avg_q_63_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_01] END [avg_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_02] END [avg_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_03] END [avg_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_04] END [avg_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_05] END [avg_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_06] END [avg_q_63_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_07] END [avg_q_63_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_08] END [avg_q_63_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_09] END [avg_q_63_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_10] END [avg_q_63_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_00] END [avg_q_64_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_01] END [avg_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_02] END [avg_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_03] END [avg_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_04] END [avg_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_05] END [avg_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_06] END [avg_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_07] END [avg_q_64_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_08] END [avg_q_64_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_09] END [avg_q_64_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_10] END [avg_q_64_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_00] END [avg_q_65_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_01] END [avg_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_02] END [avg_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_03] END [avg_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_04] END [avg_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_05] END [avg_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_06] END [avg_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_07] END [avg_q_65_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_08] END [avg_q_65_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_09] END [avg_q_65_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_10] END [avg_q_65_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_00] END [avg_q_66_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_01] END [avg_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_02] END [avg_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_03] END [avg_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_04] END [avg_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_05] END [avg_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_06] END [avg_q_66_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_07] END [avg_q_66_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_08] END [avg_q_66_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_09] END [avg_q_66_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_10] END [avg_q_66_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_00] END [avg_q_67_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_01] END [avg_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_02] END [avg_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_03] END [avg_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_04] END [avg_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_05] END [avg_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_06] END [avg_q_67_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_07] END [avg_q_67_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_08] END [avg_q_67_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_09] END [avg_q_67_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_10] END [avg_q_67_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_00] END [avg_q_68_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_01] END [avg_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_02] END [avg_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_03] END [avg_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_04] END [avg_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_05] END [avg_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_06] END [avg_q_68_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_07] END [avg_q_68_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_08] END [avg_q_68_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_09] END [avg_q_68_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_10] END [avg_q_68_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_00] END [avg_q_69_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_01] END [avg_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_02] END [avg_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_03] END [avg_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_04] END [avg_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_05] END [avg_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_06] END [avg_q_69_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_07] END [avg_q_69_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_08] END [avg_q_69_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_09] END [avg_q_69_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_10] END [avg_q_69_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_00] END [avg_q_70_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_01] END [avg_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_02] END [avg_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_03] END [avg_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_04] END [avg_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_05] END [avg_q_70_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_06] END [avg_q_70_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_07] END [avg_q_70_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_08] END [avg_q_70_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_09] END [avg_q_70_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_10] END [avg_q_70_10],
					/*
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_00] END [avg_q_71_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_01] END [avg_q_71_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_02] END [avg_q_71_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_03] END [avg_q_71_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_04] END [avg_q_71_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_05] END [avg_q_71_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_06] END [avg_q_71_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_07] END [avg_q_71_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_08] END [avg_q_71_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_09] END [avg_q_71_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_10] END [avg_q_71_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_00] END [avg_q_72_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_01] END [avg_q_72_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_02] END [avg_q_72_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_03] END [avg_q_72_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_04] END [avg_q_72_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_05] END [avg_q_72_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_06] END [avg_q_72_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_07] END [avg_q_72_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_08] END [avg_q_72_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_09] END [avg_q_72_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_10] END [avg_q_72_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_00] END [avg_q_73_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_01] END [avg_q_73_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_02] END [avg_q_73_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_03] END [avg_q_73_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_04] END [avg_q_73_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_05] END [avg_q_73_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_06] END [avg_q_73_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_07] END [avg_q_73_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_08] END [avg_q_73_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_09] END [avg_q_73_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_10] END [avg_q_73_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_00] END [avg_q_74_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_01] END [avg_q_74_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_02] END [avg_q_74_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_03] END [avg_q_74_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_04] END [avg_q_74_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_05] END [avg_q_74_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_06] END [avg_q_74_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_07] END [avg_q_74_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_08] END [avg_q_74_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_09] END [avg_q_74_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_10] END [avg_q_74_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_00] END [avg_q_75_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_01] END [avg_q_75_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_02] END [avg_q_75_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_03] END [avg_q_75_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_04] END [avg_q_75_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_05] END [avg_q_75_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_06] END [avg_q_75_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_07] END [avg_q_75_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_08] END [avg_q_75_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_09] END [avg_q_75_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_10] END [avg_q_75_10],
					*/
					CASE WHEN LEN(COALESCE(A.[NPS], '')) = 0 THEN '0' ELSE A.[NPS] END [nps],
					CASE WHEN LEN(COALESCE(A.[RPI], '')) = 0 THEN '0' ELSE A.[RPI] END [rpi],
					CASE WHEN LEN(COALESCE(A.[Achievement Z-Score], '')) = 0 THEN '0' ELSE A.[Achievement Z-Score] END [achievement_z-score],
					CASE WHEN LEN(COALESCE(A.[Belonging Z-Score], '')) = 0 THEN '0' ELSE A.[Belonging Z-Score] END [belonging_z-score],
					CASE WHEN LEN(COALESCE(A.[Character Z-Score], '')) = 0 THEN '0' ELSE A.[Character Z-Score] END [character_z-score],
					CASE WHEN LEN(COALESCE(A.[Giving Z-Score], '')) = 0 THEN '0' ELSE A.[Giving Z-Score] END [giving_z-score],
					CASE WHEN LEN(COALESCE(A.[Health Z-Score], '')) = 0 THEN '0' ELSE A.[Health Z-Score] END [health_z-score],
					CASE WHEN LEN(COALESCE(A.[Inspiration Z-Score], '')) = 0 THEN '0' ELSE A.[Inspiration Z-Score] END [inspiration_z-score],
					CASE WHEN LEN(COALESCE(A.[Meaning Z-Score], '')) = 0 THEN '0' ELSE A.[Meaning Z-Score] END [meaning_z-score],
					CASE WHEN LEN(COALESCE(A.[Relationship Z-Score], '')) = 0 THEN '0' ELSE A.[Relationship Z-Score] END [relationship_z-score],
					CASE WHEN LEN(COALESCE(A.[Safety Z-Score], '')) = 0 THEN '0' ELSE A.[Safety Z-Score] END [safety_z-score],
					CASE WHEN LEN(COALESCE(A.[Achievement Percentile], '')) = 0 THEN '0' ELSE A.[Achievement Percentile] END [achievement_percentile],
					CASE WHEN LEN(COALESCE(A.[Belonging Percentile], '')) = 0 THEN '0' ELSE A.[Belonging Percentile] END [belonging_percentile],
					CASE WHEN LEN(COALESCE(A.[Character Percentile], '')) = 0 THEN '0' ELSE A.[Character Percentile] END [character_percentile],
					CASE WHEN LEN(COALESCE(A.[Giving Percentile], '')) = 0 THEN '0' ELSE A.[Giving Percentile] END [giving_percentile],
					CASE WHEN LEN(COALESCE(A.[Health Percentile], '')) = 0 THEN '0' ELSE A.[Health Percentile] END [health_percentile],
					CASE WHEN LEN(COALESCE(A.[Inspiration Percentile], '')) = 0 THEN '0' ELSE A.[Inspiration Percentile] END [inspiration_percentile],
					CASE WHEN LEN(COALESCE(A.[Meaning Percentile], '')) = 0 THEN '0' ELSE A.[Meaning Percentile] END [meaning_percentile],
					CASE WHEN LEN(COALESCE(A.[Relationship Percentile], '')) = 0 THEN '0' ELSE A.[Relationship Percentile] END [relationship_percentile],
					CASE WHEN LEN(COALESCE(A.[Safety Percentile], '')) = 0 THEN '0' ELSE A.[Safety Percentile] END [safety_percentile]

			FROM	Seer_STG.dbo.[Program Aggregated Data] A
						
			WHERE	((ISNUMERIC(A.[response_count]) = 1) OR (LEN(COALESCE(A.[response_count], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_10], '')) = 0))
					/*
					AND ((ISNUMERIC(A.[Avg_Q_71_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_10], '')) = 0))
					*/
					AND ((ISNUMERIC(A.[NPS]) = 1 AND CONVERT(DECIMAL(20, 6), A.[NPS]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[NPS], '')) = 0))
					AND ((ISNUMERIC(A.[RPI]) = 1 AND CONVERT(DECIMAL(20, 6), A.[RPI]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[RPI], '')) = 0))
					AND ((ISNUMERIC(A.[Achievement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Achievement Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Belonging Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Belonging Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Character Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Character Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Giving Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Giving Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Health Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Health Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Inspiration Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Inspiration Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Meaning Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Meaning Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Relationship Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Relationship Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Safety Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Safety Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Achievement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Achievement Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Belonging Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Belonging Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Character Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Character Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Giving Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Giving Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Health Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Health Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Inspiration Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Inspiration Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Meaning Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Meaning Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Relationship Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Relationship Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Safety Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Safety Percentile], '')) = 0))

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
				AND target.form_code = source.form_code
				AND target.official_association_number = source.official_association_number
				--AND target.official_branch_number = source.official_branch_number
			
			WHEN MATCHED AND (target.[response_load_date] <> source.[response_load_date]
								OR target.[association_name] <> source.[association_name]
								--OR target.[branch_name] <> source.[branch_name]
								OR target.[response_count] <> source.[response_count]
								OR target.[avg_q_01_00] <> source.[avg_q_01_00]
								OR target.[avg_q_01_01] <> source.[avg_q_01_01]
								OR target.[avg_q_01_02] <> source.[avg_q_01_02]
								OR target.[avg_q_01_03] <> source.[avg_q_01_03]
								OR target.[avg_q_01_04] <> source.[avg_q_01_04]
								OR target.[avg_q_01_05] <> source.[avg_q_01_05]
								OR target.[avg_q_01_06] <> source.[avg_q_01_06]
								OR target.[avg_q_01_07] <> source.[avg_q_01_07]
								OR target.[avg_q_01_08] <> source.[avg_q_01_08]
								OR target.[avg_q_01_09] <> source.[avg_q_01_09]
								OR target.[avg_q_01_10] <> source.[avg_q_01_10]
								OR target.[avg_q_02_00] <> source.[avg_q_02_00]
								OR target.[avg_q_02_01] <> source.[avg_q_02_01]
								OR target.[avg_q_02_02] <> source.[avg_q_02_02]
								OR target.[avg_q_02_03] <> source.[avg_q_02_03]
								OR target.[avg_q_02_04] <> source.[avg_q_02_04]
								OR target.[avg_q_02_05] <> source.[avg_q_02_05]
								OR target.[avg_q_02_06] <> source.[avg_q_02_06]
								OR target.[avg_q_02_07] <> source.[avg_q_02_07]
								OR target.[avg_q_02_08] <> source.[avg_q_02_08]
								OR target.[avg_q_02_09] <> source.[avg_q_02_09]
								OR target.[avg_q_02_10] <> source.[avg_q_02_10]
								OR target.[avg_q_03_00] <> source.[avg_q_03_00]
								OR target.[avg_q_03_01] <> source.[avg_q_03_01]
								OR target.[avg_q_03_02] <> source.[avg_q_03_02]
								OR target.[avg_q_03_03] <> source.[avg_q_03_03]
								OR target.[avg_q_03_04] <> source.[avg_q_03_04]
								OR target.[avg_q_03_05] <> source.[avg_q_03_05]
								OR target.[avg_q_03_06] <> source.[avg_q_03_06]
								OR target.[avg_q_03_07] <> source.[avg_q_03_07]
								OR target.[avg_q_03_08] <> source.[avg_q_03_08]
								OR target.[avg_q_03_09] <> source.[avg_q_03_09]
								OR target.[avg_q_03_10] <> source.[avg_q_03_10]
								OR target.[avg_q_04_00] <> source.[avg_q_04_00]
								OR target.[avg_q_04_01] <> source.[avg_q_04_01]
								OR target.[avg_q_04_02] <> source.[avg_q_04_02]
								OR target.[avg_q_04_03] <> source.[avg_q_04_03]
								OR target.[avg_q_04_04] <> source.[avg_q_04_04]
								OR target.[avg_q_04_05] <> source.[avg_q_04_05]
								OR target.[avg_q_04_06] <> source.[avg_q_04_06]
								OR target.[avg_q_04_07] <> source.[avg_q_04_07]
								OR target.[avg_q_04_08] <> source.[avg_q_04_08]
								OR target.[avg_q_04_09] <> source.[avg_q_04_09]
								OR target.[avg_q_04_10] <> source.[avg_q_04_10]
								OR target.[avg_q_05_00] <> source.[avg_q_05_00]
								OR target.[avg_q_05_01] <> source.[avg_q_05_01]
								OR target.[avg_q_05_02] <> source.[avg_q_05_02]
								OR target.[avg_q_05_03] <> source.[avg_q_05_03]
								OR target.[avg_q_05_04] <> source.[avg_q_05_04]
								OR target.[avg_q_05_05] <> source.[avg_q_05_05]
								OR target.[avg_q_05_06] <> source.[avg_q_05_06]
								OR target.[avg_q_05_07] <> source.[avg_q_05_07]
								OR target.[avg_q_05_08] <> source.[avg_q_05_08]
								OR target.[avg_q_05_09] <> source.[avg_q_05_09]
								OR target.[avg_q_05_10] <> source.[avg_q_05_10]
								OR target.[avg_q_06_00] <> source.[avg_q_06_00]
								OR target.[avg_q_06_01] <> source.[avg_q_06_01]
								OR target.[avg_q_06_02] <> source.[avg_q_06_02]
								OR target.[avg_q_06_03] <> source.[avg_q_06_03]
								OR target.[avg_q_06_04] <> source.[avg_q_06_04]
								OR target.[avg_q_06_05] <> source.[avg_q_06_05]
								OR target.[avg_q_06_06] <> source.[avg_q_06_06]
								OR target.[avg_q_06_07] <> source.[avg_q_06_07]
								OR target.[avg_q_06_08] <> source.[avg_q_06_08]
								OR target.[avg_q_06_09] <> source.[avg_q_06_09]
								OR target.[avg_q_06_10] <> source.[avg_q_06_10]
								OR target.[avg_q_07_00] <> source.[avg_q_07_00]
								OR target.[avg_q_07_01] <> source.[avg_q_07_01]
								OR target.[avg_q_07_02] <> source.[avg_q_07_02]
								OR target.[avg_q_07_03] <> source.[avg_q_07_03]
								OR target.[avg_q_07_04] <> source.[avg_q_07_04]
								OR target.[avg_q_07_05] <> source.[avg_q_07_05]
								OR target.[avg_q_07_06] <> source.[avg_q_07_06]
								OR target.[avg_q_07_07] <> source.[avg_q_07_07]
								OR target.[avg_q_07_08] <> source.[avg_q_07_08]
								OR target.[avg_q_07_09] <> source.[avg_q_07_09]
								OR target.[avg_q_07_10] <> source.[avg_q_07_10]
								OR target.[avg_q_08_00] <> source.[avg_q_08_00]
								OR target.[avg_q_08_01] <> source.[avg_q_08_01]
								OR target.[avg_q_08_02] <> source.[avg_q_08_02]
								OR target.[avg_q_08_03] <> source.[avg_q_08_03]
								OR target.[avg_q_08_04] <> source.[avg_q_08_04]
								OR target.[avg_q_08_05] <> source.[avg_q_08_05]
								OR target.[avg_q_08_06] <> source.[avg_q_08_06]
								OR target.[avg_q_08_07] <> source.[avg_q_08_07]
								OR target.[avg_q_08_08] <> source.[avg_q_08_08]
								OR target.[avg_q_08_09] <> source.[avg_q_08_09]
								OR target.[avg_q_08_10] <> source.[avg_q_08_10]
								OR target.[avg_q_09_00] <> source.[avg_q_09_00]
								OR target.[avg_q_09_01] <> source.[avg_q_09_01]
								OR target.[avg_q_09_02] <> source.[avg_q_09_02]
								OR target.[avg_q_09_03] <> source.[avg_q_09_03]
								OR target.[avg_q_09_04] <> source.[avg_q_09_04]
								OR target.[avg_q_09_05] <> source.[avg_q_09_05]
								OR target.[avg_q_09_06] <> source.[avg_q_09_06]
								OR target.[avg_q_09_07] <> source.[avg_q_09_07]
								OR target.[avg_q_09_08] <> source.[avg_q_09_08]
								OR target.[avg_q_09_09] <> source.[avg_q_09_09]
								OR target.[avg_q_09_10] <> source.[avg_q_09_10]
								OR target.[avg_q_10_00] <> source.[avg_q_10_00]
								OR target.[avg_q_10_01] <> source.[avg_q_10_01]
								OR target.[avg_q_10_02] <> source.[avg_q_10_02]
								OR target.[avg_q_10_03] <> source.[avg_q_10_03]
								OR target.[avg_q_10_04] <> source.[avg_q_10_04]
								OR target.[avg_q_10_05] <> source.[avg_q_10_05]
								OR target.[avg_q_10_06] <> source.[avg_q_10_06]
								OR target.[avg_q_10_07] <> source.[avg_q_10_07]
								OR target.[avg_q_10_08] <> source.[avg_q_10_08]
								OR target.[avg_q_10_09] <> source.[avg_q_10_09]
								OR target.[avg_q_10_10] <> source.[avg_q_10_10]
								OR target.[avg_q_11_00] <> source.[avg_q_11_00]
								OR target.[avg_q_11_01] <> source.[avg_q_11_01]
								OR target.[avg_q_11_02] <> source.[avg_q_11_02]
								OR target.[avg_q_11_03] <> source.[avg_q_11_03]
								OR target.[avg_q_11_04] <> source.[avg_q_11_04]
								OR target.[avg_q_11_05] <> source.[avg_q_11_05]
								OR target.[avg_q_11_06] <> source.[avg_q_11_06]
								OR target.[avg_q_11_07] <> source.[avg_q_11_07]
								OR target.[avg_q_11_08] <> source.[avg_q_11_08]
								OR target.[avg_q_11_09] <> source.[avg_q_11_09]
								OR target.[avg_q_11_10] <> source.[avg_q_11_10]
								OR target.[avg_q_12_00] <> source.[avg_q_12_00]
								OR target.[avg_q_12_01] <> source.[avg_q_12_01]
								OR target.[avg_q_12_02] <> source.[avg_q_12_02]
								OR target.[avg_q_12_03] <> source.[avg_q_12_03]
								OR target.[avg_q_12_04] <> source.[avg_q_12_04]
								OR target.[avg_q_12_05] <> source.[avg_q_12_05]
								OR target.[avg_q_12_06] <> source.[avg_q_12_06]
								OR target.[avg_q_12_07] <> source.[avg_q_12_07]
								OR target.[avg_q_12_08] <> source.[avg_q_12_08]
								OR target.[avg_q_12_09] <> source.[avg_q_12_09]
								OR target.[avg_q_12_10] <> source.[avg_q_12_10]
								OR target.[avg_q_13_00] <> source.[avg_q_13_00]
								OR target.[avg_q_13_01] <> source.[avg_q_13_01]
								OR target.[avg_q_13_02] <> source.[avg_q_13_02]
								OR target.[avg_q_13_03] <> source.[avg_q_13_03]
								OR target.[avg_q_13_04] <> source.[avg_q_13_04]
								OR target.[avg_q_13_05] <> source.[avg_q_13_05]
								OR target.[avg_q_13_06] <> source.[avg_q_13_06]
								OR target.[avg_q_13_07] <> source.[avg_q_13_07]
								OR target.[avg_q_13_08] <> source.[avg_q_13_08]
								OR target.[avg_q_13_09] <> source.[avg_q_13_09]
								OR target.[avg_q_13_10] <> source.[avg_q_13_10]
								OR target.[avg_q_14_00] <> source.[avg_q_14_00]
								OR target.[avg_q_14_01] <> source.[avg_q_14_01]
								OR target.[avg_q_14_02] <> source.[avg_q_14_02]
								OR target.[avg_q_14_03] <> source.[avg_q_14_03]
								OR target.[avg_q_14_04] <> source.[avg_q_14_04]
								OR target.[avg_q_14_05] <> source.[avg_q_14_05]
								OR target.[avg_q_14_06] <> source.[avg_q_14_06]
								OR target.[avg_q_14_07] <> source.[avg_q_14_07]
								OR target.[avg_q_14_08] <> source.[avg_q_14_08]
								OR target.[avg_q_14_09] <> source.[avg_q_14_09]
								OR target.[avg_q_14_10] <> source.[avg_q_14_10]
								OR target.[avg_q_15_00] <> source.[avg_q_15_00]
								OR target.[avg_q_15_01] <> source.[avg_q_15_01]
								OR target.[avg_q_15_02] <> source.[avg_q_15_02]
								OR target.[avg_q_15_03] <> source.[avg_q_15_03]
								OR target.[avg_q_15_04] <> source.[avg_q_15_04]
								OR target.[avg_q_15_05] <> source.[avg_q_15_05]
								OR target.[avg_q_15_06] <> source.[avg_q_15_06]
								OR target.[avg_q_15_07] <> source.[avg_q_15_07]
								OR target.[avg_q_15_08] <> source.[avg_q_15_08]
								OR target.[avg_q_15_09] <> source.[avg_q_15_09]
								OR target.[avg_q_15_10] <> source.[avg_q_15_10]
								OR target.[avg_q_16_00] <> source.[avg_q_16_00]
								OR target.[avg_q_16_01] <> source.[avg_q_16_01]
								OR target.[avg_q_16_02] <> source.[avg_q_16_02]
								OR target.[avg_q_16_03] <> source.[avg_q_16_03]
								OR target.[avg_q_16_04] <> source.[avg_q_16_04]
								OR target.[avg_q_16_05] <> source.[avg_q_16_05]
								OR target.[avg_q_16_06] <> source.[avg_q_16_06]
								OR target.[avg_q_16_07] <> source.[avg_q_16_07]
								OR target.[avg_q_16_08] <> source.[avg_q_16_08]
								OR target.[avg_q_16_09] <> source.[avg_q_16_09]
								OR target.[avg_q_16_10] <> source.[avg_q_16_10]
								OR target.[avg_q_17_00] <> source.[avg_q_17_00]
								OR target.[avg_q_17_01] <> source.[avg_q_17_01]
								OR target.[avg_q_17_02] <> source.[avg_q_17_02]
								OR target.[avg_q_17_03] <> source.[avg_q_17_03]
								OR target.[avg_q_17_04] <> source.[avg_q_17_04]
								OR target.[avg_q_17_05] <> source.[avg_q_17_05]
								OR target.[avg_q_17_06] <> source.[avg_q_17_06]
								OR target.[avg_q_17_07] <> source.[avg_q_17_07]
								OR target.[avg_q_17_08] <> source.[avg_q_17_08]
								OR target.[avg_q_17_09] <> source.[avg_q_17_09]
								OR target.[avg_q_17_10] <> source.[avg_q_17_10]
								OR target.[avg_q_18_00] <> source.[avg_q_18_00]
								OR target.[avg_q_18_01] <> source.[avg_q_18_01]
								OR target.[avg_q_18_02] <> source.[avg_q_18_02]
								OR target.[avg_q_18_03] <> source.[avg_q_18_03]
								OR target.[avg_q_18_04] <> source.[avg_q_18_04]
								OR target.[avg_q_18_05] <> source.[avg_q_18_05]
								OR target.[avg_q_18_06] <> source.[avg_q_18_06]
								OR target.[avg_q_18_07] <> source.[avg_q_18_07]
								OR target.[avg_q_18_08] <> source.[avg_q_18_08]
								OR target.[avg_q_18_09] <> source.[avg_q_18_09]
								OR target.[avg_q_18_10] <> source.[avg_q_18_10]
								OR target.[avg_q_19_00] <> source.[avg_q_19_00]
								OR target.[avg_q_19_01] <> source.[avg_q_19_01]
								OR target.[avg_q_19_02] <> source.[avg_q_19_02]
								OR target.[avg_q_19_03] <> source.[avg_q_19_03]
								OR target.[avg_q_19_04] <> source.[avg_q_19_04]
								OR target.[avg_q_19_05] <> source.[avg_q_19_05]
								OR target.[avg_q_19_06] <> source.[avg_q_19_06]
								OR target.[avg_q_19_07] <> source.[avg_q_19_07]
								OR target.[avg_q_19_08] <> source.[avg_q_19_08]
								OR target.[avg_q_19_09] <> source.[avg_q_19_09]
								OR target.[avg_q_19_10] <> source.[avg_q_19_10]
								OR target.[avg_q_20_00] <> source.[avg_q_20_00]
								OR target.[avg_q_20_01] <> source.[avg_q_20_01]
								OR target.[avg_q_20_02] <> source.[avg_q_20_02]
								OR target.[avg_q_20_03] <> source.[avg_q_20_03]
								OR target.[avg_q_20_04] <> source.[avg_q_20_04]
								OR target.[avg_q_20_05] <> source.[avg_q_20_05]
								OR target.[avg_q_20_06] <> source.[avg_q_20_06]
								OR target.[avg_q_20_07] <> source.[avg_q_20_07]
								OR target.[avg_q_20_08] <> source.[avg_q_20_08]
								OR target.[avg_q_20_09] <> source.[avg_q_20_09]
								OR target.[avg_q_20_10] <> source.[avg_q_20_10]
								OR target.[avg_q_21_00] <> source.[avg_q_21_00]
								OR target.[avg_q_21_01] <> source.[avg_q_21_01]
								OR target.[avg_q_21_02] <> source.[avg_q_21_02]
								OR target.[avg_q_21_03] <> source.[avg_q_21_03]
								OR target.[avg_q_21_04] <> source.[avg_q_21_04]
								OR target.[avg_q_21_05] <> source.[avg_q_21_05]
								OR target.[avg_q_21_06] <> source.[avg_q_21_06]
								OR target.[avg_q_21_07] <> source.[avg_q_21_07]
								OR target.[avg_q_21_08] <> source.[avg_q_21_08]
								OR target.[avg_q_21_09] <> source.[avg_q_21_09]
								OR target.[avg_q_21_10] <> source.[avg_q_21_10]
								OR target.[avg_q_22_00] <> source.[avg_q_22_00]
								OR target.[avg_q_22_01] <> source.[avg_q_22_01]
								OR target.[avg_q_22_02] <> source.[avg_q_22_02]
								OR target.[avg_q_22_03] <> source.[avg_q_22_03]
								OR target.[avg_q_22_04] <> source.[avg_q_22_04]
								OR target.[avg_q_22_05] <> source.[avg_q_22_05]
								OR target.[avg_q_22_06] <> source.[avg_q_22_06]
								OR target.[avg_q_22_07] <> source.[avg_q_22_07]
								OR target.[avg_q_22_08] <> source.[avg_q_22_08]
								OR target.[avg_q_22_09] <> source.[avg_q_22_09]
								OR target.[avg_q_22_10] <> source.[avg_q_22_10]
								OR target.[avg_q_23_00] <> source.[avg_q_23_00]
								OR target.[avg_q_23_01] <> source.[avg_q_23_01]
								OR target.[avg_q_23_02] <> source.[avg_q_23_02]
								OR target.[avg_q_23_03] <> source.[avg_q_23_03]
								OR target.[avg_q_23_04] <> source.[avg_q_23_04]
								OR target.[avg_q_23_05] <> source.[avg_q_23_05]
								OR target.[avg_q_23_06] <> source.[avg_q_23_06]
								OR target.[avg_q_23_07] <> source.[avg_q_23_07]
								OR target.[avg_q_23_08] <> source.[avg_q_23_08]
								OR target.[avg_q_23_09] <> source.[avg_q_23_09]
								OR target.[avg_q_23_10] <> source.[avg_q_23_10]
								OR target.[avg_q_24_00] <> source.[avg_q_24_00]
								OR target.[avg_q_24_01] <> source.[avg_q_24_01]
								OR target.[avg_q_24_02] <> source.[avg_q_24_02]
								OR target.[avg_q_24_03] <> source.[avg_q_24_03]
								OR target.[avg_q_24_04] <> source.[avg_q_24_04]
								OR target.[avg_q_24_05] <> source.[avg_q_24_05]
								OR target.[avg_q_24_06] <> source.[avg_q_24_06]
								OR target.[avg_q_24_07] <> source.[avg_q_24_07]
								OR target.[avg_q_24_08] <> source.[avg_q_24_08]
								OR target.[avg_q_24_09] <> source.[avg_q_24_09]
								OR target.[avg_q_24_10] <> source.[avg_q_24_10]
								OR target.[avg_q_25_00] <> source.[avg_q_25_00]
								OR target.[avg_q_25_01] <> source.[avg_q_25_01]
								OR target.[avg_q_25_02] <> source.[avg_q_25_02]
								OR target.[avg_q_25_03] <> source.[avg_q_25_03]
								OR target.[avg_q_25_04] <> source.[avg_q_25_04]
								OR target.[avg_q_25_05] <> source.[avg_q_25_05]
								OR target.[avg_q_25_06] <> source.[avg_q_25_06]
								OR target.[avg_q_25_07] <> source.[avg_q_25_07]
								OR target.[avg_q_25_08] <> source.[avg_q_25_08]
								OR target.[avg_q_25_09] <> source.[avg_q_25_09]
								OR target.[avg_q_25_10] <> source.[avg_q_25_10]
								OR target.[avg_q_26_00] <> source.[avg_q_26_00]
								OR target.[avg_q_26_01] <> source.[avg_q_26_01]
								OR target.[avg_q_26_02] <> source.[avg_q_26_02]
								OR target.[avg_q_26_03] <> source.[avg_q_26_03]
								OR target.[avg_q_26_04] <> source.[avg_q_26_04]
								OR target.[avg_q_26_05] <> source.[avg_q_26_05]
								OR target.[avg_q_26_06] <> source.[avg_q_26_06]
								OR target.[avg_q_26_07] <> source.[avg_q_26_07]
								OR target.[avg_q_26_08] <> source.[avg_q_26_08]
								OR target.[avg_q_26_09] <> source.[avg_q_26_09]
								OR target.[avg_q_26_10] <> source.[avg_q_26_10]
								OR target.[avg_q_27_00] <> source.[avg_q_27_00]
								OR target.[avg_q_27_01] <> source.[avg_q_27_01]
								OR target.[avg_q_27_02] <> source.[avg_q_27_02]
								OR target.[avg_q_27_03] <> source.[avg_q_27_03]
								OR target.[avg_q_27_04] <> source.[avg_q_27_04]
								OR target.[avg_q_27_05] <> source.[avg_q_27_05]
								OR target.[avg_q_27_06] <> source.[avg_q_27_06]
								OR target.[avg_q_27_07] <> source.[avg_q_27_07]
								OR target.[avg_q_27_08] <> source.[avg_q_27_08]
								OR target.[avg_q_27_09] <> source.[avg_q_27_09]
								OR target.[avg_q_27_10] <> source.[avg_q_27_10]
								OR target.[avg_q_28_00] <> source.[avg_q_28_00]
								OR target.[avg_q_28_01] <> source.[avg_q_28_01]
								OR target.[avg_q_28_02] <> source.[avg_q_28_02]
								OR target.[avg_q_28_03] <> source.[avg_q_28_03]
								OR target.[avg_q_28_04] <> source.[avg_q_28_04]
								OR target.[avg_q_28_05] <> source.[avg_q_28_05]
								OR target.[avg_q_28_06] <> source.[avg_q_28_06]
								OR target.[avg_q_28_07] <> source.[avg_q_28_07]
								OR target.[avg_q_28_08] <> source.[avg_q_28_08]
								OR target.[avg_q_28_09] <> source.[avg_q_28_09]
								OR target.[avg_q_28_10] <> source.[avg_q_28_10]
								OR target.[avg_q_29_00] <> source.[avg_q_29_00]
								OR target.[avg_q_29_01] <> source.[avg_q_29_01]
								OR target.[avg_q_29_02] <> source.[avg_q_29_02]
								OR target.[avg_q_29_03] <> source.[avg_q_29_03]
								OR target.[avg_q_29_04] <> source.[avg_q_29_04]
								OR target.[avg_q_29_05] <> source.[avg_q_29_05]
								OR target.[avg_q_29_06] <> source.[avg_q_29_06]
								OR target.[avg_q_29_07] <> source.[avg_q_29_07]
								OR target.[avg_q_29_08] <> source.[avg_q_29_08]
								OR target.[avg_q_29_09] <> source.[avg_q_29_09]
								OR target.[avg_q_29_10] <> source.[avg_q_29_10]
								OR target.[avg_q_30_00] <> source.[avg_q_30_00]
								OR target.[avg_q_30_01] <> source.[avg_q_30_01]
								OR target.[avg_q_30_02] <> source.[avg_q_30_02]
								OR target.[avg_q_30_03] <> source.[avg_q_30_03]
								OR target.[avg_q_30_04] <> source.[avg_q_30_04]
								OR target.[avg_q_30_05] <> source.[avg_q_30_05]
								OR target.[avg_q_30_06] <> source.[avg_q_30_06]
								OR target.[avg_q_30_07] <> source.[avg_q_30_07]
								OR target.[avg_q_30_08] <> source.[avg_q_30_08]
								OR target.[avg_q_30_09] <> source.[avg_q_30_09]
								OR target.[avg_q_30_10] <> source.[avg_q_30_10]
								OR target.[avg_q_31_00] <> source.[avg_q_31_00]
								OR target.[avg_q_31_01] <> source.[avg_q_31_01]
								OR target.[avg_q_31_02] <> source.[avg_q_31_02]
								OR target.[avg_q_31_03] <> source.[avg_q_31_03]
								OR target.[avg_q_31_04] <> source.[avg_q_31_04]
								OR target.[avg_q_31_05] <> source.[avg_q_31_05]
								OR target.[avg_q_31_06] <> source.[avg_q_31_06]
								OR target.[avg_q_31_07] <> source.[avg_q_31_07]
								OR target.[avg_q_31_08] <> source.[avg_q_31_08]
								OR target.[avg_q_31_09] <> source.[avg_q_31_09]
								OR target.[avg_q_31_10] <> source.[avg_q_31_10]
								OR target.[avg_q_32_00] <> source.[avg_q_32_00]
								OR target.[avg_q_32_01] <> source.[avg_q_32_01]
								OR target.[avg_q_32_02] <> source.[avg_q_32_02]
								OR target.[avg_q_32_03] <> source.[avg_q_32_03]
								OR target.[avg_q_32_04] <> source.[avg_q_32_04]
								OR target.[avg_q_32_05] <> source.[avg_q_32_05]
								OR target.[avg_q_32_06] <> source.[avg_q_32_06]
								OR target.[avg_q_32_07] <> source.[avg_q_32_07]
								OR target.[avg_q_32_08] <> source.[avg_q_32_08]
								OR target.[avg_q_32_09] <> source.[avg_q_32_09]
								OR target.[avg_q_32_10] <> source.[avg_q_32_10]
								OR target.[avg_q_33_00] <> source.[avg_q_33_00]
								OR target.[avg_q_33_01] <> source.[avg_q_33_01]
								OR target.[avg_q_33_02] <> source.[avg_q_33_02]
								OR target.[avg_q_33_03] <> source.[avg_q_33_03]
								OR target.[avg_q_33_04] <> source.[avg_q_33_04]
								OR target.[avg_q_33_05] <> source.[avg_q_33_05]
								OR target.[avg_q_33_06] <> source.[avg_q_33_06]
								OR target.[avg_q_33_07] <> source.[avg_q_33_07]
								OR target.[avg_q_33_08] <> source.[avg_q_33_08]
								OR target.[avg_q_33_09] <> source.[avg_q_33_09]
								OR target.[avg_q_33_10] <> source.[avg_q_33_10]
								OR target.[avg_q_34_00] <> source.[avg_q_34_00]
								OR target.[avg_q_34_01] <> source.[avg_q_34_01]
								OR target.[avg_q_34_02] <> source.[avg_q_34_02]
								OR target.[avg_q_34_03] <> source.[avg_q_34_03]
								OR target.[avg_q_34_04] <> source.[avg_q_34_04]
								OR target.[avg_q_34_05] <> source.[avg_q_34_05]
								OR target.[avg_q_34_06] <> source.[avg_q_34_06]
								OR target.[avg_q_34_07] <> source.[avg_q_34_07]
								OR target.[avg_q_34_08] <> source.[avg_q_34_08]
								OR target.[avg_q_34_09] <> source.[avg_q_34_09]
								OR target.[avg_q_34_10] <> source.[avg_q_34_10]
								OR target.[avg_q_35_00] <> source.[avg_q_35_00]
								OR target.[avg_q_35_01] <> source.[avg_q_35_01]
								OR target.[avg_q_35_02] <> source.[avg_q_35_02]
								OR target.[avg_q_35_03] <> source.[avg_q_35_03]
								OR target.[avg_q_35_04] <> source.[avg_q_35_04]
								OR target.[avg_q_35_05] <> source.[avg_q_35_05]
								OR target.[avg_q_35_06] <> source.[avg_q_35_06]
								OR target.[avg_q_35_07] <> source.[avg_q_35_07]
								OR target.[avg_q_35_08] <> source.[avg_q_35_08]
								OR target.[avg_q_35_09] <> source.[avg_q_35_09]
								OR target.[avg_q_35_10] <> source.[avg_q_35_10]
								OR target.[avg_q_36_00] <> source.[avg_q_36_00]
								OR target.[avg_q_36_01] <> source.[avg_q_36_01]
								OR target.[avg_q_36_02] <> source.[avg_q_36_02]
								OR target.[avg_q_36_03] <> source.[avg_q_36_03]
								OR target.[avg_q_36_04] <> source.[avg_q_36_04]
								OR target.[avg_q_36_05] <> source.[avg_q_36_05]
								OR target.[avg_q_36_06] <> source.[avg_q_36_06]
								OR target.[avg_q_36_07] <> source.[avg_q_36_07]
								OR target.[avg_q_36_08] <> source.[avg_q_36_08]
								OR target.[avg_q_36_09] <> source.[avg_q_36_09]
								OR target.[avg_q_36_10] <> source.[avg_q_36_10]
								OR target.[avg_q_37_00] <> source.[avg_q_37_00]
								OR target.[avg_q_37_01] <> source.[avg_q_37_01]
								OR target.[avg_q_37_02] <> source.[avg_q_37_02]
								OR target.[avg_q_37_03] <> source.[avg_q_37_03]
								OR target.[avg_q_37_04] <> source.[avg_q_37_04]
								OR target.[avg_q_37_05] <> source.[avg_q_37_05]
								OR target.[avg_q_37_06] <> source.[avg_q_37_06]
								OR target.[avg_q_37_07] <> source.[avg_q_37_07]
								OR target.[avg_q_37_08] <> source.[avg_q_37_08]
								OR target.[avg_q_37_09] <> source.[avg_q_37_09]
								OR target.[avg_q_37_10] <> source.[avg_q_37_10]
								OR target.[avg_q_38_00] <> source.[avg_q_38_00]
								OR target.[avg_q_38_01] <> source.[avg_q_38_01]
								OR target.[avg_q_38_02] <> source.[avg_q_38_02]
								OR target.[avg_q_38_03] <> source.[avg_q_38_03]
								OR target.[avg_q_38_04] <> source.[avg_q_38_04]
								OR target.[avg_q_38_05] <> source.[avg_q_38_05]
								OR target.[avg_q_38_06] <> source.[avg_q_38_06]
								OR target.[avg_q_38_07] <> source.[avg_q_38_07]
								OR target.[avg_q_38_08] <> source.[avg_q_38_08]
								OR target.[avg_q_38_09] <> source.[avg_q_38_09]
								OR target.[avg_q_38_10] <> source.[avg_q_38_10]
								OR target.[avg_q_39_00] <> source.[avg_q_39_00]
								OR target.[avg_q_39_01] <> source.[avg_q_39_01]
								OR target.[avg_q_39_02] <> source.[avg_q_39_02]
								OR target.[avg_q_39_03] <> source.[avg_q_39_03]
								OR target.[avg_q_39_04] <> source.[avg_q_39_04]
								OR target.[avg_q_39_05] <> source.[avg_q_39_05]
								OR target.[avg_q_39_06] <> source.[avg_q_39_06]
								OR target.[avg_q_39_07] <> source.[avg_q_39_07]
								OR target.[avg_q_39_08] <> source.[avg_q_39_08]
								OR target.[avg_q_39_09] <> source.[avg_q_39_09]
								OR target.[avg_q_39_10] <> source.[avg_q_39_10]
								OR target.[avg_q_40_00] <> source.[avg_q_40_00]
								OR target.[avg_q_40_01] <> source.[avg_q_40_01]
								OR target.[avg_q_40_02] <> source.[avg_q_40_02]
								OR target.[avg_q_40_03] <> source.[avg_q_40_03]
								OR target.[avg_q_40_04] <> source.[avg_q_40_04]
								OR target.[avg_q_40_05] <> source.[avg_q_40_05]
								OR target.[avg_q_40_06] <> source.[avg_q_40_06]
								OR target.[avg_q_40_07] <> source.[avg_q_40_07]
								OR target.[avg_q_40_08] <> source.[avg_q_40_08]
								OR target.[avg_q_40_09] <> source.[avg_q_40_09]
								OR target.[avg_q_40_10] <> source.[avg_q_40_10]
								OR target.[avg_q_41_00] <> source.[avg_q_41_00]
								OR target.[avg_q_41_01] <> source.[avg_q_41_01]
								OR target.[avg_q_41_02] <> source.[avg_q_41_02]
								OR target.[avg_q_41_03] <> source.[avg_q_41_03]
								OR target.[avg_q_41_04] <> source.[avg_q_41_04]
								OR target.[avg_q_41_05] <> source.[avg_q_41_05]
								OR target.[avg_q_41_06] <> source.[avg_q_41_06]
								OR target.[avg_q_41_07] <> source.[avg_q_41_07]
								OR target.[avg_q_41_08] <> source.[avg_q_41_08]
								OR target.[avg_q_41_09] <> source.[avg_q_41_09]
								OR target.[avg_q_41_10] <> source.[avg_q_41_10]
								OR target.[avg_q_42_00] <> source.[avg_q_42_00]
								OR target.[avg_q_42_01] <> source.[avg_q_42_01]
								OR target.[avg_q_42_02] <> source.[avg_q_42_02]
								OR target.[avg_q_42_03] <> source.[avg_q_42_03]
								OR target.[avg_q_42_04] <> source.[avg_q_42_04]
								OR target.[avg_q_42_05] <> source.[avg_q_42_05]
								OR target.[avg_q_42_06] <> source.[avg_q_42_06]
								OR target.[avg_q_42_07] <> source.[avg_q_42_07]
								OR target.[avg_q_42_08] <> source.[avg_q_42_08]
								OR target.[avg_q_42_09] <> source.[avg_q_42_09]
								OR target.[avg_q_42_10] <> source.[avg_q_42_10]
								OR target.[avg_q_43_00] <> source.[avg_q_43_00]
								OR target.[avg_q_43_01] <> source.[avg_q_43_01]
								OR target.[avg_q_43_02] <> source.[avg_q_43_02]
								OR target.[avg_q_43_03] <> source.[avg_q_43_03]
								OR target.[avg_q_43_04] <> source.[avg_q_43_04]
								OR target.[avg_q_43_05] <> source.[avg_q_43_05]
								OR target.[avg_q_43_06] <> source.[avg_q_43_06]
								OR target.[avg_q_43_07] <> source.[avg_q_43_07]
								OR target.[avg_q_43_08] <> source.[avg_q_43_08]
								OR target.[avg_q_43_09] <> source.[avg_q_43_09]
								OR target.[avg_q_43_10] <> source.[avg_q_43_10]
								OR target.[avg_q_44_00] <> source.[avg_q_44_00]
								OR target.[avg_q_44_01] <> source.[avg_q_44_01]
								OR target.[avg_q_44_02] <> source.[avg_q_44_02]
								OR target.[avg_q_44_03] <> source.[avg_q_44_03]
								OR target.[avg_q_44_04] <> source.[avg_q_44_04]
								OR target.[avg_q_44_05] <> source.[avg_q_44_05]
								OR target.[avg_q_44_06] <> source.[avg_q_44_06]
								OR target.[avg_q_44_07] <> source.[avg_q_44_07]
								OR target.[avg_q_44_08] <> source.[avg_q_44_08]
								OR target.[avg_q_44_09] <> source.[avg_q_44_09]
								OR target.[avg_q_44_10] <> source.[avg_q_44_10]
								OR target.[avg_q_45_00] <> source.[avg_q_45_00]
								OR target.[avg_q_45_01] <> source.[avg_q_45_01]
								OR target.[avg_q_45_02] <> source.[avg_q_45_02]
								OR target.[avg_q_45_03] <> source.[avg_q_45_03]
								OR target.[avg_q_45_04] <> source.[avg_q_45_04]
								OR target.[avg_q_45_05] <> source.[avg_q_45_05]
								OR target.[avg_q_45_06] <> source.[avg_q_45_06]
								OR target.[avg_q_45_07] <> source.[avg_q_45_07]
								OR target.[avg_q_45_08] <> source.[avg_q_45_08]
								OR target.[avg_q_45_09] <> source.[avg_q_45_09]
								OR target.[avg_q_45_10] <> source.[avg_q_45_10]
								OR target.[avg_q_46_00] <> source.[avg_q_46_00]
								OR target.[avg_q_46_01] <> source.[avg_q_46_01]
								OR target.[avg_q_46_02] <> source.[avg_q_46_02]
								OR target.[avg_q_46_03] <> source.[avg_q_46_03]
								OR target.[avg_q_46_04] <> source.[avg_q_46_04]
								OR target.[avg_q_46_05] <> source.[avg_q_46_05]
								OR target.[avg_q_46_06] <> source.[avg_q_46_06]
								OR target.[avg_q_46_07] <> source.[avg_q_46_07]
								OR target.[avg_q_46_08] <> source.[avg_q_46_08]
								OR target.[avg_q_46_09] <> source.[avg_q_46_09]
								OR target.[avg_q_46_10] <> source.[avg_q_46_10]
								OR target.[avg_q_47_00] <> source.[avg_q_47_00]
								OR target.[avg_q_47_01] <> source.[avg_q_47_01]
								OR target.[avg_q_47_02] <> source.[avg_q_47_02]
								OR target.[avg_q_47_03] <> source.[avg_q_47_03]
								OR target.[avg_q_47_04] <> source.[avg_q_47_04]
								OR target.[avg_q_47_05] <> source.[avg_q_47_05]
								OR target.[avg_q_47_06] <> source.[avg_q_47_06]
								OR target.[avg_q_47_07] <> source.[avg_q_47_07]
								OR target.[avg_q_47_08] <> source.[avg_q_47_08]
								OR target.[avg_q_47_09] <> source.[avg_q_47_09]
								OR target.[avg_q_47_10] <> source.[avg_q_47_10]
								OR target.[avg_q_48_00] <> source.[avg_q_48_00]
								OR target.[avg_q_48_01] <> source.[avg_q_48_01]
								OR target.[avg_q_48_02] <> source.[avg_q_48_02]
								OR target.[avg_q_48_03] <> source.[avg_q_48_03]
								OR target.[avg_q_48_04] <> source.[avg_q_48_04]
								OR target.[avg_q_48_05] <> source.[avg_q_48_05]
								OR target.[avg_q_48_06] <> source.[avg_q_48_06]
								OR target.[avg_q_48_07] <> source.[avg_q_48_07]
								OR target.[avg_q_48_08] <> source.[avg_q_48_08]
								OR target.[avg_q_48_09] <> source.[avg_q_48_09]
								OR target.[avg_q_48_10] <> source.[avg_q_48_10]
								OR target.[avg_q_49_00] <> source.[avg_q_49_00]
								OR target.[avg_q_49_01] <> source.[avg_q_49_01]
								OR target.[avg_q_49_02] <> source.[avg_q_49_02]
								OR target.[avg_q_49_03] <> source.[avg_q_49_03]
								OR target.[avg_q_49_04] <> source.[avg_q_49_04]
								OR target.[avg_q_49_05] <> source.[avg_q_49_05]
								OR target.[avg_q_49_06] <> source.[avg_q_49_06]
								OR target.[avg_q_49_07] <> source.[avg_q_49_07]
								OR target.[avg_q_49_08] <> source.[avg_q_49_08]
								OR target.[avg_q_49_09] <> source.[avg_q_49_09]
								OR target.[avg_q_49_10] <> source.[avg_q_49_10]
								OR target.[avg_q_50_00] <> source.[avg_q_50_00]
								OR target.[avg_q_50_01] <> source.[avg_q_50_01]
								OR target.[avg_q_50_02] <> source.[avg_q_50_02]
								OR target.[avg_q_50_03] <> source.[avg_q_50_03]
								OR target.[avg_q_50_04] <> source.[avg_q_50_04]
								OR target.[avg_q_50_05] <> source.[avg_q_50_05]
								OR target.[avg_q_50_06] <> source.[avg_q_50_06]
								OR target.[avg_q_50_07] <> source.[avg_q_50_07]
								OR target.[avg_q_50_08] <> source.[avg_q_50_08]
								OR target.[avg_q_50_09] <> source.[avg_q_50_09]
								OR target.[avg_q_50_10] <> source.[avg_q_50_10]
								OR target.[avg_q_51_00] <> source.[avg_q_51_00]
								OR target.[avg_q_51_01] <> source.[avg_q_51_01]
								OR target.[avg_q_51_02] <> source.[avg_q_51_02]
								OR target.[avg_q_51_03] <> source.[avg_q_51_03]
								OR target.[avg_q_51_04] <> source.[avg_q_51_04]
								OR target.[avg_q_51_05] <> source.[avg_q_51_05]
								OR target.[avg_q_51_06] <> source.[avg_q_51_06]
								OR target.[avg_q_51_07] <> source.[avg_q_51_07]
								OR target.[avg_q_51_08] <> source.[avg_q_51_08]
								OR target.[avg_q_51_09] <> source.[avg_q_51_09]
								OR target.[avg_q_51_10] <> source.[avg_q_51_10]
								OR target.[avg_q_52_00] <> source.[avg_q_52_00]
								OR target.[avg_q_52_01] <> source.[avg_q_52_01]
								OR target.[avg_q_52_02] <> source.[avg_q_52_02]
								OR target.[avg_q_52_03] <> source.[avg_q_52_03]
								OR target.[avg_q_52_04] <> source.[avg_q_52_04]
								OR target.[avg_q_52_05] <> source.[avg_q_52_05]
								OR target.[avg_q_52_06] <> source.[avg_q_52_06]
								OR target.[avg_q_52_07] <> source.[avg_q_52_07]
								OR target.[avg_q_52_08] <> source.[avg_q_52_08]
								OR target.[avg_q_52_09] <> source.[avg_q_52_09]
								OR target.[avg_q_52_10] <> source.[avg_q_52_10]
								OR target.[avg_q_53_00] <> source.[avg_q_53_00]
								OR target.[avg_q_53_01] <> source.[avg_q_53_01]
								OR target.[avg_q_53_02] <> source.[avg_q_53_02]
								OR target.[avg_q_53_03] <> source.[avg_q_53_03]
								OR target.[avg_q_53_04] <> source.[avg_q_53_04]
								OR target.[avg_q_53_05] <> source.[avg_q_53_05]
								OR target.[avg_q_53_06] <> source.[avg_q_53_06]
								OR target.[avg_q_53_07] <> source.[avg_q_53_07]
								OR target.[avg_q_53_08] <> source.[avg_q_53_08]
								OR target.[avg_q_53_09] <> source.[avg_q_53_09]
								OR target.[avg_q_53_10] <> source.[avg_q_53_10]
								OR target.[avg_q_54_00] <> source.[avg_q_54_00]
								OR target.[avg_q_54_01] <> source.[avg_q_54_01]
								OR target.[avg_q_54_02] <> source.[avg_q_54_02]
								OR target.[avg_q_54_03] <> source.[avg_q_54_03]
								OR target.[avg_q_54_04] <> source.[avg_q_54_04]
								OR target.[avg_q_54_05] <> source.[avg_q_54_05]
								OR target.[avg_q_54_06] <> source.[avg_q_54_06]
								OR target.[avg_q_54_07] <> source.[avg_q_54_07]
								OR target.[avg_q_54_08] <> source.[avg_q_54_08]
								OR target.[avg_q_54_09] <> source.[avg_q_54_09]
								OR target.[avg_q_54_10] <> source.[avg_q_54_10]
								OR target.[avg_q_55_00] <> source.[avg_q_55_00]
								OR target.[avg_q_55_01] <> source.[avg_q_55_01]
								OR target.[avg_q_55_02] <> source.[avg_q_55_02]
								OR target.[avg_q_55_03] <> source.[avg_q_55_03]
								OR target.[avg_q_55_04] <> source.[avg_q_55_04]
								OR target.[avg_q_55_05] <> source.[avg_q_55_05]
								OR target.[avg_q_55_06] <> source.[avg_q_55_06]
								OR target.[avg_q_55_07] <> source.[avg_q_55_07]
								OR target.[avg_q_55_08] <> source.[avg_q_55_08]
								OR target.[avg_q_55_09] <> source.[avg_q_55_09]
								OR target.[avg_q_55_10] <> source.[avg_q_55_10]
								OR target.[avg_q_56_00] <> source.[avg_q_56_00]
								OR target.[avg_q_56_01] <> source.[avg_q_56_01]
								OR target.[avg_q_56_02] <> source.[avg_q_56_02]
								OR target.[avg_q_56_03] <> source.[avg_q_56_03]
								OR target.[avg_q_56_04] <> source.[avg_q_56_04]
								OR target.[avg_q_56_05] <> source.[avg_q_56_05]
								OR target.[avg_q_56_06] <> source.[avg_q_56_06]
								OR target.[avg_q_56_07] <> source.[avg_q_56_07]
								OR target.[avg_q_56_08] <> source.[avg_q_56_08]
								OR target.[avg_q_56_09] <> source.[avg_q_56_09]
								OR target.[avg_q_56_10] <> source.[avg_q_56_10]
								OR target.[avg_q_57_00] <> source.[avg_q_57_00]
								OR target.[avg_q_57_01] <> source.[avg_q_57_01]
								OR target.[avg_q_57_02] <> source.[avg_q_57_02]
								OR target.[avg_q_57_03] <> source.[avg_q_57_03]
								OR target.[avg_q_57_04] <> source.[avg_q_57_04]
								OR target.[avg_q_57_05] <> source.[avg_q_57_05]
								OR target.[avg_q_57_06] <> source.[avg_q_57_06]
								OR target.[avg_q_57_07] <> source.[avg_q_57_07]
								OR target.[avg_q_57_08] <> source.[avg_q_57_08]
								OR target.[avg_q_57_09] <> source.[avg_q_57_09]
								OR target.[avg_q_57_10] <> source.[avg_q_57_10]
								OR target.[avg_q_58_00] <> source.[avg_q_58_00]
								OR target.[avg_q_58_01] <> source.[avg_q_58_01]
								OR target.[avg_q_58_02] <> source.[avg_q_58_02]
								OR target.[avg_q_58_03] <> source.[avg_q_58_03]
								OR target.[avg_q_58_04] <> source.[avg_q_58_04]
								OR target.[avg_q_58_05] <> source.[avg_q_58_05]
								OR target.[avg_q_58_06] <> source.[avg_q_58_06]
								OR target.[avg_q_58_07] <> source.[avg_q_58_07]
								OR target.[avg_q_58_08] <> source.[avg_q_58_08]
								OR target.[avg_q_58_09] <> source.[avg_q_58_09]
								OR target.[avg_q_58_10] <> source.[avg_q_58_10]
								OR target.[avg_q_59_00] <> source.[avg_q_59_00]
								OR target.[avg_q_59_01] <> source.[avg_q_59_01]
								OR target.[avg_q_59_02] <> source.[avg_q_59_02]
								OR target.[avg_q_59_03] <> source.[avg_q_59_03]
								OR target.[avg_q_59_04] <> source.[avg_q_59_04]
								OR target.[avg_q_59_05] <> source.[avg_q_59_05]
								OR target.[avg_q_59_06] <> source.[avg_q_59_06]
								OR target.[avg_q_59_07] <> source.[avg_q_59_07]
								OR target.[avg_q_59_08] <> source.[avg_q_59_08]
								OR target.[avg_q_59_09] <> source.[avg_q_59_09]
								OR target.[avg_q_59_10] <> source.[avg_q_59_10]
								OR target.[avg_q_60_00] <> source.[avg_q_60_00]
								OR target.[avg_q_60_01] <> source.[avg_q_60_01]
								OR target.[avg_q_60_02] <> source.[avg_q_60_02]
								OR target.[avg_q_60_03] <> source.[avg_q_60_03]
								OR target.[avg_q_60_04] <> source.[avg_q_60_04]
								OR target.[avg_q_60_05] <> source.[avg_q_60_05]
								OR target.[avg_q_60_06] <> source.[avg_q_60_06]
								OR target.[avg_q_60_07] <> source.[avg_q_60_07]
								OR target.[avg_q_60_08] <> source.[avg_q_60_08]
								OR target.[avg_q_60_09] <> source.[avg_q_60_09]
								OR target.[avg_q_60_10] <> source.[avg_q_60_10]
								OR target.[avg_q_61_00] <> source.[avg_q_61_00]
								OR target.[avg_q_61_01] <> source.[avg_q_61_01]
								OR target.[avg_q_61_02] <> source.[avg_q_61_02]
								OR target.[avg_q_61_03] <> source.[avg_q_61_03]
								OR target.[avg_q_61_04] <> source.[avg_q_61_04]
								OR target.[avg_q_61_05] <> source.[avg_q_61_05]
								OR target.[avg_q_61_06] <> source.[avg_q_61_06]
								OR target.[avg_q_61_07] <> source.[avg_q_61_07]
								OR target.[avg_q_61_08] <> source.[avg_q_61_08]
								OR target.[avg_q_61_09] <> source.[avg_q_61_09]
								OR target.[avg_q_61_10] <> source.[avg_q_61_10]
								OR target.[avg_q_62_00] <> source.[avg_q_62_00]
								OR target.[avg_q_62_01] <> source.[avg_q_62_01]
								OR target.[avg_q_62_02] <> source.[avg_q_62_02]
								OR target.[avg_q_62_03] <> source.[avg_q_62_03]
								OR target.[avg_q_62_04] <> source.[avg_q_62_04]
								OR target.[avg_q_62_05] <> source.[avg_q_62_05]
								OR target.[avg_q_62_06] <> source.[avg_q_62_06]
								OR target.[avg_q_62_07] <> source.[avg_q_62_07]
								OR target.[avg_q_62_08] <> source.[avg_q_62_08]
								OR target.[avg_q_62_09] <> source.[avg_q_62_09]
								OR target.[avg_q_62_10] <> source.[avg_q_62_10]
								OR target.[avg_q_63_00] <> source.[avg_q_63_00]
								OR target.[avg_q_63_01] <> source.[avg_q_63_01]
								OR target.[avg_q_63_02] <> source.[avg_q_63_02]
								OR target.[avg_q_63_03] <> source.[avg_q_63_03]
								OR target.[avg_q_63_04] <> source.[avg_q_63_04]
								OR target.[avg_q_63_05] <> source.[avg_q_63_05]
								OR target.[avg_q_63_06] <> source.[avg_q_63_06]
								OR target.[avg_q_63_07] <> source.[avg_q_63_07]
								OR target.[avg_q_63_08] <> source.[avg_q_63_08]
								OR target.[avg_q_63_09] <> source.[avg_q_63_09]
								OR target.[avg_q_63_10] <> source.[avg_q_63_10]
								OR target.[avg_q_64_01] <> source.[avg_q_64_01]
								OR target.[avg_q_64_02] <> source.[avg_q_64_02]
								OR target.[avg_q_64_03] <> source.[avg_q_64_03]
								OR target.[avg_q_64_04] <> source.[avg_q_64_04]
								OR target.[avg_q_64_05] <> source.[avg_q_64_05]
								OR target.[avg_q_64_06] <> source.[avg_q_64_06]
								OR target.[avg_q_64_07] <> source.[avg_q_64_07]
								OR target.[avg_q_64_08] <> source.[avg_q_64_08]
								OR target.[avg_q_64_09] <> source.[avg_q_64_09]
								OR target.[avg_q_64_10] <> source.[avg_q_64_10]
								OR target.[avg_q_65_00] <> source.[avg_q_65_00]
								OR target.[avg_q_65_01] <> source.[avg_q_65_01]
								OR target.[avg_q_65_02] <> source.[avg_q_65_02]
								OR target.[avg_q_65_03] <> source.[avg_q_65_03]
								OR target.[avg_q_65_04] <> source.[avg_q_65_04]
								OR target.[avg_q_65_05] <> source.[avg_q_65_05]
								OR target.[avg_q_65_06] <> source.[avg_q_65_06]
								OR target.[avg_q_65_07] <> source.[avg_q_65_07]
								OR target.[avg_q_65_08] <> source.[avg_q_65_08]
								OR target.[avg_q_65_09] <> source.[avg_q_65_09]
								OR target.[avg_q_65_10] <> source.[avg_q_65_10]
								OR target.[avg_q_66_00] <> source.[avg_q_66_00]
								OR target.[avg_q_66_01] <> source.[avg_q_66_01]
								OR target.[avg_q_66_02] <> source.[avg_q_66_02]
								OR target.[avg_q_66_03] <> source.[avg_q_66_03]
								OR target.[avg_q_66_04] <> source.[avg_q_66_04]
								OR target.[avg_q_66_05] <> source.[avg_q_66_05]
								OR target.[avg_q_66_06] <> source.[avg_q_66_06]
								OR target.[avg_q_66_07] <> source.[avg_q_66_07]
								OR target.[avg_q_66_08] <> source.[avg_q_66_08]
								OR target.[avg_q_66_09] <> source.[avg_q_66_09]
								OR target.[avg_q_66_10] <> source.[avg_q_66_10]
								OR target.[avg_q_67_00] <> source.[avg_q_67_00]
								OR target.[avg_q_67_01] <> source.[avg_q_67_01]
								OR target.[avg_q_67_02] <> source.[avg_q_67_02]
								OR target.[avg_q_67_03] <> source.[avg_q_67_03]
								OR target.[avg_q_67_04] <> source.[avg_q_67_04]
								OR target.[avg_q_67_05] <> source.[avg_q_67_05]
								OR target.[avg_q_67_06] <> source.[avg_q_67_06]
								OR target.[avg_q_67_07] <> source.[avg_q_67_07]
								OR target.[avg_q_67_08] <> source.[avg_q_67_08]
								OR target.[avg_q_67_09] <> source.[avg_q_67_09]
								OR target.[avg_q_67_10] <> source.[avg_q_67_10]
								OR target.[avg_q_68_00] <> source.[avg_q_68_00]
								OR target.[avg_q_68_01] <> source.[avg_q_68_01]
								OR target.[avg_q_68_02] <> source.[avg_q_68_02]
								OR target.[avg_q_68_03] <> source.[avg_q_68_03]
								OR target.[avg_q_68_04] <> source.[avg_q_68_04]
								OR target.[avg_q_68_05] <> source.[avg_q_68_05]
								OR target.[avg_q_68_06] <> source.[avg_q_68_06]
								OR target.[avg_q_68_07] <> source.[avg_q_68_07]
								OR target.[avg_q_68_08] <> source.[avg_q_68_08]
								OR target.[avg_q_68_09] <> source.[avg_q_68_09]
								OR target.[avg_q_68_10] <> source.[avg_q_68_10]
								OR target.[avg_q_69_00] <> source.[avg_q_69_00]
								OR target.[avg_q_69_01] <> source.[avg_q_69_01]
								OR target.[avg_q_69_02] <> source.[avg_q_69_02]
								OR target.[avg_q_69_03] <> source.[avg_q_69_03]
								OR target.[avg_q_69_04] <> source.[avg_q_69_04]
								OR target.[avg_q_69_05] <> source.[avg_q_69_05]
								OR target.[avg_q_69_06] <> source.[avg_q_69_06]
								OR target.[avg_q_69_07] <> source.[avg_q_69_07]
								OR target.[avg_q_69_08] <> source.[avg_q_69_08]
								OR target.[avg_q_69_09] <> source.[avg_q_69_09]
								OR target.[avg_q_69_10] <> source.[avg_q_69_10]
								OR target.[avg_q_70_00] <> source.[avg_q_70_00]
								OR target.[avg_q_70_01] <> source.[avg_q_70_01]
								OR target.[avg_q_70_02] <> source.[avg_q_70_02]
								OR target.[avg_q_70_03] <> source.[avg_q_70_03]
								OR target.[avg_q_70_04] <> source.[avg_q_70_04]
								OR target.[avg_q_70_05] <> source.[avg_q_70_05]
								OR target.[avg_q_70_06] <> source.[avg_q_70_06]
								OR target.[avg_q_70_07] <> source.[avg_q_70_07]
								OR target.[avg_q_70_08] <> source.[avg_q_70_08]
								OR target.[avg_q_70_09] <> source.[avg_q_70_09]
								OR target.[avg_q_70_10] <> source.[avg_q_70_10]
								/*
								OR target.[avg_q_71_00] <> source.[avg_q_71_00]
								OR target.[avg_q_71_01] <> source.[avg_q_71_01]
								OR target.[avg_q_71_02] <> source.[avg_q_71_02]
								OR target.[avg_q_71_03] <> source.[avg_q_71_03]
								OR target.[avg_q_71_04] <> source.[avg_q_71_04]
								OR target.[avg_q_71_05] <> source.[avg_q_71_05]
								OR target.[avg_q_71_06] <> source.[avg_q_71_06]
								OR target.[avg_q_71_07] <> source.[avg_q_71_07]
								OR target.[avg_q_71_08] <> source.[avg_q_71_08]
								OR target.[avg_q_71_09] <> source.[avg_q_71_09]
								OR target.[avg_q_71_10] <> source.[avg_q_71_10]
								OR target.[avg_q_72_00] <> source.[avg_q_72_00]
								OR target.[avg_q_72_01] <> source.[avg_q_72_01]
								OR target.[avg_q_72_02] <> source.[avg_q_72_02]
								OR target.[avg_q_72_03] <> source.[avg_q_72_03]
								OR target.[avg_q_72_04] <> source.[avg_q_72_04]
								OR target.[avg_q_72_05] <> source.[avg_q_72_05]
								OR target.[avg_q_72_06] <> source.[avg_q_72_06]
								OR target.[avg_q_72_07] <> source.[avg_q_72_07]
								OR target.[avg_q_72_08] <> source.[avg_q_72_08]
								OR target.[avg_q_72_09] <> source.[avg_q_72_09]
								OR target.[avg_q_72_10] <> source.[avg_q_72_10]
								OR target.[avg_q_73_00] <> source.[avg_q_73_00]
								OR target.[avg_q_73_01] <> source.[avg_q_73_01]
								OR target.[avg_q_73_02] <> source.[avg_q_73_02]
								OR target.[avg_q_73_03] <> source.[avg_q_73_03]
								OR target.[avg_q_73_04] <> source.[avg_q_73_04]
								OR target.[avg_q_73_05] <> source.[avg_q_73_05]
								OR target.[avg_q_73_06] <> source.[avg_q_73_06]
								OR target.[avg_q_73_07] <> source.[avg_q_73_07]
								OR target.[avg_q_73_08] <> source.[avg_q_73_08]
								OR target.[avg_q_73_09] <> source.[avg_q_73_09]
								OR target.[avg_q_73_10] <> source.[avg_q_73_10]
								OR target.[avg_q_74_00] <> source.[avg_q_74_00]
								OR target.[avg_q_74_01] <> source.[avg_q_74_01]
								OR target.[avg_q_74_02] <> source.[avg_q_74_02]
								OR target.[avg_q_74_03] <> source.[avg_q_74_03]
								OR target.[avg_q_74_04] <> source.[avg_q_74_04]
								OR target.[avg_q_74_05] <> source.[avg_q_74_05]
								OR target.[avg_q_74_06] <> source.[avg_q_74_06]
								OR target.[avg_q_74_07] <> source.[avg_q_74_07]
								OR target.[avg_q_74_08] <> source.[avg_q_74_08]
								OR target.[avg_q_74_09] <> source.[avg_q_74_09]
								OR target.[avg_q_74_10] <> source.[avg_q_74_10]
								OR target.[avg_q_75_00] <> source.[avg_q_75_00]
								OR target.[avg_q_75_01] <> source.[avg_q_75_01]
								OR target.[avg_q_75_02] <> source.[avg_q_75_02]
								OR target.[avg_q_75_03] <> source.[avg_q_75_03]
								OR target.[avg_q_75_04] <> source.[avg_q_75_04]
								OR target.[avg_q_75_05] <> source.[avg_q_75_05]
								OR target.[avg_q_75_06] <> source.[avg_q_75_06]
								OR target.[avg_q_75_07] <> source.[avg_q_75_07]
								OR target.[avg_q_75_08] <> source.[avg_q_75_08]
								OR target.[avg_q_75_09] <> source.[avg_q_75_09]
								OR target.[avg_q_75_10] <> source.[avg_q_75_10]
								*/
								OR target.[nps] <> source.[nps]
								OR target.[rpi] <> source.[rpi]
								OR target.[achievement_z-score] <> source.[achievement_z-score]
								OR target.[belonging_z-score] <> source.[belonging_z-score]
								OR target.[character_z-score] <> source.[character_z-score]
								OR target.[giving_z-score] <> source.[giving_z-score]
								OR target.[health_z-score] <> source.[health_z-score]
								OR target.[inspiration_z-score] <> source.[inspiration_z-score]
								OR target.[meaning_z-score] <> source.[meaning_z-score]
								OR target.[relationship_z-score] <> source.[relationship_z-score]
								OR target.[safety_z-score] <> source.[safety_z-score]
								OR target.[achievement_percentile] <> source.[achievement_percentile]
								OR target.[belonging_percentile] <> source.[belonging_percentile]
								OR target.[character_percentile] <> source.[character_percentile]
								OR target.[giving_percentile] <> source.[giving_percentile]
								OR target.[health_percentile] <> source.[health_percentile]
								OR target.[inspiration_percentile] <> source.[inspiration_percentile]
								OR target.[meaning_percentile] <> source.[meaning_percentile]
								OR target.[relationship_percentile] <> source.[relationship_percentile]
								OR target.[safety_percentile] <> source.[safety_percentile]
)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
		 AND LEN(source.official_association_number) > 0
		 --AND LEN(source.official_branch_number) > 0
		)
		THEN 
			INSERT ([module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					--[branch_name],
					--[official_branch_number],
					[response_count],
					[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					[avg_q_02_06],
					[avg_q_02_07],
					[avg_q_02_08],
					[avg_q_02_09],
					[avg_q_02_10],
					[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					[avg_q_03_06],
					[avg_q_03_07],
					[avg_q_03_08],
					[avg_q_03_09],
					[avg_q_03_10],
					[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					[avg_q_04_06],
					[avg_q_04_07],
					[avg_q_04_08],
					[avg_q_04_09],
					[avg_q_04_10],
					[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					[avg_q_05_06],
					[avg_q_05_07],
					[avg_q_05_08],
					[avg_q_05_09],
					[avg_q_05_10],
					[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					[avg_q_06_06],
					[avg_q_06_07],
					[avg_q_06_08],
					[avg_q_06_09],
					[avg_q_06_10],
					[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					[avg_q_07_06],
					[avg_q_07_07],
					[avg_q_07_08],
					[avg_q_07_09],
					[avg_q_07_10],
					[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					[avg_q_08_06],
					[avg_q_08_07],
					[avg_q_08_08],
					[avg_q_08_09],
					[avg_q_08_10],
					[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					[avg_q_09_06],
					[avg_q_09_07],
					[avg_q_09_08],
					[avg_q_09_09],
					[avg_q_09_10],
					[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					[avg_q_10_06],
					[avg_q_10_07],
					[avg_q_10_08],
					[avg_q_10_09],
					[avg_q_10_10],
					[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					[avg_q_11_06],
					[avg_q_11_07],
					[avg_q_11_08],
					[avg_q_11_09],
					[avg_q_11_10],
					[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					[avg_q_12_06],
					[avg_q_12_07],
					[avg_q_12_08],
					[avg_q_12_09],
					[avg_q_12_10],
					[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					[avg_q_32_00],
					[avg_q_32_01],
					[avg_q_32_02],
					[avg_q_32_03],
					[avg_q_32_04],
					[avg_q_32_05],
					[avg_q_32_06],
					[avg_q_32_07],
					[avg_q_32_08],
					[avg_q_32_09],
					[avg_q_32_10],
					[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					[avg_q_35_00],
					[avg_q_35_01],
					[avg_q_35_02],
					[avg_q_35_03],
					[avg_q_35_04],
					[avg_q_35_05],
					[avg_q_35_06],
					[avg_q_35_07],
					[avg_q_35_08],
					[avg_q_35_09],
					[avg_q_35_10],
					[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					[avg_q_43_00],
					[avg_q_43_01],
					[avg_q_43_02],
					[avg_q_43_03],
					[avg_q_43_04],
					[avg_q_43_05],
					[avg_q_43_06],
					[avg_q_43_07],
					[avg_q_43_08],
					[avg_q_43_09],
					[avg_q_43_10],
					[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					[avg_q_46_00],
					[avg_q_46_01],
					[avg_q_46_02],
					[avg_q_46_03],
					[avg_q_46_04],
					[avg_q_46_05],
					[avg_q_46_06],
					[avg_q_46_07],
					[avg_q_46_08],
					[avg_q_46_09],
					[avg_q_46_10],
					[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
					/*
					[avg_q_71_00],
					[avg_q_71_01],
					[avg_q_71_02],
					[avg_q_71_03],
					[avg_q_71_04],
					[avg_q_71_05],
					[avg_q_71_06],
					[avg_q_71_07],
					[avg_q_71_08],
					[avg_q_71_09],
					[avg_q_71_10],
					[avg_q_72_00],
					[avg_q_72_01],
					[avg_q_72_02],
					[avg_q_72_03],
					[avg_q_72_04],
					[avg_q_72_05],
					[avg_q_72_06],
					[avg_q_72_07],
					[avg_q_72_08],
					[avg_q_72_09],
					[avg_q_72_10],
					[avg_q_73_00],
					[avg_q_73_01],
					[avg_q_73_02],
					[avg_q_73_03],
					[avg_q_73_04],
					[avg_q_73_05],
					[avg_q_73_06],
					[avg_q_73_07],
					[avg_q_73_08],
					[avg_q_73_09],
					[avg_q_73_10],
					[avg_q_74_00],
					[avg_q_74_01],
					[avg_q_74_02],
					[avg_q_74_03],
					[avg_q_74_04],
					[avg_q_74_05],
					[avg_q_74_06],
					[avg_q_74_07],
					[avg_q_74_08],
					[avg_q_74_09],
					[avg_q_74_10],
					[avg_q_75_00],
					[avg_q_75_01],
					[avg_q_75_02],
					[avg_q_75_03],
					[avg_q_75_04],
					[avg_q_75_05],
					[avg_q_75_06],
					[avg_q_75_07],
					[avg_q_75_08],
					[avg_q_75_09],
					[avg_q_75_10],
					*/
					[nps],
					[rpi],
					[achievement_z-score],
					[belonging_z-score],
					[character_z-score],
					[giving_z-score],
					[health_z-score],
					[inspiration_z-score],
					[meaning_z-score],
					[relationship_z-score],
					[safety_z-score],
					[achievement_percentile],
					[belonging_percentile],
					[character_percentile],
					[giving_percentile],
					[health_percentile],
					[inspiration_percentile],
					[meaning_percentile],
					[relationship_percentile],
					[safety_percentile]

					)
			VALUES ([module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					--[branch_name],
					--[official_branch_number],
					[response_count],
					[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					[avg_q_02_06],
					[avg_q_02_07],
					[avg_q_02_08],
					[avg_q_02_09],
					[avg_q_02_10],
					[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					[avg_q_03_06],
					[avg_q_03_07],
					[avg_q_03_08],
					[avg_q_03_09],
					[avg_q_03_10],
					[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					[avg_q_04_06],
					[avg_q_04_07],
					[avg_q_04_08],
					[avg_q_04_09],
					[avg_q_04_10],
					[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					[avg_q_05_06],
					[avg_q_05_07],
					[avg_q_05_08],
					[avg_q_05_09],
					[avg_q_05_10],
					[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					[avg_q_06_06],
					[avg_q_06_07],
					[avg_q_06_08],
					[avg_q_06_09],
					[avg_q_06_10],
					[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					[avg_q_07_06],
					[avg_q_07_07],
					[avg_q_07_08],
					[avg_q_07_09],
					[avg_q_07_10],
					[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					[avg_q_08_06],
					[avg_q_08_07],
					[avg_q_08_08],
					[avg_q_08_09],
					[avg_q_08_10],
					[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					[avg_q_09_06],
					[avg_q_09_07],
					[avg_q_09_08],
					[avg_q_09_09],
					[avg_q_09_10],
					[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					[avg_q_10_06],
					[avg_q_10_07],
					[avg_q_10_08],
					[avg_q_10_09],
					[avg_q_10_10],
					[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					[avg_q_11_06],
					[avg_q_11_07],
					[avg_q_11_08],
					[avg_q_11_09],
					[avg_q_11_10],
					[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					[avg_q_12_06],
					[avg_q_12_07],
					[avg_q_12_08],
					[avg_q_12_09],
					[avg_q_12_10],
					[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					[avg_q_32_00],
					[avg_q_32_01],
					[avg_q_32_02],
					[avg_q_32_03],
					[avg_q_32_04],
					[avg_q_32_05],
					[avg_q_32_06],
					[avg_q_32_07],
					[avg_q_32_08],
					[avg_q_32_09],
					[avg_q_32_10],
					[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					[avg_q_35_00],
					[avg_q_35_01],
					[avg_q_35_02],
					[avg_q_35_03],
					[avg_q_35_04],
					[avg_q_35_05],
					[avg_q_35_06],
					[avg_q_35_07],
					[avg_q_35_08],
					[avg_q_35_09],
					[avg_q_35_10],
					[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					[avg_q_43_00],
					[avg_q_43_01],
					[avg_q_43_02],
					[avg_q_43_03],
					[avg_q_43_04],
					[avg_q_43_05],
					[avg_q_43_06],
					[avg_q_43_07],
					[avg_q_43_08],
					[avg_q_43_09],
					[avg_q_43_10],
					[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					[avg_q_46_00],
					[avg_q_46_01],
					[avg_q_46_02],
					[avg_q_46_03],
					[avg_q_46_04],
					[avg_q_46_05],
					[avg_q_46_06],
					[avg_q_46_07],
					[avg_q_46_08],
					[avg_q_46_09],
					[avg_q_46_10],
					[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
					/*
					[avg_q_71_00],
					[avg_q_71_01],
					[avg_q_71_02],
					[avg_q_71_03],
					[avg_q_71_04],
					[avg_q_71_05],
					[avg_q_71_06],
					[avg_q_71_07],
					[avg_q_71_08],
					[avg_q_71_09],
					[avg_q_71_10],
					[avg_q_72_00],
					[avg_q_72_01],
					[avg_q_72_02],
					[avg_q_72_03],
					[avg_q_72_04],
					[avg_q_72_05],
					[avg_q_72_06],
					[avg_q_72_07],
					[avg_q_72_08],
					[avg_q_72_09],
					[avg_q_72_10],
					[avg_q_73_00],
					[avg_q_73_01],
					[avg_q_73_02],
					[avg_q_73_03],
					[avg_q_73_04],
					[avg_q_73_05],
					[avg_q_73_06],
					[avg_q_73_07],
					[avg_q_73_08],
					[avg_q_73_09],
					[avg_q_73_10],
					[avg_q_74_00],
					[avg_q_74_01],
					[avg_q_74_02],
					[avg_q_74_03],
					[avg_q_74_04],
					[avg_q_74_05],
					[avg_q_74_06],
					[avg_q_74_07],
					[avg_q_74_08],
					[avg_q_74_09],
					[avg_q_74_10],
					[avg_q_75_00],
					[avg_q_75_01],
					[avg_q_75_02],
					[avg_q_75_03],
					[avg_q_75_04],
					[avg_q_75_05],
					[avg_q_75_06],
					[avg_q_75_07],
					[avg_q_75_08],
					[avg_q_75_09],
					[avg_q_75_10],
					*/
					[nps],
					[rpi],
					[achievement_z-score],
					[belonging_z-score],
					[character_z-score],
					[giving_z-score],
					[health_z-score],
					[inspiration_z-score],
					[meaning_z-score],
					[relationship_z-score],
					[safety_z-score],
					[achievement_percentile],
					[belonging_percentile],
					[character_percentile],
					[giving_percentile],
					[health_percentile],
					[inspiration_percentile],
					[meaning_percentile],
					[relationship_percentile],
					[safety_percentile]
)
					
	;
COMMIT TRAN

BEGIN TRAN
MERGE	Seer_ODS.dbo.Aggregated_Data AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					1 current_indicator,
					'Program' module,
					A.[Aggregate_Type] [aggregate_type],
					A.[Response_Load_Date] [response_load_date],
					A.[Form_Code] [form_code],
					CASE WHEN LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'National' THEN '0000'
						ELSE A.[OFF_ASSOC_NUM]
					END [official_association_number],
					CASE WHEN A.[Aggregate_Type] = 'National' THEN 'All Associations'
						ELSE REPLACE(A.[ASSOCIATION_NAME], '"', '')
					END [association_name],
					/*
					CASE WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) <> 3 THEN A.[OFF_ASSOC_NUM]
						 WHEN A.[Aggregate_Type] = 'National' THEN '0000'
						 WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
						 ELSE COALESCE(A.[OFF_BR_Num], '')
					END [official_branch_number],
					CASE WHEN A.[Aggregate_Type] = 'Association' THEN REPLACE(A.[ASSOCIATION_NAME], '"', '')
						 WHEN A.[Aggregate_Type] = 'National' THEN 'All Associations'
						 WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
						 ELSE COALESCE(A.[BRANCH_NAME], '')
					END [branch_name],
					*/
					CASE WHEN LEN(COALESCE(A.[Response_Count], '')) = 0 THEN 0
						ELSE A.Response_Count
					END  [response_count],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_00] END [avg_q_01_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_01] END [avg_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_02] END [avg_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_03] END [avg_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_04] END [avg_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_05] END [avg_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_06] END [avg_q_01_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_07] END [avg_q_01_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_08] END [avg_q_01_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_09] END [avg_q_01_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_10] END [avg_q_01_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_00] END [avg_q_02_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_01] END [avg_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_02] END [avg_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_03] END [avg_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_04] END [avg_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_05] END [avg_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_06] END [avg_q_02_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_07] END [avg_q_02_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_08] END [avg_q_02_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_09] END [avg_q_02_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_10] END [avg_q_02_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_00] END [avg_q_03_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_01] END [avg_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_02] END [avg_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_03] END [avg_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_04] END [avg_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_05] END [avg_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_06] END [avg_q_03_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_07] END [avg_q_03_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_08] END [avg_q_03_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_09] END [avg_q_03_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_10] END [avg_q_03_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_00] END [avg_q_04_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_01] END [avg_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_02] END [avg_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_03] END [avg_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_04] END [avg_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_05] END [avg_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_06] END [avg_q_04_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_07] END [avg_q_04_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_08] END [avg_q_04_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_09] END [avg_q_04_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_10] END [avg_q_04_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_00] END [avg_q_05_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_01] END [avg_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_02] END [avg_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_03] END [avg_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_04] END [avg_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_05] END [avg_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_06] END [avg_q_05_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_07] END [avg_q_05_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_08] END [avg_q_05_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_09] END [avg_q_05_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_10] END [avg_q_05_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_00] END [avg_q_06_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_01] END [avg_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_02] END [avg_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_03] END [avg_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_04] END [avg_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_05] END [avg_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_06] END [avg_q_06_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_07] END [avg_q_06_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_08] END [avg_q_06_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_09] END [avg_q_06_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_10] END [avg_q_06_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_00] END [avg_q_07_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_01] END [avg_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_02] END [avg_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_03] END [avg_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_04] END [avg_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_05] END [avg_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_06] END [avg_q_07_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_07] END [avg_q_07_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_08] END [avg_q_07_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_09] END [avg_q_07_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_10] END [avg_q_07_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_00] END [avg_q_08_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_01] END [avg_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_02] END [avg_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_03] END [avg_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_04] END [avg_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_05] END [avg_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_06] END [avg_q_08_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_07] END [avg_q_08_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_08] END [avg_q_08_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_09] END [avg_q_08_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_10] END [avg_q_08_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_00] END [avg_q_09_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_01] END [avg_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_02] END [avg_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_03] END [avg_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_04] END [avg_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_05] END [avg_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_06] END [avg_q_09_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_07] END [avg_q_09_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_08] END [avg_q_09_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_09] END [avg_q_09_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_10] END [avg_q_09_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_00] END [avg_q_10_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_01] END [avg_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_02] END [avg_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_03] END [avg_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_04] END [avg_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_05] END [avg_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_06] END [avg_q_10_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_07] END [avg_q_10_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_08] END [avg_q_10_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_09] END [avg_q_10_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_10] END [avg_q_10_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_00] END [avg_q_11_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_01] END [avg_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_02] END [avg_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_03] END [avg_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_04] END [avg_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_05] END [avg_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_06] END [avg_q_11_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_07] END [avg_q_11_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_08] END [avg_q_11_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_09] END [avg_q_11_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_10] END [avg_q_11_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_00] END [avg_q_12_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_01] END [avg_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_02] END [avg_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_03] END [avg_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_04] END [avg_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_05] END [avg_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_06] END [avg_q_12_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_07] END [avg_q_12_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_08] END [avg_q_12_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_09] END [avg_q_12_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_10] END [avg_q_12_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_00] END [avg_q_13_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_01] END [avg_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_02] END [avg_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_03] END [avg_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_04] END [avg_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_05] END [avg_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_06] END [avg_q_13_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_07] END [avg_q_13_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_08] END [avg_q_13_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_09] END [avg_q_13_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_10] END [avg_q_13_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_00] END [avg_q_14_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_01] END [avg_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_02] END [avg_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_03] END [avg_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_04] END [avg_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_05] END [avg_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_06] END [avg_q_14_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_07] END [avg_q_14_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_08] END [avg_q_14_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_09] END [avg_q_14_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_10] END [avg_q_14_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_00] END [avg_q_15_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_01] END [avg_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_02] END [avg_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_03] END [avg_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_04] END [avg_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_05] END [avg_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_06] END [avg_q_15_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_07] END [avg_q_15_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_08] END [avg_q_15_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_09] END [avg_q_15_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_10] END [avg_q_15_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_00] END [avg_q_16_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_01] END [avg_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_02] END [avg_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_03] END [avg_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_04] END [avg_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_05] END [avg_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_06] END [avg_q_16_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_07] END [avg_q_16_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_08] END [avg_q_16_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_09] END [avg_q_16_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_10] END [avg_q_16_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_00] END [avg_q_17_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_01] END [avg_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_02] END [avg_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_03] END [avg_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_04] END [avg_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_05] END [avg_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_06] END [avg_q_17_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_07] END [avg_q_17_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_08] END [avg_q_17_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_09] END [avg_q_17_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_10] END [avg_q_17_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_00] END [avg_q_18_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_01] END [avg_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_02] END [avg_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_03] END [avg_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_04] END [avg_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_05] END [avg_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_06] END [avg_q_18_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_07] END [avg_q_18_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_08] END [avg_q_18_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_09] END [avg_q_18_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_10] END [avg_q_18_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_00] END [avg_q_19_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_01] END [avg_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_02] END [avg_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_03] END [avg_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_04] END [avg_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_05] END [avg_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_06] END [avg_q_19_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_07] END [avg_q_19_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_08] END [avg_q_19_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_09] END [avg_q_19_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_10] END [avg_q_19_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_00] END [avg_q_20_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_01] END [avg_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_02] END [avg_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_03] END [avg_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_04] END [avg_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_05] END [avg_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_06] END [avg_q_20_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_07] END [avg_q_20_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_08] END [avg_q_20_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_09] END [avg_q_20_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_10] END [avg_q_20_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_00] END [avg_q_21_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_01] END [avg_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_02] END [avg_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_03] END [avg_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_04] END [avg_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_05] END [avg_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_06] END [avg_q_21_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_07] END [avg_q_21_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_08] END [avg_q_21_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_09] END [avg_q_21_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_10] END [avg_q_21_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_00] END [avg_q_22_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_01] END [avg_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_02] END [avg_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_03] END [avg_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_04] END [avg_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_05] END [avg_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_06] END [avg_q_22_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_07] END [avg_q_22_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_08] END [avg_q_22_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_09] END [avg_q_22_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_10] END [avg_q_22_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_00] END [avg_q_23_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_01] END [avg_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_02] END [avg_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_03] END [avg_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_04] END [avg_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_05] END [avg_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_06] END [avg_q_23_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_07] END [avg_q_23_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_08] END [avg_q_23_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_09] END [avg_q_23_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_10] END [avg_q_23_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_00] END [avg_q_24_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_01] END [avg_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_02] END [avg_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_03] END [avg_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_04] END [avg_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_05] END [avg_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_06] END [avg_q_24_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_07] END [avg_q_24_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_08] END [avg_q_24_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_09] END [avg_q_24_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_10] END [avg_q_24_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_00] END [avg_q_25_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_01] END [avg_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_02] END [avg_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_03] END [avg_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_04] END [avg_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_05] END [avg_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_06] END [avg_q_25_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_07] END [avg_q_25_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_08] END [avg_q_25_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_09] END [avg_q_25_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_10] END [avg_q_25_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_00] END [avg_q_26_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_01] END [avg_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_02] END [avg_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_03] END [avg_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_04] END [avg_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_05] END [avg_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_06] END [avg_q_26_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_07] END [avg_q_26_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_08] END [avg_q_26_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_09] END [avg_q_26_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_10] END [avg_q_26_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_00] END [avg_q_27_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_01] END [avg_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_02] END [avg_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_03] END [avg_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_04] END [avg_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_05] END [avg_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_06] END [avg_q_27_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_07] END [avg_q_27_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_08] END [avg_q_27_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_09] END [avg_q_27_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_10] END [avg_q_27_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_00] END [avg_q_28_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_01] END [avg_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_02] END [avg_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_03] END [avg_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_04] END [avg_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_05] END [avg_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_06] END [avg_q_28_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_07] END [avg_q_28_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_08] END [avg_q_28_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_09] END [avg_q_28_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_10] END [avg_q_28_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_00] END [avg_q_29_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_01] END [avg_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_02] END [avg_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_03] END [avg_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_04] END [avg_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_05] END [avg_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_06] END [avg_q_29_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_07] END [avg_q_29_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_08] END [avg_q_29_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_09] END [avg_q_29_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_10] END [avg_q_29_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_00] END [avg_q_30_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_01] END [avg_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_02] END [avg_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_03] END [avg_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_04] END [avg_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_05] END [avg_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_06] END [avg_q_30_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_07] END [avg_q_30_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_08] END [avg_q_30_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_09] END [avg_q_30_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_10] END [avg_q_30_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_00] END [avg_q_31_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_01] END [avg_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_02] END [avg_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_03] END [avg_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_04] END [avg_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_05] END [avg_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_06] END [avg_q_31_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_07] END [avg_q_31_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_08] END [avg_q_31_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_09] END [avg_q_31_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_10] END [avg_q_31_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_00] END [avg_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_01] END [avg_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_02] END [avg_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_03] END [avg_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_04] END [avg_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_05] END [avg_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_06] END [avg_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_07] END [avg_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_08] END [avg_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_09] END [avg_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_10] END [avg_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_00] END [avg_q_33_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_01] END [avg_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_02] END [avg_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_03] END [avg_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_04] END [avg_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_05] END [avg_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_06] END [avg_q_33_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_07] END [avg_q_33_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_08] END [avg_q_33_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_09] END [avg_q_33_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_10] END [avg_q_33_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_00] END [avg_q_34_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_01] END [avg_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_02] END [avg_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_03] END [avg_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_04] END [avg_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_05] END [avg_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_06] END [avg_q_34_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_07] END [avg_q_34_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_08] END [avg_q_34_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_09] END [avg_q_34_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_10] END [avg_q_34_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_00] END [avg_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_01] END [avg_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_02] END [avg_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_03] END [avg_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_04] END [avg_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_05] END [avg_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_06] END [avg_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_07] END [avg_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_08] END [avg_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_09] END [avg_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_10] END [avg_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_00] END [avg_q_36_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_01] END [avg_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_02] END [avg_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_03] END [avg_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_04] END [avg_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_05] END [avg_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_06] END [avg_q_36_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_07] END [avg_q_36_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_08] END [avg_q_36_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_09] END [avg_q_36_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_10] END [avg_q_36_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_00] END [avg_q_37_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_01] END [avg_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_02] END [avg_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_03] END [avg_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_04] END [avg_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_05] END [avg_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_06] END [avg_q_37_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_07] END [avg_q_37_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_08] END [avg_q_37_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_09] END [avg_q_37_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_10] END [avg_q_37_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_00] END [avg_q_38_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_01] END [avg_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_02] END [avg_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_03] END [avg_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_04] END [avg_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_05] END [avg_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_06] END [avg_q_38_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_07] END [avg_q_38_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_08] END [avg_q_38_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_09] END [avg_q_38_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_10] END [avg_q_38_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_00] END [avg_q_39_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_01] END [avg_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_02] END [avg_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_03] END [avg_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_04] END [avg_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_05] END [avg_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_06] END [avg_q_39_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_07] END [avg_q_39_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_08] END [avg_q_39_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_09] END [avg_q_39_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_10] END [avg_q_39_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_00] END [avg_q_40_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_01] END [avg_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_02] END [avg_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_03] END [avg_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_04] END [avg_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_05] END [avg_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_06] END [avg_q_40_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_07] END [avg_q_40_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_08] END [avg_q_40_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_09] END [avg_q_40_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_10] END [avg_q_40_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_00] END [avg_q_41_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_01] END [avg_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_02] END [avg_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_03] END [avg_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_04] END [avg_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_05] END [avg_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_06] END [avg_q_41_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_07] END [avg_q_41_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_08] END [avg_q_41_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_09] END [avg_q_41_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_10] END [avg_q_41_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_00] END [avg_q_42_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_01] END [avg_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_02] END [avg_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_03] END [avg_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_04] END [avg_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_05] END [avg_q_42_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_06] END [avg_q_42_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_07] END [avg_q_42_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_08] END [avg_q_42_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_09] END [avg_q_42_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_10] END [avg_q_42_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_00] END [avg_q_43_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_01] END [avg_q_43_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_02] END [avg_q_43_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_03] END [avg_q_43_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_04] END [avg_q_43_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_05] END [avg_q_43_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_06] END [avg_q_43_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_07] END [avg_q_43_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_08] END [avg_q_43_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_09] END [avg_q_43_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_43_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_43_10] END [avg_q_43_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_00] END [avg_q_44_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_01] END [avg_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_02] END [avg_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_03] END [avg_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_04] END [avg_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_05] END [avg_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_06] END [avg_q_44_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_07] END [avg_q_44_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_08] END [avg_q_44_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_09] END [avg_q_44_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_10] END [avg_q_44_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_00] END [avg_q_45_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_01] END [avg_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_02] END [avg_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_03] END [avg_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_04] END [avg_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_05] END [avg_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_06] END [avg_q_45_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_07] END [avg_q_45_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_08] END [avg_q_45_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_09] END [avg_q_45_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_10] END [avg_q_45_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_00] END [avg_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_01] END [avg_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_02] END [avg_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_03] END [avg_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_04] END [avg_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_05] END [avg_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_06] END [avg_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_07] END [avg_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_08] END [avg_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_09] END [avg_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_10] END [avg_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_00] END [avg_q_47_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_01] END [avg_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_02] END [avg_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_03] END [avg_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_04] END [avg_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_05] END [avg_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_06] END [avg_q_47_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_07] END [avg_q_47_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_08] END [avg_q_47_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_09] END [avg_q_47_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_10] END [avg_q_47_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_00] END [avg_q_48_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_01] END [avg_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_02] END [avg_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_03] END [avg_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_04] END [avg_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_05] END [avg_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_06] END [avg_q_48_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_07] END [avg_q_48_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_08] END [avg_q_48_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_09] END [avg_q_48_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_10] END [avg_q_48_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_00] END [avg_q_49_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_01] END [avg_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_02] END [avg_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_03] END [avg_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_04] END [avg_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_05] END [avg_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_06] END [avg_q_49_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_07] END [avg_q_49_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_08] END [avg_q_49_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_09] END [avg_q_49_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_10] END [avg_q_49_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_00] END [avg_q_50_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_01] END [avg_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_02] END [avg_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_03] END [avg_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_04] END [avg_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_05] END [avg_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_06] END [avg_q_50_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_07] END [avg_q_50_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_08] END [avg_q_50_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_09] END [avg_q_50_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_10] END [avg_q_50_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_00] END [avg_q_51_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_01] END [avg_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_02] END [avg_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_03] END [avg_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_04] END [avg_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_05] END [avg_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_06] END [avg_q_51_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_07] END [avg_q_51_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_08] END [avg_q_51_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_09] END [avg_q_51_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_10] END [avg_q_51_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_00] END [avg_q_52_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_01] END [avg_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_02] END [avg_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_03] END [avg_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_04] END [avg_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_05] END [avg_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_06] END [avg_q_52_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_07] END [avg_q_52_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_08] END [avg_q_52_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_09] END [avg_q_52_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_10] END [avg_q_52_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_00] END [avg_q_53_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_01] END [avg_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_02] END [avg_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_03] END [avg_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_04] END [avg_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_05] END [avg_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_06] END [avg_q_53_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_07] END [avg_q_53_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_08] END [avg_q_53_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_09] END [avg_q_53_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_10] END [avg_q_53_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_00] END [avg_q_54_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_01] END [avg_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_02] END [avg_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_03] END [avg_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_04] END [avg_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_05] END [avg_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_06] END [avg_q_54_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_07] END [avg_q_54_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_08] END [avg_q_54_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_09] END [avg_q_54_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_10] END [avg_q_54_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_00] END [avg_q_55_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_01] END [avg_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_02] END [avg_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_03] END [avg_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_04] END [avg_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_05] END [avg_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_06] END [avg_q_55_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_07] END [avg_q_55_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_08] END [avg_q_55_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_09] END [avg_q_55_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_10] END [avg_q_55_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_00] END [avg_q_56_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_01] END [avg_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_02] END [avg_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_03] END [avg_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_04] END [avg_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_05] END [avg_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_06] END [avg_q_56_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_07] END [avg_q_56_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_08] END [avg_q_56_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_09] END [avg_q_56_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_10] END [avg_q_56_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_00] END [avg_q_57_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_01] END [avg_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_02] END [avg_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_03] END [avg_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_04] END [avg_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_05] END [avg_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_06] END [avg_q_57_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_07] END [avg_q_57_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_08] END [avg_q_57_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_09] END [avg_q_57_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_10] END [avg_q_57_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_00] END [avg_q_58_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_01] END [avg_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_02] END [avg_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_03] END [avg_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_04] END [avg_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_05] END [avg_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_06] END [avg_q_58_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_07] END [avg_q_58_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_08] END [avg_q_58_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_09] END [avg_q_58_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_10] END [avg_q_58_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_00] END [avg_q_59_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_01] END [avg_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_02] END [avg_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_03] END [avg_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_04] END [avg_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_05] END [avg_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_06] END [avg_q_59_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_07] END [avg_q_59_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_08] END [avg_q_59_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_09] END [avg_q_59_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_10] END [avg_q_59_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_00] END [avg_q_60_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_01] END [avg_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_02] END [avg_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_03] END [avg_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_04] END [avg_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_05] END [avg_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_06] END [avg_q_60_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_07] END [avg_q_60_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_08] END [avg_q_60_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_09] END [avg_q_60_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_10] END [avg_q_60_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_00] END [avg_q_61_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_01] END [avg_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_02] END [avg_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_03] END [avg_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_04] END [avg_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_05] END [avg_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_06] END [avg_q_61_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_07] END [avg_q_61_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_08] END [avg_q_61_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_09] END [avg_q_61_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_10] END [avg_q_61_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_00] END [avg_q_62_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_01] END [avg_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_02] END [avg_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_03] END [avg_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_04] END [avg_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_05] END [avg_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_06] END [avg_q_62_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_07] END [avg_q_62_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_08] END [avg_q_62_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_09] END [avg_q_62_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_10] END [avg_q_62_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_00] END [avg_q_63_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_01] END [avg_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_02] END [avg_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_03] END [avg_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_04] END [avg_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_05] END [avg_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_06] END [avg_q_63_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_07] END [avg_q_63_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_08] END [avg_q_63_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_09] END [avg_q_63_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_10] END [avg_q_63_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_00] END [avg_q_64_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_01] END [avg_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_02] END [avg_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_03] END [avg_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_04] END [avg_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_05] END [avg_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_06] END [avg_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_07] END [avg_q_64_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_08] END [avg_q_64_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_09] END [avg_q_64_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_10] END [avg_q_64_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_00] END [avg_q_65_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_01] END [avg_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_02] END [avg_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_03] END [avg_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_04] END [avg_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_05] END [avg_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_06] END [avg_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_07] END [avg_q_65_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_08] END [avg_q_65_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_09] END [avg_q_65_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_10] END [avg_q_65_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_00] END [avg_q_66_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_01] END [avg_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_02] END [avg_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_03] END [avg_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_04] END [avg_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_05] END [avg_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_06] END [avg_q_66_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_07] END [avg_q_66_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_08] END [avg_q_66_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_09] END [avg_q_66_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_10] END [avg_q_66_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_00] END [avg_q_67_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_01] END [avg_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_02] END [avg_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_03] END [avg_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_04] END [avg_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_05] END [avg_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_06] END [avg_q_67_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_07] END [avg_q_67_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_08] END [avg_q_67_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_09] END [avg_q_67_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_10] END [avg_q_67_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_00] END [avg_q_68_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_01] END [avg_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_02] END [avg_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_03] END [avg_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_04] END [avg_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_05] END [avg_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_06] END [avg_q_68_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_07] END [avg_q_68_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_08] END [avg_q_68_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_09] END [avg_q_68_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_10] END [avg_q_68_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_00] END [avg_q_69_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_01] END [avg_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_02] END [avg_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_03] END [avg_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_04] END [avg_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_05] END [avg_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_06] END [avg_q_69_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_07] END [avg_q_69_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_08] END [avg_q_69_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_09] END [avg_q_69_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_10] END [avg_q_69_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_00] END [avg_q_70_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_01] END [avg_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_02] END [avg_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_03] END [avg_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_04] END [avg_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_05] END [avg_q_70_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_06] END [avg_q_70_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_07] END [avg_q_70_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_08] END [avg_q_70_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_09] END [avg_q_70_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_10] END [avg_q_70_10],
					/*
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_00] END [avg_q_71_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_01] END [avg_q_71_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_02] END [avg_q_71_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_03] END [avg_q_71_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_04] END [avg_q_71_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_05] END [avg_q_71_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_06] END [avg_q_71_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_07] END [avg_q_71_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_08] END [avg_q_71_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_09] END [avg_q_71_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_71_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_71_10] END [avg_q_71_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_00] END [avg_q_72_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_01] END [avg_q_72_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_02] END [avg_q_72_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_03] END [avg_q_72_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_04] END [avg_q_72_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_05] END [avg_q_72_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_06] END [avg_q_72_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_07] END [avg_q_72_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_08] END [avg_q_72_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_09] END [avg_q_72_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_72_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_72_10] END [avg_q_72_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_00] END [avg_q_73_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_01] END [avg_q_73_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_02] END [avg_q_73_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_03] END [avg_q_73_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_04] END [avg_q_73_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_05] END [avg_q_73_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_06] END [avg_q_73_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_07] END [avg_q_73_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_08] END [avg_q_73_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_09] END [avg_q_73_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_73_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_73_10] END [avg_q_73_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_00] END [avg_q_74_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_01] END [avg_q_74_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_02] END [avg_q_74_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_03] END [avg_q_74_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_04] END [avg_q_74_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_05] END [avg_q_74_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_06] END [avg_q_74_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_07] END [avg_q_74_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_08] END [avg_q_74_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_09] END [avg_q_74_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_74_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_74_10] END [avg_q_74_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_00] END [avg_q_75_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_01] END [avg_q_75_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_02] END [avg_q_75_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_03] END [avg_q_75_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_04] END [avg_q_75_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_05] END [avg_q_75_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_06] END [avg_q_75_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_07] END [avg_q_75_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_08] END [avg_q_75_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_09] END [avg_q_75_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_75_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_75_10] END [avg_q_75_10],
					*/
					CASE WHEN LEN(COALESCE(A.[NPS], '')) = 0 THEN '0' ELSE A.[NPS] END [nps],
					CASE WHEN LEN(COALESCE(A.[RPI], '')) = 0 THEN '0' ELSE A.[RPI] END [rpi],
					CASE WHEN LEN(COALESCE(A.[Achievement Z-Score], '')) = 0 THEN '0' ELSE A.[Achievement Z-Score] END [achievement_z-score],
					CASE WHEN LEN(COALESCE(A.[Belonging Z-Score], '')) = 0 THEN '0' ELSE A.[Belonging Z-Score] END [belonging_z-score],
					CASE WHEN LEN(COALESCE(A.[Character Z-Score], '')) = 0 THEN '0' ELSE A.[Character Z-Score] END [character_z-score],
					CASE WHEN LEN(COALESCE(A.[Giving Z-Score], '')) = 0 THEN '0' ELSE A.[Giving Z-Score] END [giving_z-score],
					CASE WHEN LEN(COALESCE(A.[Health Z-Score], '')) = 0 THEN '0' ELSE A.[Health Z-Score] END [health_z-score],
					CASE WHEN LEN(COALESCE(A.[Inspiration Z-Score], '')) = 0 THEN '0' ELSE A.[Inspiration Z-Score] END [inspiration_z-score],
					CASE WHEN LEN(COALESCE(A.[Meaning Z-Score], '')) = 0 THEN '0' ELSE A.[Meaning Z-Score] END [meaning_z-score],
					CASE WHEN LEN(COALESCE(A.[Relationship Z-Score], '')) = 0 THEN '0' ELSE A.[Relationship Z-Score] END [relationship_z-score],
					CASE WHEN LEN(COALESCE(A.[Safety Z-Score], '')) = 0 THEN '0' ELSE A.[Safety Z-Score] END [safety_z-score],
					CASE WHEN LEN(COALESCE(A.[Achievement Percentile], '')) = 0 THEN '0' ELSE A.[Achievement Percentile] END [achievement_percentile],
					CASE WHEN LEN(COALESCE(A.[Belonging Percentile], '')) = 0 THEN '0' ELSE A.[Belonging Percentile] END [belonging_percentile],
					CASE WHEN LEN(COALESCE(A.[Character Percentile], '')) = 0 THEN '0' ELSE A.[Character Percentile] END [character_percentile],
					CASE WHEN LEN(COALESCE(A.[Giving Percentile], '')) = 0 THEN '0' ELSE A.[Giving Percentile] END [giving_percentile],
					CASE WHEN LEN(COALESCE(A.[Health Percentile], '')) = 0 THEN '0' ELSE A.[Health Percentile] END [health_percentile],
					CASE WHEN LEN(COALESCE(A.[Inspiration Percentile], '')) = 0 THEN '0' ELSE A.[Inspiration Percentile] END [inspiration_percentile],
					CASE WHEN LEN(COALESCE(A.[Meaning Percentile], '')) = 0 THEN '0' ELSE A.[Meaning Percentile] END [meaning_percentile],
					CASE WHEN LEN(COALESCE(A.[Relationship Percentile], '')) = 0 THEN '0' ELSE A.[Relationship Percentile] END [relationship_percentile],
					CASE WHEN LEN(COALESCE(A.[Safety Percentile], '')) = 0 THEN '0' ELSE A.[Safety Percentile] END [safety_percentile]

			FROM	Seer_STG.dbo.[Program Aggregated Data] A
						
			WHERE	((ISNUMERIC(A.[response_count]) = 1) OR (LEN(COALESCE(A.[response_count], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_01_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_01_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_02_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_02_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_03_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_03_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_04_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_04_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_05_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_05_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_06_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_06_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_07_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_07_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_08_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_08_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_09_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_09_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_10_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_10_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_11_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_11_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_12_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_12_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_13_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_13_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_14_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_14_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_15_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_15_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_16_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_16_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_17_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_17_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_18_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_18_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_19_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_19_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_20_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_20_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_21_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_21_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_22_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_22_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_23_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_23_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_24_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_24_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_25_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_25_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_26_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_26_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_27_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_27_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_28_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_28_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_29_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_29_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_30_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_30_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_31_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_31_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_33_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_33_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_34_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_34_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_36_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_36_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_37_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_37_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_38_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_38_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_39_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_39_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_40_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_40_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_41_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_41_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_42_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_42_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_43_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_43_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_44_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_44_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_45_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_45_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_47_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_47_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_48_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_48_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_49_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_49_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_50_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_50_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_51_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_51_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_52_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_52_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_53_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_53_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_54_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_54_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_55_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_55_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_56_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_56_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_57_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_57_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_58_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_58_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_59_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_59_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_60_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_60_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_61_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_61_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_62_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_62_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_63_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_63_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_64_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_64_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_65_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_65_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_66_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_66_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_67_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_67_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_68_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_68_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_69_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_69_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_70_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_70_10], '')) = 0))
					/*
					AND ((ISNUMERIC(A.[Avg_Q_71_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_71_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_71_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_72_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_72_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_73_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_73_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_74_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_74_10], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_00], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_01], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_02], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_03], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_04], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_05], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_06], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_07], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_08], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_09], '')) = 0))
					AND ((ISNUMERIC(A.[Avg_Q_75_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Avg_Q_75_10], '')) = 0))
					*/
					AND ((ISNUMERIC(A.[NPS]) = 1 AND CONVERT(DECIMAL(20, 6), A.[NPS]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[NPS], '')) = 0))
					AND ((ISNUMERIC(A.[RPI]) = 1 AND CONVERT(DECIMAL(20, 6), A.[RPI]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[RPI], '')) = 0))
					AND ((ISNUMERIC(A.[Achievement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Achievement Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Belonging Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Belonging Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Character Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Character Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Giving Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Giving Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Health Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Health Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Inspiration Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Inspiration Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Meaning Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Meaning Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Relationship Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Relationship Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Safety Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety z-score]) BETWEEN -4.000000 AND 4.000000) OR (LEN(COALESCE(A.[Safety Z-Score], '')) = 0))
					AND ((ISNUMERIC(A.[Achievement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Achievement Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Belonging Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Belonging Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Character Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Character Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Giving Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Giving Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Health Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Health Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Inspiration Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Inspiration Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Meaning Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Meaning Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Relationship Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Relationship Percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Safety Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety Percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[Safety Percentile], '')) = 0))

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
				AND target.form_code = source.form_code
				AND target.official_association_number = source.official_association_number
				--AND target.official_branch_number = source.official_branch_number
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
		 AND LEN(source.official_association_number) > 0
		 --AND LEN(source.official_branch_number) > 0
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					--[branch_name],
					--[official_branch_number],
					[response_count],
					[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					[avg_q_02_06],
					[avg_q_02_07],
					[avg_q_02_08],
					[avg_q_02_09],
					[avg_q_02_10],
					[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					[avg_q_03_06],
					[avg_q_03_07],
					[avg_q_03_08],
					[avg_q_03_09],
					[avg_q_03_10],
					[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					[avg_q_04_06],
					[avg_q_04_07],
					[avg_q_04_08],
					[avg_q_04_09],
					[avg_q_04_10],
					[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					[avg_q_05_06],
					[avg_q_05_07],
					[avg_q_05_08],
					[avg_q_05_09],
					[avg_q_05_10],
					[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					[avg_q_06_06],
					[avg_q_06_07],
					[avg_q_06_08],
					[avg_q_06_09],
					[avg_q_06_10],
					[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					[avg_q_07_06],
					[avg_q_07_07],
					[avg_q_07_08],
					[avg_q_07_09],
					[avg_q_07_10],
					[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					[avg_q_08_06],
					[avg_q_08_07],
					[avg_q_08_08],
					[avg_q_08_09],
					[avg_q_08_10],
					[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					[avg_q_09_06],
					[avg_q_09_07],
					[avg_q_09_08],
					[avg_q_09_09],
					[avg_q_09_10],
					[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					[avg_q_10_06],
					[avg_q_10_07],
					[avg_q_10_08],
					[avg_q_10_09],
					[avg_q_10_10],
					[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					[avg_q_11_06],
					[avg_q_11_07],
					[avg_q_11_08],
					[avg_q_11_09],
					[avg_q_11_10],
					[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					[avg_q_12_06],
					[avg_q_12_07],
					[avg_q_12_08],
					[avg_q_12_09],
					[avg_q_12_10],
					[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					[avg_q_32_00],
					[avg_q_32_01],
					[avg_q_32_02],
					[avg_q_32_03],
					[avg_q_32_04],
					[avg_q_32_05],
					[avg_q_32_06],
					[avg_q_32_07],
					[avg_q_32_08],
					[avg_q_32_09],
					[avg_q_32_10],
					[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					[avg_q_35_00],
					[avg_q_35_01],
					[avg_q_35_02],
					[avg_q_35_03],
					[avg_q_35_04],
					[avg_q_35_05],
					[avg_q_35_06],
					[avg_q_35_07],
					[avg_q_35_08],
					[avg_q_35_09],
					[avg_q_35_10],
					[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					[avg_q_43_00],
					[avg_q_43_01],
					[avg_q_43_02],
					[avg_q_43_03],
					[avg_q_43_04],
					[avg_q_43_05],
					[avg_q_43_06],
					[avg_q_43_07],
					[avg_q_43_08],
					[avg_q_43_09],
					[avg_q_43_10],
					[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					[avg_q_46_00],
					[avg_q_46_01],
					[avg_q_46_02],
					[avg_q_46_03],
					[avg_q_46_04],
					[avg_q_46_05],
					[avg_q_46_06],
					[avg_q_46_07],
					[avg_q_46_08],
					[avg_q_46_09],
					[avg_q_46_10],
					[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
					/*
					[avg_q_71_00],
					[avg_q_71_01],
					[avg_q_71_02],
					[avg_q_71_03],
					[avg_q_71_04],
					[avg_q_71_05],
					[avg_q_71_06],
					[avg_q_71_07],
					[avg_q_71_08],
					[avg_q_71_09],
					[avg_q_71_10],
					[avg_q_72_00],
					[avg_q_72_01],
					[avg_q_72_02],
					[avg_q_72_03],
					[avg_q_72_04],
					[avg_q_72_05],
					[avg_q_72_06],
					[avg_q_72_07],
					[avg_q_72_08],
					[avg_q_72_09],
					[avg_q_72_10],
					[avg_q_73_00],
					[avg_q_73_01],
					[avg_q_73_02],
					[avg_q_73_03],
					[avg_q_73_04],
					[avg_q_73_05],
					[avg_q_73_06],
					[avg_q_73_07],
					[avg_q_73_08],
					[avg_q_73_09],
					[avg_q_73_10],
					[avg_q_74_00],
					[avg_q_74_01],
					[avg_q_74_02],
					[avg_q_74_03],
					[avg_q_74_04],
					[avg_q_74_05],
					[avg_q_74_06],
					[avg_q_74_07],
					[avg_q_74_08],
					[avg_q_74_09],
					[avg_q_74_10],
					[avg_q_75_00],
					[avg_q_75_01],
					[avg_q_75_02],
					[avg_q_75_03],
					[avg_q_75_04],
					[avg_q_75_05],
					[avg_q_75_06],
					[avg_q_75_07],
					[avg_q_75_08],
					[avg_q_75_09],
					[avg_q_75_10],
					*/
					[nps],
					[rpi],
					[achievement_z-score],
					[belonging_z-score],
					[character_z-score],
					[giving_z-score],
					[health_z-score],
					[inspiration_z-score],
					[meaning_z-score],
					[relationship_z-score],
					[safety_z-score],
					[achievement_percentile],
					[belonging_percentile],
					[character_percentile],
					[giving_percentile],
					[health_percentile],
					[inspiration_percentile],
					[meaning_percentile],
					[relationship_percentile],
					[safety_percentile]

					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					--[branch_name],
					--[official_branch_number],
					[response_count],
					[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					[avg_q_02_06],
					[avg_q_02_07],
					[avg_q_02_08],
					[avg_q_02_09],
					[avg_q_02_10],
					[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					[avg_q_03_06],
					[avg_q_03_07],
					[avg_q_03_08],
					[avg_q_03_09],
					[avg_q_03_10],
					[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					[avg_q_04_06],
					[avg_q_04_07],
					[avg_q_04_08],
					[avg_q_04_09],
					[avg_q_04_10],
					[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					[avg_q_05_06],
					[avg_q_05_07],
					[avg_q_05_08],
					[avg_q_05_09],
					[avg_q_05_10],
					[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					[avg_q_06_06],
					[avg_q_06_07],
					[avg_q_06_08],
					[avg_q_06_09],
					[avg_q_06_10],
					[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					[avg_q_07_06],
					[avg_q_07_07],
					[avg_q_07_08],
					[avg_q_07_09],
					[avg_q_07_10],
					[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					[avg_q_08_06],
					[avg_q_08_07],
					[avg_q_08_08],
					[avg_q_08_09],
					[avg_q_08_10],
					[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					[avg_q_09_06],
					[avg_q_09_07],
					[avg_q_09_08],
					[avg_q_09_09],
					[avg_q_09_10],
					[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					[avg_q_10_06],
					[avg_q_10_07],
					[avg_q_10_08],
					[avg_q_10_09],
					[avg_q_10_10],
					[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					[avg_q_11_06],
					[avg_q_11_07],
					[avg_q_11_08],
					[avg_q_11_09],
					[avg_q_11_10],
					[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					[avg_q_12_06],
					[avg_q_12_07],
					[avg_q_12_08],
					[avg_q_12_09],
					[avg_q_12_10],
					[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					[avg_q_32_00],
					[avg_q_32_01],
					[avg_q_32_02],
					[avg_q_32_03],
					[avg_q_32_04],
					[avg_q_32_05],
					[avg_q_32_06],
					[avg_q_32_07],
					[avg_q_32_08],
					[avg_q_32_09],
					[avg_q_32_10],
					[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					[avg_q_35_00],
					[avg_q_35_01],
					[avg_q_35_02],
					[avg_q_35_03],
					[avg_q_35_04],
					[avg_q_35_05],
					[avg_q_35_06],
					[avg_q_35_07],
					[avg_q_35_08],
					[avg_q_35_09],
					[avg_q_35_10],
					[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					[avg_q_43_00],
					[avg_q_43_01],
					[avg_q_43_02],
					[avg_q_43_03],
					[avg_q_43_04],
					[avg_q_43_05],
					[avg_q_43_06],
					[avg_q_43_07],
					[avg_q_43_08],
					[avg_q_43_09],
					[avg_q_43_10],
					[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					[avg_q_46_00],
					[avg_q_46_01],
					[avg_q_46_02],
					[avg_q_46_03],
					[avg_q_46_04],
					[avg_q_46_05],
					[avg_q_46_06],
					[avg_q_46_07],
					[avg_q_46_08],
					[avg_q_46_09],
					[avg_q_46_10],
					[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
					/*
					[avg_q_71_00],
					[avg_q_71_01],
					[avg_q_71_02],
					[avg_q_71_03],
					[avg_q_71_04],
					[avg_q_71_05],
					[avg_q_71_06],
					[avg_q_71_07],
					[avg_q_71_08],
					[avg_q_71_09],
					[avg_q_71_10],
					[avg_q_72_00],
					[avg_q_72_01],
					[avg_q_72_02],
					[avg_q_72_03],
					[avg_q_72_04],
					[avg_q_72_05],
					[avg_q_72_06],
					[avg_q_72_07],
					[avg_q_72_08],
					[avg_q_72_09],
					[avg_q_72_10],
					[avg_q_73_00],
					[avg_q_73_01],
					[avg_q_73_02],
					[avg_q_73_03],
					[avg_q_73_04],
					[avg_q_73_05],
					[avg_q_73_06],
					[avg_q_73_07],
					[avg_q_73_08],
					[avg_q_73_09],
					[avg_q_73_10],
					[avg_q_74_00],
					[avg_q_74_01],
					[avg_q_74_02],
					[avg_q_74_03],
					[avg_q_74_04],
					[avg_q_74_05],
					[avg_q_74_06],
					[avg_q_74_07],
					[avg_q_74_08],
					[avg_q_74_09],
					[avg_q_74_10],
					[avg_q_75_00],
					[avg_q_75_01],
					[avg_q_75_02],
					[avg_q_75_03],
					[avg_q_75_04],
					[avg_q_75_05],
					[avg_q_75_06],
					[avg_q_75_07],
					[avg_q_75_08],
					[avg_q_75_09],
					[avg_q_75_10],
					*/
					[nps],
					[rpi],
					[achievement_z-score],
					[belonging_z-score],
					[character_z-score],
					[giving_z-score],
					[health_z-score],
					[inspiration_z-score],
					[meaning_z-score],
					[relationship_z-score],
					[safety_z-score],
					[achievement_percentile],
					[belonging_percentile],
					[character_percentile],
					[giving_percentile],
					[health_percentile],
					[inspiration_percentile],
					[meaning_percentile],
					[relationship_percentile],
					[safety_percentile]
)
					
	;
COMMIT TRAN

BEGIN TRAN
	INSERT INTO Seer_CTRL.dbo.[Program Aggregated Data]([Aggregate_Type],
														[Response_Load_Date],
														[Form_Code],
														[Association_Name],
														[Off_Assoc_Num],
														--[Branch_Name],
														--[Off_Br_Num],
														[Response_Count],
														[Avg_Q_01_00],
														[Avg_Q_01_01],
														[Avg_Q_01_02],
														[Avg_Q_01_03],
														[Avg_Q_01_04],
														[Avg_Q_01_05],
														[Avg_Q_01_06],
														[Avg_Q_01_07],
														[Avg_Q_01_08],
														[Avg_Q_01_09],
														[Avg_Q_01_10],
														[Avg_Q_02_00],
														[Avg_Q_02_01],
														[Avg_Q_02_02],
														[Avg_Q_02_03],
														[Avg_Q_02_04],
														[Avg_Q_02_05],
														[Avg_Q_02_06],
														[Avg_Q_02_07],
														[Avg_Q_02_08],
														[Avg_Q_02_09],
														[Avg_Q_02_10],
														[Avg_Q_03_00],
														[Avg_Q_03_01],
														[Avg_Q_03_02],
														[Avg_Q_03_03],
														[Avg_Q_03_04],
														[Avg_Q_03_05],
														[Avg_Q_03_06],
														[Avg_Q_03_07],
														[Avg_Q_03_08],
														[Avg_Q_03_09],
														[Avg_Q_03_10],
														[Avg_Q_04_00],
														[Avg_Q_04_01],
														[Avg_Q_04_02],
														[Avg_Q_04_03],
														[Avg_Q_04_04],
														[Avg_Q_04_05],
														[Avg_Q_04_06],
														[Avg_Q_04_07],
														[Avg_Q_04_08],
														[Avg_Q_04_09],
														[Avg_Q_04_10],
														[Avg_Q_05_00],
														[Avg_Q_05_01],
														[Avg_Q_05_02],
														[Avg_Q_05_03],
														[Avg_Q_05_04],
														[Avg_Q_05_05],
														[Avg_Q_05_06],
														[Avg_Q_05_07],
														[Avg_Q_05_08],
														[Avg_Q_05_09],
														[Avg_Q_05_10],
														[Avg_Q_06_00],
														[Avg_Q_06_01],
														[Avg_Q_06_02],
														[Avg_Q_06_03],
														[Avg_Q_06_04],
														[Avg_Q_06_05],
														[Avg_Q_06_06],
														[Avg_Q_06_07],
														[Avg_Q_06_08],
														[Avg_Q_06_09],
														[Avg_Q_06_10],
														[Avg_Q_07_00],
														[Avg_Q_07_01],
														[Avg_Q_07_02],
														[Avg_Q_07_03],
														[Avg_Q_07_04],
														[Avg_Q_07_05],
														[Avg_Q_07_06],
														[Avg_Q_07_07],
														[Avg_Q_07_08],
														[Avg_Q_07_09],
														[Avg_Q_07_10],
														[Avg_Q_08_00],
														[Avg_Q_08_01],
														[Avg_Q_08_02],
														[Avg_Q_08_03],
														[Avg_Q_08_04],
														[Avg_Q_08_05],
														[Avg_Q_08_06],
														[Avg_Q_08_07],
														[Avg_Q_08_08],
														[Avg_Q_08_09],
														[Avg_Q_08_10],
														[Avg_Q_09_00],
														[Avg_Q_09_01],
														[Avg_Q_09_02],
														[Avg_Q_09_03],
														[Avg_Q_09_04],
														[Avg_Q_09_05],
														[Avg_Q_09_06],
														[Avg_Q_09_07],
														[Avg_Q_09_08],
														[Avg_Q_09_09],
														[Avg_Q_09_10],
														[Avg_Q_10_00],
														[Avg_Q_10_01],
														[Avg_Q_10_02],
														[Avg_Q_10_03],
														[Avg_Q_10_04],
														[Avg_Q_10_05],
														[Avg_Q_10_06],
														[Avg_Q_10_07],
														[Avg_Q_10_08],
														[Avg_Q_10_09],
														[Avg_Q_10_10],
														[Avg_Q_11_00],
														[Avg_Q_11_01],
														[Avg_Q_11_02],
														[Avg_Q_11_03],
														[Avg_Q_11_04],
														[Avg_Q_11_05],
														[Avg_Q_11_06],
														[Avg_Q_11_07],
														[Avg_Q_11_08],
														[Avg_Q_11_09],
														[Avg_Q_11_10],
														[Avg_Q_12_00],
														[Avg_Q_12_01],
														[Avg_Q_12_02],
														[Avg_Q_12_03],
														[Avg_Q_12_04],
														[Avg_Q_12_05],
														[Avg_Q_12_06],
														[Avg_Q_12_07],
														[Avg_Q_12_08],
														[Avg_Q_12_09],
														[Avg_Q_12_10],
														[Avg_Q_13_00],
														[Avg_Q_13_01],
														[Avg_Q_13_02],
														[Avg_Q_13_03],
														[Avg_Q_13_04],
														[Avg_Q_13_05],
														[Avg_Q_13_06],
														[Avg_Q_13_07],
														[Avg_Q_13_08],
														[Avg_Q_13_09],
														[Avg_Q_13_10],
														[Avg_Q_14_00],
														[Avg_Q_14_01],
														[Avg_Q_14_02],
														[Avg_Q_14_03],
														[Avg_Q_14_04],
														[Avg_Q_14_05],
														[Avg_Q_14_06],
														[Avg_Q_14_07],
														[Avg_Q_14_08],
														[Avg_Q_14_09],
														[Avg_Q_14_10],
														[Avg_Q_15_00],
														[Avg_Q_15_01],
														[Avg_Q_15_02],
														[Avg_Q_15_03],
														[Avg_Q_15_04],
														[Avg_Q_15_05],
														[Avg_Q_15_06],
														[Avg_Q_15_07],
														[Avg_Q_15_08],
														[Avg_Q_15_09],
														[Avg_Q_15_10],
														[Avg_Q_16_00],
														[Avg_Q_16_01],
														[Avg_Q_16_02],
														[Avg_Q_16_03],
														[Avg_Q_16_04],
														[Avg_Q_16_05],
														[Avg_Q_16_06],
														[Avg_Q_16_07],
														[Avg_Q_16_08],
														[Avg_Q_16_09],
														[Avg_Q_16_10],
														[Avg_Q_17_00],
														[Avg_Q_17_01],
														[Avg_Q_17_02],
														[Avg_Q_17_03],
														[Avg_Q_17_04],
														[Avg_Q_17_05],
														[Avg_Q_17_06],
														[Avg_Q_17_07],
														[Avg_Q_17_08],
														[Avg_Q_17_09],
														[Avg_Q_17_10],
														[Avg_Q_18_00],
														[Avg_Q_18_01],
														[Avg_Q_18_02],
														[Avg_Q_18_03],
														[Avg_Q_18_04],
														[Avg_Q_18_05],
														[Avg_Q_18_06],
														[Avg_Q_18_07],
														[Avg_Q_18_08],
														[Avg_Q_18_09],
														[Avg_Q_18_10],
														[Avg_Q_19_00],
														[Avg_Q_19_01],
														[Avg_Q_19_02],
														[Avg_Q_19_03],
														[Avg_Q_19_04],
														[Avg_Q_19_05],
														[Avg_Q_19_06],
														[Avg_Q_19_07],
														[Avg_Q_19_08],
														[Avg_Q_19_09],
														[Avg_Q_19_10],
														[Avg_Q_20_00],
														[Avg_Q_20_01],
														[Avg_Q_20_02],
														[Avg_Q_20_03],
														[Avg_Q_20_04],
														[Avg_Q_20_05],
														[Avg_Q_20_06],
														[Avg_Q_20_07],
														[Avg_Q_20_08],
														[Avg_Q_20_09],
														[Avg_Q_20_10],
														[Avg_Q_21_00],
														[Avg_Q_21_01],
														[Avg_Q_21_02],
														[Avg_Q_21_03],
														[Avg_Q_21_04],
														[Avg_Q_21_05],
														[Avg_Q_21_06],
														[Avg_Q_21_07],
														[Avg_Q_21_08],
														[Avg_Q_21_09],
														[Avg_Q_21_10],
														[Avg_Q_22_00],
														[Avg_Q_22_01],
														[Avg_Q_22_02],
														[Avg_Q_22_03],
														[Avg_Q_22_04],
														[Avg_Q_22_05],
														[Avg_Q_22_06],
														[Avg_Q_22_07],
														[Avg_Q_22_08],
														[Avg_Q_22_09],
														[Avg_Q_22_10],
														[Avg_Q_23_00],
														[Avg_Q_23_01],
														[Avg_Q_23_02],
														[Avg_Q_23_03],
														[Avg_Q_23_04],
														[Avg_Q_23_05],
														[Avg_Q_23_06],
														[Avg_Q_23_07],
														[Avg_Q_23_08],
														[Avg_Q_23_09],
														[Avg_Q_23_10],
														[Avg_Q_24_00],
														[Avg_Q_24_01],
														[Avg_Q_24_02],
														[Avg_Q_24_03],
														[Avg_Q_24_04],
														[Avg_Q_24_05],
														[Avg_Q_24_06],
														[Avg_Q_24_07],
														[Avg_Q_24_08],
														[Avg_Q_24_09],
														[Avg_Q_24_10],
														[Avg_Q_25_00],
														[Avg_Q_25_01],
														[Avg_Q_25_02],
														[Avg_Q_25_03],
														[Avg_Q_25_04],
														[Avg_Q_25_05],
														[Avg_Q_25_06],
														[Avg_Q_25_07],
														[Avg_Q_25_08],
														[Avg_Q_25_09],
														[Avg_Q_25_10],
														[Avg_Q_26_00],
														[Avg_Q_26_01],
														[Avg_Q_26_02],
														[Avg_Q_26_03],
														[Avg_Q_26_04],
														[Avg_Q_26_05],
														[Avg_Q_26_06],
														[Avg_Q_26_07],
														[Avg_Q_26_08],
														[Avg_Q_26_09],
														[Avg_Q_26_10],
														[Avg_Q_27_00],
														[Avg_Q_27_01],
														[Avg_Q_27_02],
														[Avg_Q_27_03],
														[Avg_Q_27_04],
														[Avg_Q_27_05],
														[Avg_Q_27_06],
														[Avg_Q_27_07],
														[Avg_Q_27_08],
														[Avg_Q_27_09],
														[Avg_Q_27_10],
														[Avg_Q_28_00],
														[Avg_Q_28_01],
														[Avg_Q_28_02],
														[Avg_Q_28_03],
														[Avg_Q_28_04],
														[Avg_Q_28_05],
														[Avg_Q_28_06],
														[Avg_Q_28_07],
														[Avg_Q_28_08],
														[Avg_Q_28_09],
														[Avg_Q_28_10],
														[Avg_Q_29_00],
														[Avg_Q_29_01],
														[Avg_Q_29_02],
														[Avg_Q_29_03],
														[Avg_Q_29_04],
														[Avg_Q_29_05],
														[Avg_Q_29_06],
														[Avg_Q_29_07],
														[Avg_Q_29_08],
														[Avg_Q_29_09],
														[Avg_Q_29_10],
														[Avg_Q_30_00],
														[Avg_Q_30_01],
														[Avg_Q_30_02],
														[Avg_Q_30_03],
														[Avg_Q_30_04],
														[Avg_Q_30_05],
														[Avg_Q_30_06],
														[Avg_Q_30_07],
														[Avg_Q_30_08],
														[Avg_Q_30_09],
														[Avg_Q_30_10],
														[Avg_Q_31_00],
														[Avg_Q_31_01],
														[Avg_Q_31_02],
														[Avg_Q_31_03],
														[Avg_Q_31_04],
														[Avg_Q_31_05],
														[Avg_Q_31_06],
														[Avg_Q_31_07],
														[Avg_Q_31_08],
														[Avg_Q_31_09],
														[Avg_Q_31_10],
														[Avg_Q_32_00],
														[Avg_Q_32_01],
														[Avg_Q_32_02],
														[Avg_Q_32_03],
														[Avg_Q_32_04],
														[Avg_Q_32_05],
														[Avg_Q_32_06],
														[Avg_Q_32_07],
														[Avg_Q_32_08],
														[Avg_Q_32_09],
														[Avg_Q_32_10],
														[Avg_Q_33_00],
														[Avg_Q_33_01],
														[Avg_Q_33_02],
														[Avg_Q_33_03],
														[Avg_Q_33_04],
														[Avg_Q_33_05],
														[Avg_Q_33_06],
														[Avg_Q_33_07],
														[Avg_Q_33_08],
														[Avg_Q_33_09],
														[Avg_Q_33_10],
														[Avg_Q_34_00],
														[Avg_Q_34_01],
														[Avg_Q_34_02],
														[Avg_Q_34_03],
														[Avg_Q_34_04],
														[Avg_Q_34_05],
														[Avg_Q_34_06],
														[Avg_Q_34_07],
														[Avg_Q_34_08],
														[Avg_Q_34_09],
														[Avg_Q_34_10],
														[Avg_Q_35_00],
														[Avg_Q_35_01],
														[Avg_Q_35_02],
														[Avg_Q_35_03],
														[Avg_Q_35_04],
														[Avg_Q_35_05],
														[Avg_Q_35_06],
														[Avg_Q_35_07],
														[Avg_Q_35_08],
														[Avg_Q_35_09],
														[Avg_Q_35_10],
														[Avg_Q_36_00],
														[Avg_Q_36_01],
														[Avg_Q_36_02],
														[Avg_Q_36_03],
														[Avg_Q_36_04],
														[Avg_Q_36_05],
														[Avg_Q_36_06],
														[Avg_Q_36_07],
														[Avg_Q_36_08],
														[Avg_Q_36_09],
														[Avg_Q_36_10],
														[Avg_Q_37_00],
														[Avg_Q_37_01],
														[Avg_Q_37_02],
														[Avg_Q_37_03],
														[Avg_Q_37_04],
														[Avg_Q_37_05],
														[Avg_Q_37_06],
														[Avg_Q_37_07],
														[Avg_Q_37_08],
														[Avg_Q_37_09],
														[Avg_Q_37_10],
														[Avg_Q_38_00],
														[Avg_Q_38_01],
														[Avg_Q_38_02],
														[Avg_Q_38_03],
														[Avg_Q_38_04],
														[Avg_Q_38_05],
														[Avg_Q_38_06],
														[Avg_Q_38_07],
														[Avg_Q_38_08],
														[Avg_Q_38_09],
														[Avg_Q_38_10],
														[Avg_Q_39_00],
														[Avg_Q_39_01],
														[Avg_Q_39_02],
														[Avg_Q_39_03],
														[Avg_Q_39_04],
														[Avg_Q_39_05],
														[Avg_Q_39_06],
														[Avg_Q_39_07],
														[Avg_Q_39_08],
														[Avg_Q_39_09],
														[Avg_Q_39_10],
														[Avg_Q_40_00],
														[Avg_Q_40_01],
														[Avg_Q_40_02],
														[Avg_Q_40_03],
														[Avg_Q_40_04],
														[Avg_Q_40_05],
														[Avg_Q_40_06],
														[Avg_Q_40_07],
														[Avg_Q_40_08],
														[Avg_Q_40_09],
														[Avg_Q_40_10],
														[Avg_Q_41_00],
														[Avg_Q_41_01],
														[Avg_Q_41_02],
														[Avg_Q_41_03],
														[Avg_Q_41_04],
														[Avg_Q_41_05],
														[Avg_Q_41_06],
														[Avg_Q_41_07],
														[Avg_Q_41_08],
														[Avg_Q_41_09],
														[Avg_Q_41_10],
														[Avg_Q_42_00],
														[Avg_Q_42_01],
														[Avg_Q_42_02],
														[Avg_Q_42_03],
														[Avg_Q_42_04],
														[Avg_Q_42_05],
														[Avg_Q_42_06],
														[Avg_Q_42_07],
														[Avg_Q_42_08],
														[Avg_Q_42_09],
														[Avg_Q_42_10],
														[Avg_Q_43_00],
														[Avg_Q_43_01],
														[Avg_Q_43_02],
														[Avg_Q_43_03],
														[Avg_Q_43_04],
														[Avg_Q_43_05],
														[Avg_Q_43_06],
														[Avg_Q_43_07],
														[Avg_Q_43_08],
														[Avg_Q_43_09],
														[Avg_Q_43_10],
														[Avg_Q_44_00],
														[Avg_Q_44_01],
														[Avg_Q_44_02],
														[Avg_Q_44_03],
														[Avg_Q_44_04],
														[Avg_Q_44_05],
														[Avg_Q_44_06],
														[Avg_Q_44_07],
														[Avg_Q_44_08],
														[Avg_Q_44_09],
														[Avg_Q_44_10],
														[Avg_Q_45_00],
														[Avg_Q_45_01],
														[Avg_Q_45_02],
														[Avg_Q_45_03],
														[Avg_Q_45_04],
														[Avg_Q_45_05],
														[Avg_Q_45_06],
														[Avg_Q_45_07],
														[Avg_Q_45_08],
														[Avg_Q_45_09],
														[Avg_Q_45_10],
														[Avg_Q_46_00],
														[Avg_Q_46_01],
														[Avg_Q_46_02],
														[Avg_Q_46_03],
														[Avg_Q_46_04],
														[Avg_Q_46_05],
														[Avg_Q_46_06],
														[Avg_Q_46_07],
														[Avg_Q_46_08],
														[Avg_Q_46_09],
														[Avg_Q_46_10],
														[Avg_Q_47_00],
														[Avg_Q_47_01],
														[Avg_Q_47_02],
														[Avg_Q_47_03],
														[Avg_Q_47_04],
														[Avg_Q_47_05],
														[Avg_Q_47_06],
														[Avg_Q_47_07],
														[Avg_Q_47_08],
														[Avg_Q_47_09],
														[Avg_Q_47_10],
														[Avg_Q_48_00],
														[Avg_Q_48_01],
														[Avg_Q_48_02],
														[Avg_Q_48_03],
														[Avg_Q_48_04],
														[Avg_Q_48_05],
														[Avg_Q_48_06],
														[Avg_Q_48_07],
														[Avg_Q_48_08],
														[Avg_Q_48_09],
														[Avg_Q_48_10],
														[Avg_Q_49_00],
														[Avg_Q_49_01],
														[Avg_Q_49_02],
														[Avg_Q_49_03],
														[Avg_Q_49_04],
														[Avg_Q_49_05],
														[Avg_Q_49_06],
														[Avg_Q_49_07],
														[Avg_Q_49_08],
														[Avg_Q_49_09],
														[Avg_Q_49_10],
														[Avg_Q_50_00],
														[Avg_Q_50_01],
														[Avg_Q_50_02],
														[Avg_Q_50_03],
														[Avg_Q_50_04],
														[Avg_Q_50_05],
														[Avg_Q_50_06],
														[Avg_Q_50_07],
														[Avg_Q_50_08],
														[Avg_Q_50_09],
														[Avg_Q_50_10],
														[Avg_Q_51_00],
														[Avg_Q_51_01],
														[Avg_Q_51_02],
														[Avg_Q_51_03],
														[Avg_Q_51_04],
														[Avg_Q_51_05],
														[Avg_Q_51_06],
														[Avg_Q_51_07],
														[Avg_Q_51_08],
														[Avg_Q_51_09],
														[Avg_Q_51_10],
														[Avg_Q_52_00],
														[Avg_Q_52_01],
														[Avg_Q_52_02],
														[Avg_Q_52_03],
														[Avg_Q_52_04],
														[Avg_Q_52_05],
														[Avg_Q_52_06],
														[Avg_Q_52_07],
														[Avg_Q_52_08],
														[Avg_Q_52_09],
														[Avg_Q_52_10],
														[Avg_Q_53_00],
														[Avg_Q_53_01],
														[Avg_Q_53_02],
														[Avg_Q_53_03],
														[Avg_Q_53_04],
														[Avg_Q_53_05],
														[Avg_Q_53_06],
														[Avg_Q_53_07],
														[Avg_Q_53_08],
														[Avg_Q_53_09],
														[Avg_Q_53_10],
														[Avg_Q_54_00],
														[Avg_Q_54_01],
														[Avg_Q_54_02],
														[Avg_Q_54_03],
														[Avg_Q_54_04],
														[Avg_Q_54_05],
														[Avg_Q_54_06],
														[Avg_Q_54_07],
														[Avg_Q_54_08],
														[Avg_Q_54_09],
														[Avg_Q_54_10],
														[Avg_Q_55_00],
														[Avg_Q_55_01],
														[Avg_Q_55_02],
														[Avg_Q_55_03],
														[Avg_Q_55_04],
														[Avg_Q_55_05],
														[Avg_Q_55_06],
														[Avg_Q_55_07],
														[Avg_Q_55_08],
														[Avg_Q_55_09],
														[Avg_Q_55_10],
														[Avg_Q_56_00],
														[Avg_Q_56_01],
														[Avg_Q_56_02],
														[Avg_Q_56_03],
														[Avg_Q_56_04],
														[Avg_Q_56_05],
														[Avg_Q_56_06],
														[Avg_Q_56_07],
														[Avg_Q_56_08],
														[Avg_Q_56_09],
														[Avg_Q_56_10],
														[Avg_Q_57_00],
														[Avg_Q_57_01],
														[Avg_Q_57_02],
														[Avg_Q_57_03],
														[Avg_Q_57_04],
														[Avg_Q_57_05],
														[Avg_Q_57_06],
														[Avg_Q_57_07],
														[Avg_Q_57_08],
														[Avg_Q_57_09],
														[Avg_Q_57_10],
														[Avg_Q_58_00],
														[Avg_Q_58_01],
														[Avg_Q_58_02],
														[Avg_Q_58_03],
														[Avg_Q_58_04],
														[Avg_Q_58_05],
														[Avg_Q_58_06],
														[Avg_Q_58_07],
														[Avg_Q_58_08],
														[Avg_Q_58_09],
														[Avg_Q_58_10],
														[Avg_Q_59_00],
														[Avg_Q_59_01],
														[Avg_Q_59_02],
														[Avg_Q_59_03],
														[Avg_Q_59_04],
														[Avg_Q_59_05],
														[Avg_Q_59_06],
														[Avg_Q_59_07],
														[Avg_Q_59_08],
														[Avg_Q_59_09],
														[Avg_Q_59_10],
														[Avg_Q_60_00],
														[Avg_Q_60_01],
														[Avg_Q_60_02],
														[Avg_Q_60_03],
														[Avg_Q_60_04],
														[Avg_Q_60_05],
														[Avg_Q_60_06],
														[Avg_Q_60_07],
														[Avg_Q_60_08],
														[Avg_Q_60_09],
														[Avg_Q_60_10],
														[Avg_Q_61_00],
														[Avg_Q_61_01],
														[Avg_Q_61_02],
														[Avg_Q_61_03],
														[Avg_Q_61_04],
														[Avg_Q_61_05],
														[Avg_Q_61_06],
														[Avg_Q_61_07],
														[Avg_Q_61_08],
														[Avg_Q_61_09],
														[Avg_Q_61_10],
														[Avg_Q_62_00],
														[Avg_Q_62_01],
														[Avg_Q_62_02],
														[Avg_Q_62_03],
														[Avg_Q_62_04],
														[Avg_Q_62_05],
														[Avg_Q_62_06],
														[Avg_Q_62_07],
														[Avg_Q_62_08],
														[Avg_Q_62_09],
														[Avg_Q_62_10],
														[Avg_Q_63_00],
														[Avg_Q_63_01],
														[Avg_Q_63_02],
														[Avg_Q_63_03],
														[Avg_Q_63_04],
														[Avg_Q_63_05],
														[Avg_Q_63_06],
														[Avg_Q_63_07],
														[Avg_Q_63_08],
														[Avg_Q_63_09],
														[Avg_Q_63_10],
														[Avg_Q_64_00],
														[Avg_Q_64_01],
														[Avg_Q_64_02],
														[Avg_Q_64_03],
														[Avg_Q_64_04],
														[Avg_Q_64_05],
														[Avg_Q_64_06],
														[Avg_Q_64_07],
														[Avg_Q_64_08],
														[Avg_Q_64_09],
														[Avg_Q_64_10],
														[Avg_Q_65_00],
														[Avg_Q_65_01],
														[Avg_Q_65_02],
														[Avg_Q_65_03],
														[Avg_Q_65_04],
														[Avg_Q_65_05],
														[Avg_Q_65_06],
														[Avg_Q_65_07],
														[Avg_Q_65_08],
														[Avg_Q_65_09],
														[Avg_Q_65_10],
														[Avg_Q_66_00],
														[Avg_Q_66_01],
														[Avg_Q_66_02],
														[Avg_Q_66_03],
														[Avg_Q_66_04],
														[Avg_Q_66_05],
														[Avg_Q_66_06],
														[Avg_Q_66_07],
														[Avg_Q_66_08],
														[Avg_Q_66_09],
														[Avg_Q_66_10],
														[Avg_Q_67_00],
														[Avg_Q_67_01],
														[Avg_Q_67_02],
														[Avg_Q_67_03],
														[Avg_Q_67_04],
														[Avg_Q_67_05],
														[Avg_Q_67_06],
														[Avg_Q_67_07],
														[Avg_Q_67_08],
														[Avg_Q_67_09],
														[Avg_Q_67_10],
														[Avg_Q_68_00],
														[Avg_Q_68_01],
														[Avg_Q_68_02],
														[Avg_Q_68_03],
														[Avg_Q_68_04],
														[Avg_Q_68_05],
														[Avg_Q_68_06],
														[Avg_Q_68_07],
														[Avg_Q_68_08],
														[Avg_Q_68_09],
														[Avg_Q_68_10],
														[Avg_Q_69_00],
														[Avg_Q_69_01],
														[Avg_Q_69_02],
														[Avg_Q_69_03],
														[Avg_Q_69_04],
														[Avg_Q_69_05],
														[Avg_Q_69_06],
														[Avg_Q_69_07],
														[Avg_Q_69_08],
														[Avg_Q_69_09],
														[Avg_Q_69_10],
														[Avg_Q_70_00],
														[Avg_Q_70_01],
														[Avg_Q_70_02],
														[Avg_Q_70_03],
														[Avg_Q_70_04],
														[Avg_Q_70_05],
														[Avg_Q_70_06],
														[Avg_Q_70_07],
														[Avg_Q_70_08],
														[Avg_Q_70_09],
														[Avg_Q_70_10],
														/*
														[Avg_Q_71_00],
														[Avg_Q_71_01],
														[Avg_Q_71_02],
														[Avg_Q_71_03],
														[Avg_Q_71_04],
														[Avg_Q_71_05],
														[Avg_Q_71_06],
														[Avg_Q_71_07],
														[Avg_Q_71_08],
														[Avg_Q_71_09],
														[Avg_Q_71_10],
														[Avg_Q_72_00],
														[Avg_Q_72_01],
														[Avg_Q_72_02],
														[Avg_Q_72_03],
														[Avg_Q_72_04],
														[Avg_Q_72_05],
														[Avg_Q_72_06],
														[Avg_Q_72_07],
														[Avg_Q_72_08],
														[Avg_Q_72_09],
														[Avg_Q_72_10],
														[Avg_Q_73_00],
														[Avg_Q_73_01],
														[Avg_Q_73_02],
														[Avg_Q_73_03],
														[Avg_Q_73_04],
														[Avg_Q_73_05],
														[Avg_Q_73_06],
														[Avg_Q_73_07],
														[Avg_Q_73_08],
														[Avg_Q_73_09],
														[Avg_Q_73_10],
														[Avg_Q_74_00],
														[Avg_Q_74_01],
														[Avg_Q_74_02],
														[Avg_Q_74_03],
														[Avg_Q_74_04],
														[Avg_Q_74_05],
														[Avg_Q_74_06],
														[Avg_Q_74_07],
														[Avg_Q_74_08],
														[Avg_Q_74_09],
														[Avg_Q_74_10],
														[Avg_Q_75_00],
														[Avg_Q_75_01],
														[Avg_Q_75_02],
														[Avg_Q_75_03],
														[Avg_Q_75_04],
														[Avg_Q_75_05],
														[Avg_Q_75_06],
														[Avg_Q_75_07],
														[Avg_Q_75_08],
														[Avg_Q_75_09],
														[Avg_Q_75_10],
														*/
														[NPS],
														[RPI],
														[Achievement Z-Score],
														[Belonging Z-Score],
														[Character Z-Score],
														[Giving Z-Score],
														[Health Z-Score],
														[Inspiration Z-Score],
														[Meaning Z-Score],
														[Relationship Z-Score],
														[Safety Z-Score],
														[Achievement Percentile],
														[Belonging Percentile],
														[Character Percentile],
														[Giving Percentile],
														[Health Percentile],
														[Inspiration Percentile],
														[Meaning Percentile],
														[Relationship Percentile],
														[Safety Percentile],
														[CreateDateTime]

													)
	
	SELECT	A.[Aggregate_Type],
			A.[Response_Load_Date],
			A.[Form_Code],
			A.[Association_Name],
			A.[Off_Assoc_Num],
			--A.[Branch_Name],
			--A.[Off_Br_Num],
			A.[Response_Count],
			A.[Avg_Q_01_00],
			A.[Avg_Q_01_01],
			A.[Avg_Q_01_02],
			A.[Avg_Q_01_03],
			A.[Avg_Q_01_04],
			A.[Avg_Q_01_05],
			A.[Avg_Q_01_06],
			A.[Avg_Q_01_07],
			A.[Avg_Q_01_08],
			A.[Avg_Q_01_09],
			A.[Avg_Q_01_10],
			A.[Avg_Q_02_00],
			A.[Avg_Q_02_01],
			A.[Avg_Q_02_02],
			A.[Avg_Q_02_03],
			A.[Avg_Q_02_04],
			A.[Avg_Q_02_05],
			A.[Avg_Q_02_06],
			A.[Avg_Q_02_07],
			A.[Avg_Q_02_08],
			A.[Avg_Q_02_09],
			A.[Avg_Q_02_10],
			A.[Avg_Q_03_00],
			A.[Avg_Q_03_01],
			A.[Avg_Q_03_02],
			A.[Avg_Q_03_03],
			A.[Avg_Q_03_04],
			A.[Avg_Q_03_05],
			A.[Avg_Q_03_06],
			A.[Avg_Q_03_07],
			A.[Avg_Q_03_08],
			A.[Avg_Q_03_09],
			A.[Avg_Q_03_10],
			A.[Avg_Q_04_00],
			A.[Avg_Q_04_01],
			A.[Avg_Q_04_02],
			A.[Avg_Q_04_03],
			A.[Avg_Q_04_04],
			A.[Avg_Q_04_05],
			A.[Avg_Q_04_06],
			A.[Avg_Q_04_07],
			A.[Avg_Q_04_08],
			A.[Avg_Q_04_09],
			A.[Avg_Q_04_10],
			A.[Avg_Q_05_00],
			A.[Avg_Q_05_01],
			A.[Avg_Q_05_02],
			A.[Avg_Q_05_03],
			A.[Avg_Q_05_04],
			A.[Avg_Q_05_05],
			A.[Avg_Q_05_06],
			A.[Avg_Q_05_07],
			A.[Avg_Q_05_08],
			A.[Avg_Q_05_09],
			A.[Avg_Q_05_10],
			A.[Avg_Q_06_00],
			A.[Avg_Q_06_01],
			A.[Avg_Q_06_02],
			A.[Avg_Q_06_03],
			A.[Avg_Q_06_04],
			A.[Avg_Q_06_05],
			A.[Avg_Q_06_06],
			A.[Avg_Q_06_07],
			A.[Avg_Q_06_08],
			A.[Avg_Q_06_09],
			A.[Avg_Q_06_10],
			A.[Avg_Q_07_00],
			A.[Avg_Q_07_01],
			A.[Avg_Q_07_02],
			A.[Avg_Q_07_03],
			A.[Avg_Q_07_04],
			A.[Avg_Q_07_05],
			A.[Avg_Q_07_06],
			A.[Avg_Q_07_07],
			A.[Avg_Q_07_08],
			A.[Avg_Q_07_09],
			A.[Avg_Q_07_10],
			A.[Avg_Q_08_00],
			A.[Avg_Q_08_01],
			A.[Avg_Q_08_02],
			A.[Avg_Q_08_03],
			A.[Avg_Q_08_04],
			A.[Avg_Q_08_05],
			A.[Avg_Q_08_06],
			A.[Avg_Q_08_07],
			A.[Avg_Q_08_08],
			A.[Avg_Q_08_09],
			A.[Avg_Q_08_10],
			A.[Avg_Q_09_00],
			A.[Avg_Q_09_01],
			A.[Avg_Q_09_02],
			A.[Avg_Q_09_03],
			A.[Avg_Q_09_04],
			A.[Avg_Q_09_05],
			A.[Avg_Q_09_06],
			A.[Avg_Q_09_07],
			A.[Avg_Q_09_08],
			A.[Avg_Q_09_09],
			A.[Avg_Q_09_10],
			A.[Avg_Q_10_00],
			A.[Avg_Q_10_01],
			A.[Avg_Q_10_02],
			A.[Avg_Q_10_03],
			A.[Avg_Q_10_04],
			A.[Avg_Q_10_05],
			A.[Avg_Q_10_06],
			A.[Avg_Q_10_07],
			A.[Avg_Q_10_08],
			A.[Avg_Q_10_09],
			A.[Avg_Q_10_10],
			A.[Avg_Q_11_00],
			A.[Avg_Q_11_01],
			A.[Avg_Q_11_02],
			A.[Avg_Q_11_03],
			A.[Avg_Q_11_04],
			A.[Avg_Q_11_05],
			A.[Avg_Q_11_06],
			A.[Avg_Q_11_07],
			A.[Avg_Q_11_08],
			A.[Avg_Q_11_09],
			A.[Avg_Q_11_10],
			A.[Avg_Q_12_00],
			A.[Avg_Q_12_01],
			A.[Avg_Q_12_02],
			A.[Avg_Q_12_03],
			A.[Avg_Q_12_04],
			A.[Avg_Q_12_05],
			A.[Avg_Q_12_06],
			A.[Avg_Q_12_07],
			A.[Avg_Q_12_08],
			A.[Avg_Q_12_09],
			A.[Avg_Q_12_10],
			A.[Avg_Q_13_00],
			A.[Avg_Q_13_01],
			A.[Avg_Q_13_02],
			A.[Avg_Q_13_03],
			A.[Avg_Q_13_04],
			A.[Avg_Q_13_05],
			A.[Avg_Q_13_06],
			A.[Avg_Q_13_07],
			A.[Avg_Q_13_08],
			A.[Avg_Q_13_09],
			A.[Avg_Q_13_10],
			A.[Avg_Q_14_00],
			A.[Avg_Q_14_01],
			A.[Avg_Q_14_02],
			A.[Avg_Q_14_03],
			A.[Avg_Q_14_04],
			A.[Avg_Q_14_05],
			A.[Avg_Q_14_06],
			A.[Avg_Q_14_07],
			A.[Avg_Q_14_08],
			A.[Avg_Q_14_09],
			A.[Avg_Q_14_10],
			A.[Avg_Q_15_00],
			A.[Avg_Q_15_01],
			A.[Avg_Q_15_02],
			A.[Avg_Q_15_03],
			A.[Avg_Q_15_04],
			A.[Avg_Q_15_05],
			A.[Avg_Q_15_06],
			A.[Avg_Q_15_07],
			A.[Avg_Q_15_08],
			A.[Avg_Q_15_09],
			A.[Avg_Q_15_10],
			A.[Avg_Q_16_00],
			A.[Avg_Q_16_01],
			A.[Avg_Q_16_02],
			A.[Avg_Q_16_03],
			A.[Avg_Q_16_04],
			A.[Avg_Q_16_05],
			A.[Avg_Q_16_06],
			A.[Avg_Q_16_07],
			A.[Avg_Q_16_08],
			A.[Avg_Q_16_09],
			A.[Avg_Q_16_10],
			A.[Avg_Q_17_00],
			A.[Avg_Q_17_01],
			A.[Avg_Q_17_02],
			A.[Avg_Q_17_03],
			A.[Avg_Q_17_04],
			A.[Avg_Q_17_05],
			A.[Avg_Q_17_06],
			A.[Avg_Q_17_07],
			A.[Avg_Q_17_08],
			A.[Avg_Q_17_09],
			A.[Avg_Q_17_10],
			A.[Avg_Q_18_00],
			A.[Avg_Q_18_01],
			A.[Avg_Q_18_02],
			A.[Avg_Q_18_03],
			A.[Avg_Q_18_04],
			A.[Avg_Q_18_05],
			A.[Avg_Q_18_06],
			A.[Avg_Q_18_07],
			A.[Avg_Q_18_08],
			A.[Avg_Q_18_09],
			A.[Avg_Q_18_10],
			A.[Avg_Q_19_00],
			A.[Avg_Q_19_01],
			A.[Avg_Q_19_02],
			A.[Avg_Q_19_03],
			A.[Avg_Q_19_04],
			A.[Avg_Q_19_05],
			A.[Avg_Q_19_06],
			A.[Avg_Q_19_07],
			A.[Avg_Q_19_08],
			A.[Avg_Q_19_09],
			A.[Avg_Q_19_10],
			A.[Avg_Q_20_00],
			A.[Avg_Q_20_01],
			A.[Avg_Q_20_02],
			A.[Avg_Q_20_03],
			A.[Avg_Q_20_04],
			A.[Avg_Q_20_05],
			A.[Avg_Q_20_06],
			A.[Avg_Q_20_07],
			A.[Avg_Q_20_08],
			A.[Avg_Q_20_09],
			A.[Avg_Q_20_10],
			A.[Avg_Q_21_00],
			A.[Avg_Q_21_01],
			A.[Avg_Q_21_02],
			A.[Avg_Q_21_03],
			A.[Avg_Q_21_04],
			A.[Avg_Q_21_05],
			A.[Avg_Q_21_06],
			A.[Avg_Q_21_07],
			A.[Avg_Q_21_08],
			A.[Avg_Q_21_09],
			A.[Avg_Q_21_10],
			A.[Avg_Q_22_00],
			A.[Avg_Q_22_01],
			A.[Avg_Q_22_02],
			A.[Avg_Q_22_03],
			A.[Avg_Q_22_04],
			A.[Avg_Q_22_05],
			A.[Avg_Q_22_06],
			A.[Avg_Q_22_07],
			A.[Avg_Q_22_08],
			A.[Avg_Q_22_09],
			A.[Avg_Q_22_10],
			A.[Avg_Q_23_00],
			A.[Avg_Q_23_01],
			A.[Avg_Q_23_02],
			A.[Avg_Q_23_03],
			A.[Avg_Q_23_04],
			A.[Avg_Q_23_05],
			A.[Avg_Q_23_06],
			A.[Avg_Q_23_07],
			A.[Avg_Q_23_08],
			A.[Avg_Q_23_09],
			A.[Avg_Q_23_10],
			A.[Avg_Q_24_00],
			A.[Avg_Q_24_01],
			A.[Avg_Q_24_02],
			A.[Avg_Q_24_03],
			A.[Avg_Q_24_04],
			A.[Avg_Q_24_05],
			A.[Avg_Q_24_06],
			A.[Avg_Q_24_07],
			A.[Avg_Q_24_08],
			A.[Avg_Q_24_09],
			A.[Avg_Q_24_10],
			A.[Avg_Q_25_00],
			A.[Avg_Q_25_01],
			A.[Avg_Q_25_02],
			A.[Avg_Q_25_03],
			A.[Avg_Q_25_04],
			A.[Avg_Q_25_05],
			A.[Avg_Q_25_06],
			A.[Avg_Q_25_07],
			A.[Avg_Q_25_08],
			A.[Avg_Q_25_09],
			A.[Avg_Q_25_10],
			A.[Avg_Q_26_00],
			A.[Avg_Q_26_01],
			A.[Avg_Q_26_02],
			A.[Avg_Q_26_03],
			A.[Avg_Q_26_04],
			A.[Avg_Q_26_05],
			A.[Avg_Q_26_06],
			A.[Avg_Q_26_07],
			A.[Avg_Q_26_08],
			A.[Avg_Q_26_09],
			A.[Avg_Q_26_10],
			A.[Avg_Q_27_00],
			A.[Avg_Q_27_01],
			A.[Avg_Q_27_02],
			A.[Avg_Q_27_03],
			A.[Avg_Q_27_04],
			A.[Avg_Q_27_05],
			A.[Avg_Q_27_06],
			A.[Avg_Q_27_07],
			A.[Avg_Q_27_08],
			A.[Avg_Q_27_09],
			A.[Avg_Q_27_10],
			A.[Avg_Q_28_00],
			A.[Avg_Q_28_01],
			A.[Avg_Q_28_02],
			A.[Avg_Q_28_03],
			A.[Avg_Q_28_04],
			A.[Avg_Q_28_05],
			A.[Avg_Q_28_06],
			A.[Avg_Q_28_07],
			A.[Avg_Q_28_08],
			A.[Avg_Q_28_09],
			A.[Avg_Q_28_10],
			A.[Avg_Q_29_00],
			A.[Avg_Q_29_01],
			A.[Avg_Q_29_02],
			A.[Avg_Q_29_03],
			A.[Avg_Q_29_04],
			A.[Avg_Q_29_05],
			A.[Avg_Q_29_06],
			A.[Avg_Q_29_07],
			A.[Avg_Q_29_08],
			A.[Avg_Q_29_09],
			A.[Avg_Q_29_10],
			A.[Avg_Q_30_00],
			A.[Avg_Q_30_01],
			A.[Avg_Q_30_02],
			A.[Avg_Q_30_03],
			A.[Avg_Q_30_04],
			A.[Avg_Q_30_05],
			A.[Avg_Q_30_06],
			A.[Avg_Q_30_07],
			A.[Avg_Q_30_08],
			A.[Avg_Q_30_09],
			A.[Avg_Q_30_10],
			A.[Avg_Q_31_00],
			A.[Avg_Q_31_01],
			A.[Avg_Q_31_02],
			A.[Avg_Q_31_03],
			A.[Avg_Q_31_04],
			A.[Avg_Q_31_05],
			A.[Avg_Q_31_06],
			A.[Avg_Q_31_07],
			A.[Avg_Q_31_08],
			A.[Avg_Q_31_09],
			A.[Avg_Q_31_10],
			A.[Avg_Q_32_00],
			A.[Avg_Q_32_01],
			A.[Avg_Q_32_02],
			A.[Avg_Q_32_03],
			A.[Avg_Q_32_04],
			A.[Avg_Q_32_05],
			A.[Avg_Q_32_06],
			A.[Avg_Q_32_07],
			A.[Avg_Q_32_08],
			A.[Avg_Q_32_09],
			A.[Avg_Q_32_10],
			A.[Avg_Q_33_00],
			A.[Avg_Q_33_01],
			A.[Avg_Q_33_02],
			A.[Avg_Q_33_03],
			A.[Avg_Q_33_04],
			A.[Avg_Q_33_05],
			A.[Avg_Q_33_06],
			A.[Avg_Q_33_07],
			A.[Avg_Q_33_08],
			A.[Avg_Q_33_09],
			A.[Avg_Q_33_10],
			A.[Avg_Q_34_00],
			A.[Avg_Q_34_01],
			A.[Avg_Q_34_02],
			A.[Avg_Q_34_03],
			A.[Avg_Q_34_04],
			A.[Avg_Q_34_05],
			A.[Avg_Q_34_06],
			A.[Avg_Q_34_07],
			A.[Avg_Q_34_08],
			A.[Avg_Q_34_09],
			A.[Avg_Q_34_10],
			A.[Avg_Q_35_00],
			A.[Avg_Q_35_01],
			A.[Avg_Q_35_02],
			A.[Avg_Q_35_03],
			A.[Avg_Q_35_04],
			A.[Avg_Q_35_05],
			A.[Avg_Q_35_06],
			A.[Avg_Q_35_07],
			A.[Avg_Q_35_08],
			A.[Avg_Q_35_09],
			A.[Avg_Q_35_10],
			A.[Avg_Q_36_00],
			A.[Avg_Q_36_01],
			A.[Avg_Q_36_02],
			A.[Avg_Q_36_03],
			A.[Avg_Q_36_04],
			A.[Avg_Q_36_05],
			A.[Avg_Q_36_06],
			A.[Avg_Q_36_07],
			A.[Avg_Q_36_08],
			A.[Avg_Q_36_09],
			A.[Avg_Q_36_10],
			A.[Avg_Q_37_00],
			A.[Avg_Q_37_01],
			A.[Avg_Q_37_02],
			A.[Avg_Q_37_03],
			A.[Avg_Q_37_04],
			A.[Avg_Q_37_05],
			A.[Avg_Q_37_06],
			A.[Avg_Q_37_07],
			A.[Avg_Q_37_08],
			A.[Avg_Q_37_09],
			A.[Avg_Q_37_10],
			A.[Avg_Q_38_00],
			A.[Avg_Q_38_01],
			A.[Avg_Q_38_02],
			A.[Avg_Q_38_03],
			A.[Avg_Q_38_04],
			A.[Avg_Q_38_05],
			A.[Avg_Q_38_06],
			A.[Avg_Q_38_07],
			A.[Avg_Q_38_08],
			A.[Avg_Q_38_09],
			A.[Avg_Q_38_10],
			A.[Avg_Q_39_00],
			A.[Avg_Q_39_01],
			A.[Avg_Q_39_02],
			A.[Avg_Q_39_03],
			A.[Avg_Q_39_04],
			A.[Avg_Q_39_05],
			A.[Avg_Q_39_06],
			A.[Avg_Q_39_07],
			A.[Avg_Q_39_08],
			A.[Avg_Q_39_09],
			A.[Avg_Q_39_10],
			A.[Avg_Q_40_00],
			A.[Avg_Q_40_01],
			A.[Avg_Q_40_02],
			A.[Avg_Q_40_03],
			A.[Avg_Q_40_04],
			A.[Avg_Q_40_05],
			A.[Avg_Q_40_06],
			A.[Avg_Q_40_07],
			A.[Avg_Q_40_08],
			A.[Avg_Q_40_09],
			A.[Avg_Q_40_10],
			A.[Avg_Q_41_00],
			A.[Avg_Q_41_01],
			A.[Avg_Q_41_02],
			A.[Avg_Q_41_03],
			A.[Avg_Q_41_04],
			A.[Avg_Q_41_05],
			A.[Avg_Q_41_06],
			A.[Avg_Q_41_07],
			A.[Avg_Q_41_08],
			A.[Avg_Q_41_09],
			A.[Avg_Q_41_10],
			A.[Avg_Q_42_00],
			A.[Avg_Q_42_01],
			A.[Avg_Q_42_02],
			A.[Avg_Q_42_03],
			A.[Avg_Q_42_04],
			A.[Avg_Q_42_05],
			A.[Avg_Q_42_06],
			A.[Avg_Q_42_07],
			A.[Avg_Q_42_08],
			A.[Avg_Q_42_09],
			A.[Avg_Q_42_10],
			A.[Avg_Q_43_00],
			A.[Avg_Q_43_01],
			A.[Avg_Q_43_02],
			A.[Avg_Q_43_03],
			A.[Avg_Q_43_04],
			A.[Avg_Q_43_05],
			A.[Avg_Q_43_06],
			A.[Avg_Q_43_07],
			A.[Avg_Q_43_08],
			A.[Avg_Q_43_09],
			A.[Avg_Q_43_10],
			A.[Avg_Q_44_00],
			A.[Avg_Q_44_01],
			A.[Avg_Q_44_02],
			A.[Avg_Q_44_03],
			A.[Avg_Q_44_04],
			A.[Avg_Q_44_05],
			A.[Avg_Q_44_06],
			A.[Avg_Q_44_07],
			A.[Avg_Q_44_08],
			A.[Avg_Q_44_09],
			A.[Avg_Q_44_10],
			A.[Avg_Q_45_00],
			A.[Avg_Q_45_01],
			A.[Avg_Q_45_02],
			A.[Avg_Q_45_03],
			A.[Avg_Q_45_04],
			A.[Avg_Q_45_05],
			A.[Avg_Q_45_06],
			A.[Avg_Q_45_07],
			A.[Avg_Q_45_08],
			A.[Avg_Q_45_09],
			A.[Avg_Q_45_10],
			A.[Avg_Q_46_00],
			A.[Avg_Q_46_01],
			A.[Avg_Q_46_02],
			A.[Avg_Q_46_03],
			A.[Avg_Q_46_04],
			A.[Avg_Q_46_05],
			A.[Avg_Q_46_06],
			A.[Avg_Q_46_07],
			A.[Avg_Q_46_08],
			A.[Avg_Q_46_09],
			A.[Avg_Q_46_10],
			A.[Avg_Q_47_00],
			A.[Avg_Q_47_01],
			A.[Avg_Q_47_02],
			A.[Avg_Q_47_03],
			A.[Avg_Q_47_04],
			A.[Avg_Q_47_05],
			A.[Avg_Q_47_06],
			A.[Avg_Q_47_07],
			A.[Avg_Q_47_08],
			A.[Avg_Q_47_09],
			A.[Avg_Q_47_10],
			A.[Avg_Q_48_00],
			A.[Avg_Q_48_01],
			A.[Avg_Q_48_02],
			A.[Avg_Q_48_03],
			A.[Avg_Q_48_04],
			A.[Avg_Q_48_05],
			A.[Avg_Q_48_06],
			A.[Avg_Q_48_07],
			A.[Avg_Q_48_08],
			A.[Avg_Q_48_09],
			A.[Avg_Q_48_10],
			A.[Avg_Q_49_00],
			A.[Avg_Q_49_01],
			A.[Avg_Q_49_02],
			A.[Avg_Q_49_03],
			A.[Avg_Q_49_04],
			A.[Avg_Q_49_05],
			A.[Avg_Q_49_06],
			A.[Avg_Q_49_07],
			A.[Avg_Q_49_08],
			A.[Avg_Q_49_09],
			A.[Avg_Q_49_10],
			A.[Avg_Q_50_00],
			A.[Avg_Q_50_01],
			A.[Avg_Q_50_02],
			A.[Avg_Q_50_03],
			A.[Avg_Q_50_04],
			A.[Avg_Q_50_05],
			A.[Avg_Q_50_06],
			A.[Avg_Q_50_07],
			A.[Avg_Q_50_08],
			A.[Avg_Q_50_09],
			A.[Avg_Q_50_10],
			A.[Avg_Q_51_00],
			A.[Avg_Q_51_01],
			A.[Avg_Q_51_02],
			A.[Avg_Q_51_03],
			A.[Avg_Q_51_04],
			A.[Avg_Q_51_05],
			A.[Avg_Q_51_06],
			A.[Avg_Q_51_07],
			A.[Avg_Q_51_08],
			A.[Avg_Q_51_09],
			A.[Avg_Q_51_10],
			A.[Avg_Q_52_00],
			A.[Avg_Q_52_01],
			A.[Avg_Q_52_02],
			A.[Avg_Q_52_03],
			A.[Avg_Q_52_04],
			A.[Avg_Q_52_05],
			A.[Avg_Q_52_06],
			A.[Avg_Q_52_07],
			A.[Avg_Q_52_08],
			A.[Avg_Q_52_09],
			A.[Avg_Q_52_10],
			A.[Avg_Q_53_00],
			A.[Avg_Q_53_01],
			A.[Avg_Q_53_02],
			A.[Avg_Q_53_03],
			A.[Avg_Q_53_04],
			A.[Avg_Q_53_05],
			A.[Avg_Q_53_06],
			A.[Avg_Q_53_07],
			A.[Avg_Q_53_08],
			A.[Avg_Q_53_09],
			A.[Avg_Q_53_10],
			A.[Avg_Q_54_00],
			A.[Avg_Q_54_01],
			A.[Avg_Q_54_02],
			A.[Avg_Q_54_03],
			A.[Avg_Q_54_04],
			A.[Avg_Q_54_05],
			A.[Avg_Q_54_06],
			A.[Avg_Q_54_07],
			A.[Avg_Q_54_08],
			A.[Avg_Q_54_09],
			A.[Avg_Q_54_10],
			A.[Avg_Q_55_00],
			A.[Avg_Q_55_01],
			A.[Avg_Q_55_02],
			A.[Avg_Q_55_03],
			A.[Avg_Q_55_04],
			A.[Avg_Q_55_05],
			A.[Avg_Q_55_06],
			A.[Avg_Q_55_07],
			A.[Avg_Q_55_08],
			A.[Avg_Q_55_09],
			A.[Avg_Q_55_10],
			A.[Avg_Q_56_00],
			A.[Avg_Q_56_01],
			A.[Avg_Q_56_02],
			A.[Avg_Q_56_03],
			A.[Avg_Q_56_04],
			A.[Avg_Q_56_05],
			A.[Avg_Q_56_06],
			A.[Avg_Q_56_07],
			A.[Avg_Q_56_08],
			A.[Avg_Q_56_09],
			A.[Avg_Q_56_10],
			A.[Avg_Q_57_00],
			A.[Avg_Q_57_01],
			A.[Avg_Q_57_02],
			A.[Avg_Q_57_03],
			A.[Avg_Q_57_04],
			A.[Avg_Q_57_05],
			A.[Avg_Q_57_06],
			A.[Avg_Q_57_07],
			A.[Avg_Q_57_08],
			A.[Avg_Q_57_09],
			A.[Avg_Q_57_10],
			A.[Avg_Q_58_00],
			A.[Avg_Q_58_01],
			A.[Avg_Q_58_02],
			A.[Avg_Q_58_03],
			A.[Avg_Q_58_04],
			A.[Avg_Q_58_05],
			A.[Avg_Q_58_06],
			A.[Avg_Q_58_07],
			A.[Avg_Q_58_08],
			A.[Avg_Q_58_09],
			A.[Avg_Q_58_10],
			A.[Avg_Q_59_00],
			A.[Avg_Q_59_01],
			A.[Avg_Q_59_02],
			A.[Avg_Q_59_03],
			A.[Avg_Q_59_04],
			A.[Avg_Q_59_05],
			A.[Avg_Q_59_06],
			A.[Avg_Q_59_07],
			A.[Avg_Q_59_08],
			A.[Avg_Q_59_09],
			A.[Avg_Q_59_10],
			A.[Avg_Q_60_00],
			A.[Avg_Q_60_01],
			A.[Avg_Q_60_02],
			A.[Avg_Q_60_03],
			A.[Avg_Q_60_04],
			A.[Avg_Q_60_05],
			A.[Avg_Q_60_06],
			A.[Avg_Q_60_07],
			A.[Avg_Q_60_08],
			A.[Avg_Q_60_09],
			A.[Avg_Q_60_10],
			A.[Avg_Q_61_00],
			A.[Avg_Q_61_01],
			A.[Avg_Q_61_02],
			A.[Avg_Q_61_03],
			A.[Avg_Q_61_04],
			A.[Avg_Q_61_05],
			A.[Avg_Q_61_06],
			A.[Avg_Q_61_07],
			A.[Avg_Q_61_08],
			A.[Avg_Q_61_09],
			A.[Avg_Q_61_10],
			A.[Avg_Q_62_00],
			A.[Avg_Q_62_01],
			A.[Avg_Q_62_02],
			A.[Avg_Q_62_03],
			A.[Avg_Q_62_04],
			A.[Avg_Q_62_05],
			A.[Avg_Q_62_06],
			A.[Avg_Q_62_07],
			A.[Avg_Q_62_08],
			A.[Avg_Q_62_09],
			A.[Avg_Q_62_10],
			A.[Avg_Q_63_00],
			A.[Avg_Q_63_01],
			A.[Avg_Q_63_02],
			A.[Avg_Q_63_03],
			A.[Avg_Q_63_04],
			A.[Avg_Q_63_05],
			A.[Avg_Q_63_06],
			A.[Avg_Q_63_07],
			A.[Avg_Q_63_08],
			A.[Avg_Q_63_09],
			A.[Avg_Q_63_10],
			A.[Avg_Q_64_00],
			A.[Avg_Q_64_01],
			A.[Avg_Q_64_02],
			A.[Avg_Q_64_03],
			A.[Avg_Q_64_04],
			A.[Avg_Q_64_05],
			A.[Avg_Q_64_06],
			A.[Avg_Q_64_07],
			A.[Avg_Q_64_08],
			A.[Avg_Q_64_09],
			A.[Avg_Q_64_10],
			A.[Avg_Q_65_00],
			A.[Avg_Q_65_01],
			A.[Avg_Q_65_02],
			A.[Avg_Q_65_03],
			A.[Avg_Q_65_04],
			A.[Avg_Q_65_05],
			A.[Avg_Q_65_06],
			A.[Avg_Q_65_07],
			A.[Avg_Q_65_08],
			A.[Avg_Q_65_09],
			A.[Avg_Q_65_10],
			A.[Avg_Q_66_00],
			A.[Avg_Q_66_01],
			A.[Avg_Q_66_02],
			A.[Avg_Q_66_03],
			A.[Avg_Q_66_04],
			A.[Avg_Q_66_05],
			A.[Avg_Q_66_06],
			A.[Avg_Q_66_07],
			A.[Avg_Q_66_08],
			A.[Avg_Q_66_09],
			A.[Avg_Q_66_10],
			A.[Avg_Q_67_00],
			A.[Avg_Q_67_01],
			A.[Avg_Q_67_02],
			A.[Avg_Q_67_03],
			A.[Avg_Q_67_04],
			A.[Avg_Q_67_05],
			A.[Avg_Q_67_06],
			A.[Avg_Q_67_07],
			A.[Avg_Q_67_08],
			A.[Avg_Q_67_09],
			A.[Avg_Q_67_10],
			A.[Avg_Q_68_00],
			A.[Avg_Q_68_01],
			A.[Avg_Q_68_02],
			A.[Avg_Q_68_03],
			A.[Avg_Q_68_04],
			A.[Avg_Q_68_05],
			A.[Avg_Q_68_06],
			A.[Avg_Q_68_07],
			A.[Avg_Q_68_08],
			A.[Avg_Q_68_09],
			A.[Avg_Q_68_10],
			A.[Avg_Q_69_00],
			A.[Avg_Q_69_01],
			A.[Avg_Q_69_02],
			A.[Avg_Q_69_03],
			A.[Avg_Q_69_04],
			A.[Avg_Q_69_05],
			A.[Avg_Q_69_06],
			A.[Avg_Q_69_07],
			A.[Avg_Q_69_08],
			A.[Avg_Q_69_09],
			A.[Avg_Q_69_10],
			A.[Avg_Q_70_00],
			A.[Avg_Q_70_01],
			A.[Avg_Q_70_02],
			A.[Avg_Q_70_03],
			A.[Avg_Q_70_04],
			A.[Avg_Q_70_05],
			A.[Avg_Q_70_06],
			A.[Avg_Q_70_07],
			A.[Avg_Q_70_08],
			A.[Avg_Q_70_09],
			A.[Avg_Q_70_10],
			/*
			A.[Avg_Q_71_00],
			A.[Avg_Q_71_01],
			A.[Avg_Q_71_02],
			A.[Avg_Q_71_03],
			A.[Avg_Q_71_04],
			A.[Avg_Q_71_05],
			A.[Avg_Q_71_06],
			A.[Avg_Q_71_07],
			A.[Avg_Q_71_08],
			A.[Avg_Q_71_09],
			A.[Avg_Q_71_10],
			A.[Avg_Q_72_00],
			A.[Avg_Q_72_01],
			A.[Avg_Q_72_02],
			A.[Avg_Q_72_03],
			A.[Avg_Q_72_04],
			A.[Avg_Q_72_05],
			A.[Avg_Q_72_06],
			A.[Avg_Q_72_07],
			A.[Avg_Q_72_08],
			A.[Avg_Q_72_09],
			A.[Avg_Q_72_10],
			A.[Avg_Q_73_00],
			A.[Avg_Q_73_01],
			A.[Avg_Q_73_02],
			A.[Avg_Q_73_03],
			A.[Avg_Q_73_04],
			A.[Avg_Q_73_05],
			A.[Avg_Q_73_06],
			A.[Avg_Q_73_07],
			A.[Avg_Q_73_08],
			A.[Avg_Q_73_09],
			A.[Avg_Q_73_10],
			A.[Avg_Q_74_00],
			A.[Avg_Q_74_01],
			A.[Avg_Q_74_02],
			A.[Avg_Q_74_03],
			A.[Avg_Q_74_04],
			A.[Avg_Q_74_05],
			A.[Avg_Q_74_06],
			A.[Avg_Q_74_07],
			A.[Avg_Q_74_08],
			A.[Avg_Q_74_09],
			A.[Avg_Q_74_10],
			A.[Avg_Q_75_00],
			A.[Avg_Q_75_01],
			A.[Avg_Q_75_02],
			A.[Avg_Q_75_03],
			A.[Avg_Q_75_04],
			A.[Avg_Q_75_05],
			A.[Avg_Q_75_06],
			A.[Avg_Q_75_07],
			A.[Avg_Q_75_08],
			A.[Avg_Q_75_09],
			A.[Avg_Q_75_10],
			*/
			A.[NPS],
			A.[RPI],
			A.[Achievement Z-Score],
			A.[Belonging Z-Score],
			A.[Character Z-Score],
			A.[Giving Z-Score],
			A.[Health Z-Score],
			A.[Inspiration Z-Score],
			A.[Meaning Z-Score],
			A.[Relationship Z-Score],
			A.[Safety Z-Score],
			A.[Achievement Percentile],
			A.[Belonging Percentile],
			A.[Character Percentile],
			A.[Giving Percentile],
			A.[Health Percentile],
			A.[Inspiration Percentile],
			A.[Meaning Percentile],
			A.[Relationship Percentile],
			A.[Safety Percentile],
			A.[CreateDateTime]
			
	FROM	Seer_STG.dbo.[Program Aggregated Data] A

	WHERE	LEN(A.Form_Code) = 0
			--OR ((LEN(COALESCE(A.[Response_Count], '')) > 0) AND (ISNUMERIC(COALESCE(A.[Response_Count], '')) = 0) AND (CONVERT(INT, A.[Response_Count]) < 0))
			OR ((LEN(COALESCE(A.[Response_Count], '')) > 0 AND ISNUMERIC(COALESCE(A.[Response_Count], '')) = 0) OR (ISNUMERIC(COALESCE(A.[Response_Count], '')) = 1 AND CONVERT(INT, A.[Response_Count]) < 0))
			OR ((ISNUMERIC(A.[Avg_Q_01_00]) = 0 AND LEN(A.[Avg_Q_01_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_01]) = 0 AND LEN(A.[Avg_Q_01_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_02]) = 0 AND LEN(A.[Avg_Q_01_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_03]) = 0 AND LEN(A.[Avg_Q_01_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_04]) = 0 AND LEN(A.[Avg_Q_01_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_05]) = 0 AND LEN(A.[Avg_Q_01_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_06]) = 0 AND LEN(A.[Avg_Q_01_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_07]) = 0 AND LEN(A.[Avg_Q_01_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_08]) = 0 AND LEN(A.[Avg_Q_01_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_09]) = 0 AND LEN(A.[Avg_Q_01_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_01_10]) = 0 AND LEN(A.[Avg_Q_01_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_01_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_01_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_00]) = 0 AND LEN(A.[Avg_Q_02_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_01]) = 0 AND LEN(A.[Avg_Q_02_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_02]) = 0 AND LEN(A.[Avg_Q_02_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_03]) = 0 AND LEN(A.[Avg_Q_02_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_04]) = 0 AND LEN(A.[Avg_Q_02_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_05]) = 0 AND LEN(A.[Avg_Q_02_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_06]) = 0 AND LEN(A.[Avg_Q_02_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_07]) = 0 AND LEN(A.[Avg_Q_02_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_08]) = 0 AND LEN(A.[Avg_Q_02_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_09]) = 0 AND LEN(A.[Avg_Q_02_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_02_10]) = 0 AND LEN(A.[Avg_Q_02_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_02_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_02_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_00]) = 0 AND LEN(A.[Avg_Q_03_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_01]) = 0 AND LEN(A.[Avg_Q_03_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_02]) = 0 AND LEN(A.[Avg_Q_03_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_03]) = 0 AND LEN(A.[Avg_Q_03_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_04]) = 0 AND LEN(A.[Avg_Q_03_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_05]) = 0 AND LEN(A.[Avg_Q_03_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_06]) = 0 AND LEN(A.[Avg_Q_03_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_07]) = 0 AND LEN(A.[Avg_Q_03_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_08]) = 0 AND LEN(A.[Avg_Q_03_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_09]) = 0 AND LEN(A.[Avg_Q_03_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_03_10]) = 0 AND LEN(A.[Avg_Q_03_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_03_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_03_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_00]) = 0 AND LEN(A.[Avg_Q_04_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_01]) = 0 AND LEN(A.[Avg_Q_04_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_02]) = 0 AND LEN(A.[Avg_Q_04_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_03]) = 0 AND LEN(A.[Avg_Q_04_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_04]) = 0 AND LEN(A.[Avg_Q_04_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_05]) = 0 AND LEN(A.[Avg_Q_04_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_06]) = 0 AND LEN(A.[Avg_Q_04_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_07]) = 0 AND LEN(A.[Avg_Q_04_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_08]) = 0 AND LEN(A.[Avg_Q_04_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_09]) = 0 AND LEN(A.[Avg_Q_04_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_04_10]) = 0 AND LEN(A.[Avg_Q_04_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_04_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_04_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_00]) = 0 AND LEN(A.[Avg_Q_05_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_01]) = 0 AND LEN(A.[Avg_Q_05_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_02]) = 0 AND LEN(A.[Avg_Q_05_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_03]) = 0 AND LEN(A.[Avg_Q_05_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_04]) = 0 AND LEN(A.[Avg_Q_05_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_05]) = 0 AND LEN(A.[Avg_Q_05_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_06]) = 0 AND LEN(A.[Avg_Q_05_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_07]) = 0 AND LEN(A.[Avg_Q_05_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_08]) = 0 AND LEN(A.[Avg_Q_05_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_09]) = 0 AND LEN(A.[Avg_Q_05_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_05_10]) = 0 AND LEN(A.[Avg_Q_05_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_05_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_05_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_00]) = 0 AND LEN(A.[Avg_Q_06_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_01]) = 0 AND LEN(A.[Avg_Q_06_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_02]) = 0 AND LEN(A.[Avg_Q_06_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_03]) = 0 AND LEN(A.[Avg_Q_06_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_04]) = 0 AND LEN(A.[Avg_Q_06_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_05]) = 0 AND LEN(A.[Avg_Q_06_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_06]) = 0 AND LEN(A.[Avg_Q_06_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_07]) = 0 AND LEN(A.[Avg_Q_06_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_08]) = 0 AND LEN(A.[Avg_Q_06_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_09]) = 0 AND LEN(A.[Avg_Q_06_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_06_10]) = 0 AND LEN(A.[Avg_Q_06_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_06_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_06_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_00]) = 0 AND LEN(A.[Avg_Q_07_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_01]) = 0 AND LEN(A.[Avg_Q_07_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_02]) = 0 AND LEN(A.[Avg_Q_07_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_03]) = 0 AND LEN(A.[Avg_Q_07_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_04]) = 0 AND LEN(A.[Avg_Q_07_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_05]) = 0 AND LEN(A.[Avg_Q_07_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_06]) = 0 AND LEN(A.[Avg_Q_07_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_07]) = 0 AND LEN(A.[Avg_Q_07_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_08]) = 0 AND LEN(A.[Avg_Q_07_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_09]) = 0 AND LEN(A.[Avg_Q_07_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_07_10]) = 0 AND LEN(A.[Avg_Q_07_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_07_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_07_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_00]) = 0 AND LEN(A.[Avg_Q_08_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_01]) = 0 AND LEN(A.[Avg_Q_08_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_02]) = 0 AND LEN(A.[Avg_Q_08_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_03]) = 0 AND LEN(A.[Avg_Q_08_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_04]) = 0 AND LEN(A.[Avg_Q_08_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_05]) = 0 AND LEN(A.[Avg_Q_08_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_06]) = 0 AND LEN(A.[Avg_Q_08_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_07]) = 0 AND LEN(A.[Avg_Q_08_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_08]) = 0 AND LEN(A.[Avg_Q_08_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_09]) = 0 AND LEN(A.[Avg_Q_08_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_08_10]) = 0 AND LEN(A.[Avg_Q_08_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_08_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_08_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_00]) = 0 AND LEN(A.[Avg_Q_09_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_01]) = 0 AND LEN(A.[Avg_Q_09_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_02]) = 0 AND LEN(A.[Avg_Q_09_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_03]) = 0 AND LEN(A.[Avg_Q_09_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_04]) = 0 AND LEN(A.[Avg_Q_09_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_05]) = 0 AND LEN(A.[Avg_Q_09_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_06]) = 0 AND LEN(A.[Avg_Q_09_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_07]) = 0 AND LEN(A.[Avg_Q_09_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_08]) = 0 AND LEN(A.[Avg_Q_09_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_09]) = 0 AND LEN(A.[Avg_Q_09_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_09_10]) = 0 AND LEN(A.[Avg_Q_09_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_09_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_09_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_00]) = 0 AND LEN(A.[Avg_Q_10_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_01]) = 0 AND LEN(A.[Avg_Q_10_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_02]) = 0 AND LEN(A.[Avg_Q_10_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_03]) = 0 AND LEN(A.[Avg_Q_10_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_04]) = 0 AND LEN(A.[Avg_Q_10_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_05]) = 0 AND LEN(A.[Avg_Q_10_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_06]) = 0 AND LEN(A.[Avg_Q_10_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_07]) = 0 AND LEN(A.[Avg_Q_10_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_08]) = 0 AND LEN(A.[Avg_Q_10_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_09]) = 0 AND LEN(A.[Avg_Q_10_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_10_10]) = 0 AND LEN(A.[Avg_Q_10_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_10_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_10_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_00]) = 0 AND LEN(A.[Avg_Q_11_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_01]) = 0 AND LEN(A.[Avg_Q_11_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_02]) = 0 AND LEN(A.[Avg_Q_11_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_03]) = 0 AND LEN(A.[Avg_Q_11_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_04]) = 0 AND LEN(A.[Avg_Q_11_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_05]) = 0 AND LEN(A.[Avg_Q_11_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_06]) = 0 AND LEN(A.[Avg_Q_11_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_07]) = 0 AND LEN(A.[Avg_Q_11_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_08]) = 0 AND LEN(A.[Avg_Q_11_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_09]) = 0 AND LEN(A.[Avg_Q_11_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_11_10]) = 0 AND LEN(A.[Avg_Q_11_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_11_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_11_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_00]) = 0 AND LEN(A.[Avg_Q_12_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_01]) = 0 AND LEN(A.[Avg_Q_12_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_02]) = 0 AND LEN(A.[Avg_Q_12_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_03]) = 0 AND LEN(A.[Avg_Q_12_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_04]) = 0 AND LEN(A.[Avg_Q_12_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_05]) = 0 AND LEN(A.[Avg_Q_12_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_06]) = 0 AND LEN(A.[Avg_Q_12_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_07]) = 0 AND LEN(A.[Avg_Q_12_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_08]) = 0 AND LEN(A.[Avg_Q_12_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_09]) = 0 AND LEN(A.[Avg_Q_12_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_12_10]) = 0 AND LEN(A.[Avg_Q_12_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_12_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_12_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_00]) = 0 AND LEN(A.[Avg_Q_13_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_01]) = 0 AND LEN(A.[Avg_Q_13_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_02]) = 0 AND LEN(A.[Avg_Q_13_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_03]) = 0 AND LEN(A.[Avg_Q_13_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_04]) = 0 AND LEN(A.[Avg_Q_13_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_05]) = 0 AND LEN(A.[Avg_Q_13_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_06]) = 0 AND LEN(A.[Avg_Q_13_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_07]) = 0 AND LEN(A.[Avg_Q_13_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_08]) = 0 AND LEN(A.[Avg_Q_13_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_09]) = 0 AND LEN(A.[Avg_Q_13_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_13_10]) = 0 AND LEN(A.[Avg_Q_13_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_13_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_13_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_00]) = 0 AND LEN(A.[Avg_Q_14_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_01]) = 0 AND LEN(A.[Avg_Q_14_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_02]) = 0 AND LEN(A.[Avg_Q_14_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_03]) = 0 AND LEN(A.[Avg_Q_14_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_04]) = 0 AND LEN(A.[Avg_Q_14_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_05]) = 0 AND LEN(A.[Avg_Q_14_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_06]) = 0 AND LEN(A.[Avg_Q_14_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_07]) = 0 AND LEN(A.[Avg_Q_14_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_08]) = 0 AND LEN(A.[Avg_Q_14_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_09]) = 0 AND LEN(A.[Avg_Q_14_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_14_10]) = 0 AND LEN(A.[Avg_Q_14_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_14_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_14_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_00]) = 0 AND LEN(A.[Avg_Q_15_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_01]) = 0 AND LEN(A.[Avg_Q_15_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_02]) = 0 AND LEN(A.[Avg_Q_15_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_03]) = 0 AND LEN(A.[Avg_Q_15_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_04]) = 0 AND LEN(A.[Avg_Q_15_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_05]) = 0 AND LEN(A.[Avg_Q_15_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_06]) = 0 AND LEN(A.[Avg_Q_15_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_07]) = 0 AND LEN(A.[Avg_Q_15_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_08]) = 0 AND LEN(A.[Avg_Q_15_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_09]) = 0 AND LEN(A.[Avg_Q_15_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_15_10]) = 0 AND LEN(A.[Avg_Q_15_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_15_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_15_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_00]) = 0 AND LEN(A.[Avg_Q_16_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_01]) = 0 AND LEN(A.[Avg_Q_16_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_02]) = 0 AND LEN(A.[Avg_Q_16_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_03]) = 0 AND LEN(A.[Avg_Q_16_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_04]) = 0 AND LEN(A.[Avg_Q_16_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_05]) = 0 AND LEN(A.[Avg_Q_16_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_06]) = 0 AND LEN(A.[Avg_Q_16_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_07]) = 0 AND LEN(A.[Avg_Q_16_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_08]) = 0 AND LEN(A.[Avg_Q_16_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_09]) = 0 AND LEN(A.[Avg_Q_16_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_16_10]) = 0 AND LEN(A.[Avg_Q_16_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_16_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_16_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_00]) = 0 AND LEN(A.[Avg_Q_17_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_01]) = 0 AND LEN(A.[Avg_Q_17_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_02]) = 0 AND LEN(A.[Avg_Q_17_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_03]) = 0 AND LEN(A.[Avg_Q_17_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_04]) = 0 AND LEN(A.[Avg_Q_17_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_05]) = 0 AND LEN(A.[Avg_Q_17_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_06]) = 0 AND LEN(A.[Avg_Q_17_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_07]) = 0 AND LEN(A.[Avg_Q_17_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_08]) = 0 AND LEN(A.[Avg_Q_17_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_09]) = 0 AND LEN(A.[Avg_Q_17_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_17_10]) = 0 AND LEN(A.[Avg_Q_17_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_17_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_17_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_00]) = 0 AND LEN(A.[Avg_Q_18_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_01]) = 0 AND LEN(A.[Avg_Q_18_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_02]) = 0 AND LEN(A.[Avg_Q_18_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_03]) = 0 AND LEN(A.[Avg_Q_18_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_04]) = 0 AND LEN(A.[Avg_Q_18_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_05]) = 0 AND LEN(A.[Avg_Q_18_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_06]) = 0 AND LEN(A.[Avg_Q_18_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_07]) = 0 AND LEN(A.[Avg_Q_18_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_08]) = 0 AND LEN(A.[Avg_Q_18_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_09]) = 0 AND LEN(A.[Avg_Q_18_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_18_10]) = 0 AND LEN(A.[Avg_Q_18_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_18_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_18_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_00]) = 0 AND LEN(A.[Avg_Q_19_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_01]) = 0 AND LEN(A.[Avg_Q_19_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_02]) = 0 AND LEN(A.[Avg_Q_19_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_03]) = 0 AND LEN(A.[Avg_Q_19_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_04]) = 0 AND LEN(A.[Avg_Q_19_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_05]) = 0 AND LEN(A.[Avg_Q_19_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_06]) = 0 AND LEN(A.[Avg_Q_19_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_07]) = 0 AND LEN(A.[Avg_Q_19_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_08]) = 0 AND LEN(A.[Avg_Q_19_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_09]) = 0 AND LEN(A.[Avg_Q_19_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_19_10]) = 0 AND LEN(A.[Avg_Q_19_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_19_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_19_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_00]) = 0 AND LEN(A.[Avg_Q_20_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_01]) = 0 AND LEN(A.[Avg_Q_20_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_02]) = 0 AND LEN(A.[Avg_Q_20_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_03]) = 0 AND LEN(A.[Avg_Q_20_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_04]) = 0 AND LEN(A.[Avg_Q_20_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_05]) = 0 AND LEN(A.[Avg_Q_20_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_06]) = 0 AND LEN(A.[Avg_Q_20_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_07]) = 0 AND LEN(A.[Avg_Q_20_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_08]) = 0 AND LEN(A.[Avg_Q_20_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_09]) = 0 AND LEN(A.[Avg_Q_20_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_20_10]) = 0 AND LEN(A.[Avg_Q_20_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_20_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_20_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_00]) = 0 AND LEN(A.[Avg_Q_21_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_01]) = 0 AND LEN(A.[Avg_Q_21_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_02]) = 0 AND LEN(A.[Avg_Q_21_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_03]) = 0 AND LEN(A.[Avg_Q_21_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_04]) = 0 AND LEN(A.[Avg_Q_21_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_05]) = 0 AND LEN(A.[Avg_Q_21_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_06]) = 0 AND LEN(A.[Avg_Q_21_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_07]) = 0 AND LEN(A.[Avg_Q_21_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_08]) = 0 AND LEN(A.[Avg_Q_21_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_09]) = 0 AND LEN(A.[Avg_Q_21_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_21_10]) = 0 AND LEN(A.[Avg_Q_21_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_21_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_21_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_00]) = 0 AND LEN(A.[Avg_Q_22_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_01]) = 0 AND LEN(A.[Avg_Q_22_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_02]) = 0 AND LEN(A.[Avg_Q_22_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_03]) = 0 AND LEN(A.[Avg_Q_22_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_04]) = 0 AND LEN(A.[Avg_Q_22_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_05]) = 0 AND LEN(A.[Avg_Q_22_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_06]) = 0 AND LEN(A.[Avg_Q_22_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_07]) = 0 AND LEN(A.[Avg_Q_22_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_08]) = 0 AND LEN(A.[Avg_Q_22_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_09]) = 0 AND LEN(A.[Avg_Q_22_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_22_10]) = 0 AND LEN(A.[Avg_Q_22_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_22_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_22_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_00]) = 0 AND LEN(A.[Avg_Q_23_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_01]) = 0 AND LEN(A.[Avg_Q_23_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_02]) = 0 AND LEN(A.[Avg_Q_23_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_03]) = 0 AND LEN(A.[Avg_Q_23_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_04]) = 0 AND LEN(A.[Avg_Q_23_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_05]) = 0 AND LEN(A.[Avg_Q_23_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_06]) = 0 AND LEN(A.[Avg_Q_23_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_07]) = 0 AND LEN(A.[Avg_Q_23_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_08]) = 0 AND LEN(A.[Avg_Q_23_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_09]) = 0 AND LEN(A.[Avg_Q_23_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_23_10]) = 0 AND LEN(A.[Avg_Q_23_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_23_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_23_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_00]) = 0 AND LEN(A.[Avg_Q_24_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_01]) = 0 AND LEN(A.[Avg_Q_24_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_02]) = 0 AND LEN(A.[Avg_Q_24_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_03]) = 0 AND LEN(A.[Avg_Q_24_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_04]) = 0 AND LEN(A.[Avg_Q_24_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_05]) = 0 AND LEN(A.[Avg_Q_24_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_06]) = 0 AND LEN(A.[Avg_Q_24_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_07]) = 0 AND LEN(A.[Avg_Q_24_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_08]) = 0 AND LEN(A.[Avg_Q_24_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_09]) = 0 AND LEN(A.[Avg_Q_24_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_24_10]) = 0 AND LEN(A.[Avg_Q_24_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_24_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_24_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_00]) = 0 AND LEN(A.[Avg_Q_25_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_01]) = 0 AND LEN(A.[Avg_Q_25_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_02]) = 0 AND LEN(A.[Avg_Q_25_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_03]) = 0 AND LEN(A.[Avg_Q_25_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_04]) = 0 AND LEN(A.[Avg_Q_25_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_05]) = 0 AND LEN(A.[Avg_Q_25_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_06]) = 0 AND LEN(A.[Avg_Q_25_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_07]) = 0 AND LEN(A.[Avg_Q_25_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_08]) = 0 AND LEN(A.[Avg_Q_25_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_09]) = 0 AND LEN(A.[Avg_Q_25_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_25_10]) = 0 AND LEN(A.[Avg_Q_25_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_25_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_25_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_00]) = 0 AND LEN(A.[Avg_Q_26_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_01]) = 0 AND LEN(A.[Avg_Q_26_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_02]) = 0 AND LEN(A.[Avg_Q_26_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_03]) = 0 AND LEN(A.[Avg_Q_26_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_04]) = 0 AND LEN(A.[Avg_Q_26_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_05]) = 0 AND LEN(A.[Avg_Q_26_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_06]) = 0 AND LEN(A.[Avg_Q_26_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_07]) = 0 AND LEN(A.[Avg_Q_26_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_08]) = 0 AND LEN(A.[Avg_Q_26_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_09]) = 0 AND LEN(A.[Avg_Q_26_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_26_10]) = 0 AND LEN(A.[Avg_Q_26_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_26_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_26_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_00]) = 0 AND LEN(A.[Avg_Q_27_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_01]) = 0 AND LEN(A.[Avg_Q_27_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_02]) = 0 AND LEN(A.[Avg_Q_27_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_03]) = 0 AND LEN(A.[Avg_Q_27_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_04]) = 0 AND LEN(A.[Avg_Q_27_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_05]) = 0 AND LEN(A.[Avg_Q_27_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_06]) = 0 AND LEN(A.[Avg_Q_27_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_07]) = 0 AND LEN(A.[Avg_Q_27_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_08]) = 0 AND LEN(A.[Avg_Q_27_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_09]) = 0 AND LEN(A.[Avg_Q_27_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_27_10]) = 0 AND LEN(A.[Avg_Q_27_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_27_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_27_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_00]) = 0 AND LEN(A.[Avg_Q_28_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_01]) = 0 AND LEN(A.[Avg_Q_28_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_02]) = 0 AND LEN(A.[Avg_Q_28_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_03]) = 0 AND LEN(A.[Avg_Q_28_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_04]) = 0 AND LEN(A.[Avg_Q_28_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_05]) = 0 AND LEN(A.[Avg_Q_28_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_06]) = 0 AND LEN(A.[Avg_Q_28_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_07]) = 0 AND LEN(A.[Avg_Q_28_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_08]) = 0 AND LEN(A.[Avg_Q_28_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_09]) = 0 AND LEN(A.[Avg_Q_28_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_28_10]) = 0 AND LEN(A.[Avg_Q_28_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_28_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_28_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_00]) = 0 AND LEN(A.[Avg_Q_29_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_01]) = 0 AND LEN(A.[Avg_Q_29_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_02]) = 0 AND LEN(A.[Avg_Q_29_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_03]) = 0 AND LEN(A.[Avg_Q_29_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_04]) = 0 AND LEN(A.[Avg_Q_29_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_05]) = 0 AND LEN(A.[Avg_Q_29_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_06]) = 0 AND LEN(A.[Avg_Q_29_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_07]) = 0 AND LEN(A.[Avg_Q_29_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_08]) = 0 AND LEN(A.[Avg_Q_29_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_09]) = 0 AND LEN(A.[Avg_Q_29_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_29_10]) = 0 AND LEN(A.[Avg_Q_29_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_29_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_29_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_00]) = 0 AND LEN(A.[Avg_Q_30_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_01]) = 0 AND LEN(A.[Avg_Q_30_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_02]) = 0 AND LEN(A.[Avg_Q_30_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_03]) = 0 AND LEN(A.[Avg_Q_30_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_04]) = 0 AND LEN(A.[Avg_Q_30_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_05]) = 0 AND LEN(A.[Avg_Q_30_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_06]) = 0 AND LEN(A.[Avg_Q_30_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_07]) = 0 AND LEN(A.[Avg_Q_30_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_08]) = 0 AND LEN(A.[Avg_Q_30_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_09]) = 0 AND LEN(A.[Avg_Q_30_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_30_10]) = 0 AND LEN(A.[Avg_Q_30_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_30_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_30_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_00]) = 0 AND LEN(A.[Avg_Q_31_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_01]) = 0 AND LEN(A.[Avg_Q_31_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_02]) = 0 AND LEN(A.[Avg_Q_31_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_03]) = 0 AND LEN(A.[Avg_Q_31_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_04]) = 0 AND LEN(A.[Avg_Q_31_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_05]) = 0 AND LEN(A.[Avg_Q_31_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_06]) = 0 AND LEN(A.[Avg_Q_31_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_07]) = 0 AND LEN(A.[Avg_Q_31_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_08]) = 0 AND LEN(A.[Avg_Q_31_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_09]) = 0 AND LEN(A.[Avg_Q_31_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_31_10]) = 0 AND LEN(A.[Avg_Q_31_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_31_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_31_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_00]) = 0 AND LEN(A.[Avg_Q_32_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_01]) = 0 AND LEN(A.[Avg_Q_32_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_02]) = 0 AND LEN(A.[Avg_Q_32_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_03]) = 0 AND LEN(A.[Avg_Q_32_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_04]) = 0 AND LEN(A.[Avg_Q_32_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_05]) = 0 AND LEN(A.[Avg_Q_32_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_06]) = 0 AND LEN(A.[Avg_Q_32_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_07]) = 0 AND LEN(A.[Avg_Q_32_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_08]) = 0 AND LEN(A.[Avg_Q_32_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_09]) = 0 AND LEN(A.[Avg_Q_32_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_32_10]) = 0 AND LEN(A.[Avg_Q_32_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_32_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_32_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_00]) = 0 AND LEN(A.[Avg_Q_33_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_01]) = 0 AND LEN(A.[Avg_Q_33_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_02]) = 0 AND LEN(A.[Avg_Q_33_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_03]) = 0 AND LEN(A.[Avg_Q_33_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_04]) = 0 AND LEN(A.[Avg_Q_33_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_05]) = 0 AND LEN(A.[Avg_Q_33_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_06]) = 0 AND LEN(A.[Avg_Q_33_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_07]) = 0 AND LEN(A.[Avg_Q_33_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_08]) = 0 AND LEN(A.[Avg_Q_33_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_09]) = 0 AND LEN(A.[Avg_Q_33_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_33_10]) = 0 AND LEN(A.[Avg_Q_33_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_33_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_33_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_00]) = 0 AND LEN(A.[Avg_Q_34_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_01]) = 0 AND LEN(A.[Avg_Q_34_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_02]) = 0 AND LEN(A.[Avg_Q_34_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_03]) = 0 AND LEN(A.[Avg_Q_34_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_04]) = 0 AND LEN(A.[Avg_Q_34_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_05]) = 0 AND LEN(A.[Avg_Q_34_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_06]) = 0 AND LEN(A.[Avg_Q_34_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_07]) = 0 AND LEN(A.[Avg_Q_34_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_08]) = 0 AND LEN(A.[Avg_Q_34_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_09]) = 0 AND LEN(A.[Avg_Q_34_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_34_10]) = 0 AND LEN(A.[Avg_Q_34_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_34_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_34_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_00]) = 0 AND LEN(A.[Avg_Q_35_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_01]) = 0 AND LEN(A.[Avg_Q_35_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_02]) = 0 AND LEN(A.[Avg_Q_35_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_03]) = 0 AND LEN(A.[Avg_Q_35_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_04]) = 0 AND LEN(A.[Avg_Q_35_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_05]) = 0 AND LEN(A.[Avg_Q_35_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_06]) = 0 AND LEN(A.[Avg_Q_35_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_07]) = 0 AND LEN(A.[Avg_Q_35_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_08]) = 0 AND LEN(A.[Avg_Q_35_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_09]) = 0 AND LEN(A.[Avg_Q_35_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_35_10]) = 0 AND LEN(A.[Avg_Q_35_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_35_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_35_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_00]) = 0 AND LEN(A.[Avg_Q_36_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_01]) = 0 AND LEN(A.[Avg_Q_36_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_02]) = 0 AND LEN(A.[Avg_Q_36_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_03]) = 0 AND LEN(A.[Avg_Q_36_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_04]) = 0 AND LEN(A.[Avg_Q_36_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_05]) = 0 AND LEN(A.[Avg_Q_36_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_06]) = 0 AND LEN(A.[Avg_Q_36_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_07]) = 0 AND LEN(A.[Avg_Q_36_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_08]) = 0 AND LEN(A.[Avg_Q_36_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_09]) = 0 AND LEN(A.[Avg_Q_36_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_36_10]) = 0 AND LEN(A.[Avg_Q_36_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_36_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_36_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_00]) = 0 AND LEN(A.[Avg_Q_37_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_01]) = 0 AND LEN(A.[Avg_Q_37_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_02]) = 0 AND LEN(A.[Avg_Q_37_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_03]) = 0 AND LEN(A.[Avg_Q_37_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_04]) = 0 AND LEN(A.[Avg_Q_37_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_05]) = 0 AND LEN(A.[Avg_Q_37_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_06]) = 0 AND LEN(A.[Avg_Q_37_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_07]) = 0 AND LEN(A.[Avg_Q_37_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_08]) = 0 AND LEN(A.[Avg_Q_37_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_09]) = 0 AND LEN(A.[Avg_Q_37_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_37_10]) = 0 AND LEN(A.[Avg_Q_37_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_37_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_37_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_00]) = 0 AND LEN(A.[Avg_Q_38_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_01]) = 0 AND LEN(A.[Avg_Q_38_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_02]) = 0 AND LEN(A.[Avg_Q_38_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_03]) = 0 AND LEN(A.[Avg_Q_38_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_04]) = 0 AND LEN(A.[Avg_Q_38_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_05]) = 0 AND LEN(A.[Avg_Q_38_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_06]) = 0 AND LEN(A.[Avg_Q_38_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_07]) = 0 AND LEN(A.[Avg_Q_38_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_08]) = 0 AND LEN(A.[Avg_Q_38_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_09]) = 0 AND LEN(A.[Avg_Q_38_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_38_10]) = 0 AND LEN(A.[Avg_Q_38_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_38_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_38_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_00]) = 0 AND LEN(A.[Avg_Q_39_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_01]) = 0 AND LEN(A.[Avg_Q_39_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_02]) = 0 AND LEN(A.[Avg_Q_39_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_03]) = 0 AND LEN(A.[Avg_Q_39_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_04]) = 0 AND LEN(A.[Avg_Q_39_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_05]) = 0 AND LEN(A.[Avg_Q_39_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_06]) = 0 AND LEN(A.[Avg_Q_39_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_07]) = 0 AND LEN(A.[Avg_Q_39_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_08]) = 0 AND LEN(A.[Avg_Q_39_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_09]) = 0 AND LEN(A.[Avg_Q_39_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_39_10]) = 0 AND LEN(A.[Avg_Q_39_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_39_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_39_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_00]) = 0 AND LEN(A.[Avg_Q_40_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_01]) = 0 AND LEN(A.[Avg_Q_40_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_02]) = 0 AND LEN(A.[Avg_Q_40_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_03]) = 0 AND LEN(A.[Avg_Q_40_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_04]) = 0 AND LEN(A.[Avg_Q_40_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_05]) = 0 AND LEN(A.[Avg_Q_40_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_06]) = 0 AND LEN(A.[Avg_Q_40_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_07]) = 0 AND LEN(A.[Avg_Q_40_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_08]) = 0 AND LEN(A.[Avg_Q_40_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_09]) = 0 AND LEN(A.[Avg_Q_40_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_40_10]) = 0 AND LEN(A.[Avg_Q_40_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_40_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_40_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_00]) = 0 AND LEN(A.[Avg_Q_41_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_01]) = 0 AND LEN(A.[Avg_Q_41_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_02]) = 0 AND LEN(A.[Avg_Q_41_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_03]) = 0 AND LEN(A.[Avg_Q_41_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_04]) = 0 AND LEN(A.[Avg_Q_41_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_05]) = 0 AND LEN(A.[Avg_Q_41_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_06]) = 0 AND LEN(A.[Avg_Q_41_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_07]) = 0 AND LEN(A.[Avg_Q_41_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_08]) = 0 AND LEN(A.[Avg_Q_41_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_09]) = 0 AND LEN(A.[Avg_Q_41_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_41_10]) = 0 AND LEN(A.[Avg_Q_41_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_41_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_41_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_00]) = 0 AND LEN(A.[Avg_Q_42_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_01]) = 0 AND LEN(A.[Avg_Q_42_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_02]) = 0 AND LEN(A.[Avg_Q_42_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_03]) = 0 AND LEN(A.[Avg_Q_42_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_04]) = 0 AND LEN(A.[Avg_Q_42_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_05]) = 0 AND LEN(A.[Avg_Q_42_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_06]) = 0 AND LEN(A.[Avg_Q_42_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_07]) = 0 AND LEN(A.[Avg_Q_42_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_08]) = 0 AND LEN(A.[Avg_Q_42_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_09]) = 0 AND LEN(A.[Avg_Q_42_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_42_10]) = 0 AND LEN(A.[Avg_Q_42_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_42_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_42_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_00]) = 0 AND LEN(A.[Avg_Q_43_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_01]) = 0 AND LEN(A.[Avg_Q_43_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_02]) = 0 AND LEN(A.[Avg_Q_43_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_03]) = 0 AND LEN(A.[Avg_Q_43_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_04]) = 0 AND LEN(A.[Avg_Q_43_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_05]) = 0 AND LEN(A.[Avg_Q_43_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_06]) = 0 AND LEN(A.[Avg_Q_43_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_07]) = 0 AND LEN(A.[Avg_Q_43_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_08]) = 0 AND LEN(A.[Avg_Q_43_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_09]) = 0 AND LEN(A.[Avg_Q_43_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_43_10]) = 0 AND LEN(A.[Avg_Q_43_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_43_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_43_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_00]) = 0 AND LEN(A.[Avg_Q_44_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_01]) = 0 AND LEN(A.[Avg_Q_44_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_02]) = 0 AND LEN(A.[Avg_Q_44_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_03]) = 0 AND LEN(A.[Avg_Q_44_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_04]) = 0 AND LEN(A.[Avg_Q_44_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_05]) = 0 AND LEN(A.[Avg_Q_44_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_06]) = 0 AND LEN(A.[Avg_Q_44_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_07]) = 0 AND LEN(A.[Avg_Q_44_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_08]) = 0 AND LEN(A.[Avg_Q_44_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_09]) = 0 AND LEN(A.[Avg_Q_44_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_44_10]) = 0 AND LEN(A.[Avg_Q_44_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_44_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_44_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_00]) = 0 AND LEN(A.[Avg_Q_45_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_01]) = 0 AND LEN(A.[Avg_Q_45_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_02]) = 0 AND LEN(A.[Avg_Q_45_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_03]) = 0 AND LEN(A.[Avg_Q_45_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_04]) = 0 AND LEN(A.[Avg_Q_45_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_05]) = 0 AND LEN(A.[Avg_Q_45_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_06]) = 0 AND LEN(A.[Avg_Q_45_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_07]) = 0 AND LEN(A.[Avg_Q_45_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_08]) = 0 AND LEN(A.[Avg_Q_45_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_09]) = 0 AND LEN(A.[Avg_Q_45_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_45_10]) = 0 AND LEN(A.[Avg_Q_45_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_45_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_45_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_00]) = 0 AND LEN(A.[Avg_Q_46_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_01]) = 0 AND LEN(A.[Avg_Q_46_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_02]) = 0 AND LEN(A.[Avg_Q_46_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_03]) = 0 AND LEN(A.[Avg_Q_46_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_04]) = 0 AND LEN(A.[Avg_Q_46_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_05]) = 0 AND LEN(A.[Avg_Q_46_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_06]) = 0 AND LEN(A.[Avg_Q_46_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_07]) = 0 AND LEN(A.[Avg_Q_46_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_08]) = 0 AND LEN(A.[Avg_Q_46_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_09]) = 0 AND LEN(A.[Avg_Q_46_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_46_10]) = 0 AND LEN(A.[Avg_Q_46_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_46_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_46_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_00]) = 0 AND LEN(A.[Avg_Q_47_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_01]) = 0 AND LEN(A.[Avg_Q_47_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_02]) = 0 AND LEN(A.[Avg_Q_47_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_03]) = 0 AND LEN(A.[Avg_Q_47_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_04]) = 0 AND LEN(A.[Avg_Q_47_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_05]) = 0 AND LEN(A.[Avg_Q_47_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_06]) = 0 AND LEN(A.[Avg_Q_47_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_07]) = 0 AND LEN(A.[Avg_Q_47_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_08]) = 0 AND LEN(A.[Avg_Q_47_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_09]) = 0 AND LEN(A.[Avg_Q_47_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_47_10]) = 0 AND LEN(A.[Avg_Q_47_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_47_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_47_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_00]) = 0 AND LEN(A.[Avg_Q_48_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_01]) = 0 AND LEN(A.[Avg_Q_48_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_02]) = 0 AND LEN(A.[Avg_Q_48_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_03]) = 0 AND LEN(A.[Avg_Q_48_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_04]) = 0 AND LEN(A.[Avg_Q_48_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_05]) = 0 AND LEN(A.[Avg_Q_48_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_06]) = 0 AND LEN(A.[Avg_Q_48_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_07]) = 0 AND LEN(A.[Avg_Q_48_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_08]) = 0 AND LEN(A.[Avg_Q_48_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_09]) = 0 AND LEN(A.[Avg_Q_48_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_48_10]) = 0 AND LEN(A.[Avg_Q_48_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_48_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_48_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_00]) = 0 AND LEN(A.[Avg_Q_49_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_01]) = 0 AND LEN(A.[Avg_Q_49_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_02]) = 0 AND LEN(A.[Avg_Q_49_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_03]) = 0 AND LEN(A.[Avg_Q_49_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_04]) = 0 AND LEN(A.[Avg_Q_49_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_05]) = 0 AND LEN(A.[Avg_Q_49_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_06]) = 0 AND LEN(A.[Avg_Q_49_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_07]) = 0 AND LEN(A.[Avg_Q_49_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_08]) = 0 AND LEN(A.[Avg_Q_49_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_09]) = 0 AND LEN(A.[Avg_Q_49_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_49_10]) = 0 AND LEN(A.[Avg_Q_49_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_49_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_49_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_00]) = 0 AND LEN(A.[Avg_Q_50_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_01]) = 0 AND LEN(A.[Avg_Q_50_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_02]) = 0 AND LEN(A.[Avg_Q_50_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_03]) = 0 AND LEN(A.[Avg_Q_50_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_04]) = 0 AND LEN(A.[Avg_Q_50_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_05]) = 0 AND LEN(A.[Avg_Q_50_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_06]) = 0 AND LEN(A.[Avg_Q_50_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_07]) = 0 AND LEN(A.[Avg_Q_50_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_08]) = 0 AND LEN(A.[Avg_Q_50_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_09]) = 0 AND LEN(A.[Avg_Q_50_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_50_10]) = 0 AND LEN(A.[Avg_Q_50_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_50_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_50_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_00]) = 0 AND LEN(A.[Avg_Q_51_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_01]) = 0 AND LEN(A.[Avg_Q_51_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_02]) = 0 AND LEN(A.[Avg_Q_51_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_03]) = 0 AND LEN(A.[Avg_Q_51_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_04]) = 0 AND LEN(A.[Avg_Q_51_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_05]) = 0 AND LEN(A.[Avg_Q_51_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_06]) = 0 AND LEN(A.[Avg_Q_51_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_07]) = 0 AND LEN(A.[Avg_Q_51_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_08]) = 0 AND LEN(A.[Avg_Q_51_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_09]) = 0 AND LEN(A.[Avg_Q_51_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_51_10]) = 0 AND LEN(A.[Avg_Q_51_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_51_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_51_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_00]) = 0 AND LEN(A.[Avg_Q_52_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_01]) = 0 AND LEN(A.[Avg_Q_52_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_02]) = 0 AND LEN(A.[Avg_Q_52_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_03]) = 0 AND LEN(A.[Avg_Q_52_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_04]) = 0 AND LEN(A.[Avg_Q_52_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_05]) = 0 AND LEN(A.[Avg_Q_52_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_06]) = 0 AND LEN(A.[Avg_Q_52_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_07]) = 0 AND LEN(A.[Avg_Q_52_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_08]) = 0 AND LEN(A.[Avg_Q_52_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_09]) = 0 AND LEN(A.[Avg_Q_52_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_52_10]) = 0 AND LEN(A.[Avg_Q_52_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_52_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_52_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_00]) = 0 AND LEN(A.[Avg_Q_53_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_01]) = 0 AND LEN(A.[Avg_Q_53_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_02]) = 0 AND LEN(A.[Avg_Q_53_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_03]) = 0 AND LEN(A.[Avg_Q_53_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_04]) = 0 AND LEN(A.[Avg_Q_53_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_05]) = 0 AND LEN(A.[Avg_Q_53_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_06]) = 0 AND LEN(A.[Avg_Q_53_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_07]) = 0 AND LEN(A.[Avg_Q_53_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_08]) = 0 AND LEN(A.[Avg_Q_53_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_09]) = 0 AND LEN(A.[Avg_Q_53_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_53_10]) = 0 AND LEN(A.[Avg_Q_53_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_53_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_53_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_00]) = 0 AND LEN(A.[Avg_Q_54_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_01]) = 0 AND LEN(A.[Avg_Q_54_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_02]) = 0 AND LEN(A.[Avg_Q_54_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_03]) = 0 AND LEN(A.[Avg_Q_54_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_04]) = 0 AND LEN(A.[Avg_Q_54_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_05]) = 0 AND LEN(A.[Avg_Q_54_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_06]) = 0 AND LEN(A.[Avg_Q_54_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_07]) = 0 AND LEN(A.[Avg_Q_54_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_08]) = 0 AND LEN(A.[Avg_Q_54_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_09]) = 0 AND LEN(A.[Avg_Q_54_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_54_10]) = 0 AND LEN(A.[Avg_Q_54_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_54_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_54_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_00]) = 0 AND LEN(A.[Avg_Q_55_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_01]) = 0 AND LEN(A.[Avg_Q_55_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_02]) = 0 AND LEN(A.[Avg_Q_55_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_03]) = 0 AND LEN(A.[Avg_Q_55_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_04]) = 0 AND LEN(A.[Avg_Q_55_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_05]) = 0 AND LEN(A.[Avg_Q_55_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_06]) = 0 AND LEN(A.[Avg_Q_55_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_07]) = 0 AND LEN(A.[Avg_Q_55_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_08]) = 0 AND LEN(A.[Avg_Q_55_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_09]) = 0 AND LEN(A.[Avg_Q_55_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_55_10]) = 0 AND LEN(A.[Avg_Q_55_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_55_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_55_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_00]) = 0 AND LEN(A.[Avg_Q_56_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_01]) = 0 AND LEN(A.[Avg_Q_56_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_02]) = 0 AND LEN(A.[Avg_Q_56_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_03]) = 0 AND LEN(A.[Avg_Q_56_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_04]) = 0 AND LEN(A.[Avg_Q_56_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_05]) = 0 AND LEN(A.[Avg_Q_56_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_06]) = 0 AND LEN(A.[Avg_Q_56_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_07]) = 0 AND LEN(A.[Avg_Q_56_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_08]) = 0 AND LEN(A.[Avg_Q_56_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_09]) = 0 AND LEN(A.[Avg_Q_56_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_56_10]) = 0 AND LEN(A.[Avg_Q_56_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_56_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_56_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_00]) = 0 AND LEN(A.[Avg_Q_57_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_01]) = 0 AND LEN(A.[Avg_Q_57_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_02]) = 0 AND LEN(A.[Avg_Q_57_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_03]) = 0 AND LEN(A.[Avg_Q_57_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_04]) = 0 AND LEN(A.[Avg_Q_57_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_05]) = 0 AND LEN(A.[Avg_Q_57_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_06]) = 0 AND LEN(A.[Avg_Q_57_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_07]) = 0 AND LEN(A.[Avg_Q_57_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_08]) = 0 AND LEN(A.[Avg_Q_57_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_09]) = 0 AND LEN(A.[Avg_Q_57_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_57_10]) = 0 AND LEN(A.[Avg_Q_57_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_57_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_57_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_00]) = 0 AND LEN(A.[Avg_Q_58_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_01]) = 0 AND LEN(A.[Avg_Q_58_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_02]) = 0 AND LEN(A.[Avg_Q_58_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_03]) = 0 AND LEN(A.[Avg_Q_58_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_04]) = 0 AND LEN(A.[Avg_Q_58_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_05]) = 0 AND LEN(A.[Avg_Q_58_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_06]) = 0 AND LEN(A.[Avg_Q_58_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_07]) = 0 AND LEN(A.[Avg_Q_58_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_08]) = 0 AND LEN(A.[Avg_Q_58_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_09]) = 0 AND LEN(A.[Avg_Q_58_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_58_10]) = 0 AND LEN(A.[Avg_Q_58_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_58_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_58_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_00]) = 0 AND LEN(A.[Avg_Q_59_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_01]) = 0 AND LEN(A.[Avg_Q_59_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_02]) = 0 AND LEN(A.[Avg_Q_59_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_03]) = 0 AND LEN(A.[Avg_Q_59_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_04]) = 0 AND LEN(A.[Avg_Q_59_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_05]) = 0 AND LEN(A.[Avg_Q_59_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_06]) = 0 AND LEN(A.[Avg_Q_59_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_07]) = 0 AND LEN(A.[Avg_Q_59_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_08]) = 0 AND LEN(A.[Avg_Q_59_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_09]) = 0 AND LEN(A.[Avg_Q_59_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_59_10]) = 0 AND LEN(A.[Avg_Q_59_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_59_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_59_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_00]) = 0 AND LEN(A.[Avg_Q_60_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_01]) = 0 AND LEN(A.[Avg_Q_60_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_02]) = 0 AND LEN(A.[Avg_Q_60_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_03]) = 0 AND LEN(A.[Avg_Q_60_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_04]) = 0 AND LEN(A.[Avg_Q_60_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_05]) = 0 AND LEN(A.[Avg_Q_60_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_06]) = 0 AND LEN(A.[Avg_Q_60_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_07]) = 0 AND LEN(A.[Avg_Q_60_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_08]) = 0 AND LEN(A.[Avg_Q_60_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_09]) = 0 AND LEN(A.[Avg_Q_60_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_60_10]) = 0 AND LEN(A.[Avg_Q_60_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_60_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_60_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_00]) = 0 AND LEN(A.[Avg_Q_61_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_01]) = 0 AND LEN(A.[Avg_Q_61_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_02]) = 0 AND LEN(A.[Avg_Q_61_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_03]) = 0 AND LEN(A.[Avg_Q_61_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_04]) = 0 AND LEN(A.[Avg_Q_61_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_05]) = 0 AND LEN(A.[Avg_Q_61_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_06]) = 0 AND LEN(A.[Avg_Q_61_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_07]) = 0 AND LEN(A.[Avg_Q_61_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_08]) = 0 AND LEN(A.[Avg_Q_61_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_09]) = 0 AND LEN(A.[Avg_Q_61_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_61_10]) = 0 AND LEN(A.[Avg_Q_61_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_61_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_61_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_00]) = 0 AND LEN(A.[Avg_Q_62_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_01]) = 0 AND LEN(A.[Avg_Q_62_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_02]) = 0 AND LEN(A.[Avg_Q_62_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_03]) = 0 AND LEN(A.[Avg_Q_62_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_04]) = 0 AND LEN(A.[Avg_Q_62_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_05]) = 0 AND LEN(A.[Avg_Q_62_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_06]) = 0 AND LEN(A.[Avg_Q_62_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_07]) = 0 AND LEN(A.[Avg_Q_62_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_08]) = 0 AND LEN(A.[Avg_Q_62_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_09]) = 0 AND LEN(A.[Avg_Q_62_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_62_10]) = 0 AND LEN(A.[Avg_Q_62_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_62_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_62_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_00]) = 0 AND LEN(A.[Avg_Q_63_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_01]) = 0 AND LEN(A.[Avg_Q_63_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_02]) = 0 AND LEN(A.[Avg_Q_63_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_03]) = 0 AND LEN(A.[Avg_Q_63_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_04]) = 0 AND LEN(A.[Avg_Q_63_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_05]) = 0 AND LEN(A.[Avg_Q_63_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_06]) = 0 AND LEN(A.[Avg_Q_63_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_07]) = 0 AND LEN(A.[Avg_Q_63_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_08]) = 0 AND LEN(A.[Avg_Q_63_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_09]) = 0 AND LEN(A.[Avg_Q_63_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_63_10]) = 0 AND LEN(A.[Avg_Q_63_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_63_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_63_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_00]) = 0 AND LEN(A.[Avg_Q_64_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_01]) = 0 AND LEN(A.[Avg_Q_64_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_02]) = 0 AND LEN(A.[Avg_Q_64_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_03]) = 0 AND LEN(A.[Avg_Q_64_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_04]) = 0 AND LEN(A.[Avg_Q_64_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_05]) = 0 AND LEN(A.[Avg_Q_64_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_06]) = 0 AND LEN(A.[Avg_Q_64_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_07]) = 0 AND LEN(A.[Avg_Q_64_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_08]) = 0 AND LEN(A.[Avg_Q_64_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_09]) = 0 AND LEN(A.[Avg_Q_64_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_64_10]) = 0 AND LEN(A.[Avg_Q_64_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_64_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_64_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_00]) = 0 AND LEN(A.[Avg_Q_65_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_01]) = 0 AND LEN(A.[Avg_Q_65_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_02]) = 0 AND LEN(A.[Avg_Q_65_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_03]) = 0 AND LEN(A.[Avg_Q_65_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_04]) = 0 AND LEN(A.[Avg_Q_65_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_05]) = 0 AND LEN(A.[Avg_Q_65_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_06]) = 0 AND LEN(A.[Avg_Q_65_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_07]) = 0 AND LEN(A.[Avg_Q_65_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_08]) = 0 AND LEN(A.[Avg_Q_65_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_09]) = 0 AND LEN(A.[Avg_Q_65_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_65_10]) = 0 AND LEN(A.[Avg_Q_65_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_65_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_65_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_00]) = 0 AND LEN(A.[Avg_Q_66_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_01]) = 0 AND LEN(A.[Avg_Q_66_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_02]) = 0 AND LEN(A.[Avg_Q_66_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_03]) = 0 AND LEN(A.[Avg_Q_66_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_04]) = 0 AND LEN(A.[Avg_Q_66_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_05]) = 0 AND LEN(A.[Avg_Q_66_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_06]) = 0 AND LEN(A.[Avg_Q_66_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_07]) = 0 AND LEN(A.[Avg_Q_66_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_08]) = 0 AND LEN(A.[Avg_Q_66_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_09]) = 0 AND LEN(A.[Avg_Q_66_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_66_10]) = 0 AND LEN(A.[Avg_Q_66_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_66_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_66_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_00]) = 0 AND LEN(A.[Avg_Q_67_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_01]) = 0 AND LEN(A.[Avg_Q_67_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_02]) = 0 AND LEN(A.[Avg_Q_67_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_03]) = 0 AND LEN(A.[Avg_Q_67_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_04]) = 0 AND LEN(A.[Avg_Q_67_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_05]) = 0 AND LEN(A.[Avg_Q_67_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_06]) = 0 AND LEN(A.[Avg_Q_67_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_07]) = 0 AND LEN(A.[Avg_Q_67_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_08]) = 0 AND LEN(A.[Avg_Q_67_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_09]) = 0 AND LEN(A.[Avg_Q_67_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_67_10]) = 0 AND LEN(A.[Avg_Q_67_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_67_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_67_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_00]) = 0 AND LEN(A.[Avg_Q_68_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_01]) = 0 AND LEN(A.[Avg_Q_68_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_02]) = 0 AND LEN(A.[Avg_Q_68_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_03]) = 0 AND LEN(A.[Avg_Q_68_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_04]) = 0 AND LEN(A.[Avg_Q_68_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_05]) = 0 AND LEN(A.[Avg_Q_68_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_06]) = 0 AND LEN(A.[Avg_Q_68_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_07]) = 0 AND LEN(A.[Avg_Q_68_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_08]) = 0 AND LEN(A.[Avg_Q_68_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_09]) = 0 AND LEN(A.[Avg_Q_68_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_68_10]) = 0 AND LEN(A.[Avg_Q_68_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_68_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_68_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_00]) = 0 AND LEN(A.[Avg_Q_69_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_01]) = 0 AND LEN(A.[Avg_Q_69_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_02]) = 0 AND LEN(A.[Avg_Q_69_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_03]) = 0 AND LEN(A.[Avg_Q_69_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_04]) = 0 AND LEN(A.[Avg_Q_69_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_05]) = 0 AND LEN(A.[Avg_Q_69_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_06]) = 0 AND LEN(A.[Avg_Q_69_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_07]) = 0 AND LEN(A.[Avg_Q_69_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_08]) = 0 AND LEN(A.[Avg_Q_69_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_09]) = 0 AND LEN(A.[Avg_Q_69_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_69_10]) = 0 AND LEN(A.[Avg_Q_69_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_69_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_69_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_00]) = 0 AND LEN(A.[Avg_Q_70_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_01]) = 0 AND LEN(A.[Avg_Q_70_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_02]) = 0 AND LEN(A.[Avg_Q_70_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_03]) = 0 AND LEN(A.[Avg_Q_70_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_04]) = 0 AND LEN(A.[Avg_Q_70_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_05]) = 0 AND LEN(A.[Avg_Q_70_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_06]) = 0 AND LEN(A.[Avg_Q_70_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_07]) = 0 AND LEN(A.[Avg_Q_70_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_08]) = 0 AND LEN(A.[Avg_Q_70_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_09]) = 0 AND LEN(A.[Avg_Q_70_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_70_10]) = 0 AND LEN(A.[Avg_Q_70_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_70_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_70_10]) NOT BETWEEN 0.000000 AND 1.000000))
			/*
			OR ((ISNUMERIC(A.[Avg_Q_71_00]) = 0 AND LEN(A.[Avg_Q_71_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_01]) = 0 AND LEN(A.[Avg_Q_71_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_02]) = 0 AND LEN(A.[Avg_Q_71_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_03]) = 0 AND LEN(A.[Avg_Q_71_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_04]) = 0 AND LEN(A.[Avg_Q_71_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_05]) = 0 AND LEN(A.[Avg_Q_71_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_06]) = 0 AND LEN(A.[Avg_Q_71_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_07]) = 0 AND LEN(A.[Avg_Q_71_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_08]) = 0 AND LEN(A.[Avg_Q_71_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_09]) = 0 AND LEN(A.[Avg_Q_71_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_71_10]) = 0 AND LEN(A.[Avg_Q_71_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_71_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_71_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_00]) = 0 AND LEN(A.[Avg_Q_72_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_01]) = 0 AND LEN(A.[Avg_Q_72_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_02]) = 0 AND LEN(A.[Avg_Q_72_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_03]) = 0 AND LEN(A.[Avg_Q_72_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_04]) = 0 AND LEN(A.[Avg_Q_72_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_05]) = 0 AND LEN(A.[Avg_Q_72_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_06]) = 0 AND LEN(A.[Avg_Q_72_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_07]) = 0 AND LEN(A.[Avg_Q_72_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_08]) = 0 AND LEN(A.[Avg_Q_72_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_09]) = 0 AND LEN(A.[Avg_Q_72_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_72_10]) = 0 AND LEN(A.[Avg_Q_72_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_72_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_72_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_00]) = 0 AND LEN(A.[Avg_Q_73_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_01]) = 0 AND LEN(A.[Avg_Q_73_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_02]) = 0 AND LEN(A.[Avg_Q_73_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_03]) = 0 AND LEN(A.[Avg_Q_73_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_04]) = 0 AND LEN(A.[Avg_Q_73_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_05]) = 0 AND LEN(A.[Avg_Q_73_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_06]) = 0 AND LEN(A.[Avg_Q_73_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_07]) = 0 AND LEN(A.[Avg_Q_73_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_08]) = 0 AND LEN(A.[Avg_Q_73_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_09]) = 0 AND LEN(A.[Avg_Q_73_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_73_10]) = 0 AND LEN(A.[Avg_Q_73_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_73_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_73_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_00]) = 0 AND LEN(A.[Avg_Q_74_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_01]) = 0 AND LEN(A.[Avg_Q_74_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_02]) = 0 AND LEN(A.[Avg_Q_74_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_03]) = 0 AND LEN(A.[Avg_Q_74_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_04]) = 0 AND LEN(A.[Avg_Q_74_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_05]) = 0 AND LEN(A.[Avg_Q_74_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_06]) = 0 AND LEN(A.[Avg_Q_74_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_07]) = 0 AND LEN(A.[Avg_Q_74_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_08]) = 0 AND LEN(A.[Avg_Q_74_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_09]) = 0 AND LEN(A.[Avg_Q_74_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_74_10]) = 0 AND LEN(A.[Avg_Q_74_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_74_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_74_10]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_00]) = 0 AND LEN(A.[Avg_Q_75_00]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_00], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_00]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_01]) = 0 AND LEN(A.[Avg_Q_75_01]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_01], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_01]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_02]) = 0 AND LEN(A.[Avg_Q_75_02]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_02], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_02]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_03]) = 0 AND LEN(A.[Avg_Q_75_03]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_03], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_03]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_04]) = 0 AND LEN(A.[Avg_Q_75_04]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_04], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_04]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_05]) = 0 AND LEN(A.[Avg_Q_75_05]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_05], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_05]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_06]) = 0 AND LEN(A.[Avg_Q_75_06]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_06], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_06]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_07]) = 0 AND LEN(A.[Avg_Q_75_07]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_07], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_07]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_08]) = 0 AND LEN(A.[Avg_Q_75_08]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_08], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_08]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_09]) = 0 AND LEN(A.[Avg_Q_75_09]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_09], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_09]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Avg_Q_75_10]) = 0 AND LEN(A.[Avg_Q_75_10]) > 0) OR (ISNUMERIC(COALESCE(A.[Avg_Q_75_10], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Avg_Q_75_10]) NOT BETWEEN 0.000000 AND 1.000000))
			*/
			OR ((ISNUMERIC(A.[NPS]) = 0 AND LEN(A.[NPS]) > 0) OR (ISNUMERIC(COALESCE(A.[NPS], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[NPS]) NOT BETWEEN -1.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[RPI]) = 0 AND LEN(A.[RPI]) > 0) OR (ISNUMERIC(COALESCE(A.[RPI], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[RPI]) NOT BETWEEN -1.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Achievement Z-Score]) = 0 AND LEN(A.[Achievement Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Achievement Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Belonging Z-Score]) = 0 AND LEN(A.[Belonging Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Belonging Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Character Z-Score]) = 0 AND LEN(A.[Character Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Character Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Giving Z-Score]) = 0 AND LEN(A.[Giving Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Giving Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Health Z-Score]) = 0 AND LEN(A.[Health Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Health Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Inspiration Z-Score]) = 0 AND LEN(A.[Inspiration Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Inspiration Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Meaning Z-Score]) = 0 AND LEN(A.[Meaning Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Meaning Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Relationship Z-Score]) = 0 AND LEN(A.[Relationship Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Relationship Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Safety Z-Score]) = 0 AND LEN(A.[Safety Z-Score]) > 0) OR (ISNUMERIC(COALESCE(A.[Safety Z-Score], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety z-score]) NOT BETWEEN -4.000000 AND 4.000000))
			OR ((ISNUMERIC(A.[Achievement Percentile]) = 0 AND LEN(A.[Achievement Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Achievement Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Achievement Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Belonging Percentile]) = 0 AND LEN(A.[Belonging Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Belonging Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Belonging Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Character Percentile]) = 0 AND LEN(A.[Character Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Character Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Character Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Giving Percentile]) = 0 AND LEN(A.[Giving Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Giving Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Giving Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Health Percentile]) = 0 AND LEN(A.[Health Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Health Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Health Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Inspiration Percentile]) = 0 AND LEN(A.[Inspiration Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Inspiration Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Inspiration Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Meaning Percentile]) = 0 AND LEN(A.[Meaning Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Meaning Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Meaning Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Relationship Percentile]) = 0 AND LEN(A.[Relationship Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Relationship Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Relationship Percentile]) NOT BETWEEN 0.000000 AND 1.000000))
			OR ((ISNUMERIC(A.[Safety Percentile]) = 0 AND LEN(A.[Safety Percentile]) > 0) OR (ISNUMERIC(COALESCE(A.[Safety Percentile], '')) = 1 AND CONVERT(DECIMAL(20, 6), A.[Safety Percentile]) NOT BETWEEN 0.000000 AND 1.000000))

;
COMMIT TRAN
END