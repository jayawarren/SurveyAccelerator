/*
truncate table Seer_ODS.dbo.Aggregated_Data
truncate table Seer_CTRL.dbo.[Member Aggregated Data]
drop procedure spPopulate_odsAggregated_Member
select * from Seer_ODS.dbo.Aggregated_Data
select * from Seer_CTRL.dbo.[Member Aggregated Data]
*/
CREATE PROCEDURE spPopulate_odsAggregated_Member AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Aggregated_Data AS target
	USING	(
			SELECT	1 current_indicator,
					'Member' module,
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
					CASE WHEN LEN(COALESCE(A.[Response_Count], '')) = 0 THEN 0
						ELSE A.Response_Count
					END  [response_count],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01a_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01a_01] END [avg_m_01a_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01b_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01b_01] END [avg_m_01b_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01c_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01c_01] END [avg_m_01c_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01d_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01d_01] END [avg_m_01d_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_01] END [avg_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_02] END [avg_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_03] END [avg_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_04] END [avg_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_05] END [avg_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_01] END [avg_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_02] END [avg_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_03] END [avg_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_04] END [avg_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_05] END [avg_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_01] END [avg_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_02] END [avg_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_03] END [avg_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_04] END [avg_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_05] END [avg_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_01] END [avg_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_02] END [avg_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_03] END [avg_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_04] END [avg_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_05] END [avg_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_01] END [avg_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_02] END [avg_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_03] END [avg_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_04] END [avg_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_05] END [avg_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_01] END [avg_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_02] END [avg_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_03] END [avg_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_04] END [avg_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_05] END [avg_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_01] END [avg_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_02] END [avg_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_03] END [avg_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_04] END [avg_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_05] END [avg_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_01] END [avg_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_02] END [avg_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_03] END [avg_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_04] END [avg_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_05] END [avg_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_01] END [avg_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_02] END [avg_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_03] END [avg_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_04] END [avg_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_05] END [avg_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_01] END [avg_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_02] END [avg_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_03] END [avg_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_04] END [avg_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_05] END [avg_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_01] END [avg_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_02] END [avg_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_03] END [avg_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_04] END [avg_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_05] END [avg_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_01] END [avg_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_02] END [avg_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_03] END [avg_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_04] END [avg_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_05] END [avg_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_01] END [avg_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_02] END [avg_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_03] END [avg_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_04] END [avg_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_05] END [avg_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_01] END [avg_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_02] END [avg_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_03] END [avg_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_04] END [avg_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_05] END [avg_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_01] END [avg_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_02] END [avg_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_03] END [avg_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_04] END [avg_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_05] END [avg_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_01] END [avg_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_02] END [avg_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_03] END [avg_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_04] END [avg_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_05] END [avg_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_01] END [avg_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_02] END [avg_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_03] END [avg_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_04] END [avg_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_05] END [avg_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_01] END [avg_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_02] END [avg_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_03] END [avg_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_04] END [avg_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_05] END [avg_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_01] END [avg_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_02] END [avg_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_03] END [avg_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_04] END [avg_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_05] END [avg_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_01] END [avg_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_02] END [avg_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_03] END [avg_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_04] END [avg_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_05] END [avg_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_01] END [avg_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_02] END [avg_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_03] END [avg_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_04] END [avg_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_05] END [avg_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_01] END [avg_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_02] END [avg_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_03] END [avg_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_04] END [avg_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_05] END [avg_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_01] END [avg_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_02] END [avg_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_03] END [avg_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_04] END [avg_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_05] END [avg_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_01] END [avg_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_02] END [avg_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_03] END [avg_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_04] END [avg_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_05] END [avg_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_01] END [avg_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_02] END [avg_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_03] END [avg_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_04] END [avg_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_05] END [avg_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_01] END [avg_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_02] END [avg_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_03] END [avg_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_04] END [avg_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_05] END [avg_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_01] END [avg_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_02] END [avg_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_03] END [avg_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_04] END [avg_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_05] END [avg_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_01] END [avg_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_02] END [avg_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_03] END [avg_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_04] END [avg_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_05] END [avg_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_01] END [avg_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_02] END [avg_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_03] END [avg_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_04] END [avg_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_05] END [avg_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_01] END [avg_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_02] END [avg_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_03] END [avg_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_04] END [avg_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_05] END [avg_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_01] END [avg_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_02] END [avg_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_03] END [avg_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_04] END [avg_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_05] END [avg_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_00] END [avg_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_01] END [avg_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_10] END [avg_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_02] END [avg_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_03] END [avg_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_04] END [avg_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_05] END [avg_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_06] END [avg_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_07] END [avg_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_08] END [avg_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_09] END [avg_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_01] END [avg_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_02] END [avg_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_03] END [avg_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_04] END [avg_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_05] END [avg_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_01] END [avg_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_02] END [avg_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_03] END [avg_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_04] END [avg_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_05] END [avg_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_00] END [avg_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_01] END [avg_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_10] END [avg_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_02] END [avg_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_03] END [avg_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_04] END [avg_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_05] END [avg_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_06] END [avg_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_07] END [avg_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_08] END [avg_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_09] END [avg_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_01] END [avg_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_02] END [avg_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_03] END [avg_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_04] END [avg_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_05] END [avg_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_01] END [avg_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_02] END [avg_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_03] END [avg_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_04] END [avg_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_05] END [avg_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_01] END [avg_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_02] END [avg_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_03] END [avg_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_04] END [avg_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_05] END [avg_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_01] END [avg_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_02] END [avg_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_03] END [avg_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_04] END [avg_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_05] END [avg_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_01] END [avg_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_02] END [avg_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_03] END [avg_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_04] END [avg_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_05] END [avg_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_01] END [avg_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_02] END [avg_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_03] END [avg_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_04] END [avg_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_05] END [avg_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_01] END [avg_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_02] END [avg_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_03] END [avg_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_04] END [avg_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_05] END [avg_q_42_05],
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
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_01] END [avg_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_02] END [avg_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_03] END [avg_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_04] END [avg_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_05] END [avg_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_01] END [avg_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_02] END [avg_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_03] END [avg_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_04] END [avg_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_05] END [avg_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_00] END [avg_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_01] END [avg_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_10] END [avg_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_02] END [avg_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_03] END [avg_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_04] END [avg_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_05] END [avg_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_06] END [avg_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_07] END [avg_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_08] END [avg_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_09] END [avg_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_01] END [avg_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_02] END [avg_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_03] END [avg_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_04] END [avg_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_05] END [avg_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_01] END [avg_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_02] END [avg_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_03] END [avg_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_04] END [avg_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_05] END [avg_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_01] END [avg_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_02] END [avg_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_03] END [avg_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_04] END [avg_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_05] END [avg_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_01] END [avg_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_02] END [avg_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_03] END [avg_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_04] END [avg_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_05] END [avg_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_01] END [avg_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_02] END [avg_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_03] END [avg_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_04] END [avg_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_05] END [avg_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_01] END [avg_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_02] END [avg_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_03] END [avg_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_04] END [avg_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_05] END [avg_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_01] END [avg_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_02] END [avg_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_03] END [avg_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_04] END [avg_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_05] END [avg_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_01] END [avg_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_02] END [avg_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_03] END [avg_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_04] END [avg_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_05] END [avg_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_01] END [avg_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_02] END [avg_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_03] END [avg_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_04] END [avg_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_05] END [avg_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_01] END [avg_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_02] END [avg_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_03] END [avg_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_04] END [avg_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_05] END [avg_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_01] END [avg_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_02] END [avg_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_03] END [avg_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_04] END [avg_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_05] END [avg_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_01] END [avg_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_02] END [avg_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_03] END [avg_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_04] END [avg_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_05] END [avg_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_01] END [avg_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_02] END [avg_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_03] END [avg_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_04] END [avg_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_05] END [avg_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_01] END [avg_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_02] END [avg_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_03] END [avg_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_04] END [avg_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_05] END [avg_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_01] END [avg_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_02] END [avg_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_03] END [avg_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_04] END [avg_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_05] END [avg_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_01] END [avg_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_02] END [avg_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_03] END [avg_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_04] END [avg_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_05] END [avg_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_01] END [avg_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_02] END [avg_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_03] END [avg_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_04] END [avg_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_05] END [avg_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_01] END [avg_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_02] END [avg_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_03] END [avg_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_04] END [avg_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_05] END [avg_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_06] END [avg_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_01] END [avg_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_02] END [avg_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_03] END [avg_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_04] END [avg_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_05] END [avg_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_06] END [avg_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_07] END [avg_q_65_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_01] END [avg_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_02] END [avg_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_03] END [avg_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_04] END [avg_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_05] END [avg_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_01] END [avg_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_02] END [avg_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_03] END [avg_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_04] END [avg_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_05] END [avg_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_01] END [avg_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_02] END [avg_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_03] END [avg_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_04] END [avg_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_05] END [avg_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_01] END [avg_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_02] END [avg_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_03] END [avg_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_04] END [avg_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_05] END [avg_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_01] END [avg_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_02] END [avg_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_03] END [avg_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_04] END [avg_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_05] END [avg_q_70_05],
					CASE WHEN LEN(COALESCE(A.[NPS], '')) = 0 THEN '0' ELSE A.[NPS] END [nps],
					CASE WHEN LEN(COALESCE(A.[RPI_COM], '')) = 0 THEN '0' ELSE A.[RPI_COM] END [rpi_com],
					CASE WHEN LEN(COALESCE(A.[RPI_IND], '')) = 0 THEN '0' ELSE A.[RPI_IND] END [rpi_ind],
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
					CASE WHEN LEN(COALESCE(A.[Safety Percentile], '')) = 0 THEN '0' ELSE A.[Safety Percentile] END [safety_percentile],
					CASE WHEN LEN(COALESCE(A.[Facilities Z-Score], '')) = 0 THEN '0' ELSE A.[Facilities Z-Score] END [facilities_z-score],
					CASE WHEN LEN(COALESCE(A.[Service Z-Score], '')) = 0 THEN '0' ELSE A.[Service Z-Score] END [service_z-score],
					CASE WHEN LEN(COALESCE(A.[Value Z-Score], '')) = 0 THEN '0' ELSE A.[Value Z-Score] END [value_z-score],
					CASE WHEN LEN(COALESCE(A.[Engagement Z-Score], '')) = 0 THEN '0' ELSE A.[Engagement Z-Score] END [engagement_z-score],
					CASE WHEN LEN(COALESCE(A.[Health and Wellness Z-Score], '')) = 0 THEN '0' ELSE A.[Health and Wellness Z-Score] END [health_and_wellness_z-score],
					CASE WHEN LEN(COALESCE(A.[Involvement Z-Score], '')) = 0 THEN '0' ELSE A.[Involvement Z-Score] END [involvement_z-score],
					CASE WHEN LEN(COALESCE(A.[Facilities Percentile], '')) = 0 THEN '0' ELSE A.[Facilities Percentile] END [facilities_percentile],
					CASE WHEN LEN(COALESCE(A.[Service Percentile], '')) = 0 THEN '0' ELSE A.[Service Percentile] END [service_percentile],
					CASE WHEN LEN(COALESCE(A.[Value Percentile], '')) = 0 THEN '0' ELSE A.[Value Percentile] END [value_percentile],
					CASE WHEN LEN(COALESCE(A.[Engagement Percentile], '')) = 0 THEN '0' ELSE A.[Engagement Percentile] END [engagement_percentile],
					CASE WHEN LEN(COALESCE(A.[Health and Wellness Percentile], '')) = 0 THEN '0' ELSE A.[Health and Wellness Percentile] END [health_and_wellness_percentile],
					CASE WHEN LEN(COALESCE(A.[Involvement Percentile], '')) = 0 THEN '0' ELSE A.[Involvement Percentile] END [involvement_percentile]


			FROM	Seer_STG.dbo.[Member Aggregated Data] A
						
			WHERE	((ISNUMERIC(A.[response_count]) = 1) OR (LEN(COALESCE(A.[response_count], '')) = 0))
					AND ((LEN(COALESCE([Avg_M_01a_01], '')) = 0) OR (ISNUMERIC([Avg_M_01a_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01a_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_M_01b_01], '')) = 0) OR (ISNUMERIC([Avg_M_01b_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01b_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_M_01c_01], '')) = 0) OR (ISNUMERIC([Avg_M_01c_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01c_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_M_01d_01], '')) = 0) OR (ISNUMERIC([Avg_M_01d_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01d_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_01_01], '')) = 0) OR (ISNUMERIC([Avg_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_01_02], '')) = 0) OR (ISNUMERIC([Avg_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_01_03], '')) = 0) OR (ISNUMERIC([Avg_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_01_04], '')) = 0) OR (ISNUMERIC([Avg_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_01_05], '')) = 0) OR (ISNUMERIC([Avg_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_02_01], '')) = 0) OR (ISNUMERIC([Avg_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_02_02], '')) = 0) OR (ISNUMERIC([Avg_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_02_03], '')) = 0) OR (ISNUMERIC([Avg_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_02_04], '')) = 0) OR (ISNUMERIC([Avg_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_02_05], '')) = 0) OR (ISNUMERIC([Avg_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_03_01], '')) = 0) OR (ISNUMERIC([Avg_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_03_02], '')) = 0) OR (ISNUMERIC([Avg_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_03_03], '')) = 0) OR (ISNUMERIC([Avg_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_03_04], '')) = 0) OR (ISNUMERIC([Avg_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_03_05], '')) = 0) OR (ISNUMERIC([Avg_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_04_01], '')) = 0) OR (ISNUMERIC([Avg_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_04_02], '')) = 0) OR (ISNUMERIC([Avg_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_04_03], '')) = 0) OR (ISNUMERIC([Avg_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_04_04], '')) = 0) OR (ISNUMERIC([Avg_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_04_05], '')) = 0) OR (ISNUMERIC([Avg_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_05_01], '')) = 0) OR (ISNUMERIC([Avg_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_05_02], '')) = 0) OR (ISNUMERIC([Avg_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_05_03], '')) = 0) OR (ISNUMERIC([Avg_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_05_04], '')) = 0) OR (ISNUMERIC([Avg_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_05_05], '')) = 0) OR (ISNUMERIC([Avg_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_06_01], '')) = 0) OR (ISNUMERIC([Avg_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_06_02], '')) = 0) OR (ISNUMERIC([Avg_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_06_03], '')) = 0) OR (ISNUMERIC([Avg_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_06_04], '')) = 0) OR (ISNUMERIC([Avg_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_06_05], '')) = 0) OR (ISNUMERIC([Avg_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_07_01], '')) = 0) OR (ISNUMERIC([Avg_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_07_02], '')) = 0) OR (ISNUMERIC([Avg_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_07_03], '')) = 0) OR (ISNUMERIC([Avg_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_07_04], '')) = 0) OR (ISNUMERIC([Avg_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_07_05], '')) = 0) OR (ISNUMERIC([Avg_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_08_01], '')) = 0) OR (ISNUMERIC([Avg_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_08_02], '')) = 0) OR (ISNUMERIC([Avg_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_08_03], '')) = 0) OR (ISNUMERIC([Avg_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_08_04], '')) = 0) OR (ISNUMERIC([Avg_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_08_05], '')) = 0) OR (ISNUMERIC([Avg_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_09_01], '')) = 0) OR (ISNUMERIC([Avg_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_09_02], '')) = 0) OR (ISNUMERIC([Avg_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_09_03], '')) = 0) OR (ISNUMERIC([Avg_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_09_04], '')) = 0) OR (ISNUMERIC([Avg_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_09_05], '')) = 0) OR (ISNUMERIC([Avg_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_10_01], '')) = 0) OR (ISNUMERIC([Avg_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_10_02], '')) = 0) OR (ISNUMERIC([Avg_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_10_03], '')) = 0) OR (ISNUMERIC([Avg_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_10_04], '')) = 0) OR (ISNUMERIC([Avg_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_10_05], '')) = 0) OR (ISNUMERIC([Avg_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_11_01], '')) = 0) OR (ISNUMERIC([Avg_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_11_02], '')) = 0) OR (ISNUMERIC([Avg_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_11_03], '')) = 0) OR (ISNUMERIC([Avg_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_11_04], '')) = 0) OR (ISNUMERIC([Avg_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_11_05], '')) = 0) OR (ISNUMERIC([Avg_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_12_01], '')) = 0) OR (ISNUMERIC([Avg_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_12_02], '')) = 0) OR (ISNUMERIC([Avg_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_12_03], '')) = 0) OR (ISNUMERIC([Avg_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_12_04], '')) = 0) OR (ISNUMERIC([Avg_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_12_05], '')) = 0) OR (ISNUMERIC([Avg_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_13_01], '')) = 0) OR (ISNUMERIC([Avg_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_13_02], '')) = 0) OR (ISNUMERIC([Avg_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_13_03], '')) = 0) OR (ISNUMERIC([Avg_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_13_04], '')) = 0) OR (ISNUMERIC([Avg_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_13_05], '')) = 0) OR (ISNUMERIC([Avg_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_14_01], '')) = 0) OR (ISNUMERIC([Avg_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_14_02], '')) = 0) OR (ISNUMERIC([Avg_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_14_03], '')) = 0) OR (ISNUMERIC([Avg_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_14_04], '')) = 0) OR (ISNUMERIC([Avg_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_14_05], '')) = 0) OR (ISNUMERIC([Avg_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_15_01], '')) = 0) OR (ISNUMERIC([Avg_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_15_02], '')) = 0) OR (ISNUMERIC([Avg_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_15_03], '')) = 0) OR (ISNUMERIC([Avg_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_15_04], '')) = 0) OR (ISNUMERIC([Avg_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_15_05], '')) = 0) OR (ISNUMERIC([Avg_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_16_01], '')) = 0) OR (ISNUMERIC([Avg_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_16_02], '')) = 0) OR (ISNUMERIC([Avg_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_16_03], '')) = 0) OR (ISNUMERIC([Avg_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_16_04], '')) = 0) OR (ISNUMERIC([Avg_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_16_05], '')) = 0) OR (ISNUMERIC([Avg_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_17_01], '')) = 0) OR (ISNUMERIC([Avg_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_17_02], '')) = 0) OR (ISNUMERIC([Avg_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_17_03], '')) = 0) OR (ISNUMERIC([Avg_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_17_04], '')) = 0) OR (ISNUMERIC([Avg_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_17_05], '')) = 0) OR (ISNUMERIC([Avg_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_18_01], '')) = 0) OR (ISNUMERIC([Avg_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_18_02], '')) = 0) OR (ISNUMERIC([Avg_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_18_03], '')) = 0) OR (ISNUMERIC([Avg_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_18_04], '')) = 0) OR (ISNUMERIC([Avg_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_18_05], '')) = 0) OR (ISNUMERIC([Avg_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_19_01], '')) = 0) OR (ISNUMERIC([Avg_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_19_02], '')) = 0) OR (ISNUMERIC([Avg_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_19_03], '')) = 0) OR (ISNUMERIC([Avg_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_19_04], '')) = 0) OR (ISNUMERIC([Avg_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_19_05], '')) = 0) OR (ISNUMERIC([Avg_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_20_01], '')) = 0) OR (ISNUMERIC([Avg_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_20_02], '')) = 0) OR (ISNUMERIC([Avg_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_20_03], '')) = 0) OR (ISNUMERIC([Avg_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_20_04], '')) = 0) OR (ISNUMERIC([Avg_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_20_05], '')) = 0) OR (ISNUMERIC([Avg_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_21_01], '')) = 0) OR (ISNUMERIC([Avg_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_21_02], '')) = 0) OR (ISNUMERIC([Avg_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_21_03], '')) = 0) OR (ISNUMERIC([Avg_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_21_04], '')) = 0) OR (ISNUMERIC([Avg_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_21_05], '')) = 0) OR (ISNUMERIC([Avg_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_22_01], '')) = 0) OR (ISNUMERIC([Avg_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_22_02], '')) = 0) OR (ISNUMERIC([Avg_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_22_03], '')) = 0) OR (ISNUMERIC([Avg_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_22_04], '')) = 0) OR (ISNUMERIC([Avg_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_22_05], '')) = 0) OR (ISNUMERIC([Avg_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_23_01], '')) = 0) OR (ISNUMERIC([Avg_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_23_02], '')) = 0) OR (ISNUMERIC([Avg_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_23_03], '')) = 0) OR (ISNUMERIC([Avg_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_23_04], '')) = 0) OR (ISNUMERIC([Avg_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_23_05], '')) = 0) OR (ISNUMERIC([Avg_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_24_01], '')) = 0) OR (ISNUMERIC([Avg_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_24_02], '')) = 0) OR (ISNUMERIC([Avg_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_24_03], '')) = 0) OR (ISNUMERIC([Avg_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_24_04], '')) = 0) OR (ISNUMERIC([Avg_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_24_05], '')) = 0) OR (ISNUMERIC([Avg_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_25_01], '')) = 0) OR (ISNUMERIC([Avg_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_25_02], '')) = 0) OR (ISNUMERIC([Avg_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_25_03], '')) = 0) OR (ISNUMERIC([Avg_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_25_04], '')) = 0) OR (ISNUMERIC([Avg_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_25_05], '')) = 0) OR (ISNUMERIC([Avg_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_26_01], '')) = 0) OR (ISNUMERIC([Avg_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_26_02], '')) = 0) OR (ISNUMERIC([Avg_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_26_03], '')) = 0) OR (ISNUMERIC([Avg_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_26_04], '')) = 0) OR (ISNUMERIC([Avg_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_26_05], '')) = 0) OR (ISNUMERIC([Avg_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_27_01], '')) = 0) OR (ISNUMERIC([Avg_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_27_02], '')) = 0) OR (ISNUMERIC([Avg_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_27_03], '')) = 0) OR (ISNUMERIC([Avg_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_27_04], '')) = 0) OR (ISNUMERIC([Avg_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_27_05], '')) = 0) OR (ISNUMERIC([Avg_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_28_01], '')) = 0) OR (ISNUMERIC([Avg_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_28_02], '')) = 0) OR (ISNUMERIC([Avg_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_28_03], '')) = 0) OR (ISNUMERIC([Avg_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_28_04], '')) = 0) OR (ISNUMERIC([Avg_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_28_05], '')) = 0) OR (ISNUMERIC([Avg_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_29_01], '')) = 0) OR (ISNUMERIC([Avg_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_29_02], '')) = 0) OR (ISNUMERIC([Avg_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_29_03], '')) = 0) OR (ISNUMERIC([Avg_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_29_04], '')) = 0) OR (ISNUMERIC([Avg_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_29_05], '')) = 0) OR (ISNUMERIC([Avg_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_30_01], '')) = 0) OR (ISNUMERIC([Avg_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_30_02], '')) = 0) OR (ISNUMERIC([Avg_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_30_03], '')) = 0) OR (ISNUMERIC([Avg_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_30_04], '')) = 0) OR (ISNUMERIC([Avg_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_30_05], '')) = 0) OR (ISNUMERIC([Avg_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_31_01], '')) = 0) OR (ISNUMERIC([Avg_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_31_02], '')) = 0) OR (ISNUMERIC([Avg_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_31_03], '')) = 0) OR (ISNUMERIC([Avg_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_31_04], '')) = 0) OR (ISNUMERIC([Avg_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_31_05], '')) = 0) OR (ISNUMERIC([Avg_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_00], '')) = 0) OR (ISNUMERIC([Avg_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_00]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_01], '')) = 0) OR (ISNUMERIC([Avg_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_10], '')) = 0) OR (ISNUMERIC([Avg_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_10]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_02], '')) = 0) OR (ISNUMERIC([Avg_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_03], '')) = 0) OR (ISNUMERIC([Avg_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_04], '')) = 0) OR (ISNUMERIC([Avg_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_05], '')) = 0) OR (ISNUMERIC([Avg_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_06], '')) = 0) OR (ISNUMERIC([Avg_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_07], '')) = 0) OR (ISNUMERIC([Avg_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_07]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_08], '')) = 0) OR (ISNUMERIC([Avg_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_08]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_32_09], '')) = 0) OR (ISNUMERIC([Avg_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_09]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_33_01], '')) = 0) OR (ISNUMERIC([Avg_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_33_02], '')) = 0) OR (ISNUMERIC([Avg_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_33_03], '')) = 0) OR (ISNUMERIC([Avg_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_33_04], '')) = 0) OR (ISNUMERIC([Avg_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_33_05], '')) = 0) OR (ISNUMERIC([Avg_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_34_01], '')) = 0) OR (ISNUMERIC([Avg_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_34_02], '')) = 0) OR (ISNUMERIC([Avg_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_34_03], '')) = 0) OR (ISNUMERIC([Avg_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_34_04], '')) = 0) OR (ISNUMERIC([Avg_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_34_05], '')) = 0) OR (ISNUMERIC([Avg_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_00], '')) = 0) OR (ISNUMERIC([Avg_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_00]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_01], '')) = 0) OR (ISNUMERIC([Avg_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_10], '')) = 0) OR (ISNUMERIC([Avg_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_10]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_02], '')) = 0) OR (ISNUMERIC([Avg_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_03], '')) = 0) OR (ISNUMERIC([Avg_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_04], '')) = 0) OR (ISNUMERIC([Avg_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_05], '')) = 0) OR (ISNUMERIC([Avg_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_06], '')) = 0) OR (ISNUMERIC([Avg_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_07], '')) = 0) OR (ISNUMERIC([Avg_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_07]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_08], '')) = 0) OR (ISNUMERIC([Avg_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_08]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_35_09], '')) = 0) OR (ISNUMERIC([Avg_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_09]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_36_01], '')) = 0) OR (ISNUMERIC([Avg_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_36_02], '')) = 0) OR (ISNUMERIC([Avg_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_36_03], '')) = 0) OR (ISNUMERIC([Avg_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_36_04], '')) = 0) OR (ISNUMERIC([Avg_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_36_05], '')) = 0) OR (ISNUMERIC([Avg_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_37_01], '')) = 0) OR (ISNUMERIC([Avg_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_37_02], '')) = 0) OR (ISNUMERIC([Avg_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_37_03], '')) = 0) OR (ISNUMERIC([Avg_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_37_04], '')) = 0) OR (ISNUMERIC([Avg_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_37_05], '')) = 0) OR (ISNUMERIC([Avg_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_38_01], '')) = 0) OR (ISNUMERIC([Avg_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_38_02], '')) = 0) OR (ISNUMERIC([Avg_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_38_03], '')) = 0) OR (ISNUMERIC([Avg_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_38_04], '')) = 0) OR (ISNUMERIC([Avg_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_38_05], '')) = 0) OR (ISNUMERIC([Avg_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_39_01], '')) = 0) OR (ISNUMERIC([Avg_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_39_02], '')) = 0) OR (ISNUMERIC([Avg_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_39_03], '')) = 0) OR (ISNUMERIC([Avg_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_39_04], '')) = 0) OR (ISNUMERIC([Avg_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_39_05], '')) = 0) OR (ISNUMERIC([Avg_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_40_01], '')) = 0) OR (ISNUMERIC([Avg_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_40_02], '')) = 0) OR (ISNUMERIC([Avg_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_40_03], '')) = 0) OR (ISNUMERIC([Avg_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_40_04], '')) = 0) OR (ISNUMERIC([Avg_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_40_05], '')) = 0) OR (ISNUMERIC([Avg_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_41_01], '')) = 0) OR (ISNUMERIC([Avg_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_41_02], '')) = 0) OR (ISNUMERIC([Avg_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_41_03], '')) = 0) OR (ISNUMERIC([Avg_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_41_04], '')) = 0) OR (ISNUMERIC([Avg_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_41_05], '')) = 0) OR (ISNUMERIC([Avg_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_42_01], '')) = 0) OR (ISNUMERIC([Avg_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_42_02], '')) = 0) OR (ISNUMERIC([Avg_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_42_03], '')) = 0) OR (ISNUMERIC([Avg_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_42_04], '')) = 0) OR (ISNUMERIC([Avg_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_42_05], '')) = 0) OR (ISNUMERIC([Avg_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_00], '')) = 0) OR (ISNUMERIC([Avg_Q_43_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_00]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_01], '')) = 0) OR (ISNUMERIC([Avg_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_02], '')) = 0) OR (ISNUMERIC([Avg_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_03], '')) = 0) OR (ISNUMERIC([Avg_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_04], '')) = 0) OR (ISNUMERIC([Avg_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_05], '')) = 0) OR (ISNUMERIC([Avg_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_06], '')) = 0) OR (ISNUMERIC([Avg_Q_43_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_07], '')) = 0) OR (ISNUMERIC([Avg_Q_43_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_07]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_08], '')) = 0) OR (ISNUMERIC([Avg_Q_43_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_08]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_09], '')) = 0) OR (ISNUMERIC([Avg_Q_43_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_09]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_43_10], '')) = 0) OR (ISNUMERIC([Avg_Q_43_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_10]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_44_01], '')) = 0) OR (ISNUMERIC([Avg_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_44_02], '')) = 0) OR (ISNUMERIC([Avg_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_44_03], '')) = 0) OR (ISNUMERIC([Avg_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_44_04], '')) = 0) OR (ISNUMERIC([Avg_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_44_05], '')) = 0) OR (ISNUMERIC([Avg_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_45_01], '')) = 0) OR (ISNUMERIC([Avg_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_45_02], '')) = 0) OR (ISNUMERIC([Avg_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_45_03], '')) = 0) OR (ISNUMERIC([Avg_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_45_04], '')) = 0) OR (ISNUMERIC([Avg_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_45_05], '')) = 0) OR (ISNUMERIC([Avg_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_00], '')) = 0) OR (ISNUMERIC([Avg_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_00]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_01], '')) = 0) OR (ISNUMERIC([Avg_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_10], '')) = 0) OR (ISNUMERIC([Avg_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_10]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_02], '')) = 0) OR (ISNUMERIC([Avg_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_03], '')) = 0) OR (ISNUMERIC([Avg_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_04], '')) = 0) OR (ISNUMERIC([Avg_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_05], '')) = 0) OR (ISNUMERIC([Avg_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_06], '')) = 0) OR (ISNUMERIC([Avg_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_07], '')) = 0) OR (ISNUMERIC([Avg_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_07]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_08], '')) = 0) OR (ISNUMERIC([Avg_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_08]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_46_09], '')) = 0) OR (ISNUMERIC([Avg_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_09]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_47_01], '')) = 0) OR (ISNUMERIC([Avg_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_47_02], '')) = 0) OR (ISNUMERIC([Avg_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_47_03], '')) = 0) OR (ISNUMERIC([Avg_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_47_04], '')) = 0) OR (ISNUMERIC([Avg_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_47_05], '')) = 0) OR (ISNUMERIC([Avg_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_48_01], '')) = 0) OR (ISNUMERIC([Avg_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_48_02], '')) = 0) OR (ISNUMERIC([Avg_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_48_03], '')) = 0) OR (ISNUMERIC([Avg_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_48_04], '')) = 0) OR (ISNUMERIC([Avg_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_48_05], '')) = 0) OR (ISNUMERIC([Avg_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_49_01], '')) = 0) OR (ISNUMERIC([Avg_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_49_02], '')) = 0) OR (ISNUMERIC([Avg_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_49_03], '')) = 0) OR (ISNUMERIC([Avg_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_49_04], '')) = 0) OR (ISNUMERIC([Avg_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_49_05], '')) = 0) OR (ISNUMERIC([Avg_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_50_01], '')) = 0) OR (ISNUMERIC([Avg_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_50_02], '')) = 0) OR (ISNUMERIC([Avg_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_50_03], '')) = 0) OR (ISNUMERIC([Avg_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_50_04], '')) = 0) OR (ISNUMERIC([Avg_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_50_05], '')) = 0) OR (ISNUMERIC([Avg_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_51_01], '')) = 0) OR (ISNUMERIC([Avg_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_51_02], '')) = 0) OR (ISNUMERIC([Avg_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_51_03], '')) = 0) OR (ISNUMERIC([Avg_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_51_04], '')) = 0) OR (ISNUMERIC([Avg_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_51_05], '')) = 0) OR (ISNUMERIC([Avg_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_52_01], '')) = 0) OR (ISNUMERIC([Avg_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_52_02], '')) = 0) OR (ISNUMERIC([Avg_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_52_03], '')) = 0) OR (ISNUMERIC([Avg_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_52_04], '')) = 0) OR (ISNUMERIC([Avg_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_52_05], '')) = 0) OR (ISNUMERIC([Avg_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_53_01], '')) = 0) OR (ISNUMERIC([Avg_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_53_02], '')) = 0) OR (ISNUMERIC([Avg_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_53_03], '')) = 0) OR (ISNUMERIC([Avg_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_53_04], '')) = 0) OR (ISNUMERIC([Avg_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_53_05], '')) = 0) OR (ISNUMERIC([Avg_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_54_01], '')) = 0) OR (ISNUMERIC([Avg_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_54_02], '')) = 0) OR (ISNUMERIC([Avg_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_54_03], '')) = 0) OR (ISNUMERIC([Avg_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_54_04], '')) = 0) OR (ISNUMERIC([Avg_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_54_05], '')) = 0) OR (ISNUMERIC([Avg_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_55_01], '')) = 0) OR (ISNUMERIC([Avg_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_55_02], '')) = 0) OR (ISNUMERIC([Avg_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_55_03], '')) = 0) OR (ISNUMERIC([Avg_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_55_04], '')) = 0) OR (ISNUMERIC([Avg_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_55_05], '')) = 0) OR (ISNUMERIC([Avg_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_56_01], '')) = 0) OR (ISNUMERIC([Avg_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_56_02], '')) = 0) OR (ISNUMERIC([Avg_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_56_03], '')) = 0) OR (ISNUMERIC([Avg_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_56_04], '')) = 0) OR (ISNUMERIC([Avg_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_56_05], '')) = 0) OR (ISNUMERIC([Avg_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_57_01], '')) = 0) OR (ISNUMERIC([Avg_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_57_02], '')) = 0) OR (ISNUMERIC([Avg_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_57_03], '')) = 0) OR (ISNUMERIC([Avg_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_57_04], '')) = 0) OR (ISNUMERIC([Avg_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_57_05], '')) = 0) OR (ISNUMERIC([Avg_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_58_01], '')) = 0) OR (ISNUMERIC([Avg_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_58_02], '')) = 0) OR (ISNUMERIC([Avg_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_58_03], '')) = 0) OR (ISNUMERIC([Avg_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_58_04], '')) = 0) OR (ISNUMERIC([Avg_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_58_05], '')) = 0) OR (ISNUMERIC([Avg_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_59_01], '')) = 0) OR (ISNUMERIC([Avg_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_59_02], '')) = 0) OR (ISNUMERIC([Avg_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_59_03], '')) = 0) OR (ISNUMERIC([Avg_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_59_04], '')) = 0) OR (ISNUMERIC([Avg_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_59_05], '')) = 0) OR (ISNUMERIC([Avg_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_60_01], '')) = 0) OR (ISNUMERIC([Avg_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_60_02], '')) = 0) OR (ISNUMERIC([Avg_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_60_03], '')) = 0) OR (ISNUMERIC([Avg_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_60_04], '')) = 0) OR (ISNUMERIC([Avg_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_60_05], '')) = 0) OR (ISNUMERIC([Avg_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_61_01], '')) = 0) OR (ISNUMERIC([Avg_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_61_02], '')) = 0) OR (ISNUMERIC([Avg_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_61_03], '')) = 0) OR (ISNUMERIC([Avg_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_61_04], '')) = 0) OR (ISNUMERIC([Avg_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_61_05], '')) = 0) OR (ISNUMERIC([Avg_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_62_01], '')) = 0) OR (ISNUMERIC([Avg_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_62_02], '')) = 0) OR (ISNUMERIC([Avg_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_62_03], '')) = 0) OR (ISNUMERIC([Avg_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_62_04], '')) = 0) OR (ISNUMERIC([Avg_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_62_05], '')) = 0) OR (ISNUMERIC([Avg_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_63_01], '')) = 0) OR (ISNUMERIC([Avg_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_63_02], '')) = 0) OR (ISNUMERIC([Avg_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_63_03], '')) = 0) OR (ISNUMERIC([Avg_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_63_04], '')) = 0) OR (ISNUMERIC([Avg_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_63_05], '')) = 0) OR (ISNUMERIC([Avg_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_01], '')) = 0) OR (ISNUMERIC([Avg_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_02], '')) = 0) OR (ISNUMERIC([Avg_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_03], '')) = 0) OR (ISNUMERIC([Avg_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_04], '')) = 0) OR (ISNUMERIC([Avg_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_05], '')) = 0) OR (ISNUMERIC([Avg_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_64_06], '')) = 0) OR (ISNUMERIC([Avg_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_01], '')) = 0) OR (ISNUMERIC([Avg_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_02], '')) = 0) OR (ISNUMERIC([Avg_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_03], '')) = 0) OR (ISNUMERIC([Avg_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_04], '')) = 0) OR (ISNUMERIC([Avg_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_05], '')) = 0) OR (ISNUMERIC([Avg_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_06], '')) = 0) OR (ISNUMERIC([Avg_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_06]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_65_07], '')) = 0) OR (ISNUMERIC([Avg_Q_65_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_07]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_66_01], '')) = 0) OR (ISNUMERIC([Avg_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_66_02], '')) = 0) OR (ISNUMERIC([Avg_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_66_03], '')) = 0) OR (ISNUMERIC([Avg_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_66_04], '')) = 0) OR (ISNUMERIC([Avg_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_66_05], '')) = 0) OR (ISNUMERIC([Avg_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_67_01], '')) = 0) OR (ISNUMERIC([Avg_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_67_02], '')) = 0) OR (ISNUMERIC([Avg_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_67_03], '')) = 0) OR (ISNUMERIC([Avg_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_67_04], '')) = 0) OR (ISNUMERIC([Avg_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_67_05], '')) = 0) OR (ISNUMERIC([Avg_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_68_01], '')) = 0) OR (ISNUMERIC([Avg_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_68_02], '')) = 0) OR (ISNUMERIC([Avg_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_68_03], '')) = 0) OR (ISNUMERIC([Avg_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_68_04], '')) = 0) OR (ISNUMERIC([Avg_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_68_05], '')) = 0) OR (ISNUMERIC([Avg_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_69_01], '')) = 0) OR (ISNUMERIC([Avg_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_69_02], '')) = 0) OR (ISNUMERIC([Avg_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_69_03], '')) = 0) OR (ISNUMERIC([Avg_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_69_04], '')) = 0) OR (ISNUMERIC([Avg_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_69_05], '')) = 0) OR (ISNUMERIC([Avg_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_70_01], '')) = 0) OR (ISNUMERIC([Avg_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_01]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_70_02], '')) = 0) OR (ISNUMERIC([Avg_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_02]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_70_03], '')) = 0) OR (ISNUMERIC([Avg_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_03]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_70_04], '')) = 0) OR (ISNUMERIC([Avg_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_04]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Avg_Q_70_05], '')) = 0) OR (ISNUMERIC([Avg_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_05]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([NPS], '')) = 0) OR (ISNUMERIC([NPS]) = 1 AND CONVERT(DECIMAL(20, 6), [NPS]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([RPI_COM], '')) = 0) OR (ISNUMERIC([RPI_COM]) = 1 AND CONVERT(DECIMAL(20, 6), [RPI_COM]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([RPI_IND], '')) = 0) OR (ISNUMERIC([RPI_IND]) = 1 AND CONVERT(DECIMAL(20, 6), [RPI_IND]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Achievement Z-Score], 0)) = 0) OR (ISNUMERIC([Achievement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Achievement Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Belonging Z-Score], 0)) = 0) OR (ISNUMERIC([Belonging Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Belonging Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Character Z-Score], 0)) = 0) OR (ISNUMERIC([Character Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Character Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Giving Z-Score], 0)) = 0) OR (ISNUMERIC([Giving Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Giving Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Health Z-Score], 0)) = 0) OR (ISNUMERIC([Health Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Health Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Inspiration Z-Score], 0)) = 0) OR (ISNUMERIC([Inspiration Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Inspiration Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Meaning Z-Score], 0)) = 0) OR (ISNUMERIC([Meaning Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Meaning Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Relationship Z-Score], 0)) = 0) OR (ISNUMERIC([Relationship Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Relationship Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Safety Z-Score], 0)) = 0) OR (ISNUMERIC([Safety Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Safety Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Achievement Percentile], '')) = 0) OR (ISNUMERIC([Achievement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Achievement Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Belonging Percentile], '')) = 0) OR (ISNUMERIC([Belonging Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Belonging Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Character Percentile], '')) = 0) OR (ISNUMERIC([Character Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Character Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Giving Percentile], '')) = 0) OR (ISNUMERIC([Giving Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Giving Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Health Percentile], '')) = 0) OR (ISNUMERIC([Health Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Health Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Inspiration Percentile], '')) = 0) OR (ISNUMERIC([Inspiration Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Inspiration Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Meaning Percentile], '')) = 0) OR (ISNUMERIC([Meaning Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Meaning Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Relationship Percentile], '')) = 0) OR (ISNUMERIC([Relationship Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Relationship Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Safety Percentile], '')) = 0) OR (ISNUMERIC([Safety Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Safety Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Facilities Z-Score], 0)) = 0) OR (ISNUMERIC([Facilities Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Facilities Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Service Z-Score], 0)) = 0) OR (ISNUMERIC([Service Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Service Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Value Z-Score], 0)) = 0) OR (ISNUMERIC([Value Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Value Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Engagement Z-Score], 0)) = 0) OR (ISNUMERIC([Engagement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Engagement Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Health and Wellness Z-Score], 0)) = 0) OR (ISNUMERIC([Health and Wellness Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Health and Wellness Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Involvement Z-Score], 0)) = 0) OR (ISNUMERIC([Involvement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Involvement Z-Score]) BETWEEN -10.00000 AND 10.00000))
					AND ((LEN(COALESCE([Facilities Percentile], '')) = 0) OR (ISNUMERIC([Facilities Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Facilities Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Service Percentile], '')) = 0) OR (ISNUMERIC([Service Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Service Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Value Percentile], '')) = 0) OR (ISNUMERIC([Value Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Value Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Engagement Percentile], '')) = 0) OR (ISNUMERIC([Engagement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Engagement Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Health and Wellness Percentile], '')) = 0) OR (ISNUMERIC([Health and Wellness Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Health and Wellness Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Involvement Percentile], '')) = 0) OR (ISNUMERIC([Involvement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Involvement Percentile]) BETWEEN 0.00000 AND 1.00000))
					AND ((LEN(COALESCE([Sum_M_01b_01], 0)) = 0) OR (ISNUMERIC([Sum_M_01b_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01b_01]) >= 0))
					AND ((LEN(COALESCE([Sum_M_01c_01], 0)) = 0) OR (ISNUMERIC([Sum_M_01c_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01c_01]) >= 0))
					AND ((LEN(COALESCE([Sum_M_01d_01], 0)) = 0) OR (ISNUMERIC([Sum_M_01d_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01d_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_01_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_01_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_01_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_01_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_01_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_02_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_02_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_02_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_02_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_02_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_03_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_03_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_03_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_03_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_03_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_04_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_04_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_04_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_04_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_04_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_05_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_05_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_05_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_05_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_05_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_06_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_06_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_06_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_06_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_06_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_07_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_07_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_07_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_07_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_07_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_08_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_08_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_08_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_08_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_08_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_09_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_09_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_09_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_09_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_09_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_10_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_10_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_10_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_10_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_10_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_11_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_11_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_11_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_11_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_11_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_12_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_12_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_12_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_12_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_12_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_13_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_13_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_13_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_13_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_13_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_14_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_14_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_14_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_14_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_14_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_15_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_15_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_15_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_15_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_15_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_16_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_16_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_16_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_16_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_16_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_17_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_17_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_17_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_17_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_17_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_18_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_18_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_18_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_18_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_18_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_19_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_19_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_19_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_19_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_19_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_20_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_20_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_20_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_20_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_20_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_21_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_21_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_21_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_21_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_21_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_22_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_22_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_22_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_22_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_22_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_23_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_23_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_23_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_23_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_23_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_24_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_24_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_24_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_24_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_24_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_25_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_25_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_25_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_25_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_25_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_26_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_26_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_26_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_26_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_26_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_27_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_27_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_27_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_27_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_27_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_28_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_28_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_28_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_28_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_28_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_29_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_29_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_29_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_29_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_29_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_30_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_30_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_30_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_30_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_30_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_31_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_31_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_31_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_31_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_31_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_00], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_00]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_10], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_10]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_06], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_06]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_07], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_07]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_08], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_08]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_32_09], 0)) = 0) OR (ISNUMERIC([Sum_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_09]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_33_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_33_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_33_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_33_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_33_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_34_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_34_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_34_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_34_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_34_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_00], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_00]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_10], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_10]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_06], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_06]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_07], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_07]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_08], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_08]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_35_09], 0)) = 0) OR (ISNUMERIC([Sum_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_09]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_36_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_36_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_36_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_36_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_36_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_37_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_37_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_37_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_37_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_37_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_38_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_38_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_38_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_38_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_38_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_39_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_39_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_39_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_39_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_39_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_40_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_40_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_40_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_40_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_40_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_41_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_41_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_41_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_41_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_41_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_42_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_42_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_42_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_42_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_42_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_43_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_43_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_43_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_43_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_43_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_44_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_44_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_44_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_44_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_44_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_45_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_45_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_45_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_45_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_45_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_00], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_00]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_10], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_10]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_06], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_06]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_07], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_07]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_08], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_08]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_46_09], 0)) = 0) OR (ISNUMERIC([Sum_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_09]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_47_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_47_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_47_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_47_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_47_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_48_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_48_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_48_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_48_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_48_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_49_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_49_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_49_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_49_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_49_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_50_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_50_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_50_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_50_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_50_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_51_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_51_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_51_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_51_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_51_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_52_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_52_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_52_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_52_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_52_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_53_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_53_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_53_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_53_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_53_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_54_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_54_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_54_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_54_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_54_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_55_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_55_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_55_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_55_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_55_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_56_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_56_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_56_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_56_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_56_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_57_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_57_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_57_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_57_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_57_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_58_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_58_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_58_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_58_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_58_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_59_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_59_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_59_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_59_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_59_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_60_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_60_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_60_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_60_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_60_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_61_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_61_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_61_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_61_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_61_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_62_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_62_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_62_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_62_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_62_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_63_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_63_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_63_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_63_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_63_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_64_06], 0)) = 0) OR (ISNUMERIC([Sum_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_06]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_65_06], 0)) = 0) OR (ISNUMERIC([Sum_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_06]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_66_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_66_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_66_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_66_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_66_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_67_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_67_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_67_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_67_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_67_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_68_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_68_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_68_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_68_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_68_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_69_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_69_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_69_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_69_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_69_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_05]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_70_01], 0)) = 0) OR (ISNUMERIC([Sum_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_01]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_70_02], 0)) = 0) OR (ISNUMERIC([Sum_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_02]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_70_03], 0)) = 0) OR (ISNUMERIC([Sum_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_03]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_70_04], 0)) = 0) OR (ISNUMERIC([Sum_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_04]) >= 0))
					AND ((LEN(COALESCE([Sum_Q_70_05], 0)) = 0) OR (ISNUMERIC([Sum_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_05]) >= 0))

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
				AND target.form_code = source.form_code
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
			
			WHEN MATCHED AND (target.[response_load_date]	 <> 	source.[response_load_date]
								OR target.[official_branch_number]	 <> 	source.[official_branch_number]
								OR target.[branch_name]	 <> 	source.[branch_name]
								OR target.[response_count]	 <> 	source.[response_count]
								OR target.[avg_m_01a_01]	 <> 	source.[avg_m_01a_01]
								OR target.[avg_m_01b_01]	 <> 	source.[avg_m_01b_01]
								OR target.[avg_m_01c_01]	 <> 	source.[avg_m_01c_01]
								OR target.[avg_m_01d_01]	 <> 	source.[avg_m_01d_01]
								OR target.[avg_q_01_01]	 <> 	source.[avg_q_01_01]
								OR target.[avg_q_01_02]	 <> 	source.[avg_q_01_02]
								OR target.[avg_q_01_03]	 <> 	source.[avg_q_01_03]
								OR target.[avg_q_01_04]	 <> 	source.[avg_q_01_04]
								OR target.[avg_q_01_05]	 <> 	source.[avg_q_01_05]
								OR target.[avg_q_02_01]	 <> 	source.[avg_q_02_01]
								OR target.[avg_q_02_02]	 <> 	source.[avg_q_02_02]
								OR target.[avg_q_02_03]	 <> 	source.[avg_q_02_03]
								OR target.[avg_q_02_04]	 <> 	source.[avg_q_02_04]
								OR target.[avg_q_02_05]	 <> 	source.[avg_q_02_05]
								OR target.[avg_q_03_01]	 <> 	source.[avg_q_03_01]
								OR target.[avg_q_03_02]	 <> 	source.[avg_q_03_02]
								OR target.[avg_q_03_03]	 <> 	source.[avg_q_03_03]
								OR target.[avg_q_03_04]	 <> 	source.[avg_q_03_04]
								OR target.[avg_q_03_05]	 <> 	source.[avg_q_03_05]
								OR target.[avg_q_04_01]	 <> 	source.[avg_q_04_01]
								OR target.[avg_q_04_02]	 <> 	source.[avg_q_04_02]
								OR target.[avg_q_04_03]	 <> 	source.[avg_q_04_03]
								OR target.[avg_q_04_04]	 <> 	source.[avg_q_04_04]
								OR target.[avg_q_04_05]	 <> 	source.[avg_q_04_05]
								OR target.[avg_q_05_01]	 <> 	source.[avg_q_05_01]
								OR target.[avg_q_05_02]	 <> 	source.[avg_q_05_02]
								OR target.[avg_q_05_03]	 <> 	source.[avg_q_05_03]
								OR target.[avg_q_05_04]	 <> 	source.[avg_q_05_04]
								OR target.[avg_q_05_05]	 <> 	source.[avg_q_05_05]
								OR target.[avg_q_06_01]	 <> 	source.[avg_q_06_01]
								OR target.[avg_q_06_02]	 <> 	source.[avg_q_06_02]
								OR target.[avg_q_06_03]	 <> 	source.[avg_q_06_03]
								OR target.[avg_q_06_04]	 <> 	source.[avg_q_06_04]
								OR target.[avg_q_06_05]	 <> 	source.[avg_q_06_05]
								OR target.[avg_q_07_01]	 <> 	source.[avg_q_07_01]
								OR target.[avg_q_07_02]	 <> 	source.[avg_q_07_02]
								OR target.[avg_q_07_03]	 <> 	source.[avg_q_07_03]
								OR target.[avg_q_07_04]	 <> 	source.[avg_q_07_04]
								OR target.[avg_q_07_05]	 <> 	source.[avg_q_07_05]
								OR target.[avg_q_08_01]	 <> 	source.[avg_q_08_01]
								OR target.[avg_q_08_02]	 <> 	source.[avg_q_08_02]
								OR target.[avg_q_08_03]	 <> 	source.[avg_q_08_03]
								OR target.[avg_q_08_04]	 <> 	source.[avg_q_08_04]
								OR target.[avg_q_08_05]	 <> 	source.[avg_q_08_05]
								OR target.[avg_q_09_01]	 <> 	source.[avg_q_09_01]
								OR target.[avg_q_09_02]	 <> 	source.[avg_q_09_02]
								OR target.[avg_q_09_03]	 <> 	source.[avg_q_09_03]
								OR target.[avg_q_09_04]	 <> 	source.[avg_q_09_04]
								OR target.[avg_q_09_05]	 <> 	source.[avg_q_09_05]
								OR target.[avg_q_10_01]	 <> 	source.[avg_q_10_01]
								OR target.[avg_q_10_02]	 <> 	source.[avg_q_10_02]
								OR target.[avg_q_10_03]	 <> 	source.[avg_q_10_03]
								OR target.[avg_q_10_04]	 <> 	source.[avg_q_10_04]
								OR target.[avg_q_10_05]	 <> 	source.[avg_q_10_05]
								OR target.[avg_q_11_01]	 <> 	source.[avg_q_11_01]
								OR target.[avg_q_11_02]	 <> 	source.[avg_q_11_02]
								OR target.[avg_q_11_03]	 <> 	source.[avg_q_11_03]
								OR target.[avg_q_11_04]	 <> 	source.[avg_q_11_04]
								OR target.[avg_q_11_05]	 <> 	source.[avg_q_11_05]
								OR target.[avg_q_12_01]	 <> 	source.[avg_q_12_01]
								OR target.[avg_q_12_02]	 <> 	source.[avg_q_12_02]
								OR target.[avg_q_12_03]	 <> 	source.[avg_q_12_03]
								OR target.[avg_q_12_04]	 <> 	source.[avg_q_12_04]
								OR target.[avg_q_12_05]	 <> 	source.[avg_q_12_05]
								OR target.[avg_q_13_01]	 <> 	source.[avg_q_13_01]
								OR target.[avg_q_13_02]	 <> 	source.[avg_q_13_02]
								OR target.[avg_q_13_03]	 <> 	source.[avg_q_13_03]
								OR target.[avg_q_13_04]	 <> 	source.[avg_q_13_04]
								OR target.[avg_q_13_05]	 <> 	source.[avg_q_13_05]
								OR target.[avg_q_14_01]	 <> 	source.[avg_q_14_01]
								OR target.[avg_q_14_02]	 <> 	source.[avg_q_14_02]
								OR target.[avg_q_14_03]	 <> 	source.[avg_q_14_03]
								OR target.[avg_q_14_04]	 <> 	source.[avg_q_14_04]
								OR target.[avg_q_14_05]	 <> 	source.[avg_q_14_05]
								OR target.[avg_q_15_01]	 <> 	source.[avg_q_15_01]
								OR target.[avg_q_15_02]	 <> 	source.[avg_q_15_02]
								OR target.[avg_q_15_03]	 <> 	source.[avg_q_15_03]
								OR target.[avg_q_15_04]	 <> 	source.[avg_q_15_04]
								OR target.[avg_q_15_05]	 <> 	source.[avg_q_15_05]
								OR target.[avg_q_16_01]	 <> 	source.[avg_q_16_01]
								OR target.[avg_q_16_02]	 <> 	source.[avg_q_16_02]
								OR target.[avg_q_16_03]	 <> 	source.[avg_q_16_03]
								OR target.[avg_q_16_04]	 <> 	source.[avg_q_16_04]
								OR target.[avg_q_16_05]	 <> 	source.[avg_q_16_05]
								OR target.[avg_q_17_01]	 <> 	source.[avg_q_17_01]
								OR target.[avg_q_17_02]	 <> 	source.[avg_q_17_02]
								OR target.[avg_q_17_03]	 <> 	source.[avg_q_17_03]
								OR target.[avg_q_17_04]	 <> 	source.[avg_q_17_04]
								OR target.[avg_q_17_05]	 <> 	source.[avg_q_17_05]
								OR target.[avg_q_18_01]	 <> 	source.[avg_q_18_01]
								OR target.[avg_q_18_02]	 <> 	source.[avg_q_18_02]
								OR target.[avg_q_18_03]	 <> 	source.[avg_q_18_03]
								OR target.[avg_q_18_04]	 <> 	source.[avg_q_18_04]
								OR target.[avg_q_18_05]	 <> 	source.[avg_q_18_05]
								OR target.[avg_q_19_01]	 <> 	source.[avg_q_19_01]
								OR target.[avg_q_19_02]	 <> 	source.[avg_q_19_02]
								OR target.[avg_q_19_03]	 <> 	source.[avg_q_19_03]
								OR target.[avg_q_19_04]	 <> 	source.[avg_q_19_04]
								OR target.[avg_q_19_05]	 <> 	source.[avg_q_19_05]
								OR target.[avg_q_20_01]	 <> 	source.[avg_q_20_01]
								OR target.[avg_q_20_02]	 <> 	source.[avg_q_20_02]
								OR target.[avg_q_20_03]	 <> 	source.[avg_q_20_03]
								OR target.[avg_q_20_04]	 <> 	source.[avg_q_20_04]
								OR target.[avg_q_20_05]	 <> 	source.[avg_q_20_05]
								OR target.[avg_q_21_01]	 <> 	source.[avg_q_21_01]
								OR target.[avg_q_21_02]	 <> 	source.[avg_q_21_02]
								OR target.[avg_q_21_03]	 <> 	source.[avg_q_21_03]
								OR target.[avg_q_21_04]	 <> 	source.[avg_q_21_04]
								OR target.[avg_q_21_05]	 <> 	source.[avg_q_21_05]
								OR target.[avg_q_22_01]	 <> 	source.[avg_q_22_01]
								OR target.[avg_q_22_02]	 <> 	source.[avg_q_22_02]
								OR target.[avg_q_22_03]	 <> 	source.[avg_q_22_03]
								OR target.[avg_q_22_04]	 <> 	source.[avg_q_22_04]
								OR target.[avg_q_22_05]	 <> 	source.[avg_q_22_05]
								OR target.[avg_q_23_01]	 <> 	source.[avg_q_23_01]
								OR target.[avg_q_23_02]	 <> 	source.[avg_q_23_02]
								OR target.[avg_q_23_03]	 <> 	source.[avg_q_23_03]
								OR target.[avg_q_23_04]	 <> 	source.[avg_q_23_04]
								OR target.[avg_q_23_05]	 <> 	source.[avg_q_23_05]
								OR target.[avg_q_24_01]	 <> 	source.[avg_q_24_01]
								OR target.[avg_q_24_02]	 <> 	source.[avg_q_24_02]
								OR target.[avg_q_24_03]	 <> 	source.[avg_q_24_03]
								OR target.[avg_q_24_04]	 <> 	source.[avg_q_24_04]
								OR target.[avg_q_24_05]	 <> 	source.[avg_q_24_05]
								OR target.[avg_q_25_01]	 <> 	source.[avg_q_25_01]
								OR target.[avg_q_25_02]	 <> 	source.[avg_q_25_02]
								OR target.[avg_q_25_03]	 <> 	source.[avg_q_25_03]
								OR target.[avg_q_25_04]	 <> 	source.[avg_q_25_04]
								OR target.[avg_q_25_05]	 <> 	source.[avg_q_25_05]
								OR target.[avg_q_26_01]	 <> 	source.[avg_q_26_01]
								OR target.[avg_q_26_02]	 <> 	source.[avg_q_26_02]
								OR target.[avg_q_26_03]	 <> 	source.[avg_q_26_03]
								OR target.[avg_q_26_04]	 <> 	source.[avg_q_26_04]
								OR target.[avg_q_26_05]	 <> 	source.[avg_q_26_05]
								OR target.[avg_q_27_01]	 <> 	source.[avg_q_27_01]
								OR target.[avg_q_27_02]	 <> 	source.[avg_q_27_02]
								OR target.[avg_q_27_03]	 <> 	source.[avg_q_27_03]
								OR target.[avg_q_27_04]	 <> 	source.[avg_q_27_04]
								OR target.[avg_q_27_05]	 <> 	source.[avg_q_27_05]
								OR target.[avg_q_28_01]	 <> 	source.[avg_q_28_01]
								OR target.[avg_q_28_02]	 <> 	source.[avg_q_28_02]
								OR target.[avg_q_28_03]	 <> 	source.[avg_q_28_03]
								OR target.[avg_q_28_04]	 <> 	source.[avg_q_28_04]
								OR target.[avg_q_28_05]	 <> 	source.[avg_q_28_05]
								OR target.[avg_q_29_01]	 <> 	source.[avg_q_29_01]
								OR target.[avg_q_29_02]	 <> 	source.[avg_q_29_02]
								OR target.[avg_q_29_03]	 <> 	source.[avg_q_29_03]
								OR target.[avg_q_29_04]	 <> 	source.[avg_q_29_04]
								OR target.[avg_q_29_05]	 <> 	source.[avg_q_29_05]
								OR target.[avg_q_30_01]	 <> 	source.[avg_q_30_01]
								OR target.[avg_q_30_02]	 <> 	source.[avg_q_30_02]
								OR target.[avg_q_30_03]	 <> 	source.[avg_q_30_03]
								OR target.[avg_q_30_04]	 <> 	source.[avg_q_30_04]
								OR target.[avg_q_30_05]	 <> 	source.[avg_q_30_05]
								OR target.[avg_q_31_01]	 <> 	source.[avg_q_31_01]
								OR target.[avg_q_31_02]	 <> 	source.[avg_q_31_02]
								OR target.[avg_q_31_03]	 <> 	source.[avg_q_31_03]
								OR target.[avg_q_31_04]	 <> 	source.[avg_q_31_04]
								OR target.[avg_q_31_05]	 <> 	source.[avg_q_31_05]
								OR target.[avg_q_32_00]	 <> 	source.[avg_q_32_00]
								OR target.[avg_q_32_01]	 <> 	source.[avg_q_32_01]
								OR target.[avg_q_32_10]	 <> 	source.[avg_q_32_10]
								OR target.[avg_q_32_02]	 <> 	source.[avg_q_32_02]
								OR target.[avg_q_32_03]	 <> 	source.[avg_q_32_03]
								OR target.[avg_q_32_04]	 <> 	source.[avg_q_32_04]
								OR target.[avg_q_32_05]	 <> 	source.[avg_q_32_05]
								OR target.[avg_q_32_06]	 <> 	source.[avg_q_32_06]
								OR target.[avg_q_32_07]	 <> 	source.[avg_q_32_07]
								OR target.[avg_q_32_08]	 <> 	source.[avg_q_32_08]
								OR target.[avg_q_32_09]	 <> 	source.[avg_q_32_09]
								OR target.[avg_q_33_01]	 <> 	source.[avg_q_33_01]
								OR target.[avg_q_33_02]	 <> 	source.[avg_q_33_02]
								OR target.[avg_q_33_03]	 <> 	source.[avg_q_33_03]
								OR target.[avg_q_33_04]	 <> 	source.[avg_q_33_04]
								OR target.[avg_q_33_05]	 <> 	source.[avg_q_33_05]
								OR target.[avg_q_34_01]	 <> 	source.[avg_q_34_01]
								OR target.[avg_q_34_02]	 <> 	source.[avg_q_34_02]
								OR target.[avg_q_34_03]	 <> 	source.[avg_q_34_03]
								OR target.[avg_q_34_04]	 <> 	source.[avg_q_34_04]
								OR target.[avg_q_34_05]	 <> 	source.[avg_q_34_05]
								OR target.[avg_q_35_00]	 <> 	source.[avg_q_35_00]
								OR target.[avg_q_35_01]	 <> 	source.[avg_q_35_01]
								OR target.[avg_q_35_10]	 <> 	source.[avg_q_35_10]
								OR target.[avg_q_35_02]	 <> 	source.[avg_q_35_02]
								OR target.[avg_q_35_03]	 <> 	source.[avg_q_35_03]
								OR target.[avg_q_35_04]	 <> 	source.[avg_q_35_04]
								OR target.[avg_q_35_05]	 <> 	source.[avg_q_35_05]
								OR target.[avg_q_35_06]	 <> 	source.[avg_q_35_06]
								OR target.[avg_q_35_07]	 <> 	source.[avg_q_35_07]
								OR target.[avg_q_35_08]	 <> 	source.[avg_q_35_08]
								OR target.[avg_q_35_09]	 <> 	source.[avg_q_35_09]
								OR target.[avg_q_36_01]	 <> 	source.[avg_q_36_01]
								OR target.[avg_q_36_02]	 <> 	source.[avg_q_36_02]
								OR target.[avg_q_36_03]	 <> 	source.[avg_q_36_03]
								OR target.[avg_q_36_04]	 <> 	source.[avg_q_36_04]
								OR target.[avg_q_36_05]	 <> 	source.[avg_q_36_05]
								OR target.[avg_q_37_01]	 <> 	source.[avg_q_37_01]
								OR target.[avg_q_37_02]	 <> 	source.[avg_q_37_02]
								OR target.[avg_q_37_03]	 <> 	source.[avg_q_37_03]
								OR target.[avg_q_37_04]	 <> 	source.[avg_q_37_04]
								OR target.[avg_q_37_05]	 <> 	source.[avg_q_37_05]
								OR target.[avg_q_38_01]	 <> 	source.[avg_q_38_01]
								OR target.[avg_q_38_02]	 <> 	source.[avg_q_38_02]
								OR target.[avg_q_38_03]	 <> 	source.[avg_q_38_03]
								OR target.[avg_q_38_04]	 <> 	source.[avg_q_38_04]
								OR target.[avg_q_38_05]	 <> 	source.[avg_q_38_05]
								OR target.[avg_q_39_01]	 <> 	source.[avg_q_39_01]
								OR target.[avg_q_39_02]	 <> 	source.[avg_q_39_02]
								OR target.[avg_q_39_03]	 <> 	source.[avg_q_39_03]
								OR target.[avg_q_39_04]	 <> 	source.[avg_q_39_04]
								OR target.[avg_q_39_05]	 <> 	source.[avg_q_39_05]
								OR target.[avg_q_40_01]	 <> 	source.[avg_q_40_01]
								OR target.[avg_q_40_02]	 <> 	source.[avg_q_40_02]
								OR target.[avg_q_40_03]	 <> 	source.[avg_q_40_03]
								OR target.[avg_q_40_04]	 <> 	source.[avg_q_40_04]
								OR target.[avg_q_40_05]	 <> 	source.[avg_q_40_05]
								OR target.[avg_q_41_01]	 <> 	source.[avg_q_41_01]
								OR target.[avg_q_41_02]	 <> 	source.[avg_q_41_02]
								OR target.[avg_q_41_03]	 <> 	source.[avg_q_41_03]
								OR target.[avg_q_41_04]	 <> 	source.[avg_q_41_04]
								OR target.[avg_q_41_05]	 <> 	source.[avg_q_41_05]
								OR target.[avg_q_42_01]	 <> 	source.[avg_q_42_01]
								OR target.[avg_q_42_02]	 <> 	source.[avg_q_42_02]
								OR target.[avg_q_42_03]	 <> 	source.[avg_q_42_03]
								OR target.[avg_q_42_04]	 <> 	source.[avg_q_42_04]
								OR target.[avg_q_42_05]	 <> 	source.[avg_q_42_05]
								OR target.[avg_q_43_00]	 <> 	source.[avg_q_43_00]
								OR target.[avg_q_43_01]	 <> 	source.[avg_q_43_01]
								OR target.[avg_q_43_02]	 <> 	source.[avg_q_43_02]
								OR target.[avg_q_43_03]	 <> 	source.[avg_q_43_03]
								OR target.[avg_q_43_04]	 <> 	source.[avg_q_43_04]
								OR target.[avg_q_43_05]	 <> 	source.[avg_q_43_05]
								OR target.[avg_q_43_06]	 <> 	source.[avg_q_43_06]
								OR target.[avg_q_43_07]	 <> 	source.[avg_q_43_07]
								OR target.[avg_q_43_08]	 <> 	source.[avg_q_43_08]
								OR target.[avg_q_43_09]	 <> 	source.[avg_q_43_09]
								OR target.[avg_q_43_10]	 <> 	source.[avg_q_43_10]
								OR target.[avg_q_44_01]	 <> 	source.[avg_q_44_01]
								OR target.[avg_q_44_02]	 <> 	source.[avg_q_44_02]
								OR target.[avg_q_44_03]	 <> 	source.[avg_q_44_03]
								OR target.[avg_q_44_04]	 <> 	source.[avg_q_44_04]
								OR target.[avg_q_44_05]	 <> 	source.[avg_q_44_05]
								OR target.[avg_q_45_01]	 <> 	source.[avg_q_45_01]
								OR target.[avg_q_45_02]	 <> 	source.[avg_q_45_02]
								OR target.[avg_q_45_03]	 <> 	source.[avg_q_45_03]
								OR target.[avg_q_45_04]	 <> 	source.[avg_q_45_04]
								OR target.[avg_q_45_05]	 <> 	source.[avg_q_45_05]
								OR target.[avg_q_46_00]	 <> 	source.[avg_q_46_00]
								OR target.[avg_q_46_01]	 <> 	source.[avg_q_46_01]
								OR target.[avg_q_46_10]	 <> 	source.[avg_q_46_10]
								OR target.[avg_q_46_02]	 <> 	source.[avg_q_46_02]
								OR target.[avg_q_46_03]	 <> 	source.[avg_q_46_03]
								OR target.[avg_q_46_04]	 <> 	source.[avg_q_46_04]
								OR target.[avg_q_46_05]	 <> 	source.[avg_q_46_05]
								OR target.[avg_q_46_06]	 <> 	source.[avg_q_46_06]
								OR target.[avg_q_46_07]	 <> 	source.[avg_q_46_07]
								OR target.[avg_q_46_08]	 <> 	source.[avg_q_46_08]
								OR target.[avg_q_46_09]	 <> 	source.[avg_q_46_09]
								OR target.[avg_q_47_01]	 <> 	source.[avg_q_47_01]
								OR target.[avg_q_47_02]	 <> 	source.[avg_q_47_02]
								OR target.[avg_q_47_03]	 <> 	source.[avg_q_47_03]
								OR target.[avg_q_47_04]	 <> 	source.[avg_q_47_04]
								OR target.[avg_q_47_05]	 <> 	source.[avg_q_47_05]
								OR target.[avg_q_48_01]	 <> 	source.[avg_q_48_01]
								OR target.[avg_q_48_02]	 <> 	source.[avg_q_48_02]
								OR target.[avg_q_48_03]	 <> 	source.[avg_q_48_03]
								OR target.[avg_q_48_04]	 <> 	source.[avg_q_48_04]
								OR target.[avg_q_48_05]	 <> 	source.[avg_q_48_05]
								OR target.[avg_q_49_01]	 <> 	source.[avg_q_49_01]
								OR target.[avg_q_49_02]	 <> 	source.[avg_q_49_02]
								OR target.[avg_q_49_03]	 <> 	source.[avg_q_49_03]
								OR target.[avg_q_49_04]	 <> 	source.[avg_q_49_04]
								OR target.[avg_q_49_05]	 <> 	source.[avg_q_49_05]
								OR target.[avg_q_50_01]	 <> 	source.[avg_q_50_01]
								OR target.[avg_q_50_02]	 <> 	source.[avg_q_50_02]
								OR target.[avg_q_50_03]	 <> 	source.[avg_q_50_03]
								OR target.[avg_q_50_04]	 <> 	source.[avg_q_50_04]
								OR target.[avg_q_50_05]	 <> 	source.[avg_q_50_05]
								OR target.[avg_q_51_01]	 <> 	source.[avg_q_51_01]
								OR target.[avg_q_51_02]	 <> 	source.[avg_q_51_02]
								OR target.[avg_q_51_03]	 <> 	source.[avg_q_51_03]
								OR target.[avg_q_51_04]	 <> 	source.[avg_q_51_04]
								OR target.[avg_q_51_05]	 <> 	source.[avg_q_51_05]
								OR target.[avg_q_52_01]	 <> 	source.[avg_q_52_01]
								OR target.[avg_q_52_02]	 <> 	source.[avg_q_52_02]
								OR target.[avg_q_52_03]	 <> 	source.[avg_q_52_03]
								OR target.[avg_q_52_04]	 <> 	source.[avg_q_52_04]
								OR target.[avg_q_52_05]	 <> 	source.[avg_q_52_05]
								OR target.[avg_q_53_01]	 <> 	source.[avg_q_53_01]
								OR target.[avg_q_53_02]	 <> 	source.[avg_q_53_02]
								OR target.[avg_q_53_03]	 <> 	source.[avg_q_53_03]
								OR target.[avg_q_53_04]	 <> 	source.[avg_q_53_04]
								OR target.[avg_q_53_05]	 <> 	source.[avg_q_53_05]
								OR target.[avg_q_54_01]	 <> 	source.[avg_q_54_01]
								OR target.[avg_q_54_02]	 <> 	source.[avg_q_54_02]
								OR target.[avg_q_54_03]	 <> 	source.[avg_q_54_03]
								OR target.[avg_q_54_04]	 <> 	source.[avg_q_54_04]
								OR target.[avg_q_54_05]	 <> 	source.[avg_q_54_05]
								OR target.[avg_q_55_01]	 <> 	source.[avg_q_55_01]
								OR target.[avg_q_55_02]	 <> 	source.[avg_q_55_02]
								OR target.[avg_q_55_03]	 <> 	source.[avg_q_55_03]
								OR target.[avg_q_55_04]	 <> 	source.[avg_q_55_04]
								OR target.[avg_q_55_05]	 <> 	source.[avg_q_55_05]
								OR target.[avg_q_56_01]	 <> 	source.[avg_q_56_01]
								OR target.[avg_q_56_02]	 <> 	source.[avg_q_56_02]
								OR target.[avg_q_56_03]	 <> 	source.[avg_q_56_03]
								OR target.[avg_q_56_04]	 <> 	source.[avg_q_56_04]
								OR target.[avg_q_56_05]	 <> 	source.[avg_q_56_05]
								OR target.[avg_q_57_01]	 <> 	source.[avg_q_57_01]
								OR target.[avg_q_57_02]	 <> 	source.[avg_q_57_02]
								OR target.[avg_q_57_03]	 <> 	source.[avg_q_57_03]
								OR target.[avg_q_57_04]	 <> 	source.[avg_q_57_04]
								OR target.[avg_q_57_05]	 <> 	source.[avg_q_57_05]
								OR target.[avg_q_58_01]	 <> 	source.[avg_q_58_01]
								OR target.[avg_q_58_02]	 <> 	source.[avg_q_58_02]
								OR target.[avg_q_58_03]	 <> 	source.[avg_q_58_03]
								OR target.[avg_q_58_04]	 <> 	source.[avg_q_58_04]
								OR target.[avg_q_58_05]	 <> 	source.[avg_q_58_05]
								OR target.[avg_q_59_01]	 <> 	source.[avg_q_59_01]
								OR target.[avg_q_59_02]	 <> 	source.[avg_q_59_02]
								OR target.[avg_q_59_03]	 <> 	source.[avg_q_59_03]
								OR target.[avg_q_59_04]	 <> 	source.[avg_q_59_04]
								OR target.[avg_q_59_05]	 <> 	source.[avg_q_59_05]
								OR target.[avg_q_60_01]	 <> 	source.[avg_q_60_01]
								OR target.[avg_q_60_02]	 <> 	source.[avg_q_60_02]
								OR target.[avg_q_60_03]	 <> 	source.[avg_q_60_03]
								OR target.[avg_q_60_04]	 <> 	source.[avg_q_60_04]
								OR target.[avg_q_60_05]	 <> 	source.[avg_q_60_05]
								OR target.[avg_q_61_01]	 <> 	source.[avg_q_61_01]
								OR target.[avg_q_61_02]	 <> 	source.[avg_q_61_02]
								OR target.[avg_q_61_03]	 <> 	source.[avg_q_61_03]
								OR target.[avg_q_61_04]	 <> 	source.[avg_q_61_04]
								OR target.[avg_q_61_05]	 <> 	source.[avg_q_61_05]
								OR target.[avg_q_62_01]	 <> 	source.[avg_q_62_01]
								OR target.[avg_q_62_02]	 <> 	source.[avg_q_62_02]
								OR target.[avg_q_62_03]	 <> 	source.[avg_q_62_03]
								OR target.[avg_q_62_04]	 <> 	source.[avg_q_62_04]
								OR target.[avg_q_62_05]	 <> 	source.[avg_q_62_05]
								OR target.[avg_q_63_01]	 <> 	source.[avg_q_63_01]
								OR target.[avg_q_63_02]	 <> 	source.[avg_q_63_02]
								OR target.[avg_q_63_03]	 <> 	source.[avg_q_63_03]
								OR target.[avg_q_63_04]	 <> 	source.[avg_q_63_04]
								OR target.[avg_q_63_05]	 <> 	source.[avg_q_63_05]
								OR target.[avg_q_64_01]	 <> 	source.[avg_q_64_01]
								OR target.[avg_q_64_02]	 <> 	source.[avg_q_64_02]
								OR target.[avg_q_64_03]	 <> 	source.[avg_q_64_03]
								OR target.[avg_q_64_04]	 <> 	source.[avg_q_64_04]
								OR target.[avg_q_64_05]	 <> 	source.[avg_q_64_05]
								OR target.[avg_q_64_06]	 <> 	source.[avg_q_64_06]
								OR target.[avg_q_65_01]	 <> 	source.[avg_q_65_01]
								OR target.[avg_q_65_02]	 <> 	source.[avg_q_65_02]
								OR target.[avg_q_65_03]	 <> 	source.[avg_q_65_03]
								OR target.[avg_q_65_04]	 <> 	source.[avg_q_65_04]
								OR target.[avg_q_65_05]	 <> 	source.[avg_q_65_05]
								OR target.[avg_q_65_06]	 <> 	source.[avg_q_65_06]
								OR target.[avg_q_65_07]	 <> 	source.[avg_q_65_07]
								OR target.[avg_q_66_01]	 <> 	source.[avg_q_66_01]
								OR target.[avg_q_66_02]	 <> 	source.[avg_q_66_02]
								OR target.[avg_q_66_03]	 <> 	source.[avg_q_66_03]
								OR target.[avg_q_66_04]	 <> 	source.[avg_q_66_04]
								OR target.[avg_q_66_05]	 <> 	source.[avg_q_66_05]
								OR target.[avg_q_67_01]	 <> 	source.[avg_q_67_01]
								OR target.[avg_q_67_02]	 <> 	source.[avg_q_67_02]
								OR target.[avg_q_67_03]	 <> 	source.[avg_q_67_03]
								OR target.[avg_q_67_04]	 <> 	source.[avg_q_67_04]
								OR target.[avg_q_67_05]	 <> 	source.[avg_q_67_05]
								OR target.[avg_q_68_01]	 <> 	source.[avg_q_68_01]
								OR target.[avg_q_68_02]	 <> 	source.[avg_q_68_02]
								OR target.[avg_q_68_03]	 <> 	source.[avg_q_68_03]
								OR target.[avg_q_68_04]	 <> 	source.[avg_q_68_04]
								OR target.[avg_q_68_05]	 <> 	source.[avg_q_68_05]
								OR target.[avg_q_69_01]	 <> 	source.[avg_q_69_01]
								OR target.[avg_q_69_02]	 <> 	source.[avg_q_69_02]
								OR target.[avg_q_69_03]	 <> 	source.[avg_q_69_03]
								OR target.[avg_q_69_04]	 <> 	source.[avg_q_69_04]
								OR target.[avg_q_69_05]	 <> 	source.[avg_q_69_05]
								OR target.[avg_q_70_01]	 <> 	source.[avg_q_70_01]
								OR target.[avg_q_70_02]	 <> 	source.[avg_q_70_02]
								OR target.[avg_q_70_03]	 <> 	source.[avg_q_70_03]
								OR target.[avg_q_70_04]	 <> 	source.[avg_q_70_04]
								OR target.[avg_q_70_05]	 <> 	source.[avg_q_70_05]
								OR target.[nps]	 <> 	source.[nps]
								OR target.[rpi_com]	 <> 	source.[rpi_com]
								OR target.[rpi_ind]	 <> 	source.[rpi_ind]
								OR target.[achievement_z-score]	 <> 	source.[achievement_z-score]
								OR target.[belonging_z-score]	 <> 	source.[belonging_z-score]
								OR target.[character_z-score]	 <> 	source.[character_z-score]
								OR target.[giving_z-score]	 <> 	source.[giving_z-score]
								OR target.[health_z-score]	 <> 	source.[health_z-score]
								OR target.[inspiration_z-score]	 <> 	source.[inspiration_z-score]
								OR target.[meaning_z-score]	 <> 	source.[meaning_z-score]
								OR target.[relationship_z-score]	 <> 	source.[relationship_z-score]
								OR target.[safety_z-score]	 <> 	source.[safety_z-score]
								OR target.[achievement_percentile]	 <> 	source.[achievement_percentile]
								OR target.[belonging_percentile]	 <> 	source.[belonging_percentile]
								OR target.[character_percentile]	 <> 	source.[character_percentile]
								OR target.[giving_percentile]	 <> 	source.[giving_percentile]
								OR target.[health_percentile]	 <> 	source.[health_percentile]
								OR target.[inspiration_percentile]	 <> 	source.[inspiration_percentile]
								OR target.[meaning_percentile]	 <> 	source.[meaning_percentile]
								OR target.[relationship_percentile]	 <> 	source.[relationship_percentile]
								OR target.[safety_percentile]	 <> 	source.[safety_percentile]
								OR target.[facilities_z-score]	 <> 	source.[facilities_z-score]
								OR target.[service_z-score]	 <> 	source.[service_z-score]
								OR target.[value_z-score]	 <> 	source.[value_z-score]
								OR target.[engagement_z-score]	 <> 	source.[engagement_z-score]
								OR target.[health_and_wellness_z-score]	 <> 	source.[health_and_wellness_z-score]
								OR target.[involvement_z-score]	 <> 	source.[involvement_z-score]
								OR target.[facilities_percentile]	 <> 	source.[facilities_percentile]
								OR target.[service_percentile]	 <> 	source.[service_percentile]
								OR target.[value_percentile]	 <> 	source.[value_percentile]
								OR target.[engagement_percentile]	 <> 	source.[engagement_percentile]
								OR target.[health_and_wellness_percentile]	 <> 	source.[health_and_wellness_percentile]
								OR target.[involvement_percentile]	 <> 	source.[involvement_percentile]
)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
		 AND LEN(source.official_association_number) > 0
		 AND LEN(source.official_branch_number) > 0
		)
		THEN 
			INSERT ([module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					[branch_name],
					[official_branch_number],
					[response_count],
					[avg_m_01a_01],
					[avg_m_01b_01],
					[avg_m_01c_01],
					[avg_m_01d_01],
					--[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					/*
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					*/
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					--[avg_q_02_06],
					--[avg_q_02_07],
					--[avg_q_02_08],
					--[avg_q_02_09],
					--[avg_q_02_10],
					--[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					--[avg_q_03_06],
					--[avg_q_03_07],
					--[avg_q_03_08],
					--[avg_q_03_09],
					--[avg_q_03_10],
					--[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					--[avg_q_04_06],
					--[avg_q_04_07],
					--[avg_q_04_08],
					--[avg_q_04_09],
					--[avg_q_04_10],
					--[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					--[avg_q_05_06],
					--[avg_q_05_07],
					--[avg_q_05_08],
					--[avg_q_05_09],
					--[avg_q_05_10],
					--[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					--[avg_q_06_06],
					--[avg_q_06_07],
					--[avg_q_06_08],
					--[avg_q_06_09],
					--[avg_q_06_10],
					--[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					--[avg_q_07_06],
					--[avg_q_07_07],
					--[avg_q_07_08],
					--[avg_q_07_09],
					--[avg_q_07_10],
					--[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					--[avg_q_08_06],
					--[avg_q_08_07],
					--[avg_q_08_08],
					--[avg_q_08_09],
					--[avg_q_08_10],
					--[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					--[avg_q_09_06],
					--[avg_q_09_07],
					--[avg_q_09_08],
					--[avg_q_09_09],
					--[avg_q_09_10],
					--[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					--[avg_q_10_06],
					--[avg_q_10_07],
					--[avg_q_10_08],
					--[avg_q_10_09],
					--[avg_q_10_10],
					--[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					--[avg_q_11_06],
					--[avg_q_11_07],
					--[avg_q_11_08],
					--[avg_q_11_09],
					--[avg_q_11_10],
					--[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					--[avg_q_12_06],
					--[avg_q_12_07],
					--[avg_q_12_08],
					--[avg_q_12_09],
					--[avg_q_12_10],
					--[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					/*
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					*/
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					/*
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					*/
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					/*
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					*/
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					/*
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					*/
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					/*
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					*/
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					/*
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					*/
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					/*
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					*/
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					/*
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					*/
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					/*
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					*/
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					/*
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					*/
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					/*
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					*/
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					/*
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					*/
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					/*
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					*/
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					/*
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					*/
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					/*
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					*/
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					/*
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					*/
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					/*
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					*/
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					/*
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					*/
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					/*
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					*/
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
					--[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					/*
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					*/
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					/*
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					*/
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
					--[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					/*
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					*/
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					/*
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					*/
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					/*
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					*/
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					/*
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					*/
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					/*
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					*/
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					/*
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					*/
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					/*
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					*/
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
					--[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					/*
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					*/
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					/*
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					*/
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
					--[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					/*
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					*/
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					/*
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					*/
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					/*
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					*/
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					/*
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					*/
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					/*
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					*/
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					/*
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					*/
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					/*
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					*/
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					/*
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					*/
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					/*
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					*/
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					/*
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					*/
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					/*
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					*/
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					/*
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					*/
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					/*
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					*/
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					/*
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					*/
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					/*
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					*/
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					/*
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					*/
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					/*
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					*/
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					/*
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					*/
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					/*
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					*/
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					/*
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					*/
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					/*
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					*/
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					/*
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					*/
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					/*
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					*/
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					/*
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
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
					--[rpi],
					[rpi_com],
					[rpi_ind],
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
					[safety_percentile],
					[facilities_z-score],
					[service_z-score],
					[value_z-score],
					[engagement_z-score],
					[health_and_wellness_z-score],
					[involvement_z-score],
					[facilities_percentile],
					[service_percentile],
					[value_percentile],
					[engagement_percentile],
					[health_and_wellness_percentile],
					[involvement_percentile]
					)
			VALUES ([module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					[branch_name],
					[official_branch_number],
					[response_count],
					[avg_m_01a_01],
					[avg_m_01b_01],
					[avg_m_01c_01],
					[avg_m_01d_01],
					--[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					/*
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					*/
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					--[avg_q_02_06],
					--[avg_q_02_07],
					--[avg_q_02_08],
					--[avg_q_02_09],
					--[avg_q_02_10],
					--[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					--[avg_q_03_06],
					--[avg_q_03_07],
					--[avg_q_03_08],
					--[avg_q_03_09],
					--[avg_q_03_10],
					--[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					--[avg_q_04_06],
					--[avg_q_04_07],
					--[avg_q_04_08],
					--[avg_q_04_09],
					--[avg_q_04_10],
					--[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					--[avg_q_05_06],
					--[avg_q_05_07],
					--[avg_q_05_08],
					--[avg_q_05_09],
					--[avg_q_05_10],
					--[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					--[avg_q_06_06],
					--[avg_q_06_07],
					--[avg_q_06_08],
					--[avg_q_06_09],
					--[avg_q_06_10],
					--[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					--[avg_q_07_06],
					--[avg_q_07_07],
					--[avg_q_07_08],
					--[avg_q_07_09],
					--[avg_q_07_10],
					--[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					--[avg_q_08_06],
					--[avg_q_08_07],
					--[avg_q_08_08],
					--[avg_q_08_09],
					--[avg_q_08_10],
					--[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					--[avg_q_09_06],
					--[avg_q_09_07],
					--[avg_q_09_08],
					--[avg_q_09_09],
					--[avg_q_09_10],
					--[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					--[avg_q_10_06],
					--[avg_q_10_07],
					--[avg_q_10_08],
					--[avg_q_10_09],
					--[avg_q_10_10],
					--[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					--[avg_q_11_06],
					--[avg_q_11_07],
					--[avg_q_11_08],
					--[avg_q_11_09],
					--[avg_q_11_10],
					--[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					--[avg_q_12_06],
					--[avg_q_12_07],
					--[avg_q_12_08],
					--[avg_q_12_09],
					--[avg_q_12_10],
					--[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					/*
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					*/
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					/*
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					*/
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					/*
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					*/
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					/*
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					*/
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					/*
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					*/
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					/*
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					*/
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					/*
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					*/
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					/*
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					*/
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					/*
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					*/
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					/*
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					*/
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					/*
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					*/
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					/*
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					*/
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					/*
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					*/
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					/*
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					*/
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					/*
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					*/
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					/*
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					*/
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					/*
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					*/
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					/*
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					*/
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					/*
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					*/
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
					--[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					/*
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					*/
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					/*
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					*/
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
					--[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					/*
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					*/
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					/*
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					*/
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					/*
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					*/
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					/*
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					*/
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					/*
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					*/
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					/*
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					*/
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					/*
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					*/
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
					--[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					/*
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					*/
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					/*
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					*/
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
					--[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					/*
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					*/
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					/*
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					*/
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					/*
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					*/
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					/*
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					*/
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					/*
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					*/
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					/*
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					*/
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					/*
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					*/
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					/*
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					*/
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					/*
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					*/
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					/*
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					*/
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					/*
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					*/
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					/*
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					*/
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					/*
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					*/
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					/*
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					*/
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					/*
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					*/
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					/*
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					*/
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					/*
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					*/
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					/*
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					*/
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					/*
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					*/
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					/*
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					*/
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					/*
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					*/
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					/*
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					*/
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					/*
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					*/
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					/*
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
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
					--[rpi],
					[rpi_com],
					[rpi_ind],
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
					[safety_percentile],
					[facilities_z-score],
					[service_z-score],
					[value_z-score],
					[engagement_z-score],
					[health_and_wellness_z-score],
					[involvement_z-score],
					[facilities_percentile],
					[service_percentile],
					[value_percentile],
					[engagement_percentile],
					[health_and_wellness_percentile],
					[involvement_percentile]
					)
					
	;
COMMIT TRAN

BEGIN TRAN
MERGE	Seer_ODS.dbo.Aggregated_Data AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					1 current_indicator,
					'Member' module,
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
					CASE WHEN LEN(COALESCE(A.[Response_Count], '')) = 0 THEN 0
						ELSE A.Response_Count
					END  [response_count],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01a_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01a_01] END [avg_m_01a_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01b_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01b_01] END [avg_m_01b_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01c_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01c_01] END [avg_m_01c_01],
					CASE WHEN LEN(COALESCE(A.[Avg_M_01d_01], '')) = 0 THEN '0' ELSE A.[Avg_M_01d_01] END [avg_m_01d_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_01] END [avg_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_02] END [avg_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_03] END [avg_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_04] END [avg_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_01_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_01_05] END [avg_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_01] END [avg_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_02] END [avg_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_03] END [avg_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_04] END [avg_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_02_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_02_05] END [avg_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_01] END [avg_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_02] END [avg_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_03] END [avg_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_04] END [avg_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_03_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_03_05] END [avg_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_01] END [avg_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_02] END [avg_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_03] END [avg_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_04] END [avg_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_04_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_04_05] END [avg_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_01] END [avg_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_02] END [avg_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_03] END [avg_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_04] END [avg_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_05_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_05_05] END [avg_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_01] END [avg_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_02] END [avg_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_03] END [avg_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_04] END [avg_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_06_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_06_05] END [avg_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_01] END [avg_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_02] END [avg_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_03] END [avg_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_04] END [avg_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_07_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_07_05] END [avg_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_01] END [avg_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_02] END [avg_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_03] END [avg_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_04] END [avg_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_08_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_08_05] END [avg_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_01] END [avg_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_02] END [avg_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_03] END [avg_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_04] END [avg_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_09_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_09_05] END [avg_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_01] END [avg_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_02] END [avg_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_03] END [avg_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_04] END [avg_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_10_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_10_05] END [avg_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_01] END [avg_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_02] END [avg_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_03] END [avg_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_04] END [avg_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_11_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_11_05] END [avg_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_01] END [avg_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_02] END [avg_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_03] END [avg_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_04] END [avg_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_12_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_12_05] END [avg_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_01] END [avg_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_02] END [avg_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_03] END [avg_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_04] END [avg_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_13_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_13_05] END [avg_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_01] END [avg_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_02] END [avg_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_03] END [avg_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_04] END [avg_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_14_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_14_05] END [avg_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_01] END [avg_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_02] END [avg_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_03] END [avg_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_04] END [avg_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_15_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_15_05] END [avg_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_01] END [avg_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_02] END [avg_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_03] END [avg_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_04] END [avg_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_16_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_16_05] END [avg_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_01] END [avg_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_02] END [avg_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_03] END [avg_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_04] END [avg_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_17_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_17_05] END [avg_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_01] END [avg_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_02] END [avg_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_03] END [avg_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_04] END [avg_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_18_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_18_05] END [avg_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_01] END [avg_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_02] END [avg_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_03] END [avg_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_04] END [avg_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_19_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_19_05] END [avg_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_01] END [avg_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_02] END [avg_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_03] END [avg_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_04] END [avg_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_20_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_20_05] END [avg_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_01] END [avg_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_02] END [avg_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_03] END [avg_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_04] END [avg_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_21_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_21_05] END [avg_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_01] END [avg_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_02] END [avg_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_03] END [avg_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_04] END [avg_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_22_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_22_05] END [avg_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_01] END [avg_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_02] END [avg_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_03] END [avg_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_04] END [avg_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_23_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_23_05] END [avg_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_01] END [avg_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_02] END [avg_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_03] END [avg_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_04] END [avg_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_24_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_24_05] END [avg_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_01] END [avg_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_02] END [avg_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_03] END [avg_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_04] END [avg_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_25_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_25_05] END [avg_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_01] END [avg_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_02] END [avg_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_03] END [avg_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_04] END [avg_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_26_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_26_05] END [avg_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_01] END [avg_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_02] END [avg_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_03] END [avg_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_04] END [avg_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_27_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_27_05] END [avg_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_01] END [avg_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_02] END [avg_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_03] END [avg_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_04] END [avg_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_28_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_28_05] END [avg_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_01] END [avg_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_02] END [avg_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_03] END [avg_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_04] END [avg_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_29_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_29_05] END [avg_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_01] END [avg_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_02] END [avg_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_03] END [avg_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_04] END [avg_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_30_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_30_05] END [avg_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_01] END [avg_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_02] END [avg_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_03] END [avg_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_04] END [avg_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_31_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_31_05] END [avg_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_00] END [avg_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_01] END [avg_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_10] END [avg_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_02] END [avg_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_03] END [avg_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_04] END [avg_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_05] END [avg_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_06] END [avg_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_07] END [avg_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_08] END [avg_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_32_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_32_09] END [avg_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_01] END [avg_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_02] END [avg_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_03] END [avg_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_04] END [avg_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_33_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_33_05] END [avg_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_01] END [avg_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_02] END [avg_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_03] END [avg_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_04] END [avg_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_34_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_34_05] END [avg_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_00] END [avg_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_01] END [avg_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_10] END [avg_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_02] END [avg_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_03] END [avg_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_04] END [avg_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_05] END [avg_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_06] END [avg_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_07] END [avg_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_08] END [avg_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_35_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_35_09] END [avg_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_01] END [avg_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_02] END [avg_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_03] END [avg_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_04] END [avg_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_36_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_36_05] END [avg_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_01] END [avg_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_02] END [avg_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_03] END [avg_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_04] END [avg_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_37_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_37_05] END [avg_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_01] END [avg_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_02] END [avg_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_03] END [avg_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_04] END [avg_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_38_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_38_05] END [avg_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_01] END [avg_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_02] END [avg_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_03] END [avg_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_04] END [avg_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_39_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_39_05] END [avg_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_01] END [avg_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_02] END [avg_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_03] END [avg_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_04] END [avg_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_40_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_40_05] END [avg_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_01] END [avg_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_02] END [avg_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_03] END [avg_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_04] END [avg_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_41_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_41_05] END [avg_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_01] END [avg_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_02] END [avg_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_03] END [avg_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_04] END [avg_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_42_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_42_05] END [avg_q_42_05],
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
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_01] END [avg_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_02] END [avg_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_03] END [avg_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_04] END [avg_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_44_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_44_05] END [avg_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_01] END [avg_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_02] END [avg_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_03] END [avg_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_04] END [avg_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_45_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_45_05] END [avg_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_00], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_00] END [avg_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_01] END [avg_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_10], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_10] END [avg_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_02] END [avg_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_03] END [avg_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_04] END [avg_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_05] END [avg_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_06] END [avg_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_07] END [avg_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_08], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_08] END [avg_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_46_09], '')) = 0 THEN '0' ELSE A.[Avg_Q_46_09] END [avg_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_01] END [avg_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_02] END [avg_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_03] END [avg_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_04] END [avg_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_47_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_47_05] END [avg_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_01] END [avg_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_02] END [avg_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_03] END [avg_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_04] END [avg_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_48_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_48_05] END [avg_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_01] END [avg_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_02] END [avg_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_03] END [avg_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_04] END [avg_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_49_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_49_05] END [avg_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_01] END [avg_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_02] END [avg_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_03] END [avg_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_04] END [avg_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_50_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_50_05] END [avg_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_01] END [avg_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_02] END [avg_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_03] END [avg_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_04] END [avg_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_51_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_51_05] END [avg_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_01] END [avg_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_02] END [avg_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_03] END [avg_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_04] END [avg_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_52_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_52_05] END [avg_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_01] END [avg_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_02] END [avg_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_03] END [avg_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_04] END [avg_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_53_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_53_05] END [avg_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_01] END [avg_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_02] END [avg_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_03] END [avg_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_04] END [avg_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_54_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_54_05] END [avg_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_01] END [avg_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_02] END [avg_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_03] END [avg_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_04] END [avg_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_55_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_55_05] END [avg_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_01] END [avg_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_02] END [avg_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_03] END [avg_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_04] END [avg_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_56_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_56_05] END [avg_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_01] END [avg_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_02] END [avg_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_03] END [avg_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_04] END [avg_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_57_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_57_05] END [avg_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_01] END [avg_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_02] END [avg_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_03] END [avg_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_04] END [avg_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_58_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_58_05] END [avg_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_01] END [avg_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_02] END [avg_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_03] END [avg_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_04] END [avg_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_59_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_59_05] END [avg_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_01] END [avg_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_02] END [avg_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_03] END [avg_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_04] END [avg_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_60_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_60_05] END [avg_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_01] END [avg_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_02] END [avg_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_03] END [avg_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_04] END [avg_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_61_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_61_05] END [avg_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_01] END [avg_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_02] END [avg_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_03] END [avg_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_04] END [avg_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_62_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_62_05] END [avg_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_01] END [avg_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_02] END [avg_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_03] END [avg_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_04] END [avg_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_63_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_63_05] END [avg_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_01] END [avg_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_02] END [avg_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_03] END [avg_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_04] END [avg_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_05] END [avg_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_64_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_64_06] END [avg_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_01] END [avg_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_02] END [avg_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_03] END [avg_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_04] END [avg_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_05] END [avg_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_06], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_06] END [avg_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_65_07], '')) = 0 THEN '0' ELSE A.[Avg_Q_65_07] END [avg_q_65_07],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_01] END [avg_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_02] END [avg_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_03] END [avg_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_04] END [avg_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_66_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_66_05] END [avg_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_01] END [avg_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_02] END [avg_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_03] END [avg_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_04] END [avg_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_67_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_67_05] END [avg_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_01] END [avg_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_02] END [avg_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_03] END [avg_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_04] END [avg_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_68_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_68_05] END [avg_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_01] END [avg_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_02] END [avg_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_03] END [avg_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_04] END [avg_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_69_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_69_05] END [avg_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_01], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_01] END [avg_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_02], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_02] END [avg_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_03], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_03] END [avg_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_04], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_04] END [avg_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Avg_Q_70_05], '')) = 0 THEN '0' ELSE A.[Avg_Q_70_05] END [avg_q_70_05],
					CASE WHEN LEN(COALESCE(A.[NPS], '')) = 0 THEN '0' ELSE A.[NPS] END [nps],
					CASE WHEN LEN(COALESCE(A.[RPI_COM], '')) = 0 THEN '0' ELSE A.[RPI_COM] END [rpi_com],
					CASE WHEN LEN(COALESCE(A.[RPI_IND], '')) = 0 THEN '0' ELSE A.[RPI_IND] END [rpi_ind],
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
					CASE WHEN LEN(COALESCE(A.[Safety Percentile], '')) = 0 THEN '0' ELSE A.[Safety Percentile] END [safety_percentile],
					CASE WHEN LEN(COALESCE(A.[Facilities Z-Score], '')) = 0 THEN '0' ELSE A.[Facilities Z-Score] END [facilities_z-score],
					CASE WHEN LEN(COALESCE(A.[Service Z-Score], '')) = 0 THEN '0' ELSE A.[Service Z-Score] END [service_z-score],
					CASE WHEN LEN(COALESCE(A.[Value Z-Score], '')) = 0 THEN '0' ELSE A.[Value Z-Score] END [value_z-score],
					CASE WHEN LEN(COALESCE(A.[Engagement Z-Score], '')) = 0 THEN '0' ELSE A.[Engagement Z-Score] END [engagement_z-score],
					CASE WHEN LEN(COALESCE(A.[Health and Wellness Z-Score], '')) = 0 THEN '0' ELSE A.[Health and Wellness Z-Score] END [health_and_wellness_z-score],
					CASE WHEN LEN(COALESCE(A.[Involvement Z-Score], '')) = 0 THEN '0' ELSE A.[Involvement Z-Score] END [involvement_z-score],
					CASE WHEN LEN(COALESCE(A.[Facilities Percentile], '')) = 0 THEN '0' ELSE A.[Facilities Percentile] END [facilities_percentile],
					CASE WHEN LEN(COALESCE(A.[Service Percentile], '')) = 0 THEN '0' ELSE A.[Service Percentile] END [service_percentile],
					CASE WHEN LEN(COALESCE(A.[Value Percentile], '')) = 0 THEN '0' ELSE A.[Value Percentile] END [value_percentile],
					CASE WHEN LEN(COALESCE(A.[Engagement Percentile], '')) = 0 THEN '0' ELSE A.[Engagement Percentile] END [engagement_percentile],
					CASE WHEN LEN(COALESCE(A.[Health and Wellness Percentile], '')) = 0 THEN '0' ELSE A.[Health and Wellness Percentile] END [health_and_wellness_percentile],
					CASE WHEN LEN(COALESCE(A.[Involvement Percentile], '')) = 0 THEN '0' ELSE A.[Involvement Percentile] END [involvement_percentile]


			FROM	Seer_STG.dbo.[Member Aggregated Data] A
						
			WHERE	((ISNUMERIC(A.[response_count]) = 1) OR (LEN(COALESCE(A.[response_count], '')) = 0))
					AND ((ISNUMERIC(A.[avg_m_01a_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_m_01a_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_m_01a_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_m_01b_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_m_01b_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_m_01b_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_m_01c_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_m_01c_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_m_01c_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_m_01d_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_m_01d_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_m_01d_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_01_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_01_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_01_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_01_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_01_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_01_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_01_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_01_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_01_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_01_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_02_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_02_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_02_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_02_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_02_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_02_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_02_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_02_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_02_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_02_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_03_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_03_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_03_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_03_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_03_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_03_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_03_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_03_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_03_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_03_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_04_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_04_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_04_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_04_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_04_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_04_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_04_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_04_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_04_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_04_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_05_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_05_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_05_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_05_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_05_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_05_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_05_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_05_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_05_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_05_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_06_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_06_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_06_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_06_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_06_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_06_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_06_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_06_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_06_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_06_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_07_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_07_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_07_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_07_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_07_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_07_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_07_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_07_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_07_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_07_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_08_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_08_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_08_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_08_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_08_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_08_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_08_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_08_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_08_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_08_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_09_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_09_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_09_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_09_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_09_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_09_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_09_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_09_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_09_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_09_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_10_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_10_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_10_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_10_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_10_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_10_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_10_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_10_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_10_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_10_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_11_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_11_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_11_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_11_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_11_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_11_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_11_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_11_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_11_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_11_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_12_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_12_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_12_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_12_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_12_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_12_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_12_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_12_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_12_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_12_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_13_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_13_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_13_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_13_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_13_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_13_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_13_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_13_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_13_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_13_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_14_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_14_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_14_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_14_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_14_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_14_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_14_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_14_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_14_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_14_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_15_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_15_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_15_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_15_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_15_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_15_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_15_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_15_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_15_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_15_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_16_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_16_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_16_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_16_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_16_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_16_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_16_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_16_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_16_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_16_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_17_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_17_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_17_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_17_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_17_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_17_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_17_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_17_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_17_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_17_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_18_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_18_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_18_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_18_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_18_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_18_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_18_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_18_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_18_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_18_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_19_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_19_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_19_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_19_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_19_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_19_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_19_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_19_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_19_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_19_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_20_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_20_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_20_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_20_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_20_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_20_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_20_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_20_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_20_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_20_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_21_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_21_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_21_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_21_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_21_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_21_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_21_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_21_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_21_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_21_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_22_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_22_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_22_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_22_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_22_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_22_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_22_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_22_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_22_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_22_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_23_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_23_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_23_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_23_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_23_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_23_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_23_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_23_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_23_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_23_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_24_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_24_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_24_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_24_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_24_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_24_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_24_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_24_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_24_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_24_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_25_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_25_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_25_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_25_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_25_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_25_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_25_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_25_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_25_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_25_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_26_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_26_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_26_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_26_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_26_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_26_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_26_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_26_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_26_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_26_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_27_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_27_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_27_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_27_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_27_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_27_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_27_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_27_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_27_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_27_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_28_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_28_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_28_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_28_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_28_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_28_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_28_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_28_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_28_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_28_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_29_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_29_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_29_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_29_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_29_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_29_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_29_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_29_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_29_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_29_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_30_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_30_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_30_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_30_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_30_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_30_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_30_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_30_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_30_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_30_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_31_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_31_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_31_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_31_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_31_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_31_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_31_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_31_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_31_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_31_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_00], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_10], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_07], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_08], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_32_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_32_09], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_33_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_33_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_33_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_33_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_33_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_33_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_33_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_33_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_33_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_33_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_34_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_34_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_34_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_34_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_34_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_34_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_34_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_34_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_34_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_34_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_00], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_10], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_07], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_08], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_35_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_35_09], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_36_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_36_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_36_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_36_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_36_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_36_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_36_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_36_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_36_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_36_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_37_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_37_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_37_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_37_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_37_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_37_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_37_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_37_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_37_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_37_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_38_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_38_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_38_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_38_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_38_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_38_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_38_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_38_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_38_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_38_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_39_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_39_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_39_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_39_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_39_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_39_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_39_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_39_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_39_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_39_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_40_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_40_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_40_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_40_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_40_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_40_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_40_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_40_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_40_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_40_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_41_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_41_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_41_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_41_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_41_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_41_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_41_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_41_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_41_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_41_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_42_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_42_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_42_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_42_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_42_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_42_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_42_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_42_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_42_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_42_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_00], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_07], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_08], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_09], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_43_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_43_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_43_10], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_44_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_44_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_44_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_44_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_44_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_44_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_44_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_44_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_44_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_44_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_45_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_45_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_45_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_45_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_45_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_45_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_45_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_45_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_45_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_45_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_00]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_00], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_10]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_10], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_07], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_08]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_08], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_46_09]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_46_09], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_47_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_47_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_47_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_47_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_47_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_47_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_47_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_47_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_47_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_47_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_48_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_48_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_48_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_48_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_48_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_48_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_48_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_48_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_48_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_48_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_49_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_49_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_49_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_49_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_49_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_49_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_49_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_49_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_49_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_49_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_50_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_50_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_50_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_50_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_50_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_50_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_50_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_50_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_50_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_50_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_51_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_51_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_51_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_51_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_51_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_51_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_51_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_51_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_51_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_51_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_52_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_52_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_52_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_52_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_52_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_52_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_52_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_52_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_52_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_52_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_53_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_53_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_53_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_53_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_53_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_53_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_53_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_53_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_53_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_53_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_54_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_54_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_54_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_54_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_54_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_54_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_54_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_54_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_54_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_54_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_55_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_55_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_55_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_55_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_55_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_55_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_55_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_55_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_55_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_55_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_56_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_56_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_56_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_56_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_56_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_56_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_56_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_56_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_56_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_56_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_57_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_57_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_57_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_57_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_57_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_57_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_57_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_57_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_57_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_57_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_58_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_58_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_58_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_58_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_58_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_58_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_58_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_58_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_58_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_58_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_59_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_59_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_59_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_59_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_59_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_59_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_59_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_59_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_59_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_59_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_60_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_60_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_60_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_60_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_60_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_60_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_60_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_60_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_60_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_60_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_61_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_61_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_61_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_61_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_61_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_61_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_61_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_61_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_61_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_61_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_62_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_62_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_62_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_62_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_62_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_62_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_62_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_62_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_62_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_62_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_63_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_63_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_63_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_63_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_63_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_63_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_63_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_63_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_63_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_63_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_64_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_64_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_06]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_06], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_65_07]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_65_07]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_65_07], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_66_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_66_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_66_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_66_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_66_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_66_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_66_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_66_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_66_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_66_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_67_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_67_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_67_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_67_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_67_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_67_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_67_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_67_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_67_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_67_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_68_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_68_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_68_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_68_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_68_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_68_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_68_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_68_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_68_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_68_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_69_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_69_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_69_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_69_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_69_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_69_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_69_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_69_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_69_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_69_05], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_70_01]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_70_01], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_70_02]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_70_02], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_70_03]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_70_03], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_70_04]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_70_04], '')) = 0))
					AND ((ISNUMERIC(A.[avg_q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), A.[avg_q_70_05]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE(A.[avg_q_70_05], '')) = 0))
					AND ((ISNUMERIC(A.[nps]) = 1 AND CONVERT(DECIMAL(20, 6), A.[nps]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[nps], '')) = 0))
					AND ((ISNUMERIC(A.[rpi_com]) = 1 AND CONVERT(DECIMAL(20, 6), A.[rpi_com]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[rpi_com], '')) = 0))
					AND ((ISNUMERIC(A.[rpi_ind]) = 1 AND CONVERT(DECIMAL(20, 6), A.[rpi_ind]) BETWEEN -1.000000 AND 1.000000) OR (LEN(COALESCE(A.[rpi_ind], '')) = 0))
					AND ((ISNUMERIC(A.[achievement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([achievement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[belonging z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([belonging z-score], '')) = 0))
					AND ((ISNUMERIC(A.[character z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([character z-score], '')) = 0))
					AND ((ISNUMERIC(A.[giving z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([giving z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([health z-score], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([inspiration z-score], '')) = 0))
					AND ((ISNUMERIC(A.[meaning z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([meaning z-score], '')) = 0))
					AND ((ISNUMERIC(A.[relationship z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([relationship z-score], '')) = 0))
					AND ((ISNUMERIC(A.[safety z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([safety z-score], '')) = 0))
					AND ((ISNUMERIC(A.[achievement percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([achievement percentile], '')) = 0))
					AND ((ISNUMERIC(A.[belonging percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([belonging percentile], '')) = 0))
					AND ((ISNUMERIC(A.[character percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([character percentile], '')) = 0))
					AND ((ISNUMERIC(A.[giving percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([giving percentile], '')) = 0))
					AND ((ISNUMERIC(A.[health percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health percentile], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([inspiration percentile], '')) = 0))
					AND ((ISNUMERIC(A.[meaning percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([meaning percentile], '')) = 0))
					AND ((ISNUMERIC(A.[relationship percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([relationship percentile], '')) = 0))
					AND ((ISNUMERIC(A.[safety percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([safety percentile], '')) = 0))
					AND ((ISNUMERIC(A.[facilities z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[facilities z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([facilities z-score], '')) = 0))
					AND ((ISNUMERIC(A.[service z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[service z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([service z-score], '')) = 0))
					AND ((ISNUMERIC(A.[value z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[value z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([value z-score], '')) = 0))
					AND ((ISNUMERIC(A.[engagement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[engagement z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([engagement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health and wellness z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health and wellness z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([health and wellness z-score], '')) = 0))
					AND ((ISNUMERIC(A.[involvement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[involvement z-score]) BETWEEN -10.00000 AND 10.00000) OR (LEN(COALESCE([involvement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[facilities percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[facilities percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([facilities percentile], '')) = 0))
					AND ((ISNUMERIC(A.[service percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[service percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([service percentile], '')) = 0))
					AND ((ISNUMERIC(A.[value percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[value percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([value percentile], '')) = 0))
					AND ((ISNUMERIC(A.[engagement percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[engagement percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([engagement percentile], '')) = 0))
					AND ((ISNUMERIC(A.[health and wellness percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health and wellness percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health and wellness percentile], '')) = 0))
					AND ((ISNUMERIC(A.[involvement percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[involvement percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([involvement percentile], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_M_01b_01]) = 1 AND A.[Sum_M_01b_01] > 0) OR (LEN(COALESCE(A.[Sum_M_01b_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_M_01c_01]) = 1 AND A.[Sum_M_01c_01] > 0) OR (LEN(COALESCE(A.[Sum_M_01c_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_M_01d_01]) = 1 AND A.[Sum_M_01d_01] > 0) OR (LEN(COALESCE(A.[Sum_M_01d_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_01_01]) = 1 AND A.[Sum_Q_01_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_01_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_01_02]) = 1 AND A.[Sum_Q_01_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_01_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_01_03]) = 1 AND A.[Sum_Q_01_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_01_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_01_04]) = 1 AND A.[Sum_Q_01_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_01_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_01_05]) = 1 AND A.[Sum_Q_01_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_01_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_02_01]) = 1 AND A.[Sum_Q_02_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_02_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_02_02]) = 1 AND A.[Sum_Q_02_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_02_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_02_03]) = 1 AND A.[Sum_Q_02_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_02_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_02_04]) = 1 AND A.[Sum_Q_02_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_02_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_02_05]) = 1 AND A.[Sum_Q_02_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_02_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_03_01]) = 1 AND A.[Sum_Q_03_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_03_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_03_02]) = 1 AND A.[Sum_Q_03_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_03_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_03_03]) = 1 AND A.[Sum_Q_03_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_03_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_03_04]) = 1 AND A.[Sum_Q_03_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_03_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_03_05]) = 1 AND A.[Sum_Q_03_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_03_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_04_01]) = 1 AND A.[Sum_Q_04_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_04_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_04_02]) = 1 AND A.[Sum_Q_04_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_04_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_04_03]) = 1 AND A.[Sum_Q_04_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_04_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_04_04]) = 1 AND A.[Sum_Q_04_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_04_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_04_05]) = 1 AND A.[Sum_Q_04_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_04_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_05_01]) = 1 AND A.[Sum_Q_05_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_05_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_05_02]) = 1 AND A.[Sum_Q_05_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_05_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_05_03]) = 1 AND A.[Sum_Q_05_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_05_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_05_04]) = 1 AND A.[Sum_Q_05_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_05_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_05_05]) = 1 AND A.[Sum_Q_05_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_05_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_06_01]) = 1 AND A.[Sum_Q_06_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_06_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_06_02]) = 1 AND A.[Sum_Q_06_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_06_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_06_03]) = 1 AND A.[Sum_Q_06_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_06_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_06_04]) = 1 AND A.[Sum_Q_06_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_06_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_06_05]) = 1 AND A.[Sum_Q_06_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_06_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_07_01]) = 1 AND A.[Sum_Q_07_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_07_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_07_02]) = 1 AND A.[Sum_Q_07_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_07_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_07_03]) = 1 AND A.[Sum_Q_07_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_07_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_07_04]) = 1 AND A.[Sum_Q_07_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_07_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_07_05]) = 1 AND A.[Sum_Q_07_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_07_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_08_01]) = 1 AND A.[Sum_Q_08_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_08_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_08_02]) = 1 AND A.[Sum_Q_08_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_08_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_08_03]) = 1 AND A.[Sum_Q_08_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_08_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_08_04]) = 1 AND A.[Sum_Q_08_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_08_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_08_05]) = 1 AND A.[Sum_Q_08_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_08_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_09_01]) = 1 AND A.[Sum_Q_09_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_09_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_09_02]) = 1 AND A.[Sum_Q_09_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_09_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_09_03]) = 1 AND A.[Sum_Q_09_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_09_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_09_04]) = 1 AND A.[Sum_Q_09_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_09_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_09_05]) = 1 AND A.[Sum_Q_09_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_09_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_10_01]) = 1 AND A.[Sum_Q_10_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_10_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_10_02]) = 1 AND A.[Sum_Q_10_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_10_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_10_03]) = 1 AND A.[Sum_Q_10_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_10_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_10_04]) = 1 AND A.[Sum_Q_10_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_10_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_10_05]) = 1 AND A.[Sum_Q_10_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_10_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_11_01]) = 1 AND A.[Sum_Q_11_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_11_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_11_02]) = 1 AND A.[Sum_Q_11_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_11_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_11_03]) = 1 AND A.[Sum_Q_11_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_11_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_11_04]) = 1 AND A.[Sum_Q_11_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_11_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_11_05]) = 1 AND A.[Sum_Q_11_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_11_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_12_01]) = 1 AND A.[Sum_Q_12_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_12_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_12_02]) = 1 AND A.[Sum_Q_12_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_12_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_12_03]) = 1 AND A.[Sum_Q_12_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_12_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_12_04]) = 1 AND A.[Sum_Q_12_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_12_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_12_05]) = 1 AND A.[Sum_Q_12_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_12_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_13_01]) = 1 AND A.[Sum_Q_13_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_13_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_13_02]) = 1 AND A.[Sum_Q_13_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_13_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_13_03]) = 1 AND A.[Sum_Q_13_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_13_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_13_04]) = 1 AND A.[Sum_Q_13_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_13_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_13_05]) = 1 AND A.[Sum_Q_13_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_13_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_14_01]) = 1 AND A.[Sum_Q_14_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_14_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_14_02]) = 1 AND A.[Sum_Q_14_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_14_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_14_03]) = 1 AND A.[Sum_Q_14_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_14_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_14_04]) = 1 AND A.[Sum_Q_14_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_14_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_14_05]) = 1 AND A.[Sum_Q_14_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_14_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_15_01]) = 1 AND A.[Sum_Q_15_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_15_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_15_02]) = 1 AND A.[Sum_Q_15_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_15_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_15_03]) = 1 AND A.[Sum_Q_15_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_15_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_15_04]) = 1 AND A.[Sum_Q_15_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_15_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_15_05]) = 1 AND A.[Sum_Q_15_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_15_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_16_01]) = 1 AND A.[Sum_Q_16_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_16_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_16_02]) = 1 AND A.[Sum_Q_16_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_16_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_16_03]) = 1 AND A.[Sum_Q_16_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_16_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_16_04]) = 1 AND A.[Sum_Q_16_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_16_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_16_05]) = 1 AND A.[Sum_Q_16_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_16_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_17_01]) = 1 AND A.[Sum_Q_17_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_17_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_17_02]) = 1 AND A.[Sum_Q_17_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_17_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_17_03]) = 1 AND A.[Sum_Q_17_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_17_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_17_04]) = 1 AND A.[Sum_Q_17_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_17_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_17_05]) = 1 AND A.[Sum_Q_17_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_17_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_18_01]) = 1 AND A.[Sum_Q_18_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_18_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_18_02]) = 1 AND A.[Sum_Q_18_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_18_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_18_03]) = 1 AND A.[Sum_Q_18_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_18_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_18_04]) = 1 AND A.[Sum_Q_18_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_18_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_18_05]) = 1 AND A.[Sum_Q_18_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_18_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_19_01]) = 1 AND A.[Sum_Q_19_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_19_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_19_02]) = 1 AND A.[Sum_Q_19_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_19_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_19_03]) = 1 AND A.[Sum_Q_19_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_19_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_19_04]) = 1 AND A.[Sum_Q_19_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_19_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_19_05]) = 1 AND A.[Sum_Q_19_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_19_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_20_01]) = 1 AND A.[Sum_Q_20_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_20_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_20_02]) = 1 AND A.[Sum_Q_20_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_20_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_20_03]) = 1 AND A.[Sum_Q_20_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_20_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_20_04]) = 1 AND A.[Sum_Q_20_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_20_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_20_05]) = 1 AND A.[Sum_Q_20_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_20_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_21_01]) = 1 AND A.[Sum_Q_21_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_21_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_21_02]) = 1 AND A.[Sum_Q_21_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_21_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_21_03]) = 1 AND A.[Sum_Q_21_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_21_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_21_04]) = 1 AND A.[Sum_Q_21_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_21_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_21_05]) = 1 AND A.[Sum_Q_21_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_21_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_22_01]) = 1 AND A.[Sum_Q_22_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_22_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_22_02]) = 1 AND A.[Sum_Q_22_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_22_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_22_03]) = 1 AND A.[Sum_Q_22_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_22_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_22_04]) = 1 AND A.[Sum_Q_22_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_22_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_22_05]) = 1 AND A.[Sum_Q_22_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_22_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_23_01]) = 1 AND A.[Sum_Q_23_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_23_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_23_02]) = 1 AND A.[Sum_Q_23_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_23_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_23_03]) = 1 AND A.[Sum_Q_23_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_23_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_23_04]) = 1 AND A.[Sum_Q_23_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_23_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_23_05]) = 1 AND A.[Sum_Q_23_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_23_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_24_01]) = 1 AND A.[Sum_Q_24_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_24_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_24_02]) = 1 AND A.[Sum_Q_24_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_24_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_24_03]) = 1 AND A.[Sum_Q_24_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_24_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_24_04]) = 1 AND A.[Sum_Q_24_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_24_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_24_05]) = 1 AND A.[Sum_Q_24_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_24_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_25_01]) = 1 AND A.[Sum_Q_25_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_25_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_25_02]) = 1 AND A.[Sum_Q_25_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_25_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_25_03]) = 1 AND A.[Sum_Q_25_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_25_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_25_04]) = 1 AND A.[Sum_Q_25_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_25_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_25_05]) = 1 AND A.[Sum_Q_25_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_25_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_26_01]) = 1 AND A.[Sum_Q_26_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_26_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_26_02]) = 1 AND A.[Sum_Q_26_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_26_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_26_03]) = 1 AND A.[Sum_Q_26_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_26_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_26_04]) = 1 AND A.[Sum_Q_26_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_26_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_26_05]) = 1 AND A.[Sum_Q_26_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_26_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_27_01]) = 1 AND A.[Sum_Q_27_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_27_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_27_02]) = 1 AND A.[Sum_Q_27_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_27_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_27_03]) = 1 AND A.[Sum_Q_27_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_27_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_27_04]) = 1 AND A.[Sum_Q_27_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_27_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_27_05]) = 1 AND A.[Sum_Q_27_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_27_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_28_01]) = 1 AND A.[Sum_Q_28_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_28_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_28_02]) = 1 AND A.[Sum_Q_28_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_28_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_28_03]) = 1 AND A.[Sum_Q_28_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_28_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_28_04]) = 1 AND A.[Sum_Q_28_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_28_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_28_05]) = 1 AND A.[Sum_Q_28_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_28_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_29_01]) = 1 AND A.[Sum_Q_29_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_29_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_29_02]) = 1 AND A.[Sum_Q_29_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_29_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_29_03]) = 1 AND A.[Sum_Q_29_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_29_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_29_04]) = 1 AND A.[Sum_Q_29_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_29_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_29_05]) = 1 AND A.[Sum_Q_29_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_29_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_30_01]) = 1 AND A.[Sum_Q_30_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_30_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_30_02]) = 1 AND A.[Sum_Q_30_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_30_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_30_03]) = 1 AND A.[Sum_Q_30_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_30_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_30_04]) = 1 AND A.[Sum_Q_30_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_30_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_30_05]) = 1 AND A.[Sum_Q_30_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_30_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_31_01]) = 1 AND A.[Sum_Q_31_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_31_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_31_02]) = 1 AND A.[Sum_Q_31_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_31_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_31_03]) = 1 AND A.[Sum_Q_31_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_31_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_31_04]) = 1 AND A.[Sum_Q_31_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_31_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_31_05]) = 1 AND A.[Sum_Q_31_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_31_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_00]) = 1 AND A.[Sum_Q_32_00] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_00], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_01]) = 1 AND A.[Sum_Q_32_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_10]) = 1 AND A.[Sum_Q_32_10] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_10], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_02]) = 1 AND A.[Sum_Q_32_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_03]) = 1 AND A.[Sum_Q_32_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_04]) = 1 AND A.[Sum_Q_32_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_05]) = 1 AND A.[Sum_Q_32_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_06]) = 1 AND A.[Sum_Q_32_06] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_06], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_07]) = 1 AND A.[Sum_Q_32_07] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_07], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_08]) = 1 AND A.[Sum_Q_32_08] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_08], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_32_09]) = 1 AND A.[Sum_Q_32_09] > 0) OR (LEN(COALESCE(A.[Sum_Q_32_09], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_33_01]) = 1 AND A.[Sum_Q_33_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_33_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_33_02]) = 1 AND A.[Sum_Q_33_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_33_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_33_03]) = 1 AND A.[Sum_Q_33_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_33_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_33_04]) = 1 AND A.[Sum_Q_33_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_33_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_33_05]) = 1 AND A.[Sum_Q_33_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_33_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_34_01]) = 1 AND A.[Sum_Q_34_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_34_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_34_02]) = 1 AND A.[Sum_Q_34_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_34_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_34_03]) = 1 AND A.[Sum_Q_34_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_34_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_34_04]) = 1 AND A.[Sum_Q_34_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_34_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_34_05]) = 1 AND A.[Sum_Q_34_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_34_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_00]) = 1 AND A.[Sum_Q_35_00] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_00], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_01]) = 1 AND A.[Sum_Q_35_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_10]) = 1 AND A.[Sum_Q_35_10] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_10], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_02]) = 1 AND A.[Sum_Q_35_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_03]) = 1 AND A.[Sum_Q_35_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_04]) = 1 AND A.[Sum_Q_35_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_05]) = 1 AND A.[Sum_Q_35_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_06]) = 1 AND A.[Sum_Q_35_06] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_06], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_07]) = 1 AND A.[Sum_Q_35_07] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_07], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_08]) = 1 AND A.[Sum_Q_35_08] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_08], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_35_09]) = 1 AND A.[Sum_Q_35_09] > 0) OR (LEN(COALESCE(A.[Sum_Q_35_09], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_36_01]) = 1 AND A.[Sum_Q_36_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_36_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_36_02]) = 1 AND A.[Sum_Q_36_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_36_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_36_03]) = 1 AND A.[Sum_Q_36_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_36_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_36_04]) = 1 AND A.[Sum_Q_36_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_36_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_36_05]) = 1 AND A.[Sum_Q_36_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_36_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_37_01]) = 1 AND A.[Sum_Q_37_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_37_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_37_02]) = 1 AND A.[Sum_Q_37_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_37_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_37_03]) = 1 AND A.[Sum_Q_37_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_37_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_37_04]) = 1 AND A.[Sum_Q_37_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_37_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_37_05]) = 1 AND A.[Sum_Q_37_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_37_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_38_01]) = 1 AND A.[Sum_Q_38_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_38_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_38_02]) = 1 AND A.[Sum_Q_38_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_38_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_38_03]) = 1 AND A.[Sum_Q_38_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_38_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_38_04]) = 1 AND A.[Sum_Q_38_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_38_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_38_05]) = 1 AND A.[Sum_Q_38_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_38_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_39_01]) = 1 AND A.[Sum_Q_39_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_39_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_39_02]) = 1 AND A.[Sum_Q_39_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_39_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_39_03]) = 1 AND A.[Sum_Q_39_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_39_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_39_04]) = 1 AND A.[Sum_Q_39_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_39_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_39_05]) = 1 AND A.[Sum_Q_39_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_39_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_40_01]) = 1 AND A.[Sum_Q_40_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_40_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_40_02]) = 1 AND A.[Sum_Q_40_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_40_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_40_03]) = 1 AND A.[Sum_Q_40_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_40_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_40_04]) = 1 AND A.[Sum_Q_40_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_40_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_40_05]) = 1 AND A.[Sum_Q_40_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_40_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_41_01]) = 1 AND A.[Sum_Q_41_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_41_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_41_02]) = 1 AND A.[Sum_Q_41_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_41_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_41_03]) = 1 AND A.[Sum_Q_41_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_41_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_41_04]) = 1 AND A.[Sum_Q_41_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_41_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_41_05]) = 1 AND A.[Sum_Q_41_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_41_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_42_01]) = 1 AND A.[Sum_Q_42_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_42_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_42_02]) = 1 AND A.[Sum_Q_42_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_42_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_42_03]) = 1 AND A.[Sum_Q_42_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_42_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_42_04]) = 1 AND A.[Sum_Q_42_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_42_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_42_05]) = 1 AND A.[Sum_Q_42_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_42_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_43_01]) = 1 AND A.[Sum_Q_43_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_43_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_43_02]) = 1 AND A.[Sum_Q_43_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_43_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_43_03]) = 1 AND A.[Sum_Q_43_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_43_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_43_04]) = 1 AND A.[Sum_Q_43_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_43_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_43_05]) = 1 AND A.[Sum_Q_43_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_43_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_44_01]) = 1 AND A.[Sum_Q_44_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_44_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_44_02]) = 1 AND A.[Sum_Q_44_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_44_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_44_03]) = 1 AND A.[Sum_Q_44_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_44_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_44_04]) = 1 AND A.[Sum_Q_44_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_44_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_44_05]) = 1 AND A.[Sum_Q_44_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_44_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_45_01]) = 1 AND A.[Sum_Q_45_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_45_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_45_02]) = 1 AND A.[Sum_Q_45_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_45_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_45_03]) = 1 AND A.[Sum_Q_45_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_45_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_45_04]) = 1 AND A.[Sum_Q_45_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_45_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_45_05]) = 1 AND A.[Sum_Q_45_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_45_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_00]) = 1 AND A.[Sum_Q_46_00] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_00], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_01]) = 1 AND A.[Sum_Q_46_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_10]) = 1 AND A.[Sum_Q_46_10] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_10], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_02]) = 1 AND A.[Sum_Q_46_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_03]) = 1 AND A.[Sum_Q_46_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_04]) = 1 AND A.[Sum_Q_46_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_05]) = 1 AND A.[Sum_Q_46_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_06]) = 1 AND A.[Sum_Q_46_06] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_06], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_07]) = 1 AND A.[Sum_Q_46_07] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_07], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_08]) = 1 AND A.[Sum_Q_46_08] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_08], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_46_09]) = 1 AND A.[Sum_Q_46_09] > 0) OR (LEN(COALESCE(A.[Sum_Q_46_09], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_47_01]) = 1 AND A.[Sum_Q_47_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_47_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_47_02]) = 1 AND A.[Sum_Q_47_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_47_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_47_03]) = 1 AND A.[Sum_Q_47_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_47_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_47_04]) = 1 AND A.[Sum_Q_47_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_47_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_47_05]) = 1 AND A.[Sum_Q_47_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_47_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_48_01]) = 1 AND A.[Sum_Q_48_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_48_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_48_02]) = 1 AND A.[Sum_Q_48_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_48_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_48_03]) = 1 AND A.[Sum_Q_48_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_48_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_48_04]) = 1 AND A.[Sum_Q_48_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_48_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_48_05]) = 1 AND A.[Sum_Q_48_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_48_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_49_01]) = 1 AND A.[Sum_Q_49_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_49_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_49_02]) = 1 AND A.[Sum_Q_49_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_49_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_49_03]) = 1 AND A.[Sum_Q_49_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_49_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_49_04]) = 1 AND A.[Sum_Q_49_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_49_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_49_05]) = 1 AND A.[Sum_Q_49_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_49_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_50_01]) = 1 AND A.[Sum_Q_50_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_50_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_50_02]) = 1 AND A.[Sum_Q_50_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_50_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_50_03]) = 1 AND A.[Sum_Q_50_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_50_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_50_04]) = 1 AND A.[Sum_Q_50_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_50_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_50_05]) = 1 AND A.[Sum_Q_50_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_50_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_51_01]) = 1 AND A.[Sum_Q_51_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_51_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_51_02]) = 1 AND A.[Sum_Q_51_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_51_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_51_03]) = 1 AND A.[Sum_Q_51_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_51_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_51_04]) = 1 AND A.[Sum_Q_51_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_51_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_51_05]) = 1 AND A.[Sum_Q_51_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_51_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_52_01]) = 1 AND A.[Sum_Q_52_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_52_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_52_02]) = 1 AND A.[Sum_Q_52_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_52_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_52_03]) = 1 AND A.[Sum_Q_52_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_52_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_52_04]) = 1 AND A.[Sum_Q_52_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_52_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_52_05]) = 1 AND A.[Sum_Q_52_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_52_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_53_01]) = 1 AND A.[Sum_Q_53_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_53_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_53_02]) = 1 AND A.[Sum_Q_53_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_53_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_53_03]) = 1 AND A.[Sum_Q_53_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_53_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_53_04]) = 1 AND A.[Sum_Q_53_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_53_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_53_05]) = 1 AND A.[Sum_Q_53_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_53_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_54_01]) = 1 AND A.[Sum_Q_54_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_54_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_54_02]) = 1 AND A.[Sum_Q_54_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_54_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_54_03]) = 1 AND A.[Sum_Q_54_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_54_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_54_04]) = 1 AND A.[Sum_Q_54_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_54_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_54_05]) = 1 AND A.[Sum_Q_54_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_54_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_55_01]) = 1 AND A.[Sum_Q_55_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_55_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_55_02]) = 1 AND A.[Sum_Q_55_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_55_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_55_03]) = 1 AND A.[Sum_Q_55_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_55_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_55_04]) = 1 AND A.[Sum_Q_55_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_55_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_55_05]) = 1 AND A.[Sum_Q_55_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_55_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_56_01]) = 1 AND A.[Sum_Q_56_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_56_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_56_02]) = 1 AND A.[Sum_Q_56_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_56_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_56_03]) = 1 AND A.[Sum_Q_56_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_56_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_56_04]) = 1 AND A.[Sum_Q_56_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_56_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_56_05]) = 1 AND A.[Sum_Q_56_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_56_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_57_01]) = 1 AND A.[Sum_Q_57_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_57_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_57_02]) = 1 AND A.[Sum_Q_57_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_57_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_57_03]) = 1 AND A.[Sum_Q_57_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_57_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_57_04]) = 1 AND A.[Sum_Q_57_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_57_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_57_05]) = 1 AND A.[Sum_Q_57_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_57_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_58_01]) = 1 AND A.[Sum_Q_58_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_58_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_58_02]) = 1 AND A.[Sum_Q_58_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_58_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_58_03]) = 1 AND A.[Sum_Q_58_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_58_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_58_04]) = 1 AND A.[Sum_Q_58_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_58_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_58_05]) = 1 AND A.[Sum_Q_58_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_58_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_59_01]) = 1 AND A.[Sum_Q_59_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_59_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_59_02]) = 1 AND A.[Sum_Q_59_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_59_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_59_03]) = 1 AND A.[Sum_Q_59_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_59_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_59_04]) = 1 AND A.[Sum_Q_59_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_59_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_59_05]) = 1 AND A.[Sum_Q_59_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_59_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_60_01]) = 1 AND A.[Sum_Q_60_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_60_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_60_02]) = 1 AND A.[Sum_Q_60_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_60_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_60_03]) = 1 AND A.[Sum_Q_60_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_60_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_60_04]) = 1 AND A.[Sum_Q_60_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_60_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_60_05]) = 1 AND A.[Sum_Q_60_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_60_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_61_01]) = 1 AND A.[Sum_Q_61_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_61_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_61_02]) = 1 AND A.[Sum_Q_61_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_61_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_61_03]) = 1 AND A.[Sum_Q_61_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_61_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_61_04]) = 1 AND A.[Sum_Q_61_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_61_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_61_05]) = 1 AND A.[Sum_Q_61_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_61_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_62_01]) = 1 AND A.[Sum_Q_62_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_62_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_62_02]) = 1 AND A.[Sum_Q_62_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_62_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_62_03]) = 1 AND A.[Sum_Q_62_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_62_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_62_04]) = 1 AND A.[Sum_Q_62_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_62_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_62_05]) = 1 AND A.[Sum_Q_62_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_62_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_63_01]) = 1 AND A.[Sum_Q_63_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_63_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_63_02]) = 1 AND A.[Sum_Q_63_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_63_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_63_03]) = 1 AND A.[Sum_Q_63_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_63_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_63_04]) = 1 AND A.[Sum_Q_63_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_63_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_63_05]) = 1 AND A.[Sum_Q_63_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_63_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_01]) = 1 AND A.[Sum_Q_64_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_02]) = 1 AND A.[Sum_Q_64_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_03]) = 1 AND A.[Sum_Q_64_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_04]) = 1 AND A.[Sum_Q_64_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_05]) = 1 AND A.[Sum_Q_64_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_64_06]) = 1 AND A.[Sum_Q_64_06] > 0) OR (LEN(COALESCE(A.[Sum_Q_64_06], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_01]) = 1 AND A.[Sum_Q_65_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_02]) = 1 AND A.[Sum_Q_65_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_03]) = 1 AND A.[Sum_Q_65_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_04]) = 1 AND A.[Sum_Q_65_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_05]) = 1 AND A.[Sum_Q_65_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_65_06]) = 1 AND A.[Sum_Q_65_06] > 0) OR (LEN(COALESCE(A.[Sum_Q_65_06], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_66_01]) = 1 AND A.[Sum_Q_66_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_66_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_66_02]) = 1 AND A.[Sum_Q_66_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_66_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_66_03]) = 1 AND A.[Sum_Q_66_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_66_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_66_04]) = 1 AND A.[Sum_Q_66_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_66_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_66_05]) = 1 AND A.[Sum_Q_66_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_66_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_67_01]) = 1 AND A.[Sum_Q_67_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_67_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_67_02]) = 1 AND A.[Sum_Q_67_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_67_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_67_03]) = 1 AND A.[Sum_Q_67_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_67_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_67_04]) = 1 AND A.[Sum_Q_67_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_67_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_67_05]) = 1 AND A.[Sum_Q_67_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_67_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_68_01]) = 1 AND A.[Sum_Q_68_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_68_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_68_02]) = 1 AND A.[Sum_Q_68_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_68_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_68_03]) = 1 AND A.[Sum_Q_68_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_68_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_68_04]) = 1 AND A.[Sum_Q_68_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_68_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_68_05]) = 1 AND A.[Sum_Q_68_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_68_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_69_01]) = 1 AND A.[Sum_Q_69_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_69_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_69_02]) = 1 AND A.[Sum_Q_69_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_69_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_69_03]) = 1 AND A.[Sum_Q_69_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_69_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_69_04]) = 1 AND A.[Sum_Q_69_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_69_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_69_05]) = 1 AND A.[Sum_Q_69_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_69_05], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_70_01]) = 1 AND A.[Sum_Q_70_01] > 0) OR (LEN(COALESCE(A.[Sum_Q_70_01], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_70_02]) = 1 AND A.[Sum_Q_70_02] > 0) OR (LEN(COALESCE(A.[Sum_Q_70_02], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_70_03]) = 1 AND A.[Sum_Q_70_03] > 0) OR (LEN(COALESCE(A.[Sum_Q_70_03], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_70_04]) = 1 AND A.[Sum_Q_70_04] > 0) OR (LEN(COALESCE(A.[Sum_Q_70_04], '')) = 0))
					AND ((ISNUMERIC(A.[Sum_Q_70_05]) = 1 AND A.[Sum_Q_70_05] > 0) OR (LEN(COALESCE(A.[Sum_Q_70_05], '')) = 0))

			) AS source
			ON target.current_indicator = source.current_indicator
				AND target.module = source.module
				AND target.aggregate_type = source.aggregate_type
				AND target.form_code = source.form_code
				AND target.official_association_number = source.official_association_number
				AND target.official_branch_number = source.official_branch_number
			
			WHEN NOT MATCHED BY target AND
			(LEN(source.form_code) > 0
			 AND LEN(source.official_association_number) > 0
			 AND LEN(source.official_branch_number) > 0
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
					[branch_name],
					[official_branch_number],
					[response_count],
					[avg_m_01a_01],
					[avg_m_01b_01],
					[avg_m_01c_01],
					[avg_m_01d_01],
					--[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					/*
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					*/
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					--[avg_q_02_06],
					--[avg_q_02_07],
					--[avg_q_02_08],
					--[avg_q_02_09],
					--[avg_q_02_10],
					--[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					--[avg_q_03_06],
					--[avg_q_03_07],
					--[avg_q_03_08],
					--[avg_q_03_09],
					--[avg_q_03_10],
					--[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					--[avg_q_04_06],
					--[avg_q_04_07],
					--[avg_q_04_08],
					--[avg_q_04_09],
					--[avg_q_04_10],
					--[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					--[avg_q_05_06],
					--[avg_q_05_07],
					--[avg_q_05_08],
					--[avg_q_05_09],
					--[avg_q_05_10],
					--[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					--[avg_q_06_06],
					--[avg_q_06_07],
					--[avg_q_06_08],
					--[avg_q_06_09],
					--[avg_q_06_10],
					--[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					--[avg_q_07_06],
					--[avg_q_07_07],
					--[avg_q_07_08],
					--[avg_q_07_09],
					--[avg_q_07_10],
					--[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					--[avg_q_08_06],
					--[avg_q_08_07],
					--[avg_q_08_08],
					--[avg_q_08_09],
					--[avg_q_08_10],
					--[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					--[avg_q_09_06],
					--[avg_q_09_07],
					--[avg_q_09_08],
					--[avg_q_09_09],
					--[avg_q_09_10],
					--[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					--[avg_q_10_06],
					--[avg_q_10_07],
					--[avg_q_10_08],
					--[avg_q_10_09],
					--[avg_q_10_10],
					--[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					--[avg_q_11_06],
					--[avg_q_11_07],
					--[avg_q_11_08],
					--[avg_q_11_09],
					--[avg_q_11_10],
					--[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					--[avg_q_12_06],
					--[avg_q_12_07],
					--[avg_q_12_08],
					--[avg_q_12_09],
					--[avg_q_12_10],
					--[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					/*
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					*/
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					/*
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					*/
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					/*
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					*/
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					/*
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					*/
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					/*
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					*/
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					/*
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					*/
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					/*
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					*/
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					/*
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					*/
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					/*
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					*/
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					/*
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					*/
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					/*
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					*/
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					/*
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					*/
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					/*
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					*/
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					/*
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					*/
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					/*
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					*/
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					/*
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					*/
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					/*
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					*/
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					/*
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					*/
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					/*
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					*/
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
					--[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					/*
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					*/
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					/*
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					*/
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
					--[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					/*
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					*/
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					/*
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					*/
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					/*
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					*/
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					/*
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					*/
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					/*
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					*/
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					/*
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					*/
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					/*
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					*/
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
					--[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					/*
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					*/
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					/*
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					*/
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
					--[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					/*
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					*/
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					/*
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					*/
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					/*
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					*/
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					/*
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					*/
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					/*
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					*/
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					/*
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					*/
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					/*
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					*/
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					/*
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					*/
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					/*
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					*/
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					/*
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					*/
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					/*
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					*/
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					/*
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					*/
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					/*
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					*/
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					/*
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					*/
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					/*
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					*/
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					/*
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					*/
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					/*
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					*/
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					/*
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					*/
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					/*
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					*/
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					/*
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					*/
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					/*
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					*/
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					/*
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					*/
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					/*
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					*/
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					/*
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
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
					--[rpi],
					[rpi_com],
					[rpi_ind],
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
					[safety_percentile],
					[facilities_z-score],
					[service_z-score],
					[value_z-score],
					[engagement_z-score],
					[health_and_wellness_z-score],
					[involvement_z-score],
					[facilities_percentile],
					[service_percentile],
					[value_percentile],
					[engagement_percentile],
					[health_and_wellness_percentile],
					[involvement_percentile]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[module],
					[aggregate_type],
					[response_load_date],
					[form_code],
					[association_name],
					[official_association_number],
					[branch_name],
					[official_branch_number],
					[response_count],
					[avg_m_01a_01],
					[avg_m_01b_01],
					[avg_m_01c_01],
					[avg_m_01d_01],
					--[avg_q_01_00],
					[avg_q_01_01],
					[avg_q_01_02],
					[avg_q_01_03],
					[avg_q_01_04],
					[avg_q_01_05],
					/*
					[avg_q_01_06],
					[avg_q_01_07],
					[avg_q_01_08],
					[avg_q_01_09],
					[avg_q_01_10],
					[avg_q_02_00],
					*/
					[avg_q_02_01],
					[avg_q_02_02],
					[avg_q_02_03],
					[avg_q_02_04],
					[avg_q_02_05],
					--[avg_q_02_06],
					--[avg_q_02_07],
					--[avg_q_02_08],
					--[avg_q_02_09],
					--[avg_q_02_10],
					--[avg_q_03_00],
					[avg_q_03_01],
					[avg_q_03_02],
					[avg_q_03_03],
					[avg_q_03_04],
					[avg_q_03_05],
					--[avg_q_03_06],
					--[avg_q_03_07],
					--[avg_q_03_08],
					--[avg_q_03_09],
					--[avg_q_03_10],
					--[avg_q_04_00],
					[avg_q_04_01],
					[avg_q_04_02],
					[avg_q_04_03],
					[avg_q_04_04],
					[avg_q_04_05],
					--[avg_q_04_06],
					--[avg_q_04_07],
					--[avg_q_04_08],
					--[avg_q_04_09],
					--[avg_q_04_10],
					--[avg_q_05_00],
					[avg_q_05_01],
					[avg_q_05_02],
					[avg_q_05_03],
					[avg_q_05_04],
					[avg_q_05_05],
					--[avg_q_05_06],
					--[avg_q_05_07],
					--[avg_q_05_08],
					--[avg_q_05_09],
					--[avg_q_05_10],
					--[avg_q_06_00],
					[avg_q_06_01],
					[avg_q_06_02],
					[avg_q_06_03],
					[avg_q_06_04],
					[avg_q_06_05],
					--[avg_q_06_06],
					--[avg_q_06_07],
					--[avg_q_06_08],
					--[avg_q_06_09],
					--[avg_q_06_10],
					--[avg_q_07_00],
					[avg_q_07_01],
					[avg_q_07_02],
					[avg_q_07_03],
					[avg_q_07_04],
					[avg_q_07_05],
					--[avg_q_07_06],
					--[avg_q_07_07],
					--[avg_q_07_08],
					--[avg_q_07_09],
					--[avg_q_07_10],
					--[avg_q_08_00],
					[avg_q_08_01],
					[avg_q_08_02],
					[avg_q_08_03],
					[avg_q_08_04],
					[avg_q_08_05],
					--[avg_q_08_06],
					--[avg_q_08_07],
					--[avg_q_08_08],
					--[avg_q_08_09],
					--[avg_q_08_10],
					--[avg_q_09_00],
					[avg_q_09_01],
					[avg_q_09_02],
					[avg_q_09_03],
					[avg_q_09_04],
					[avg_q_09_05],
					--[avg_q_09_06],
					--[avg_q_09_07],
					--[avg_q_09_08],
					--[avg_q_09_09],
					--[avg_q_09_10],
					--[avg_q_10_00],
					[avg_q_10_01],
					[avg_q_10_02],
					[avg_q_10_03],
					[avg_q_10_04],
					[avg_q_10_05],
					--[avg_q_10_06],
					--[avg_q_10_07],
					--[avg_q_10_08],
					--[avg_q_10_09],
					--[avg_q_10_10],
					--[avg_q_11_00],
					[avg_q_11_01],
					[avg_q_11_02],
					[avg_q_11_03],
					[avg_q_11_04],
					[avg_q_11_05],
					--[avg_q_11_06],
					--[avg_q_11_07],
					--[avg_q_11_08],
					--[avg_q_11_09],
					--[avg_q_11_10],
					--[avg_q_12_00],
					[avg_q_12_01],
					[avg_q_12_02],
					[avg_q_12_03],
					[avg_q_12_04],
					[avg_q_12_05],
					--[avg_q_12_06],
					--[avg_q_12_07],
					--[avg_q_12_08],
					--[avg_q_12_09],
					--[avg_q_12_10],
					--[avg_q_13_00],
					[avg_q_13_01],
					[avg_q_13_02],
					[avg_q_13_03],
					[avg_q_13_04],
					[avg_q_13_05],
					/*
					[avg_q_13_06],
					[avg_q_13_07],
					[avg_q_13_08],
					[avg_q_13_09],
					[avg_q_13_10],
					[avg_q_14_00],
					*/
					[avg_q_14_01],
					[avg_q_14_02],
					[avg_q_14_03],
					[avg_q_14_04],
					[avg_q_14_05],
					/*
					[avg_q_14_06],
					[avg_q_14_07],
					[avg_q_14_08],
					[avg_q_14_09],
					[avg_q_14_10],
					[avg_q_15_00],
					*/
					[avg_q_15_01],
					[avg_q_15_02],
					[avg_q_15_03],
					[avg_q_15_04],
					[avg_q_15_05],
					/*
					[avg_q_15_06],
					[avg_q_15_07],
					[avg_q_15_08],
					[avg_q_15_09],
					[avg_q_15_10],
					[avg_q_16_00],
					*/
					[avg_q_16_01],
					[avg_q_16_02],
					[avg_q_16_03],
					[avg_q_16_04],
					[avg_q_16_05],
					/*
					[avg_q_16_06],
					[avg_q_16_07],
					[avg_q_16_08],
					[avg_q_16_09],
					[avg_q_16_10],
					[avg_q_17_00],
					*/
					[avg_q_17_01],
					[avg_q_17_02],
					[avg_q_17_03],
					[avg_q_17_04],
					[avg_q_17_05],
					/*
					[avg_q_17_06],
					[avg_q_17_07],
					[avg_q_17_08],
					[avg_q_17_09],
					[avg_q_17_10],
					[avg_q_18_00],
					*/
					[avg_q_18_01],
					[avg_q_18_02],
					[avg_q_18_03],
					[avg_q_18_04],
					[avg_q_18_05],
					/*
					[avg_q_18_06],
					[avg_q_18_07],
					[avg_q_18_08],
					[avg_q_18_09],
					[avg_q_18_10],
					[avg_q_19_00],
					*/
					[avg_q_19_01],
					[avg_q_19_02],
					[avg_q_19_03],
					[avg_q_19_04],
					[avg_q_19_05],
					/*
					[avg_q_19_06],
					[avg_q_19_07],
					[avg_q_19_08],
					[avg_q_19_09],
					[avg_q_19_10],
					[avg_q_20_00],
					*/
					[avg_q_20_01],
					[avg_q_20_02],
					[avg_q_20_03],
					[avg_q_20_04],
					[avg_q_20_05],
					/*
					[avg_q_20_06],
					[avg_q_20_07],
					[avg_q_20_08],
					[avg_q_20_09],
					[avg_q_20_10],
					[avg_q_21_00],
					*/
					[avg_q_21_01],
					[avg_q_21_02],
					[avg_q_21_03],
					[avg_q_21_04],
					[avg_q_21_05],
					/*
					[avg_q_21_06],
					[avg_q_21_07],
					[avg_q_21_08],
					[avg_q_21_09],
					[avg_q_21_10],
					[avg_q_22_00],
					*/
					[avg_q_22_01],
					[avg_q_22_02],
					[avg_q_22_03],
					[avg_q_22_04],
					[avg_q_22_05],
					/*
					[avg_q_22_06],
					[avg_q_22_07],
					[avg_q_22_08],
					[avg_q_22_09],
					[avg_q_22_10],
					[avg_q_23_00],
					*/
					[avg_q_23_01],
					[avg_q_23_02],
					[avg_q_23_03],
					[avg_q_23_04],
					[avg_q_23_05],
					/*
					[avg_q_23_06],
					[avg_q_23_07],
					[avg_q_23_08],
					[avg_q_23_09],
					[avg_q_23_10],
					[avg_q_24_00],
					*/
					[avg_q_24_01],
					[avg_q_24_02],
					[avg_q_24_03],
					[avg_q_24_04],
					[avg_q_24_05],
					/*
					[avg_q_24_06],
					[avg_q_24_07],
					[avg_q_24_08],
					[avg_q_24_09],
					[avg_q_24_10],
					[avg_q_25_00],
					*/
					[avg_q_25_01],
					[avg_q_25_02],
					[avg_q_25_03],
					[avg_q_25_04],
					[avg_q_25_05],
					/*
					[avg_q_25_06],
					[avg_q_25_07],
					[avg_q_25_08],
					[avg_q_25_09],
					[avg_q_25_10],
					[avg_q_26_00],
					*/
					[avg_q_26_01],
					[avg_q_26_02],
					[avg_q_26_03],
					[avg_q_26_04],
					[avg_q_26_05],
					/*
					[avg_q_26_06],
					[avg_q_26_07],
					[avg_q_26_08],
					[avg_q_26_09],
					[avg_q_26_10],
					[avg_q_27_00],
					*/
					[avg_q_27_01],
					[avg_q_27_02],
					[avg_q_27_03],
					[avg_q_27_04],
					[avg_q_27_05],
					/*
					[avg_q_27_06],
					[avg_q_27_07],
					[avg_q_27_08],
					[avg_q_27_09],
					[avg_q_27_10],
					[avg_q_28_00],
					*/
					[avg_q_28_01],
					[avg_q_28_02],
					[avg_q_28_03],
					[avg_q_28_04],
					[avg_q_28_05],
					/*
					[avg_q_28_06],
					[avg_q_28_07],
					[avg_q_28_08],
					[avg_q_28_09],
					[avg_q_28_10],
					[avg_q_29_00],
					*/
					[avg_q_29_01],
					[avg_q_29_02],
					[avg_q_29_03],
					[avg_q_29_04],
					[avg_q_29_05],
					/*
					[avg_q_29_06],
					[avg_q_29_07],
					[avg_q_29_08],
					[avg_q_29_09],
					[avg_q_29_10],
					[avg_q_30_00],
					*/
					[avg_q_30_01],
					[avg_q_30_02],
					[avg_q_30_03],
					[avg_q_30_04],
					[avg_q_30_05],
					/*
					[avg_q_30_06],
					[avg_q_30_07],
					[avg_q_30_08],
					[avg_q_30_09],
					[avg_q_30_10],
					[avg_q_31_00],
					*/
					[avg_q_31_01],
					[avg_q_31_02],
					[avg_q_31_03],
					[avg_q_31_04],
					[avg_q_31_05],
					/*
					[avg_q_31_06],
					[avg_q_31_07],
					[avg_q_31_08],
					[avg_q_31_09],
					[avg_q_31_10],
					*/
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
					--[avg_q_33_00],
					[avg_q_33_01],
					[avg_q_33_02],
					[avg_q_33_03],
					[avg_q_33_04],
					[avg_q_33_05],
					/*
					[avg_q_33_06],
					[avg_q_33_07],
					[avg_q_33_08],
					[avg_q_33_09],
					[avg_q_33_10],
					[avg_q_34_00],
					*/
					[avg_q_34_01],
					[avg_q_34_02],
					[avg_q_34_03],
					[avg_q_34_04],
					[avg_q_34_05],
					/*
					[avg_q_34_06],
					[avg_q_34_07],
					[avg_q_34_08],
					[avg_q_34_09],
					[avg_q_34_10],
					*/
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
					--[avg_q_36_00],
					[avg_q_36_01],
					[avg_q_36_02],
					[avg_q_36_03],
					[avg_q_36_04],
					[avg_q_36_05],
					/*
					[avg_q_36_06],
					[avg_q_36_07],
					[avg_q_36_08],
					[avg_q_36_09],
					[avg_q_36_10],
					[avg_q_37_00],
					*/
					[avg_q_37_01],
					[avg_q_37_02],
					[avg_q_37_03],
					[avg_q_37_04],
					[avg_q_37_05],
					/*
					[avg_q_37_06],
					[avg_q_37_07],
					[avg_q_37_08],
					[avg_q_37_09],
					[avg_q_37_10],
					[avg_q_38_00],
					*/
					[avg_q_38_01],
					[avg_q_38_02],
					[avg_q_38_03],
					[avg_q_38_04],
					[avg_q_38_05],
					/*
					[avg_q_38_06],
					[avg_q_38_07],
					[avg_q_38_08],
					[avg_q_38_09],
					[avg_q_38_10],
					[avg_q_39_00],
					*/
					[avg_q_39_01],
					[avg_q_39_02],
					[avg_q_39_03],
					[avg_q_39_04],
					[avg_q_39_05],
					/*
					[avg_q_39_06],
					[avg_q_39_07],
					[avg_q_39_08],
					[avg_q_39_09],
					[avg_q_39_10],
					[avg_q_40_00],
					*/
					[avg_q_40_01],
					[avg_q_40_02],
					[avg_q_40_03],
					[avg_q_40_04],
					[avg_q_40_05],
					/*
					[avg_q_40_06],
					[avg_q_40_07],
					[avg_q_40_08],
					[avg_q_40_09],
					[avg_q_40_10],
					[avg_q_41_00],
					*/
					[avg_q_41_01],
					[avg_q_41_02],
					[avg_q_41_03],
					[avg_q_41_04],
					[avg_q_41_05],
					/*
					[avg_q_41_06],
					[avg_q_41_07],
					[avg_q_41_08],
					[avg_q_41_09],
					[avg_q_41_10],
					[avg_q_42_00],
					*/
					[avg_q_42_01],
					[avg_q_42_02],
					[avg_q_42_03],
					[avg_q_42_04],
					[avg_q_42_05],
					/*
					[avg_q_42_06],
					[avg_q_42_07],
					[avg_q_42_08],
					[avg_q_42_09],
					[avg_q_42_10],
					*/
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
					--[avg_q_44_00],
					[avg_q_44_01],
					[avg_q_44_02],
					[avg_q_44_03],
					[avg_q_44_04],
					[avg_q_44_05],
					/*
					[avg_q_44_06],
					[avg_q_44_07],
					[avg_q_44_08],
					[avg_q_44_09],
					[avg_q_44_10],
					[avg_q_45_00],
					*/
					[avg_q_45_01],
					[avg_q_45_02],
					[avg_q_45_03],
					[avg_q_45_04],
					[avg_q_45_05],
					/*
					[avg_q_45_06],
					[avg_q_45_07],
					[avg_q_45_08],
					[avg_q_45_09],
					[avg_q_45_10],
					*/
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
					--[avg_q_47_00],
					[avg_q_47_01],
					[avg_q_47_02],
					[avg_q_47_03],
					[avg_q_47_04],
					[avg_q_47_05],
					/*
					[avg_q_47_06],
					[avg_q_47_07],
					[avg_q_47_08],
					[avg_q_47_09],
					[avg_q_47_10],
					[avg_q_48_00],
					*/
					[avg_q_48_01],
					[avg_q_48_02],
					[avg_q_48_03],
					[avg_q_48_04],
					[avg_q_48_05],
					/*
					[avg_q_48_06],
					[avg_q_48_07],
					[avg_q_48_08],
					[avg_q_48_09],
					[avg_q_48_10],
					[avg_q_49_00],
					*/
					[avg_q_49_01],
					[avg_q_49_02],
					[avg_q_49_03],
					[avg_q_49_04],
					[avg_q_49_05],
					/*
					[avg_q_49_06],
					[avg_q_49_07],
					[avg_q_49_08],
					[avg_q_49_09],
					[avg_q_49_10],
					[avg_q_50_00],
					*/
					[avg_q_50_01],
					[avg_q_50_02],
					[avg_q_50_03],
					[avg_q_50_04],
					[avg_q_50_05],
					/*
					[avg_q_50_06],
					[avg_q_50_07],
					[avg_q_50_08],
					[avg_q_50_09],
					[avg_q_50_10],
					[avg_q_51_00],
					*/
					[avg_q_51_01],
					[avg_q_51_02],
					[avg_q_51_03],
					[avg_q_51_04],
					[avg_q_51_05],
					/*
					[avg_q_51_06],
					[avg_q_51_07],
					[avg_q_51_08],
					[avg_q_51_09],
					[avg_q_51_10],
					[avg_q_52_00],
					*/
					[avg_q_52_01],
					[avg_q_52_02],
					[avg_q_52_03],
					[avg_q_52_04],
					[avg_q_52_05],
					/*
					[avg_q_52_06],
					[avg_q_52_07],
					[avg_q_52_08],
					[avg_q_52_09],
					[avg_q_52_10],
					[avg_q_53_00],
					*/
					[avg_q_53_01],
					[avg_q_53_02],
					[avg_q_53_03],
					[avg_q_53_04],
					[avg_q_53_05],
					/*
					[avg_q_53_06],
					[avg_q_53_07],
					[avg_q_53_08],
					[avg_q_53_09],
					[avg_q_53_10],
					[avg_q_54_00],
					*/
					[avg_q_54_01],
					[avg_q_54_02],
					[avg_q_54_03],
					[avg_q_54_04],
					[avg_q_54_05],
					/*
					[avg_q_54_06],
					[avg_q_54_07],
					[avg_q_54_08],
					[avg_q_54_09],
					[avg_q_54_10],
					[avg_q_55_00],
					*/
					[avg_q_55_01],
					[avg_q_55_02],
					[avg_q_55_03],
					[avg_q_55_04],
					[avg_q_55_05],
					/*
					[avg_q_55_06],
					[avg_q_55_07],
					[avg_q_55_08],
					[avg_q_55_09],
					[avg_q_55_10],
					[avg_q_56_00],
					*/
					[avg_q_56_01],
					[avg_q_56_02],
					[avg_q_56_03],
					[avg_q_56_04],
					[avg_q_56_05],
					/*
					[avg_q_56_06],
					[avg_q_56_07],
					[avg_q_56_08],
					[avg_q_56_09],
					[avg_q_56_10],
					[avg_q_57_00],
					*/
					[avg_q_57_01],
					[avg_q_57_02],
					[avg_q_57_03],
					[avg_q_57_04],
					[avg_q_57_05],
					/*
					[avg_q_57_06],
					[avg_q_57_07],
					[avg_q_57_08],
					[avg_q_57_09],
					[avg_q_57_10],
					[avg_q_58_00],
					*/
					[avg_q_58_01],
					[avg_q_58_02],
					[avg_q_58_03],
					[avg_q_58_04],
					[avg_q_58_05],
					/*
					[avg_q_58_06],
					[avg_q_58_07],
					[avg_q_58_08],
					[avg_q_58_09],
					[avg_q_58_10],
					[avg_q_59_00],
					*/
					[avg_q_59_01],
					[avg_q_59_02],
					[avg_q_59_03],
					[avg_q_59_04],
					[avg_q_59_05],
					/*
					[avg_q_59_06],
					[avg_q_59_07],
					[avg_q_59_08],
					[avg_q_59_09],
					[avg_q_59_10],
					[avg_q_60_00],
					*/
					[avg_q_60_01],
					[avg_q_60_02],
					[avg_q_60_03],
					[avg_q_60_04],
					[avg_q_60_05],
					/*
					[avg_q_60_06],
					[avg_q_60_07],
					[avg_q_60_08],
					[avg_q_60_09],
					[avg_q_60_10],
					[avg_q_61_00],
					*/
					[avg_q_61_01],
					[avg_q_61_02],
					[avg_q_61_03],
					[avg_q_61_04],
					[avg_q_61_05],
					/*
					[avg_q_61_06],
					[avg_q_61_07],
					[avg_q_61_08],
					[avg_q_61_09],
					[avg_q_61_10],
					[avg_q_62_00],
					*/
					[avg_q_62_01],
					[avg_q_62_02],
					[avg_q_62_03],
					[avg_q_62_04],
					[avg_q_62_05],
					/*
					[avg_q_62_06],
					[avg_q_62_07],
					[avg_q_62_08],
					[avg_q_62_09],
					[avg_q_62_10],
					[avg_q_63_00],
					*/
					[avg_q_63_01],
					[avg_q_63_02],
					[avg_q_63_03],
					[avg_q_63_04],
					[avg_q_63_05],
					/*
					[avg_q_63_06],
					[avg_q_63_07],
					[avg_q_63_08],
					[avg_q_63_09],
					[avg_q_63_10],
					[avg_q_64_00],
					*/
					[avg_q_64_01],
					[avg_q_64_02],
					[avg_q_64_03],
					[avg_q_64_04],
					[avg_q_64_05],
					[avg_q_64_06],
					/*
					[avg_q_64_07],
					[avg_q_64_08],
					[avg_q_64_09],
					[avg_q_64_10],
					[avg_q_65_00],
					*/
					[avg_q_65_01],
					[avg_q_65_02],
					[avg_q_65_03],
					[avg_q_65_04],
					[avg_q_65_05],
					[avg_q_65_06],
					[avg_q_65_07],
					/*
					[avg_q_65_08],
					[avg_q_65_09],
					[avg_q_65_10],
					[avg_q_66_00],
					*/
					[avg_q_66_01],
					[avg_q_66_02],
					[avg_q_66_03],
					[avg_q_66_04],
					[avg_q_66_05],
					/*
					[avg_q_66_06],
					[avg_q_66_07],
					[avg_q_66_08],
					[avg_q_66_09],
					[avg_q_66_10],
					[avg_q_67_00],
					*/
					[avg_q_67_01],
					[avg_q_67_02],
					[avg_q_67_03],
					[avg_q_67_04],
					[avg_q_67_05],
					/*
					[avg_q_67_06],
					[avg_q_67_07],
					[avg_q_67_08],
					[avg_q_67_09],
					[avg_q_67_10],
					[avg_q_68_00],
					*/
					[avg_q_68_01],
					[avg_q_68_02],
					[avg_q_68_03],
					[avg_q_68_04],
					[avg_q_68_05],
					/*
					[avg_q_68_06],
					[avg_q_68_07],
					[avg_q_68_08],
					[avg_q_68_09],
					[avg_q_68_10],
					[avg_q_69_00],
					*/
					[avg_q_69_01],
					[avg_q_69_02],
					[avg_q_69_03],
					[avg_q_69_04],
					[avg_q_69_05],
					/*
					[avg_q_69_06],
					[avg_q_69_07],
					[avg_q_69_08],
					[avg_q_69_09],
					[avg_q_69_10],
					[avg_q_70_00],
					*/
					[avg_q_70_01],
					[avg_q_70_02],
					[avg_q_70_03],
					[avg_q_70_04],
					[avg_q_70_05],
					/*
					[avg_q_70_06],
					[avg_q_70_07],
					[avg_q_70_08],
					[avg_q_70_09],
					[avg_q_70_10],
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
					--[rpi],
					[rpi_com],
					[rpi_ind],
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
					[safety_percentile],
					[facilities_z-score],
					[service_z-score],
					[value_z-score],
					[engagement_z-score],
					[health_and_wellness_z-score],
					[involvement_z-score],
					[facilities_percentile],
					[service_percentile],
					[value_percentile],
					[engagement_percentile],
					[health_and_wellness_percentile],
					[involvement_percentile]
					)
					
	;
COMMIT TRAN

BEGIN TRAN
	INSERT INTO Seer_CTRL.dbo.[Member Aggregated Data]([Aggregate_Type],
														[Response_Load_Date],
														[Form_Code],
														[OFF_ASSOC_NUM],
														[ASSOCIATION_NAME],
														[OFF_BR_NUM],
														[BRANCH_NAME],
														[Response_Count],
														[Avg_M_01a_01],
														[Avg_M_01b_01],
														[Avg_M_01c_01],
														[Avg_M_01d_01],
														[Avg_Q_01_01],
														[Avg_Q_01_02],
														[Avg_Q_01_03],
														[Avg_Q_01_04],
														[Avg_Q_01_05],
														[Avg_Q_02_01],
														[Avg_Q_02_02],
														[Avg_Q_02_03],
														[Avg_Q_02_04],
														[Avg_Q_02_05],
														[Avg_Q_03_01],
														[Avg_Q_03_02],
														[Avg_Q_03_03],
														[Avg_Q_03_04],
														[Avg_Q_03_05],
														[Avg_Q_04_01],
														[Avg_Q_04_02],
														[Avg_Q_04_03],
														[Avg_Q_04_04],
														[Avg_Q_04_05],
														[Avg_Q_05_01],
														[Avg_Q_05_02],
														[Avg_Q_05_03],
														[Avg_Q_05_04],
														[Avg_Q_05_05],
														[Avg_Q_06_01],
														[Avg_Q_06_02],
														[Avg_Q_06_03],
														[Avg_Q_06_04],
														[Avg_Q_06_05],
														[Avg_Q_07_01],
														[Avg_Q_07_02],
														[Avg_Q_07_03],
														[Avg_Q_07_04],
														[Avg_Q_07_05],
														[Avg_Q_08_01],
														[Avg_Q_08_02],
														[Avg_Q_08_03],
														[Avg_Q_08_04],
														[Avg_Q_08_05],
														[Avg_Q_09_01],
														[Avg_Q_09_02],
														[Avg_Q_09_03],
														[Avg_Q_09_04],
														[Avg_Q_09_05],
														[Avg_Q_10_01],
														[Avg_Q_10_02],
														[Avg_Q_10_03],
														[Avg_Q_10_04],
														[Avg_Q_10_05],
														[Avg_Q_11_01],
														[Avg_Q_11_02],
														[Avg_Q_11_03],
														[Avg_Q_11_04],
														[Avg_Q_11_05],
														[Avg_Q_12_01],
														[Avg_Q_12_02],
														[Avg_Q_12_03],
														[Avg_Q_12_04],
														[Avg_Q_12_05],
														[Avg_Q_13_01],
														[Avg_Q_13_02],
														[Avg_Q_13_03],
														[Avg_Q_13_04],
														[Avg_Q_13_05],
														[Avg_Q_14_01],
														[Avg_Q_14_02],
														[Avg_Q_14_03],
														[Avg_Q_14_04],
														[Avg_Q_14_05],
														[Avg_Q_15_01],
														[Avg_Q_15_02],
														[Avg_Q_15_03],
														[Avg_Q_15_04],
														[Avg_Q_15_05],
														[Avg_Q_16_01],
														[Avg_Q_16_02],
														[Avg_Q_16_03],
														[Avg_Q_16_04],
														[Avg_Q_16_05],
														[Avg_Q_17_01],
														[Avg_Q_17_02],
														[Avg_Q_17_03],
														[Avg_Q_17_04],
														[Avg_Q_17_05],
														[Avg_Q_18_01],
														[Avg_Q_18_02],
														[Avg_Q_18_03],
														[Avg_Q_18_04],
														[Avg_Q_18_05],
														[Avg_Q_19_01],
														[Avg_Q_19_02],
														[Avg_Q_19_03],
														[Avg_Q_19_04],
														[Avg_Q_19_05],
														[Avg_Q_20_01],
														[Avg_Q_20_02],
														[Avg_Q_20_03],
														[Avg_Q_20_04],
														[Avg_Q_20_05],
														[Avg_Q_21_01],
														[Avg_Q_21_02],
														[Avg_Q_21_03],
														[Avg_Q_21_04],
														[Avg_Q_21_05],
														[Avg_Q_22_01],
														[Avg_Q_22_02],
														[Avg_Q_22_03],
														[Avg_Q_22_04],
														[Avg_Q_22_05],
														[Avg_Q_23_01],
														[Avg_Q_23_02],
														[Avg_Q_23_03],
														[Avg_Q_23_04],
														[Avg_Q_23_05],
														[Avg_Q_24_01],
														[Avg_Q_24_02],
														[Avg_Q_24_03],
														[Avg_Q_24_04],
														[Avg_Q_24_05],
														[Avg_Q_25_01],
														[Avg_Q_25_02],
														[Avg_Q_25_03],
														[Avg_Q_25_04],
														[Avg_Q_25_05],
														[Avg_Q_26_01],
														[Avg_Q_26_02],
														[Avg_Q_26_03],
														[Avg_Q_26_04],
														[Avg_Q_26_05],
														[Avg_Q_27_01],
														[Avg_Q_27_02],
														[Avg_Q_27_03],
														[Avg_Q_27_04],
														[Avg_Q_27_05],
														[Avg_Q_28_01],
														[Avg_Q_28_02],
														[Avg_Q_28_03],
														[Avg_Q_28_04],
														[Avg_Q_28_05],
														[Avg_Q_29_01],
														[Avg_Q_29_02],
														[Avg_Q_29_03],
														[Avg_Q_29_04],
														[Avg_Q_29_05],
														[Avg_Q_30_01],
														[Avg_Q_30_02],
														[Avg_Q_30_03],
														[Avg_Q_30_04],
														[Avg_Q_30_05],
														[Avg_Q_31_01],
														[Avg_Q_31_02],
														[Avg_Q_31_03],
														[Avg_Q_31_04],
														[Avg_Q_31_05],
														[Avg_Q_32_00],
														[Avg_Q_32_01],
														[Avg_Q_32_10],
														[Avg_Q_32_02],
														[Avg_Q_32_03],
														[Avg_Q_32_04],
														[Avg_Q_32_05],
														[Avg_Q_32_06],
														[Avg_Q_32_07],
														[Avg_Q_32_08],
														[Avg_Q_32_09],
														[Avg_Q_33_01],
														[Avg_Q_33_02],
														[Avg_Q_33_03],
														[Avg_Q_33_04],
														[Avg_Q_33_05],
														[Avg_Q_34_01],
														[Avg_Q_34_02],
														[Avg_Q_34_03],
														[Avg_Q_34_04],
														[Avg_Q_34_05],
														[Avg_Q_35_00],
														[Avg_Q_35_01],
														[Avg_Q_35_10],
														[Avg_Q_35_02],
														[Avg_Q_35_03],
														[Avg_Q_35_04],
														[Avg_Q_35_05],
														[Avg_Q_35_06],
														[Avg_Q_35_07],
														[Avg_Q_35_08],
														[Avg_Q_35_09],
														[Avg_Q_36_01],
														[Avg_Q_36_02],
														[Avg_Q_36_03],
														[Avg_Q_36_04],
														[Avg_Q_36_05],
														[Avg_Q_37_01],
														[Avg_Q_37_02],
														[Avg_Q_37_03],
														[Avg_Q_37_04],
														[Avg_Q_37_05],
														[Avg_Q_38_01],
														[Avg_Q_38_02],
														[Avg_Q_38_03],
														[Avg_Q_38_04],
														[Avg_Q_38_05],
														[Avg_Q_39_01],
														[Avg_Q_39_02],
														[Avg_Q_39_03],
														[Avg_Q_39_04],
														[Avg_Q_39_05],
														[Avg_Q_40_01],
														[Avg_Q_40_02],
														[Avg_Q_40_03],
														[Avg_Q_40_04],
														[Avg_Q_40_05],
														[Avg_Q_41_01],
														[Avg_Q_41_02],
														[Avg_Q_41_03],
														[Avg_Q_41_04],
														[Avg_Q_41_05],
														[Avg_Q_42_01],
														[Avg_Q_42_02],
														[Avg_Q_42_03],
														[Avg_Q_42_04],
														[Avg_Q_42_05],
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
														[Avg_Q_44_01],
														[Avg_Q_44_02],
														[Avg_Q_44_03],
														[Avg_Q_44_04],
														[Avg_Q_44_05],
														[Avg_Q_45_01],
														[Avg_Q_45_02],
														[Avg_Q_45_03],
														[Avg_Q_45_04],
														[Avg_Q_45_05],
														[Avg_Q_46_00],
														[Avg_Q_46_01],
														[Avg_Q_46_10],
														[Avg_Q_46_02],
														[Avg_Q_46_03],
														[Avg_Q_46_04],
														[Avg_Q_46_05],
														[Avg_Q_46_06],
														[Avg_Q_46_07],
														[Avg_Q_46_08],
														[Avg_Q_46_09],
														[Avg_Q_47_01],
														[Avg_Q_47_02],
														[Avg_Q_47_03],
														[Avg_Q_47_04],
														[Avg_Q_47_05],
														[Avg_Q_48_01],
														[Avg_Q_48_02],
														[Avg_Q_48_03],
														[Avg_Q_48_04],
														[Avg_Q_48_05],
														[Avg_Q_49_01],
														[Avg_Q_49_02],
														[Avg_Q_49_03],
														[Avg_Q_49_04],
														[Avg_Q_49_05],
														[Avg_Q_50_01],
														[Avg_Q_50_02],
														[Avg_Q_50_03],
														[Avg_Q_50_04],
														[Avg_Q_50_05],
														[Avg_Q_51_01],
														[Avg_Q_51_02],
														[Avg_Q_51_03],
														[Avg_Q_51_04],
														[Avg_Q_51_05],
														[Avg_Q_52_01],
														[Avg_Q_52_02],
														[Avg_Q_52_03],
														[Avg_Q_52_04],
														[Avg_Q_52_05],
														[Avg_Q_53_01],
														[Avg_Q_53_02],
														[Avg_Q_53_03],
														[Avg_Q_53_04],
														[Avg_Q_53_05],
														[Avg_Q_54_01],
														[Avg_Q_54_02],
														[Avg_Q_54_03],
														[Avg_Q_54_04],
														[Avg_Q_54_05],
														[Avg_Q_55_01],
														[Avg_Q_55_02],
														[Avg_Q_55_03],
														[Avg_Q_55_04],
														[Avg_Q_55_05],
														[Avg_Q_56_01],
														[Avg_Q_56_02],
														[Avg_Q_56_03],
														[Avg_Q_56_04],
														[Avg_Q_56_05],
														[Avg_Q_57_01],
														[Avg_Q_57_02],
														[Avg_Q_57_03],
														[Avg_Q_57_04],
														[Avg_Q_57_05],
														[Avg_Q_58_01],
														[Avg_Q_58_02],
														[Avg_Q_58_03],
														[Avg_Q_58_04],
														[Avg_Q_58_05],
														[Avg_Q_59_01],
														[Avg_Q_59_02],
														[Avg_Q_59_03],
														[Avg_Q_59_04],
														[Avg_Q_59_05],
														[Avg_Q_60_01],
														[Avg_Q_60_02],
														[Avg_Q_60_03],
														[Avg_Q_60_04],
														[Avg_Q_60_05],
														[Avg_Q_61_01],
														[Avg_Q_61_02],
														[Avg_Q_61_03],
														[Avg_Q_61_04],
														[Avg_Q_61_05],
														[Avg_Q_62_01],
														[Avg_Q_62_02],
														[Avg_Q_62_03],
														[Avg_Q_62_04],
														[Avg_Q_62_05],
														[Avg_Q_63_01],
														[Avg_Q_63_02],
														[Avg_Q_63_03],
														[Avg_Q_63_04],
														[Avg_Q_63_05],
														[Avg_Q_64_01],
														[Avg_Q_64_02],
														[Avg_Q_64_03],
														[Avg_Q_64_04],
														[Avg_Q_64_05],
														[Avg_Q_64_06],
														[Avg_Q_65_01],
														[Avg_Q_65_02],
														[Avg_Q_65_03],
														[Avg_Q_65_04],
														[Avg_Q_65_05],
														[Avg_Q_65_06],
														[Avg_Q_65_07],
														[Avg_Q_66_01],
														[Avg_Q_66_02],
														[Avg_Q_66_03],
														[Avg_Q_66_04],
														[Avg_Q_66_05],
														[Avg_Q_67_01],
														[Avg_Q_67_02],
														[Avg_Q_67_03],
														[Avg_Q_67_04],
														[Avg_Q_67_05],
														[Avg_Q_68_01],
														[Avg_Q_68_02],
														[Avg_Q_68_03],
														[Avg_Q_68_04],
														[Avg_Q_68_05],
														[Avg_Q_69_01],
														[Avg_Q_69_02],
														[Avg_Q_69_03],
														[Avg_Q_69_04],
														[Avg_Q_69_05],
														[Avg_Q_70_01],
														[Avg_Q_70_02],
														[Avg_Q_70_03],
														[Avg_Q_70_04],
														[Avg_Q_70_05],
														[NPS],
														[RPI_COM],
														[RPI_IND],
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
														[Facilities Z-Score],
														[Service Z-Score],
														[Value Z-Score],
														[Engagement Z-Score],
														[Health and Wellness Z-Score],
														[Involvement Z-Score],
														[Facilities Percentile],
														[Service Percentile],
														[Value Percentile],
														[Engagement Percentile],
														[Health and Wellness Percentile],
														[Involvement Percentile],
														[Sum_M_01b_01],
														[Sum_M_01c_01],
														[Sum_M_01d_01],
														[Sum_Q_01_01],
														[Sum_Q_01_02],
														[Sum_Q_01_03],
														[Sum_Q_01_04],
														[Sum_Q_01_05],
														[Sum_Q_02_01],
														[Sum_Q_02_02],
														[Sum_Q_02_03],
														[Sum_Q_02_04],
														[Sum_Q_02_05],
														[Sum_Q_03_01],
														[Sum_Q_03_02],
														[Sum_Q_03_03],
														[Sum_Q_03_04],
														[Sum_Q_03_05],
														[Sum_Q_04_01],
														[Sum_Q_04_02],
														[Sum_Q_04_03],
														[Sum_Q_04_04],
														[Sum_Q_04_05],
														[Sum_Q_05_01],
														[Sum_Q_05_02],
														[Sum_Q_05_03],
														[Sum_Q_05_04],
														[Sum_Q_05_05],
														[Sum_Q_06_01],
														[Sum_Q_06_02],
														[Sum_Q_06_03],
														[Sum_Q_06_04],
														[Sum_Q_06_05],
														[Sum_Q_07_01],
														[Sum_Q_07_02],
														[Sum_Q_07_03],
														[Sum_Q_07_04],
														[Sum_Q_07_05],
														[Sum_Q_08_01],
														[Sum_Q_08_02],
														[Sum_Q_08_03],
														[Sum_Q_08_04],
														[Sum_Q_08_05],
														[Sum_Q_09_01],
														[Sum_Q_09_02],
														[Sum_Q_09_03],
														[Sum_Q_09_04],
														[Sum_Q_09_05],
														[Sum_Q_10_01],
														[Sum_Q_10_02],
														[Sum_Q_10_03],
														[Sum_Q_10_04],
														[Sum_Q_10_05],
														[Sum_Q_11_01],
														[Sum_Q_11_02],
														[Sum_Q_11_03],
														[Sum_Q_11_04],
														[Sum_Q_11_05],
														[Sum_Q_12_01],
														[Sum_Q_12_02],
														[Sum_Q_12_03],
														[Sum_Q_12_04],
														[Sum_Q_12_05],
														[Sum_Q_13_01],
														[Sum_Q_13_02],
														[Sum_Q_13_03],
														[Sum_Q_13_04],
														[Sum_Q_13_05],
														[Sum_Q_14_01],
														[Sum_Q_14_02],
														[Sum_Q_14_03],
														[Sum_Q_14_04],
														[Sum_Q_14_05],
														[Sum_Q_15_01],
														[Sum_Q_15_02],
														[Sum_Q_15_03],
														[Sum_Q_15_04],
														[Sum_Q_15_05],
														[Sum_Q_16_01],
														[Sum_Q_16_02],
														[Sum_Q_16_03],
														[Sum_Q_16_04],
														[Sum_Q_16_05],
														[Sum_Q_17_01],
														[Sum_Q_17_02],
														[Sum_Q_17_03],
														[Sum_Q_17_04],
														[Sum_Q_17_05],
														[Sum_Q_18_01],
														[Sum_Q_18_02],
														[Sum_Q_18_03],
														[Sum_Q_18_04],
														[Sum_Q_18_05],
														[Sum_Q_19_01],
														[Sum_Q_19_02],
														[Sum_Q_19_03],
														[Sum_Q_19_04],
														[Sum_Q_19_05],
														[Sum_Q_20_01],
														[Sum_Q_20_02],
														[Sum_Q_20_03],
														[Sum_Q_20_04],
														[Sum_Q_20_05],
														[Sum_Q_21_01],
														[Sum_Q_21_02],
														[Sum_Q_21_03],
														[Sum_Q_21_04],
														[Sum_Q_21_05],
														[Sum_Q_22_01],
														[Sum_Q_22_02],
														[Sum_Q_22_03],
														[Sum_Q_22_04],
														[Sum_Q_22_05],
														[Sum_Q_23_01],
														[Sum_Q_23_02],
														[Sum_Q_23_03],
														[Sum_Q_23_04],
														[Sum_Q_23_05],
														[Sum_Q_24_01],
														[Sum_Q_24_02],
														[Sum_Q_24_03],
														[Sum_Q_24_04],
														[Sum_Q_24_05],
														[Sum_Q_25_01],
														[Sum_Q_25_02],
														[Sum_Q_25_03],
														[Sum_Q_25_04],
														[Sum_Q_25_05],
														[Sum_Q_26_01],
														[Sum_Q_26_02],
														[Sum_Q_26_03],
														[Sum_Q_26_04],
														[Sum_Q_26_05],
														[Sum_Q_27_01],
														[Sum_Q_27_02],
														[Sum_Q_27_03],
														[Sum_Q_27_04],
														[Sum_Q_27_05],
														[Sum_Q_28_01],
														[Sum_Q_28_02],
														[Sum_Q_28_03],
														[Sum_Q_28_04],
														[Sum_Q_28_05],
														[Sum_Q_29_01],
														[Sum_Q_29_02],
														[Sum_Q_29_03],
														[Sum_Q_29_04],
														[Sum_Q_29_05],
														[Sum_Q_30_01],
														[Sum_Q_30_02],
														[Sum_Q_30_03],
														[Sum_Q_30_04],
														[Sum_Q_30_05],
														[Sum_Q_31_01],
														[Sum_Q_31_02],
														[Sum_Q_31_03],
														[Sum_Q_31_04],
														[Sum_Q_31_05],
														[Sum_Q_32_00],
														[Sum_Q_32_01],
														[Sum_Q_32_10],
														[Sum_Q_32_02],
														[Sum_Q_32_03],
														[Sum_Q_32_04],
														[Sum_Q_32_05],
														[Sum_Q_32_06],
														[Sum_Q_32_07],
														[Sum_Q_32_08],
														[Sum_Q_32_09],
														[Sum_Q_33_01],
														[Sum_Q_33_02],
														[Sum_Q_33_03],
														[Sum_Q_33_04],
														[Sum_Q_33_05],
														[Sum_Q_34_01],
														[Sum_Q_34_02],
														[Sum_Q_34_03],
														[Sum_Q_34_04],
														[Sum_Q_34_05],
														[Sum_Q_35_00],
														[Sum_Q_35_01],
														[Sum_Q_35_10],
														[Sum_Q_35_02],
														[Sum_Q_35_03],
														[Sum_Q_35_04],
														[Sum_Q_35_05],
														[Sum_Q_35_06],
														[Sum_Q_35_07],
														[Sum_Q_35_08],
														[Sum_Q_35_09],
														[Sum_Q_36_01],
														[Sum_Q_36_02],
														[Sum_Q_36_03],
														[Sum_Q_36_04],
														[Sum_Q_36_05],
														[Sum_Q_37_01],
														[Sum_Q_37_02],
														[Sum_Q_37_03],
														[Sum_Q_37_04],
														[Sum_Q_37_05],
														[Sum_Q_38_01],
														[Sum_Q_38_02],
														[Sum_Q_38_03],
														[Sum_Q_38_04],
														[Sum_Q_38_05],
														[Sum_Q_39_01],
														[Sum_Q_39_02],
														[Sum_Q_39_03],
														[Sum_Q_39_04],
														[Sum_Q_39_05],
														[Sum_Q_40_01],
														[Sum_Q_40_02],
														[Sum_Q_40_03],
														[Sum_Q_40_04],
														[Sum_Q_40_05],
														[Sum_Q_41_01],
														[Sum_Q_41_02],
														[Sum_Q_41_03],
														[Sum_Q_41_04],
														[Sum_Q_41_05],
														[Sum_Q_42_01],
														[Sum_Q_42_02],
														[Sum_Q_42_03],
														[Sum_Q_42_04],
														[Sum_Q_42_05],
														[Sum_Q_43_01],
														[Sum_Q_43_02],
														[Sum_Q_43_03],
														[Sum_Q_43_04],
														[Sum_Q_43_05],
														[Sum_Q_44_01],
														[Sum_Q_44_02],
														[Sum_Q_44_03],
														[Sum_Q_44_04],
														[Sum_Q_44_05],
														[Sum_Q_45_01],
														[Sum_Q_45_02],
														[Sum_Q_45_03],
														[Sum_Q_45_04],
														[Sum_Q_45_05],
														[Sum_Q_46_00],
														[Sum_Q_46_01],
														[Sum_Q_46_10],
														[Sum_Q_46_02],
														[Sum_Q_46_03],
														[Sum_Q_46_04],
														[Sum_Q_46_05],
														[Sum_Q_46_06],
														[Sum_Q_46_07],
														[Sum_Q_46_08],
														[Sum_Q_46_09],
														[Sum_Q_47_01],
														[Sum_Q_47_02],
														[Sum_Q_47_03],
														[Sum_Q_47_04],
														[Sum_Q_47_05],
														[Sum_Q_48_01],
														[Sum_Q_48_02],
														[Sum_Q_48_03],
														[Sum_Q_48_04],
														[Sum_Q_48_05],
														[Sum_Q_49_01],
														[Sum_Q_49_02],
														[Sum_Q_49_03],
														[Sum_Q_49_04],
														[Sum_Q_49_05],
														[Sum_Q_50_01],
														[Sum_Q_50_02],
														[Sum_Q_50_03],
														[Sum_Q_50_04],
														[Sum_Q_50_05],
														[Sum_Q_51_01],
														[Sum_Q_51_02],
														[Sum_Q_51_03],
														[Sum_Q_51_04],
														[Sum_Q_51_05],
														[Sum_Q_52_01],
														[Sum_Q_52_02],
														[Sum_Q_52_03],
														[Sum_Q_52_04],
														[Sum_Q_52_05],
														[Sum_Q_53_01],
														[Sum_Q_53_02],
														[Sum_Q_53_03],
														[Sum_Q_53_04],
														[Sum_Q_53_05],
														[Sum_Q_54_01],
														[Sum_Q_54_02],
														[Sum_Q_54_03],
														[Sum_Q_54_04],
														[Sum_Q_54_05],
														[Sum_Q_55_01],
														[Sum_Q_55_02],
														[Sum_Q_55_03],
														[Sum_Q_55_04],
														[Sum_Q_55_05],
														[Sum_Q_56_01],
														[Sum_Q_56_02],
														[Sum_Q_56_03],
														[Sum_Q_56_04],
														[Sum_Q_56_05],
														[Sum_Q_57_01],
														[Sum_Q_57_02],
														[Sum_Q_57_03],
														[Sum_Q_57_04],
														[Sum_Q_57_05],
														[Sum_Q_58_01],
														[Sum_Q_58_02],
														[Sum_Q_58_03],
														[Sum_Q_58_04],
														[Sum_Q_58_05],
														[Sum_Q_59_01],
														[Sum_Q_59_02],
														[Sum_Q_59_03],
														[Sum_Q_59_04],
														[Sum_Q_59_05],
														[Sum_Q_60_01],
														[Sum_Q_60_02],
														[Sum_Q_60_03],
														[Sum_Q_60_04],
														[Sum_Q_60_05],
														[Sum_Q_61_01],
														[Sum_Q_61_02],
														[Sum_Q_61_03],
														[Sum_Q_61_04],
														[Sum_Q_61_05],
														[Sum_Q_62_01],
														[Sum_Q_62_02],
														[Sum_Q_62_03],
														[Sum_Q_62_04],
														[Sum_Q_62_05],
														[Sum_Q_63_01],
														[Sum_Q_63_02],
														[Sum_Q_63_03],
														[Sum_Q_63_04],
														[Sum_Q_63_05],
														[Sum_Q_64_01],
														[Sum_Q_64_02],
														[Sum_Q_64_03],
														[Sum_Q_64_04],
														[Sum_Q_64_05],
														[Sum_Q_64_06],
														[Sum_Q_65_01],
														[Sum_Q_65_02],
														[Sum_Q_65_03],
														[Sum_Q_65_04],
														[Sum_Q_65_05],
														[Sum_Q_65_06],
														[Sum_Q_66_01],
														[Sum_Q_66_02],
														[Sum_Q_66_03],
														[Sum_Q_66_04],
														[Sum_Q_66_05],
														[Sum_Q_67_01],
														[Sum_Q_67_02],
														[Sum_Q_67_03],
														[Sum_Q_67_04],
														[Sum_Q_67_05],
														[Sum_Q_68_01],
														[Sum_Q_68_02],
														[Sum_Q_68_03],
														[Sum_Q_68_04],
														[Sum_Q_68_05],
														[Sum_Q_69_01],
														[Sum_Q_69_02],
														[Sum_Q_69_03],
														[Sum_Q_69_04],
														[Sum_Q_69_05],
														[Sum_Q_70_01],
														[Sum_Q_70_02],
														[Sum_Q_70_03],
														[Sum_Q_70_04],
														[Sum_Q_70_05],
														[CreateDatetime]
	)
	SELECT	A.[Aggregate_Type],
			A.[Response_Load_Date],
			A.[Form_Code],
			A.[OFF_ASSOC_NUM],
			A.[ASSOCIATION_NAME],
			A.[OFF_BR_NUM],
			A.[BRANCH_NAME],
			A.[Response_Count],
			A.[Avg_M_01a_01],
			A.[Avg_M_01b_01],
			A.[Avg_M_01c_01],
			A.[Avg_M_01d_01],
			A.[Avg_Q_01_01],
			A.[Avg_Q_01_02],
			A.[Avg_Q_01_03],
			A.[Avg_Q_01_04],
			A.[Avg_Q_01_05],
			A.[Avg_Q_02_01],
			A.[Avg_Q_02_02],
			A.[Avg_Q_02_03],
			A.[Avg_Q_02_04],
			A.[Avg_Q_02_05],
			A.[Avg_Q_03_01],
			A.[Avg_Q_03_02],
			A.[Avg_Q_03_03],
			A.[Avg_Q_03_04],
			A.[Avg_Q_03_05],
			A.[Avg_Q_04_01],
			A.[Avg_Q_04_02],
			A.[Avg_Q_04_03],
			A.[Avg_Q_04_04],
			A.[Avg_Q_04_05],
			A.[Avg_Q_05_01],
			A.[Avg_Q_05_02],
			A.[Avg_Q_05_03],
			A.[Avg_Q_05_04],
			A.[Avg_Q_05_05],
			A.[Avg_Q_06_01],
			A.[Avg_Q_06_02],
			A.[Avg_Q_06_03],
			A.[Avg_Q_06_04],
			A.[Avg_Q_06_05],
			A.[Avg_Q_07_01],
			A.[Avg_Q_07_02],
			A.[Avg_Q_07_03],
			A.[Avg_Q_07_04],
			A.[Avg_Q_07_05],
			A.[Avg_Q_08_01],
			A.[Avg_Q_08_02],
			A.[Avg_Q_08_03],
			A.[Avg_Q_08_04],
			A.[Avg_Q_08_05],
			A.[Avg_Q_09_01],
			A.[Avg_Q_09_02],
			A.[Avg_Q_09_03],
			A.[Avg_Q_09_04],
			A.[Avg_Q_09_05],
			A.[Avg_Q_10_01],
			A.[Avg_Q_10_02],
			A.[Avg_Q_10_03],
			A.[Avg_Q_10_04],
			A.[Avg_Q_10_05],
			A.[Avg_Q_11_01],
			A.[Avg_Q_11_02],
			A.[Avg_Q_11_03],
			A.[Avg_Q_11_04],
			A.[Avg_Q_11_05],
			A.[Avg_Q_12_01],
			A.[Avg_Q_12_02],
			A.[Avg_Q_12_03],
			A.[Avg_Q_12_04],
			A.[Avg_Q_12_05],
			A.[Avg_Q_13_01],
			A.[Avg_Q_13_02],
			A.[Avg_Q_13_03],
			A.[Avg_Q_13_04],
			A.[Avg_Q_13_05],
			A.[Avg_Q_14_01],
			A.[Avg_Q_14_02],
			A.[Avg_Q_14_03],
			A.[Avg_Q_14_04],
			A.[Avg_Q_14_05],
			A.[Avg_Q_15_01],
			A.[Avg_Q_15_02],
			A.[Avg_Q_15_03],
			A.[Avg_Q_15_04],
			A.[Avg_Q_15_05],
			A.[Avg_Q_16_01],
			A.[Avg_Q_16_02],
			A.[Avg_Q_16_03],
			A.[Avg_Q_16_04],
			A.[Avg_Q_16_05],
			A.[Avg_Q_17_01],
			A.[Avg_Q_17_02],
			A.[Avg_Q_17_03],
			A.[Avg_Q_17_04],
			A.[Avg_Q_17_05],
			A.[Avg_Q_18_01],
			A.[Avg_Q_18_02],
			A.[Avg_Q_18_03],
			A.[Avg_Q_18_04],
			A.[Avg_Q_18_05],
			A.[Avg_Q_19_01],
			A.[Avg_Q_19_02],
			A.[Avg_Q_19_03],
			A.[Avg_Q_19_04],
			A.[Avg_Q_19_05],
			A.[Avg_Q_20_01],
			A.[Avg_Q_20_02],
			A.[Avg_Q_20_03],
			A.[Avg_Q_20_04],
			A.[Avg_Q_20_05],
			A.[Avg_Q_21_01],
			A.[Avg_Q_21_02],
			A.[Avg_Q_21_03],
			A.[Avg_Q_21_04],
			A.[Avg_Q_21_05],
			A.[Avg_Q_22_01],
			A.[Avg_Q_22_02],
			A.[Avg_Q_22_03],
			A.[Avg_Q_22_04],
			A.[Avg_Q_22_05],
			A.[Avg_Q_23_01],
			A.[Avg_Q_23_02],
			A.[Avg_Q_23_03],
			A.[Avg_Q_23_04],
			A.[Avg_Q_23_05],
			A.[Avg_Q_24_01],
			A.[Avg_Q_24_02],
			A.[Avg_Q_24_03],
			A.[Avg_Q_24_04],
			A.[Avg_Q_24_05],
			A.[Avg_Q_25_01],
			A.[Avg_Q_25_02],
			A.[Avg_Q_25_03],
			A.[Avg_Q_25_04],
			A.[Avg_Q_25_05],
			A.[Avg_Q_26_01],
			A.[Avg_Q_26_02],
			A.[Avg_Q_26_03],
			A.[Avg_Q_26_04],
			A.[Avg_Q_26_05],
			A.[Avg_Q_27_01],
			A.[Avg_Q_27_02],
			A.[Avg_Q_27_03],
			A.[Avg_Q_27_04],
			A.[Avg_Q_27_05],
			A.[Avg_Q_28_01],
			A.[Avg_Q_28_02],
			A.[Avg_Q_28_03],
			A.[Avg_Q_28_04],
			A.[Avg_Q_28_05],
			A.[Avg_Q_29_01],
			A.[Avg_Q_29_02],
			A.[Avg_Q_29_03],
			A.[Avg_Q_29_04],
			A.[Avg_Q_29_05],
			A.[Avg_Q_30_01],
			A.[Avg_Q_30_02],
			A.[Avg_Q_30_03],
			A.[Avg_Q_30_04],
			A.[Avg_Q_30_05],
			A.[Avg_Q_31_01],
			A.[Avg_Q_31_02],
			A.[Avg_Q_31_03],
			A.[Avg_Q_31_04],
			A.[Avg_Q_31_05],
			A.[Avg_Q_32_00],
			A.[Avg_Q_32_01],
			A.[Avg_Q_32_10],
			A.[Avg_Q_32_02],
			A.[Avg_Q_32_03],
			A.[Avg_Q_32_04],
			A.[Avg_Q_32_05],
			A.[Avg_Q_32_06],
			A.[Avg_Q_32_07],
			A.[Avg_Q_32_08],
			A.[Avg_Q_32_09],
			A.[Avg_Q_33_01],
			A.[Avg_Q_33_02],
			A.[Avg_Q_33_03],
			A.[Avg_Q_33_04],
			A.[Avg_Q_33_05],
			A.[Avg_Q_34_01],
			A.[Avg_Q_34_02],
			A.[Avg_Q_34_03],
			A.[Avg_Q_34_04],
			A.[Avg_Q_34_05],
			A.[Avg_Q_35_00],
			A.[Avg_Q_35_01],
			A.[Avg_Q_35_10],
			A.[Avg_Q_35_02],
			A.[Avg_Q_35_03],
			A.[Avg_Q_35_04],
			A.[Avg_Q_35_05],
			A.[Avg_Q_35_06],
			A.[Avg_Q_35_07],
			A.[Avg_Q_35_08],
			A.[Avg_Q_35_09],
			A.[Avg_Q_36_01],
			A.[Avg_Q_36_02],
			A.[Avg_Q_36_03],
			A.[Avg_Q_36_04],
			A.[Avg_Q_36_05],
			A.[Avg_Q_37_01],
			A.[Avg_Q_37_02],
			A.[Avg_Q_37_03],
			A.[Avg_Q_37_04],
			A.[Avg_Q_37_05],
			A.[Avg_Q_38_01],
			A.[Avg_Q_38_02],
			A.[Avg_Q_38_03],
			A.[Avg_Q_38_04],
			A.[Avg_Q_38_05],
			A.[Avg_Q_39_01],
			A.[Avg_Q_39_02],
			A.[Avg_Q_39_03],
			A.[Avg_Q_39_04],
			A.[Avg_Q_39_05],
			A.[Avg_Q_40_01],
			A.[Avg_Q_40_02],
			A.[Avg_Q_40_03],
			A.[Avg_Q_40_04],
			A.[Avg_Q_40_05],
			A.[Avg_Q_41_01],
			A.[Avg_Q_41_02],
			A.[Avg_Q_41_03],
			A.[Avg_Q_41_04],
			A.[Avg_Q_41_05],
			A.[Avg_Q_42_01],
			A.[Avg_Q_42_02],
			A.[Avg_Q_42_03],
			A.[Avg_Q_42_04],
			A.[Avg_Q_42_05],
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
			A.[Avg_Q_44_01],
			A.[Avg_Q_44_02],
			A.[Avg_Q_44_03],
			A.[Avg_Q_44_04],
			A.[Avg_Q_44_05],
			A.[Avg_Q_45_01],
			A.[Avg_Q_45_02],
			A.[Avg_Q_45_03],
			A.[Avg_Q_45_04],
			A.[Avg_Q_45_05],
			A.[Avg_Q_46_00],
			A.[Avg_Q_46_01],
			A.[Avg_Q_46_10],
			A.[Avg_Q_46_02],
			A.[Avg_Q_46_03],
			A.[Avg_Q_46_04],
			A.[Avg_Q_46_05],
			A.[Avg_Q_46_06],
			A.[Avg_Q_46_07],
			A.[Avg_Q_46_08],
			A.[Avg_Q_46_09],
			A.[Avg_Q_47_01],
			A.[Avg_Q_47_02],
			A.[Avg_Q_47_03],
			A.[Avg_Q_47_04],
			A.[Avg_Q_47_05],
			A.[Avg_Q_48_01],
			A.[Avg_Q_48_02],
			A.[Avg_Q_48_03],
			A.[Avg_Q_48_04],
			A.[Avg_Q_48_05],
			A.[Avg_Q_49_01],
			A.[Avg_Q_49_02],
			A.[Avg_Q_49_03],
			A.[Avg_Q_49_04],
			A.[Avg_Q_49_05],
			A.[Avg_Q_50_01],
			A.[Avg_Q_50_02],
			A.[Avg_Q_50_03],
			A.[Avg_Q_50_04],
			A.[Avg_Q_50_05],
			A.[Avg_Q_51_01],
			A.[Avg_Q_51_02],
			A.[Avg_Q_51_03],
			A.[Avg_Q_51_04],
			A.[Avg_Q_51_05],
			A.[Avg_Q_52_01],
			A.[Avg_Q_52_02],
			A.[Avg_Q_52_03],
			A.[Avg_Q_52_04],
			A.[Avg_Q_52_05],
			A.[Avg_Q_53_01],
			A.[Avg_Q_53_02],
			A.[Avg_Q_53_03],
			A.[Avg_Q_53_04],
			A.[Avg_Q_53_05],
			A.[Avg_Q_54_01],
			A.[Avg_Q_54_02],
			A.[Avg_Q_54_03],
			A.[Avg_Q_54_04],
			A.[Avg_Q_54_05],
			A.[Avg_Q_55_01],
			A.[Avg_Q_55_02],
			A.[Avg_Q_55_03],
			A.[Avg_Q_55_04],
			A.[Avg_Q_55_05],
			A.[Avg_Q_56_01],
			A.[Avg_Q_56_02],
			A.[Avg_Q_56_03],
			A.[Avg_Q_56_04],
			A.[Avg_Q_56_05],
			A.[Avg_Q_57_01],
			A.[Avg_Q_57_02],
			A.[Avg_Q_57_03],
			A.[Avg_Q_57_04],
			A.[Avg_Q_57_05],
			A.[Avg_Q_58_01],
			A.[Avg_Q_58_02],
			A.[Avg_Q_58_03],
			A.[Avg_Q_58_04],
			A.[Avg_Q_58_05],
			A.[Avg_Q_59_01],
			A.[Avg_Q_59_02],
			A.[Avg_Q_59_03],
			A.[Avg_Q_59_04],
			A.[Avg_Q_59_05],
			A.[Avg_Q_60_01],
			A.[Avg_Q_60_02],
			A.[Avg_Q_60_03],
			A.[Avg_Q_60_04],
			A.[Avg_Q_60_05],
			A.[Avg_Q_61_01],
			A.[Avg_Q_61_02],
			A.[Avg_Q_61_03],
			A.[Avg_Q_61_04],
			A.[Avg_Q_61_05],
			A.[Avg_Q_62_01],
			A.[Avg_Q_62_02],
			A.[Avg_Q_62_03],
			A.[Avg_Q_62_04],
			A.[Avg_Q_62_05],
			A.[Avg_Q_63_01],
			A.[Avg_Q_63_02],
			A.[Avg_Q_63_03],
			A.[Avg_Q_63_04],
			A.[Avg_Q_63_05],
			A.[Avg_Q_64_01],
			A.[Avg_Q_64_02],
			A.[Avg_Q_64_03],
			A.[Avg_Q_64_04],
			A.[Avg_Q_64_05],
			A.[Avg_Q_64_06],
			A.[Avg_Q_65_01],
			A.[Avg_Q_65_02],
			A.[Avg_Q_65_03],
			A.[Avg_Q_65_04],
			A.[Avg_Q_65_05],
			A.[Avg_Q_65_06],
			A.[Avg_Q_65_07],
			A.[Avg_Q_66_01],
			A.[Avg_Q_66_02],
			A.[Avg_Q_66_03],
			A.[Avg_Q_66_04],
			A.[Avg_Q_66_05],
			A.[Avg_Q_67_01],
			A.[Avg_Q_67_02],
			A.[Avg_Q_67_03],
			A.[Avg_Q_67_04],
			A.[Avg_Q_67_05],
			A.[Avg_Q_68_01],
			A.[Avg_Q_68_02],
			A.[Avg_Q_68_03],
			A.[Avg_Q_68_04],
			A.[Avg_Q_68_05],
			A.[Avg_Q_69_01],
			A.[Avg_Q_69_02],
			A.[Avg_Q_69_03],
			A.[Avg_Q_69_04],
			A.[Avg_Q_69_05],
			A.[Avg_Q_70_01],
			A.[Avg_Q_70_02],
			A.[Avg_Q_70_03],
			A.[Avg_Q_70_04],
			A.[Avg_Q_70_05],
			A.[NPS],
			A.[RPI_COM],
			A.[RPI_IND],
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
			A.[Facilities Z-Score],
			A.[Service Z-Score],
			A.[Value Z-Score],
			A.[Engagement Z-Score],
			A.[Health and Wellness Z-Score],
			A.[Involvement Z-Score],
			A.[Facilities Percentile],
			A.[Service Percentile],
			A.[Value Percentile],
			A.[Engagement Percentile],
			A.[Health and Wellness Percentile],
			A.[Involvement Percentile],
			A.[Sum_M_01b_01],
			A.[Sum_M_01c_01],
			A.[Sum_M_01d_01],
			A.[Sum_Q_01_01],
			A.[Sum_Q_01_02],
			A.[Sum_Q_01_03],
			A.[Sum_Q_01_04],
			A.[Sum_Q_01_05],
			A.[Sum_Q_02_01],
			A.[Sum_Q_02_02],
			A.[Sum_Q_02_03],
			A.[Sum_Q_02_04],
			A.[Sum_Q_02_05],
			A.[Sum_Q_03_01],
			A.[Sum_Q_03_02],
			A.[Sum_Q_03_03],
			A.[Sum_Q_03_04],
			A.[Sum_Q_03_05],
			A.[Sum_Q_04_01],
			A.[Sum_Q_04_02],
			A.[Sum_Q_04_03],
			A.[Sum_Q_04_04],
			A.[Sum_Q_04_05],
			A.[Sum_Q_05_01],
			A.[Sum_Q_05_02],
			A.[Sum_Q_05_03],
			A.[Sum_Q_05_04],
			A.[Sum_Q_05_05],
			A.[Sum_Q_06_01],
			A.[Sum_Q_06_02],
			A.[Sum_Q_06_03],
			A.[Sum_Q_06_04],
			A.[Sum_Q_06_05],
			A.[Sum_Q_07_01],
			A.[Sum_Q_07_02],
			A.[Sum_Q_07_03],
			A.[Sum_Q_07_04],
			A.[Sum_Q_07_05],
			A.[Sum_Q_08_01],
			A.[Sum_Q_08_02],
			A.[Sum_Q_08_03],
			A.[Sum_Q_08_04],
			A.[Sum_Q_08_05],
			A.[Sum_Q_09_01],
			A.[Sum_Q_09_02],
			A.[Sum_Q_09_03],
			A.[Sum_Q_09_04],
			A.[Sum_Q_09_05],
			A.[Sum_Q_10_01],
			A.[Sum_Q_10_02],
			A.[Sum_Q_10_03],
			A.[Sum_Q_10_04],
			A.[Sum_Q_10_05],
			A.[Sum_Q_11_01],
			A.[Sum_Q_11_02],
			A.[Sum_Q_11_03],
			A.[Sum_Q_11_04],
			A.[Sum_Q_11_05],
			A.[Sum_Q_12_01],
			A.[Sum_Q_12_02],
			A.[Sum_Q_12_03],
			A.[Sum_Q_12_04],
			A.[Sum_Q_12_05],
			A.[Sum_Q_13_01],
			A.[Sum_Q_13_02],
			A.[Sum_Q_13_03],
			A.[Sum_Q_13_04],
			A.[Sum_Q_13_05],
			A.[Sum_Q_14_01],
			A.[Sum_Q_14_02],
			A.[Sum_Q_14_03],
			A.[Sum_Q_14_04],
			A.[Sum_Q_14_05],
			A.[Sum_Q_15_01],
			A.[Sum_Q_15_02],
			A.[Sum_Q_15_03],
			A.[Sum_Q_15_04],
			A.[Sum_Q_15_05],
			A.[Sum_Q_16_01],
			A.[Sum_Q_16_02],
			A.[Sum_Q_16_03],
			A.[Sum_Q_16_04],
			A.[Sum_Q_16_05],
			A.[Sum_Q_17_01],
			A.[Sum_Q_17_02],
			A.[Sum_Q_17_03],
			A.[Sum_Q_17_04],
			A.[Sum_Q_17_05],
			A.[Sum_Q_18_01],
			A.[Sum_Q_18_02],
			A.[Sum_Q_18_03],
			A.[Sum_Q_18_04],
			A.[Sum_Q_18_05],
			A.[Sum_Q_19_01],
			A.[Sum_Q_19_02],
			A.[Sum_Q_19_03],
			A.[Sum_Q_19_04],
			A.[Sum_Q_19_05],
			A.[Sum_Q_20_01],
			A.[Sum_Q_20_02],
			A.[Sum_Q_20_03],
			A.[Sum_Q_20_04],
			A.[Sum_Q_20_05],
			A.[Sum_Q_21_01],
			A.[Sum_Q_21_02],
			A.[Sum_Q_21_03],
			A.[Sum_Q_21_04],
			A.[Sum_Q_21_05],
			A.[Sum_Q_22_01],
			A.[Sum_Q_22_02],
			A.[Sum_Q_22_03],
			A.[Sum_Q_22_04],
			A.[Sum_Q_22_05],
			A.[Sum_Q_23_01],
			A.[Sum_Q_23_02],
			A.[Sum_Q_23_03],
			A.[Sum_Q_23_04],
			A.[Sum_Q_23_05],
			A.[Sum_Q_24_01],
			A.[Sum_Q_24_02],
			A.[Sum_Q_24_03],
			A.[Sum_Q_24_04],
			A.[Sum_Q_24_05],
			A.[Sum_Q_25_01],
			A.[Sum_Q_25_02],
			A.[Sum_Q_25_03],
			A.[Sum_Q_25_04],
			A.[Sum_Q_25_05],
			A.[Sum_Q_26_01],
			A.[Sum_Q_26_02],
			A.[Sum_Q_26_03],
			A.[Sum_Q_26_04],
			A.[Sum_Q_26_05],
			A.[Sum_Q_27_01],
			A.[Sum_Q_27_02],
			A.[Sum_Q_27_03],
			A.[Sum_Q_27_04],
			A.[Sum_Q_27_05],
			A.[Sum_Q_28_01],
			A.[Sum_Q_28_02],
			A.[Sum_Q_28_03],
			A.[Sum_Q_28_04],
			A.[Sum_Q_28_05],
			A.[Sum_Q_29_01],
			A.[Sum_Q_29_02],
			A.[Sum_Q_29_03],
			A.[Sum_Q_29_04],
			A.[Sum_Q_29_05],
			A.[Sum_Q_30_01],
			A.[Sum_Q_30_02],
			A.[Sum_Q_30_03],
			A.[Sum_Q_30_04],
			A.[Sum_Q_30_05],
			A.[Sum_Q_31_01],
			A.[Sum_Q_31_02],
			A.[Sum_Q_31_03],
			A.[Sum_Q_31_04],
			A.[Sum_Q_31_05],
			A.[Sum_Q_32_00],
			A.[Sum_Q_32_01],
			A.[Sum_Q_32_10],
			A.[Sum_Q_32_02],
			A.[Sum_Q_32_03],
			A.[Sum_Q_32_04],
			A.[Sum_Q_32_05],
			A.[Sum_Q_32_06],
			A.[Sum_Q_32_07],
			A.[Sum_Q_32_08],
			A.[Sum_Q_32_09],
			A.[Sum_Q_33_01],
			A.[Sum_Q_33_02],
			A.[Sum_Q_33_03],
			A.[Sum_Q_33_04],
			A.[Sum_Q_33_05],
			A.[Sum_Q_34_01],
			A.[Sum_Q_34_02],
			A.[Sum_Q_34_03],
			A.[Sum_Q_34_04],
			A.[Sum_Q_34_05],
			A.[Sum_Q_35_00],
			A.[Sum_Q_35_01],
			A.[Sum_Q_35_10],
			A.[Sum_Q_35_02],
			A.[Sum_Q_35_03],
			A.[Sum_Q_35_04],
			A.[Sum_Q_35_05],
			A.[Sum_Q_35_06],
			A.[Sum_Q_35_07],
			A.[Sum_Q_35_08],
			A.[Sum_Q_35_09],
			A.[Sum_Q_36_01],
			A.[Sum_Q_36_02],
			A.[Sum_Q_36_03],
			A.[Sum_Q_36_04],
			A.[Sum_Q_36_05],
			A.[Sum_Q_37_01],
			A.[Sum_Q_37_02],
			A.[Sum_Q_37_03],
			A.[Sum_Q_37_04],
			A.[Sum_Q_37_05],
			A.[Sum_Q_38_01],
			A.[Sum_Q_38_02],
			A.[Sum_Q_38_03],
			A.[Sum_Q_38_04],
			A.[Sum_Q_38_05],
			A.[Sum_Q_39_01],
			A.[Sum_Q_39_02],
			A.[Sum_Q_39_03],
			A.[Sum_Q_39_04],
			A.[Sum_Q_39_05],
			A.[Sum_Q_40_01],
			A.[Sum_Q_40_02],
			A.[Sum_Q_40_03],
			A.[Sum_Q_40_04],
			A.[Sum_Q_40_05],
			A.[Sum_Q_41_01],
			A.[Sum_Q_41_02],
			A.[Sum_Q_41_03],
			A.[Sum_Q_41_04],
			A.[Sum_Q_41_05],
			A.[Sum_Q_42_01],
			A.[Sum_Q_42_02],
			A.[Sum_Q_42_03],
			A.[Sum_Q_42_04],
			A.[Sum_Q_42_05],
			A.[Sum_Q_43_01],
			A.[Sum_Q_43_02],
			A.[Sum_Q_43_03],
			A.[Sum_Q_43_04],
			A.[Sum_Q_43_05],
			A.[Sum_Q_44_01],
			A.[Sum_Q_44_02],
			A.[Sum_Q_44_03],
			A.[Sum_Q_44_04],
			A.[Sum_Q_44_05],
			A.[Sum_Q_45_01],
			A.[Sum_Q_45_02],
			A.[Sum_Q_45_03],
			A.[Sum_Q_45_04],
			A.[Sum_Q_45_05],
			A.[Sum_Q_46_00],
			A.[Sum_Q_46_01],
			A.[Sum_Q_46_10],
			A.[Sum_Q_46_02],
			A.[Sum_Q_46_03],
			A.[Sum_Q_46_04],
			A.[Sum_Q_46_05],
			A.[Sum_Q_46_06],
			A.[Sum_Q_46_07],
			A.[Sum_Q_46_08],
			A.[Sum_Q_46_09],
			A.[Sum_Q_47_01],
			A.[Sum_Q_47_02],
			A.[Sum_Q_47_03],
			A.[Sum_Q_47_04],
			A.[Sum_Q_47_05],
			A.[Sum_Q_48_01],
			A.[Sum_Q_48_02],
			A.[Sum_Q_48_03],
			A.[Sum_Q_48_04],
			A.[Sum_Q_48_05],
			A.[Sum_Q_49_01],
			A.[Sum_Q_49_02],
			A.[Sum_Q_49_03],
			A.[Sum_Q_49_04],
			A.[Sum_Q_49_05],
			A.[Sum_Q_50_01],
			A.[Sum_Q_50_02],
			A.[Sum_Q_50_03],
			A.[Sum_Q_50_04],
			A.[Sum_Q_50_05],
			A.[Sum_Q_51_01],
			A.[Sum_Q_51_02],
			A.[Sum_Q_51_03],
			A.[Sum_Q_51_04],
			A.[Sum_Q_51_05],
			A.[Sum_Q_52_01],
			A.[Sum_Q_52_02],
			A.[Sum_Q_52_03],
			A.[Sum_Q_52_04],
			A.[Sum_Q_52_05],
			A.[Sum_Q_53_01],
			A.[Sum_Q_53_02],
			A.[Sum_Q_53_03],
			A.[Sum_Q_53_04],
			A.[Sum_Q_53_05],
			A.[Sum_Q_54_01],
			A.[Sum_Q_54_02],
			A.[Sum_Q_54_03],
			A.[Sum_Q_54_04],
			A.[Sum_Q_54_05],
			A.[Sum_Q_55_01],
			A.[Sum_Q_55_02],
			A.[Sum_Q_55_03],
			A.[Sum_Q_55_04],
			A.[Sum_Q_55_05],
			A.[Sum_Q_56_01],
			A.[Sum_Q_56_02],
			A.[Sum_Q_56_03],
			A.[Sum_Q_56_04],
			A.[Sum_Q_56_05],
			A.[Sum_Q_57_01],
			A.[Sum_Q_57_02],
			A.[Sum_Q_57_03],
			A.[Sum_Q_57_04],
			A.[Sum_Q_57_05],
			A.[Sum_Q_58_01],
			A.[Sum_Q_58_02],
			A.[Sum_Q_58_03],
			A.[Sum_Q_58_04],
			A.[Sum_Q_58_05],
			A.[Sum_Q_59_01],
			A.[Sum_Q_59_02],
			A.[Sum_Q_59_03],
			A.[Sum_Q_59_04],
			A.[Sum_Q_59_05],
			A.[Sum_Q_60_01],
			A.[Sum_Q_60_02],
			A.[Sum_Q_60_03],
			A.[Sum_Q_60_04],
			A.[Sum_Q_60_05],
			A.[Sum_Q_61_01],
			A.[Sum_Q_61_02],
			A.[Sum_Q_61_03],
			A.[Sum_Q_61_04],
			A.[Sum_Q_61_05],
			A.[Sum_Q_62_01],
			A.[Sum_Q_62_02],
			A.[Sum_Q_62_03],
			A.[Sum_Q_62_04],
			A.[Sum_Q_62_05],
			A.[Sum_Q_63_01],
			A.[Sum_Q_63_02],
			A.[Sum_Q_63_03],
			A.[Sum_Q_63_04],
			A.[Sum_Q_63_05],
			A.[Sum_Q_64_01],
			A.[Sum_Q_64_02],
			A.[Sum_Q_64_03],
			A.[Sum_Q_64_04],
			A.[Sum_Q_64_05],
			A.[Sum_Q_64_06],
			A.[Sum_Q_65_01],
			A.[Sum_Q_65_02],
			A.[Sum_Q_65_03],
			A.[Sum_Q_65_04],
			A.[Sum_Q_65_05],
			A.[Sum_Q_65_06],
			A.[Sum_Q_66_01],
			A.[Sum_Q_66_02],
			A.[Sum_Q_66_03],
			A.[Sum_Q_66_04],
			A.[Sum_Q_66_05],
			A.[Sum_Q_67_01],
			A.[Sum_Q_67_02],
			A.[Sum_Q_67_03],
			A.[Sum_Q_67_04],
			A.[Sum_Q_67_05],
			A.[Sum_Q_68_01],
			A.[Sum_Q_68_02],
			A.[Sum_Q_68_03],
			A.[Sum_Q_68_04],
			A.[Sum_Q_68_05],
			A.[Sum_Q_69_01],
			A.[Sum_Q_69_02],
			A.[Sum_Q_69_03],
			A.[Sum_Q_69_04],
			A.[Sum_Q_69_05],
			A.[Sum_Q_70_01],
			A.[Sum_Q_70_02],
			A.[Sum_Q_70_03],
			A.[Sum_Q_70_04],
			A.[Sum_Q_70_05],
			A.[CreateDatetime]
			
	FROM	Seer_STG.dbo.[Member Aggregated Data] A

	WHERE	LEN(A.Form_Code) = 0
			--OR (ISNUMERIC(COALESCE(A.[Response_Count], '0')) = 0)
			OR ((ISNUMERIC(COALESCE([Avg_M_01a_01], '')) = 0 AND LEN([Avg_M_01a_01]) > 0) OR (ISNUMERIC([Avg_M_01a_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01a_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_M_01b_01], '')) = 0 AND LEN([Avg_M_01b_01]) > 0) OR (ISNUMERIC([Avg_M_01b_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01b_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_M_01c_01], '')) = 0 AND LEN([Avg_M_01c_01]) > 0) OR (ISNUMERIC([Avg_M_01c_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01c_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_M_01d_01], '')) = 0 AND LEN([Avg_M_01d_01]) > 0) OR (ISNUMERIC([Avg_M_01d_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_M_01d_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_01_01], '')) = 0 AND LEN([Avg_Q_01_01]) > 0) OR (ISNUMERIC([Avg_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_01_02], '')) = 0 AND LEN([Avg_Q_01_02]) > 0) OR (ISNUMERIC([Avg_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_01_03], '')) = 0 AND LEN([Avg_Q_01_03]) > 0) OR (ISNUMERIC([Avg_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_01_04], '')) = 0 AND LEN([Avg_Q_01_04]) > 0) OR (ISNUMERIC([Avg_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_01_05], '')) = 0 AND LEN([Avg_Q_01_05]) > 0) OR (ISNUMERIC([Avg_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_01_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_02_01], '')) = 0 AND LEN([Avg_Q_02_01]) > 0) OR (ISNUMERIC([Avg_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_02_02], '')) = 0 AND LEN([Avg_Q_02_02]) > 0) OR (ISNUMERIC([Avg_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_02_03], '')) = 0 AND LEN([Avg_Q_02_03]) > 0) OR (ISNUMERIC([Avg_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_02_04], '')) = 0 AND LEN([Avg_Q_02_04]) > 0) OR (ISNUMERIC([Avg_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_02_05], '')) = 0 AND LEN([Avg_Q_02_05]) > 0) OR (ISNUMERIC([Avg_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_02_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_03_01], '')) = 0 AND LEN([Avg_Q_03_01]) > 0) OR (ISNUMERIC([Avg_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_03_02], '')) = 0 AND LEN([Avg_Q_03_02]) > 0) OR (ISNUMERIC([Avg_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_03_03], '')) = 0 AND LEN([Avg_Q_03_03]) > 0) OR (ISNUMERIC([Avg_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_03_04], '')) = 0 AND LEN([Avg_Q_03_04]) > 0) OR (ISNUMERIC([Avg_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_03_05], '')) = 0 AND LEN([Avg_Q_03_05]) > 0) OR (ISNUMERIC([Avg_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_03_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_04_01], '')) = 0 AND LEN([Avg_Q_04_01]) > 0) OR (ISNUMERIC([Avg_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_04_02], '')) = 0 AND LEN([Avg_Q_04_02]) > 0) OR (ISNUMERIC([Avg_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_04_03], '')) = 0 AND LEN([Avg_Q_04_03]) > 0) OR (ISNUMERIC([Avg_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_04_04], '')) = 0 AND LEN([Avg_Q_04_04]) > 0) OR (ISNUMERIC([Avg_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_04_05], '')) = 0 AND LEN([Avg_Q_04_05]) > 0) OR (ISNUMERIC([Avg_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_04_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_05_01], '')) = 0 AND LEN([Avg_Q_05_01]) > 0) OR (ISNUMERIC([Avg_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_05_02], '')) = 0 AND LEN([Avg_Q_05_02]) > 0) OR (ISNUMERIC([Avg_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_05_03], '')) = 0 AND LEN([Avg_Q_05_03]) > 0) OR (ISNUMERIC([Avg_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_05_04], '')) = 0 AND LEN([Avg_Q_05_04]) > 0) OR (ISNUMERIC([Avg_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_05_05], '')) = 0 AND LEN([Avg_Q_05_05]) > 0) OR (ISNUMERIC([Avg_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_05_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_06_01], '')) = 0 AND LEN([Avg_Q_06_01]) > 0) OR (ISNUMERIC([Avg_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_06_02], '')) = 0 AND LEN([Avg_Q_06_02]) > 0) OR (ISNUMERIC([Avg_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_06_03], '')) = 0 AND LEN([Avg_Q_06_03]) > 0) OR (ISNUMERIC([Avg_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_06_04], '')) = 0 AND LEN([Avg_Q_06_04]) > 0) OR (ISNUMERIC([Avg_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_06_05], '')) = 0 AND LEN([Avg_Q_06_05]) > 0) OR (ISNUMERIC([Avg_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_06_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_07_01], '')) = 0 AND LEN([Avg_Q_07_01]) > 0) OR (ISNUMERIC([Avg_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_07_02], '')) = 0 AND LEN([Avg_Q_07_02]) > 0) OR (ISNUMERIC([Avg_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_07_03], '')) = 0 AND LEN([Avg_Q_07_03]) > 0) OR (ISNUMERIC([Avg_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_07_04], '')) = 0 AND LEN([Avg_Q_07_04]) > 0) OR (ISNUMERIC([Avg_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_07_05], '')) = 0 AND LEN([Avg_Q_07_05]) > 0) OR (ISNUMERIC([Avg_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_07_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_08_01], '')) = 0 AND LEN([Avg_Q_08_01]) > 0) OR (ISNUMERIC([Avg_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_08_02], '')) = 0 AND LEN([Avg_Q_08_02]) > 0) OR (ISNUMERIC([Avg_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_08_03], '')) = 0 AND LEN([Avg_Q_08_03]) > 0) OR (ISNUMERIC([Avg_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_08_04], '')) = 0 AND LEN([Avg_Q_08_04]) > 0) OR (ISNUMERIC([Avg_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_08_05], '')) = 0 AND LEN([Avg_Q_08_05]) > 0) OR (ISNUMERIC([Avg_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_08_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_09_01], '')) = 0 AND LEN([Avg_Q_09_01]) > 0) OR (ISNUMERIC([Avg_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_09_02], '')) = 0 AND LEN([Avg_Q_09_02]) > 0) OR (ISNUMERIC([Avg_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_09_03], '')) = 0 AND LEN([Avg_Q_09_03]) > 0) OR (ISNUMERIC([Avg_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_09_04], '')) = 0 AND LEN([Avg_Q_09_04]) > 0) OR (ISNUMERIC([Avg_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_09_05], '')) = 0 AND LEN([Avg_Q_09_05]) > 0) OR (ISNUMERIC([Avg_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_09_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_10_01], '')) = 0 AND LEN([Avg_Q_10_01]) > 0) OR (ISNUMERIC([Avg_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_10_02], '')) = 0 AND LEN([Avg_Q_10_02]) > 0) OR (ISNUMERIC([Avg_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_10_03], '')) = 0 AND LEN([Avg_Q_10_03]) > 0) OR (ISNUMERIC([Avg_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_10_04], '')) = 0 AND LEN([Avg_Q_10_04]) > 0) OR (ISNUMERIC([Avg_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_10_05], '')) = 0 AND LEN([Avg_Q_10_05]) > 0) OR (ISNUMERIC([Avg_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_10_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_11_01], '')) = 0 AND LEN([Avg_Q_11_01]) > 0) OR (ISNUMERIC([Avg_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_11_02], '')) = 0 AND LEN([Avg_Q_11_02]) > 0) OR (ISNUMERIC([Avg_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_11_03], '')) = 0 AND LEN([Avg_Q_11_03]) > 0) OR (ISNUMERIC([Avg_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_11_04], '')) = 0 AND LEN([Avg_Q_11_04]) > 0) OR (ISNUMERIC([Avg_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_11_05], '')) = 0 AND LEN([Avg_Q_11_05]) > 0) OR (ISNUMERIC([Avg_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_11_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_12_01], '')) = 0 AND LEN([Avg_Q_12_01]) > 0) OR (ISNUMERIC([Avg_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_12_02], '')) = 0 AND LEN([Avg_Q_12_02]) > 0) OR (ISNUMERIC([Avg_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_12_03], '')) = 0 AND LEN([Avg_Q_12_03]) > 0) OR (ISNUMERIC([Avg_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_12_04], '')) = 0 AND LEN([Avg_Q_12_04]) > 0) OR (ISNUMERIC([Avg_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_12_05], '')) = 0 AND LEN([Avg_Q_12_05]) > 0) OR (ISNUMERIC([Avg_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_12_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_13_01], '')) = 0 AND LEN([Avg_Q_13_01]) > 0) OR (ISNUMERIC([Avg_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_13_02], '')) = 0 AND LEN([Avg_Q_13_02]) > 0) OR (ISNUMERIC([Avg_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_13_03], '')) = 0 AND LEN([Avg_Q_13_03]) > 0) OR (ISNUMERIC([Avg_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_13_04], '')) = 0 AND LEN([Avg_Q_13_04]) > 0) OR (ISNUMERIC([Avg_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_13_05], '')) = 0 AND LEN([Avg_Q_13_05]) > 0) OR (ISNUMERIC([Avg_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_13_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_14_01], '')) = 0 AND LEN([Avg_Q_14_01]) > 0) OR (ISNUMERIC([Avg_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_14_02], '')) = 0 AND LEN([Avg_Q_14_02]) > 0) OR (ISNUMERIC([Avg_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_14_03], '')) = 0 AND LEN([Avg_Q_14_03]) > 0) OR (ISNUMERIC([Avg_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_14_04], '')) = 0 AND LEN([Avg_Q_14_04]) > 0) OR (ISNUMERIC([Avg_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_14_05], '')) = 0 AND LEN([Avg_Q_14_05]) > 0) OR (ISNUMERIC([Avg_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_14_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_15_01], '')) = 0 AND LEN([Avg_Q_15_01]) > 0) OR (ISNUMERIC([Avg_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_15_02], '')) = 0 AND LEN([Avg_Q_15_02]) > 0) OR (ISNUMERIC([Avg_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_15_03], '')) = 0 AND LEN([Avg_Q_15_03]) > 0) OR (ISNUMERIC([Avg_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_15_04], '')) = 0 AND LEN([Avg_Q_15_04]) > 0) OR (ISNUMERIC([Avg_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_15_05], '')) = 0 AND LEN([Avg_Q_15_05]) > 0) OR (ISNUMERIC([Avg_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_15_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_16_01], '')) = 0 AND LEN([Avg_Q_16_01]) > 0) OR (ISNUMERIC([Avg_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_16_02], '')) = 0 AND LEN([Avg_Q_16_02]) > 0) OR (ISNUMERIC([Avg_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_16_03], '')) = 0 AND LEN([Avg_Q_16_03]) > 0) OR (ISNUMERIC([Avg_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_16_04], '')) = 0 AND LEN([Avg_Q_16_04]) > 0) OR (ISNUMERIC([Avg_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_16_05], '')) = 0 AND LEN([Avg_Q_16_05]) > 0) OR (ISNUMERIC([Avg_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_16_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_17_01], '')) = 0 AND LEN([Avg_Q_17_01]) > 0) OR (ISNUMERIC([Avg_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_17_02], '')) = 0 AND LEN([Avg_Q_17_02]) > 0) OR (ISNUMERIC([Avg_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_17_03], '')) = 0 AND LEN([Avg_Q_17_03]) > 0) OR (ISNUMERIC([Avg_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_17_04], '')) = 0 AND LEN([Avg_Q_17_04]) > 0) OR (ISNUMERIC([Avg_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_17_05], '')) = 0 AND LEN([Avg_Q_17_05]) > 0) OR (ISNUMERIC([Avg_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_17_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_18_01], '')) = 0 AND LEN([Avg_Q_18_01]) > 0) OR (ISNUMERIC([Avg_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_18_02], '')) = 0 AND LEN([Avg_Q_18_02]) > 0) OR (ISNUMERIC([Avg_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_18_03], '')) = 0 AND LEN([Avg_Q_18_03]) > 0) OR (ISNUMERIC([Avg_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_18_04], '')) = 0 AND LEN([Avg_Q_18_04]) > 0) OR (ISNUMERIC([Avg_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_18_05], '')) = 0 AND LEN([Avg_Q_18_05]) > 0) OR (ISNUMERIC([Avg_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_18_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_19_01], '')) = 0 AND LEN([Avg_Q_19_01]) > 0) OR (ISNUMERIC([Avg_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_19_02], '')) = 0 AND LEN([Avg_Q_19_02]) > 0) OR (ISNUMERIC([Avg_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_19_03], '')) = 0 AND LEN([Avg_Q_19_03]) > 0) OR (ISNUMERIC([Avg_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_19_04], '')) = 0 AND LEN([Avg_Q_19_04]) > 0) OR (ISNUMERIC([Avg_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_19_05], '')) = 0 AND LEN([Avg_Q_19_05]) > 0) OR (ISNUMERIC([Avg_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_19_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_20_01], '')) = 0 AND LEN([Avg_Q_20_01]) > 0) OR (ISNUMERIC([Avg_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_20_02], '')) = 0 AND LEN([Avg_Q_20_02]) > 0) OR (ISNUMERIC([Avg_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_20_03], '')) = 0 AND LEN([Avg_Q_20_03]) > 0) OR (ISNUMERIC([Avg_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_20_04], '')) = 0 AND LEN([Avg_Q_20_04]) > 0) OR (ISNUMERIC([Avg_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_20_05], '')) = 0 AND LEN([Avg_Q_20_05]) > 0) OR (ISNUMERIC([Avg_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_20_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_21_01], '')) = 0 AND LEN([Avg_Q_21_01]) > 0) OR (ISNUMERIC([Avg_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_21_02], '')) = 0 AND LEN([Avg_Q_21_02]) > 0) OR (ISNUMERIC([Avg_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_21_03], '')) = 0 AND LEN([Avg_Q_21_03]) > 0) OR (ISNUMERIC([Avg_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_21_04], '')) = 0 AND LEN([Avg_Q_21_04]) > 0) OR (ISNUMERIC([Avg_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_21_05], '')) = 0 AND LEN([Avg_Q_21_05]) > 0) OR (ISNUMERIC([Avg_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_21_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_22_01], '')) = 0 AND LEN([Avg_Q_22_01]) > 0) OR (ISNUMERIC([Avg_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_22_02], '')) = 0 AND LEN([Avg_Q_22_02]) > 0) OR (ISNUMERIC([Avg_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_22_03], '')) = 0 AND LEN([Avg_Q_22_03]) > 0) OR (ISNUMERIC([Avg_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_22_04], '')) = 0 AND LEN([Avg_Q_22_04]) > 0) OR (ISNUMERIC([Avg_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_22_05], '')) = 0 AND LEN([Avg_Q_22_05]) > 0) OR (ISNUMERIC([Avg_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_22_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_23_01], '')) = 0 AND LEN([Avg_Q_23_01]) > 0) OR (ISNUMERIC([Avg_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_23_02], '')) = 0 AND LEN([Avg_Q_23_02]) > 0) OR (ISNUMERIC([Avg_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_23_03], '')) = 0 AND LEN([Avg_Q_23_03]) > 0) OR (ISNUMERIC([Avg_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_23_04], '')) = 0 AND LEN([Avg_Q_23_04]) > 0) OR (ISNUMERIC([Avg_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_23_05], '')) = 0 AND LEN([Avg_Q_23_05]) > 0) OR (ISNUMERIC([Avg_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_23_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_24_01], '')) = 0 AND LEN([Avg_Q_24_01]) > 0) OR (ISNUMERIC([Avg_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_24_02], '')) = 0 AND LEN([Avg_Q_24_02]) > 0) OR (ISNUMERIC([Avg_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_24_03], '')) = 0 AND LEN([Avg_Q_24_03]) > 0) OR (ISNUMERIC([Avg_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_24_04], '')) = 0 AND LEN([Avg_Q_24_04]) > 0) OR (ISNUMERIC([Avg_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_24_05], '')) = 0 AND LEN([Avg_Q_24_05]) > 0) OR (ISNUMERIC([Avg_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_24_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_25_01], '')) = 0 AND LEN([Avg_Q_25_01]) > 0) OR (ISNUMERIC([Avg_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_25_02], '')) = 0 AND LEN([Avg_Q_25_02]) > 0) OR (ISNUMERIC([Avg_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_25_03], '')) = 0 AND LEN([Avg_Q_25_03]) > 0) OR (ISNUMERIC([Avg_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_25_04], '')) = 0 AND LEN([Avg_Q_25_04]) > 0) OR (ISNUMERIC([Avg_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_25_05], '')) = 0 AND LEN([Avg_Q_25_05]) > 0) OR (ISNUMERIC([Avg_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_25_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_26_01], '')) = 0 AND LEN([Avg_Q_26_01]) > 0) OR (ISNUMERIC([Avg_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_26_02], '')) = 0 AND LEN([Avg_Q_26_02]) > 0) OR (ISNUMERIC([Avg_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_26_03], '')) = 0 AND LEN([Avg_Q_26_03]) > 0) OR (ISNUMERIC([Avg_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_26_04], '')) = 0 AND LEN([Avg_Q_26_04]) > 0) OR (ISNUMERIC([Avg_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_26_05], '')) = 0 AND LEN([Avg_Q_26_05]) > 0) OR (ISNUMERIC([Avg_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_26_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_27_01], '')) = 0 AND LEN([Avg_Q_27_01]) > 0) OR (ISNUMERIC([Avg_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_27_02], '')) = 0 AND LEN([Avg_Q_27_02]) > 0) OR (ISNUMERIC([Avg_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_27_03], '')) = 0 AND LEN([Avg_Q_27_03]) > 0) OR (ISNUMERIC([Avg_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_27_04], '')) = 0 AND LEN([Avg_Q_27_04]) > 0) OR (ISNUMERIC([Avg_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_27_05], '')) = 0 AND LEN([Avg_Q_27_05]) > 0) OR (ISNUMERIC([Avg_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_27_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_28_01], '')) = 0 AND LEN([Avg_Q_28_01]) > 0) OR (ISNUMERIC([Avg_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_28_02], '')) = 0 AND LEN([Avg_Q_28_02]) > 0) OR (ISNUMERIC([Avg_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_28_03], '')) = 0 AND LEN([Avg_Q_28_03]) > 0) OR (ISNUMERIC([Avg_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_28_04], '')) = 0 AND LEN([Avg_Q_28_04]) > 0) OR (ISNUMERIC([Avg_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_28_05], '')) = 0 AND LEN([Avg_Q_28_05]) > 0) OR (ISNUMERIC([Avg_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_28_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_29_01], '')) = 0 AND LEN([Avg_Q_29_01]) > 0) OR (ISNUMERIC([Avg_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_29_02], '')) = 0 AND LEN([Avg_Q_29_02]) > 0) OR (ISNUMERIC([Avg_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_29_03], '')) = 0 AND LEN([Avg_Q_29_03]) > 0) OR (ISNUMERIC([Avg_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_29_04], '')) = 0 AND LEN([Avg_Q_29_04]) > 0) OR (ISNUMERIC([Avg_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_29_05], '')) = 0 AND LEN([Avg_Q_29_05]) > 0) OR (ISNUMERIC([Avg_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_29_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_30_01], '')) = 0 AND LEN([Avg_Q_30_01]) > 0) OR (ISNUMERIC([Avg_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_30_02], '')) = 0 AND LEN([Avg_Q_30_02]) > 0) OR (ISNUMERIC([Avg_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_30_03], '')) = 0 AND LEN([Avg_Q_30_03]) > 0) OR (ISNUMERIC([Avg_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_30_04], '')) = 0 AND LEN([Avg_Q_30_04]) > 0) OR (ISNUMERIC([Avg_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_30_05], '')) = 0 AND LEN([Avg_Q_30_05]) > 0) OR (ISNUMERIC([Avg_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_30_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_31_01], '')) = 0 AND LEN([Avg_Q_31_01]) > 0) OR (ISNUMERIC([Avg_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_31_02], '')) = 0 AND LEN([Avg_Q_31_02]) > 0) OR (ISNUMERIC([Avg_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_31_03], '')) = 0 AND LEN([Avg_Q_31_03]) > 0) OR (ISNUMERIC([Avg_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_31_04], '')) = 0 AND LEN([Avg_Q_31_04]) > 0) OR (ISNUMERIC([Avg_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_31_05], '')) = 0 AND LEN([Avg_Q_31_05]) > 0) OR (ISNUMERIC([Avg_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_31_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_00], '')) = 0 AND LEN([Avg_Q_32_00]) > 0) OR (ISNUMERIC([Avg_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_00]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_01], '')) = 0 AND LEN([Avg_Q_32_01]) > 0) OR (ISNUMERIC([Avg_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_10], '')) = 0 AND LEN([Avg_Q_32_10]) > 0) OR (ISNUMERIC([Avg_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_10]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_02], '')) = 0 AND LEN([Avg_Q_32_02]) > 0) OR (ISNUMERIC([Avg_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_03], '')) = 0 AND LEN([Avg_Q_32_03]) > 0) OR (ISNUMERIC([Avg_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_04], '')) = 0 AND LEN([Avg_Q_32_04]) > 0) OR (ISNUMERIC([Avg_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_05], '')) = 0 AND LEN([Avg_Q_32_05]) > 0) OR (ISNUMERIC([Avg_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_06], '')) = 0 AND LEN([Avg_Q_32_06]) > 0) OR (ISNUMERIC([Avg_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_07], '')) = 0 AND LEN([Avg_Q_32_07]) > 0) OR (ISNUMERIC([Avg_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_07]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_08], '')) = 0 AND LEN([Avg_Q_32_08]) > 0) OR (ISNUMERIC([Avg_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_08]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_32_09], '')) = 0 AND LEN([Avg_Q_32_09]) > 0) OR (ISNUMERIC([Avg_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_32_09]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_33_01], '')) = 0 AND LEN([Avg_Q_33_01]) > 0) OR (ISNUMERIC([Avg_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_33_02], '')) = 0 AND LEN([Avg_Q_33_02]) > 0) OR (ISNUMERIC([Avg_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_33_03], '')) = 0 AND LEN([Avg_Q_33_03]) > 0) OR (ISNUMERIC([Avg_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_33_04], '')) = 0 AND LEN([Avg_Q_33_04]) > 0) OR (ISNUMERIC([Avg_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_33_05], '')) = 0 AND LEN([Avg_Q_33_05]) > 0) OR (ISNUMERIC([Avg_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_33_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_34_01], '')) = 0 AND LEN([Avg_Q_34_01]) > 0) OR (ISNUMERIC([Avg_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_34_02], '')) = 0 AND LEN([Avg_Q_34_02]) > 0) OR (ISNUMERIC([Avg_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_34_03], '')) = 0 AND LEN([Avg_Q_34_03]) > 0) OR (ISNUMERIC([Avg_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_34_04], '')) = 0 AND LEN([Avg_Q_34_04]) > 0) OR (ISNUMERIC([Avg_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_34_05], '')) = 0 AND LEN([Avg_Q_34_05]) > 0) OR (ISNUMERIC([Avg_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_34_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_00], '')) = 0 AND LEN([Avg_Q_35_00]) > 0) OR (ISNUMERIC([Avg_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_00]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_01], '')) = 0 AND LEN([Avg_Q_35_01]) > 0) OR (ISNUMERIC([Avg_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_10], '')) = 0 AND LEN([Avg_Q_35_10]) > 0) OR (ISNUMERIC([Avg_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_10]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_02], '')) = 0 AND LEN([Avg_Q_35_02]) > 0) OR (ISNUMERIC([Avg_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_03], '')) = 0 AND LEN([Avg_Q_35_03]) > 0) OR (ISNUMERIC([Avg_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_04], '')) = 0 AND LEN([Avg_Q_35_04]) > 0) OR (ISNUMERIC([Avg_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_05], '')) = 0 AND LEN([Avg_Q_35_05]) > 0) OR (ISNUMERIC([Avg_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_06], '')) = 0 AND LEN([Avg_Q_35_06]) > 0) OR (ISNUMERIC([Avg_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_07], '')) = 0 AND LEN([Avg_Q_35_07]) > 0) OR (ISNUMERIC([Avg_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_07]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_08], '')) = 0 AND LEN([Avg_Q_35_08]) > 0) OR (ISNUMERIC([Avg_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_08]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_35_09], '')) = 0 AND LEN([Avg_Q_35_09]) > 0) OR (ISNUMERIC([Avg_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_35_09]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_36_01], '')) = 0 AND LEN([Avg_Q_36_01]) > 0) OR (ISNUMERIC([Avg_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_36_02], '')) = 0 AND LEN([Avg_Q_36_02]) > 0) OR (ISNUMERIC([Avg_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_36_03], '')) = 0 AND LEN([Avg_Q_36_03]) > 0) OR (ISNUMERIC([Avg_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_36_04], '')) = 0 AND LEN([Avg_Q_36_04]) > 0) OR (ISNUMERIC([Avg_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_36_05], '')) = 0 AND LEN([Avg_Q_36_05]) > 0) OR (ISNUMERIC([Avg_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_36_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_37_01], '')) = 0 AND LEN([Avg_Q_37_01]) > 0) OR (ISNUMERIC([Avg_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_37_02], '')) = 0 AND LEN([Avg_Q_37_02]) > 0) OR (ISNUMERIC([Avg_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_37_03], '')) = 0 AND LEN([Avg_Q_37_03]) > 0) OR (ISNUMERIC([Avg_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_37_04], '')) = 0 AND LEN([Avg_Q_37_04]) > 0) OR (ISNUMERIC([Avg_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_37_05], '')) = 0 AND LEN([Avg_Q_37_05]) > 0) OR (ISNUMERIC([Avg_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_37_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_38_01], '')) = 0 AND LEN([Avg_Q_38_01]) > 0) OR (ISNUMERIC([Avg_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_38_02], '')) = 0 AND LEN([Avg_Q_38_02]) > 0) OR (ISNUMERIC([Avg_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_38_03], '')) = 0 AND LEN([Avg_Q_38_03]) > 0) OR (ISNUMERIC([Avg_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_38_04], '')) = 0 AND LEN([Avg_Q_38_04]) > 0) OR (ISNUMERIC([Avg_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_38_05], '')) = 0 AND LEN([Avg_Q_38_05]) > 0) OR (ISNUMERIC([Avg_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_38_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_39_01], '')) = 0 AND LEN([Avg_Q_39_01]) > 0) OR (ISNUMERIC([Avg_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_39_02], '')) = 0 AND LEN([Avg_Q_39_02]) > 0) OR (ISNUMERIC([Avg_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_39_03], '')) = 0 AND LEN([Avg_Q_39_03]) > 0) OR (ISNUMERIC([Avg_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_39_04], '')) = 0 AND LEN([Avg_Q_39_04]) > 0) OR (ISNUMERIC([Avg_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_39_05], '')) = 0 AND LEN([Avg_Q_39_05]) > 0) OR (ISNUMERIC([Avg_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_39_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_40_01], '')) = 0 AND LEN([Avg_Q_40_01]) > 0) OR (ISNUMERIC([Avg_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_40_02], '')) = 0 AND LEN([Avg_Q_40_02]) > 0) OR (ISNUMERIC([Avg_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_40_03], '')) = 0 AND LEN([Avg_Q_40_03]) > 0) OR (ISNUMERIC([Avg_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_40_04], '')) = 0 AND LEN([Avg_Q_40_04]) > 0) OR (ISNUMERIC([Avg_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_40_05], '')) = 0 AND LEN([Avg_Q_40_05]) > 0) OR (ISNUMERIC([Avg_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_40_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_41_01], '')) = 0 AND LEN([Avg_Q_41_01]) > 0) OR (ISNUMERIC([Avg_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_41_02], '')) = 0 AND LEN([Avg_Q_41_02]) > 0) OR (ISNUMERIC([Avg_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_41_03], '')) = 0 AND LEN([Avg_Q_41_03]) > 0) OR (ISNUMERIC([Avg_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_41_04], '')) = 0 AND LEN([Avg_Q_41_04]) > 0) OR (ISNUMERIC([Avg_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_41_05], '')) = 0 AND LEN([Avg_Q_41_05]) > 0) OR (ISNUMERIC([Avg_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_41_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_42_01], '')) = 0 AND LEN([Avg_Q_42_01]) > 0) OR (ISNUMERIC([Avg_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_42_02], '')) = 0 AND LEN([Avg_Q_42_02]) > 0) OR (ISNUMERIC([Avg_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_42_03], '')) = 0 AND LEN([Avg_Q_42_03]) > 0) OR (ISNUMERIC([Avg_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_42_04], '')) = 0 AND LEN([Avg_Q_42_04]) > 0) OR (ISNUMERIC([Avg_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_42_05], '')) = 0 AND LEN([Avg_Q_42_05]) > 0) OR (ISNUMERIC([Avg_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_42_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_00], '')) = 0 AND LEN([Avg_Q_43_00]) > 0) OR (ISNUMERIC([Avg_Q_43_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_00]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_01], '')) = 0 AND LEN([Avg_Q_43_01]) > 0) OR (ISNUMERIC([Avg_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_02], '')) = 0 AND LEN([Avg_Q_43_02]) > 0) OR (ISNUMERIC([Avg_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_03], '')) = 0 AND LEN([Avg_Q_43_03]) > 0) OR (ISNUMERIC([Avg_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_04], '')) = 0 AND LEN([Avg_Q_43_04]) > 0) OR (ISNUMERIC([Avg_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_05], '')) = 0 AND LEN([Avg_Q_43_05]) > 0) OR (ISNUMERIC([Avg_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_06], '')) = 0 AND LEN([Avg_Q_43_06]) > 0) OR (ISNUMERIC([Avg_Q_43_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_07], '')) = 0 AND LEN([Avg_Q_43_07]) > 0) OR (ISNUMERIC([Avg_Q_43_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_07]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_08], '')) = 0 AND LEN([Avg_Q_43_08]) > 0) OR (ISNUMERIC([Avg_Q_43_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_08]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_09], '')) = 0 AND LEN([Avg_Q_43_09]) > 0) OR (ISNUMERIC([Avg_Q_43_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_09]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_43_10], '')) = 0 AND LEN([Avg_Q_43_10]) > 0) OR (ISNUMERIC([Avg_Q_43_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_43_10]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_44_01], '')) = 0 AND LEN([Avg_Q_44_01]) > 0) OR (ISNUMERIC([Avg_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_44_02], '')) = 0 AND LEN([Avg_Q_44_02]) > 0) OR (ISNUMERIC([Avg_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_44_03], '')) = 0 AND LEN([Avg_Q_44_03]) > 0) OR (ISNUMERIC([Avg_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_44_04], '')) = 0 AND LEN([Avg_Q_44_04]) > 0) OR (ISNUMERIC([Avg_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_44_05], '')) = 0 AND LEN([Avg_Q_44_05]) > 0) OR (ISNUMERIC([Avg_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_44_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_45_01], '')) = 0 AND LEN([Avg_Q_45_01]) > 0) OR (ISNUMERIC([Avg_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_45_02], '')) = 0 AND LEN([Avg_Q_45_02]) > 0) OR (ISNUMERIC([Avg_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_45_03], '')) = 0 AND LEN([Avg_Q_45_03]) > 0) OR (ISNUMERIC([Avg_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_45_04], '')) = 0 AND LEN([Avg_Q_45_04]) > 0) OR (ISNUMERIC([Avg_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_45_05], '')) = 0 AND LEN([Avg_Q_45_05]) > 0) OR (ISNUMERIC([Avg_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_45_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_00], '')) = 0 AND LEN([Avg_Q_46_00]) > 0) OR (ISNUMERIC([Avg_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_00]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_01], '')) = 0 AND LEN([Avg_Q_46_01]) > 0) OR (ISNUMERIC([Avg_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_10], '')) = 0 AND LEN([Avg_Q_46_10]) > 0) OR (ISNUMERIC([Avg_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_10]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_02], '')) = 0 AND LEN([Avg_Q_46_02]) > 0) OR (ISNUMERIC([Avg_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_03], '')) = 0 AND LEN([Avg_Q_46_03]) > 0) OR (ISNUMERIC([Avg_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_04], '')) = 0 AND LEN([Avg_Q_46_04]) > 0) OR (ISNUMERIC([Avg_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_05], '')) = 0 AND LEN([Avg_Q_46_05]) > 0) OR (ISNUMERIC([Avg_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_06], '')) = 0 AND LEN([Avg_Q_46_06]) > 0) OR (ISNUMERIC([Avg_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_07], '')) = 0 AND LEN([Avg_Q_46_07]) > 0) OR (ISNUMERIC([Avg_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_07]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_08], '')) = 0 AND LEN([Avg_Q_46_08]) > 0) OR (ISNUMERIC([Avg_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_08]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_46_09], '')) = 0 AND LEN([Avg_Q_46_09]) > 0) OR (ISNUMERIC([Avg_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_46_09]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_47_01], '')) = 0 AND LEN([Avg_Q_47_01]) > 0) OR (ISNUMERIC([Avg_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_47_02], '')) = 0 AND LEN([Avg_Q_47_02]) > 0) OR (ISNUMERIC([Avg_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_47_03], '')) = 0 AND LEN([Avg_Q_47_03]) > 0) OR (ISNUMERIC([Avg_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_47_04], '')) = 0 AND LEN([Avg_Q_47_04]) > 0) OR (ISNUMERIC([Avg_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_47_05], '')) = 0 AND LEN([Avg_Q_47_05]) > 0) OR (ISNUMERIC([Avg_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_47_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_48_01], '')) = 0 AND LEN([Avg_Q_48_01]) > 0) OR (ISNUMERIC([Avg_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_48_02], '')) = 0 AND LEN([Avg_Q_48_02]) > 0) OR (ISNUMERIC([Avg_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_48_03], '')) = 0 AND LEN([Avg_Q_48_03]) > 0) OR (ISNUMERIC([Avg_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_48_04], '')) = 0 AND LEN([Avg_Q_48_04]) > 0) OR (ISNUMERIC([Avg_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_48_05], '')) = 0 AND LEN([Avg_Q_48_05]) > 0) OR (ISNUMERIC([Avg_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_48_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_49_01], '')) = 0 AND LEN([Avg_Q_49_01]) > 0) OR (ISNUMERIC([Avg_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_49_02], '')) = 0 AND LEN([Avg_Q_49_02]) > 0) OR (ISNUMERIC([Avg_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_49_03], '')) = 0 AND LEN([Avg_Q_49_03]) > 0) OR (ISNUMERIC([Avg_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_49_04], '')) = 0 AND LEN([Avg_Q_49_04]) > 0) OR (ISNUMERIC([Avg_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_49_05], '')) = 0 AND LEN([Avg_Q_49_05]) > 0) OR (ISNUMERIC([Avg_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_49_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_50_01], '')) = 0 AND LEN([Avg_Q_50_01]) > 0) OR (ISNUMERIC([Avg_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_50_02], '')) = 0 AND LEN([Avg_Q_50_02]) > 0) OR (ISNUMERIC([Avg_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_50_03], '')) = 0 AND LEN([Avg_Q_50_03]) > 0) OR (ISNUMERIC([Avg_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_50_04], '')) = 0 AND LEN([Avg_Q_50_04]) > 0) OR (ISNUMERIC([Avg_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_50_05], '')) = 0 AND LEN([Avg_Q_50_05]) > 0) OR (ISNUMERIC([Avg_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_50_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_51_01], '')) = 0 AND LEN([Avg_Q_51_01]) > 0) OR (ISNUMERIC([Avg_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_51_02], '')) = 0 AND LEN([Avg_Q_51_02]) > 0) OR (ISNUMERIC([Avg_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_51_03], '')) = 0 AND LEN([Avg_Q_51_03]) > 0) OR (ISNUMERIC([Avg_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_51_04], '')) = 0 AND LEN([Avg_Q_51_04]) > 0) OR (ISNUMERIC([Avg_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_51_05], '')) = 0 AND LEN([Avg_Q_51_05]) > 0) OR (ISNUMERIC([Avg_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_51_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_52_01], '')) = 0 AND LEN([Avg_Q_52_01]) > 0) OR (ISNUMERIC([Avg_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_52_02], '')) = 0 AND LEN([Avg_Q_52_02]) > 0) OR (ISNUMERIC([Avg_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_52_03], '')) = 0 AND LEN([Avg_Q_52_03]) > 0) OR (ISNUMERIC([Avg_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_52_04], '')) = 0 AND LEN([Avg_Q_52_04]) > 0) OR (ISNUMERIC([Avg_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_52_05], '')) = 0 AND LEN([Avg_Q_52_05]) > 0) OR (ISNUMERIC([Avg_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_52_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_53_01], '')) = 0 AND LEN([Avg_Q_53_01]) > 0) OR (ISNUMERIC([Avg_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_53_02], '')) = 0 AND LEN([Avg_Q_53_02]) > 0) OR (ISNUMERIC([Avg_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_53_03], '')) = 0 AND LEN([Avg_Q_53_03]) > 0) OR (ISNUMERIC([Avg_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_53_04], '')) = 0 AND LEN([Avg_Q_53_04]) > 0) OR (ISNUMERIC([Avg_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_53_05], '')) = 0 AND LEN([Avg_Q_53_05]) > 0) OR (ISNUMERIC([Avg_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_53_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_54_01], '')) = 0 AND LEN([Avg_Q_54_01]) > 0) OR (ISNUMERIC([Avg_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_54_02], '')) = 0 AND LEN([Avg_Q_54_02]) > 0) OR (ISNUMERIC([Avg_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_54_03], '')) = 0 AND LEN([Avg_Q_54_03]) > 0) OR (ISNUMERIC([Avg_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_54_04], '')) = 0 AND LEN([Avg_Q_54_04]) > 0) OR (ISNUMERIC([Avg_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_54_05], '')) = 0 AND LEN([Avg_Q_54_05]) > 0) OR (ISNUMERIC([Avg_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_54_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_55_01], '')) = 0 AND LEN([Avg_Q_55_01]) > 0) OR (ISNUMERIC([Avg_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_55_02], '')) = 0 AND LEN([Avg_Q_55_02]) > 0) OR (ISNUMERIC([Avg_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_55_03], '')) = 0 AND LEN([Avg_Q_55_03]) > 0) OR (ISNUMERIC([Avg_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_55_04], '')) = 0 AND LEN([Avg_Q_55_04]) > 0) OR (ISNUMERIC([Avg_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_55_05], '')) = 0 AND LEN([Avg_Q_55_05]) > 0) OR (ISNUMERIC([Avg_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_55_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_56_01], '')) = 0 AND LEN([Avg_Q_56_01]) > 0) OR (ISNUMERIC([Avg_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_56_02], '')) = 0 AND LEN([Avg_Q_56_02]) > 0) OR (ISNUMERIC([Avg_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_56_03], '')) = 0 AND LEN([Avg_Q_56_03]) > 0) OR (ISNUMERIC([Avg_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_56_04], '')) = 0 AND LEN([Avg_Q_56_04]) > 0) OR (ISNUMERIC([Avg_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_56_05], '')) = 0 AND LEN([Avg_Q_56_05]) > 0) OR (ISNUMERIC([Avg_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_56_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_57_01], '')) = 0 AND LEN([Avg_Q_57_01]) > 0) OR (ISNUMERIC([Avg_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_57_02], '')) = 0 AND LEN([Avg_Q_57_02]) > 0) OR (ISNUMERIC([Avg_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_57_03], '')) = 0 AND LEN([Avg_Q_57_03]) > 0) OR (ISNUMERIC([Avg_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_57_04], '')) = 0 AND LEN([Avg_Q_57_04]) > 0) OR (ISNUMERIC([Avg_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_57_05], '')) = 0 AND LEN([Avg_Q_57_05]) > 0) OR (ISNUMERIC([Avg_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_57_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_58_01], '')) = 0 AND LEN([Avg_Q_58_01]) > 0) OR (ISNUMERIC([Avg_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_58_02], '')) = 0 AND LEN([Avg_Q_58_02]) > 0) OR (ISNUMERIC([Avg_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_58_03], '')) = 0 AND LEN([Avg_Q_58_03]) > 0) OR (ISNUMERIC([Avg_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_58_04], '')) = 0 AND LEN([Avg_Q_58_04]) > 0) OR (ISNUMERIC([Avg_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_58_05], '')) = 0 AND LEN([Avg_Q_58_05]) > 0) OR (ISNUMERIC([Avg_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_58_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_59_01], '')) = 0 AND LEN([Avg_Q_59_01]) > 0) OR (ISNUMERIC([Avg_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_59_02], '')) = 0 AND LEN([Avg_Q_59_02]) > 0) OR (ISNUMERIC([Avg_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_59_03], '')) = 0 AND LEN([Avg_Q_59_03]) > 0) OR (ISNUMERIC([Avg_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_59_04], '')) = 0 AND LEN([Avg_Q_59_04]) > 0) OR (ISNUMERIC([Avg_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_59_05], '')) = 0 AND LEN([Avg_Q_59_05]) > 0) OR (ISNUMERIC([Avg_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_59_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_60_01], '')) = 0 AND LEN([Avg_Q_60_01]) > 0) OR (ISNUMERIC([Avg_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_60_02], '')) = 0 AND LEN([Avg_Q_60_02]) > 0) OR (ISNUMERIC([Avg_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_60_03], '')) = 0 AND LEN([Avg_Q_60_03]) > 0) OR (ISNUMERIC([Avg_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_60_04], '')) = 0 AND LEN([Avg_Q_60_04]) > 0) OR (ISNUMERIC([Avg_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_60_05], '')) = 0 AND LEN([Avg_Q_60_05]) > 0) OR (ISNUMERIC([Avg_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_60_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_61_01], '')) = 0 AND LEN([Avg_Q_61_01]) > 0) OR (ISNUMERIC([Avg_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_61_02], '')) = 0 AND LEN([Avg_Q_61_02]) > 0) OR (ISNUMERIC([Avg_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_61_03], '')) = 0 AND LEN([Avg_Q_61_03]) > 0) OR (ISNUMERIC([Avg_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_61_04], '')) = 0 AND LEN([Avg_Q_61_04]) > 0) OR (ISNUMERIC([Avg_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_61_05], '')) = 0 AND LEN([Avg_Q_61_05]) > 0) OR (ISNUMERIC([Avg_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_61_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_62_01], '')) = 0 AND LEN([Avg_Q_62_01]) > 0) OR (ISNUMERIC([Avg_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_62_02], '')) = 0 AND LEN([Avg_Q_62_02]) > 0) OR (ISNUMERIC([Avg_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_62_03], '')) = 0 AND LEN([Avg_Q_62_03]) > 0) OR (ISNUMERIC([Avg_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_62_04], '')) = 0 AND LEN([Avg_Q_62_04]) > 0) OR (ISNUMERIC([Avg_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_62_05], '')) = 0 AND LEN([Avg_Q_62_05]) > 0) OR (ISNUMERIC([Avg_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_62_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_63_01], '')) = 0 AND LEN([Avg_Q_63_01]) > 0) OR (ISNUMERIC([Avg_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_63_02], '')) = 0 AND LEN([Avg_Q_63_02]) > 0) OR (ISNUMERIC([Avg_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_63_03], '')) = 0 AND LEN([Avg_Q_63_03]) > 0) OR (ISNUMERIC([Avg_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_63_04], '')) = 0 AND LEN([Avg_Q_63_04]) > 0) OR (ISNUMERIC([Avg_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_63_05], '')) = 0 AND LEN([Avg_Q_63_05]) > 0) OR (ISNUMERIC([Avg_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_63_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_01], '')) = 0 AND LEN([Avg_Q_64_01]) > 0) OR (ISNUMERIC([Avg_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_02], '')) = 0 AND LEN([Avg_Q_64_02]) > 0) OR (ISNUMERIC([Avg_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_03], '')) = 0 AND LEN([Avg_Q_64_03]) > 0) OR (ISNUMERIC([Avg_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_04], '')) = 0 AND LEN([Avg_Q_64_04]) > 0) OR (ISNUMERIC([Avg_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_05], '')) = 0 AND LEN([Avg_Q_64_05]) > 0) OR (ISNUMERIC([Avg_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_64_06], '')) = 0 AND LEN([Avg_Q_64_06]) > 0) OR (ISNUMERIC([Avg_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_64_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_01], '')) = 0 AND LEN([Avg_Q_65_01]) > 0) OR (ISNUMERIC([Avg_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_02], '')) = 0 AND LEN([Avg_Q_65_02]) > 0) OR (ISNUMERIC([Avg_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_03], '')) = 0 AND LEN([Avg_Q_65_03]) > 0) OR (ISNUMERIC([Avg_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_04], '')) = 0 AND LEN([Avg_Q_65_04]) > 0) OR (ISNUMERIC([Avg_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_05], '')) = 0 AND LEN([Avg_Q_65_05]) > 0) OR (ISNUMERIC([Avg_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_06], '')) = 0 AND LEN([Avg_Q_65_06]) > 0) OR (ISNUMERIC([Avg_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_06]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_65_07], '')) = 0 AND LEN([Avg_Q_65_07]) > 0) OR (ISNUMERIC([Avg_Q_65_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_65_07]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_66_01], '')) = 0 AND LEN([Avg_Q_66_01]) > 0) OR (ISNUMERIC([Avg_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_66_02], '')) = 0 AND LEN([Avg_Q_66_02]) > 0) OR (ISNUMERIC([Avg_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_66_03], '')) = 0 AND LEN([Avg_Q_66_03]) > 0) OR (ISNUMERIC([Avg_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_66_04], '')) = 0 AND LEN([Avg_Q_66_04]) > 0) OR (ISNUMERIC([Avg_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_66_05], '')) = 0 AND LEN([Avg_Q_66_05]) > 0) OR (ISNUMERIC([Avg_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_66_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_67_01], '')) = 0 AND LEN([Avg_Q_67_01]) > 0) OR (ISNUMERIC([Avg_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_67_02], '')) = 0 AND LEN([Avg_Q_67_02]) > 0) OR (ISNUMERIC([Avg_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_67_03], '')) = 0 AND LEN([Avg_Q_67_03]) > 0) OR (ISNUMERIC([Avg_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_67_04], '')) = 0 AND LEN([Avg_Q_67_04]) > 0) OR (ISNUMERIC([Avg_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_67_05], '')) = 0 AND LEN([Avg_Q_67_05]) > 0) OR (ISNUMERIC([Avg_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_67_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_68_01], '')) = 0 AND LEN([Avg_Q_68_01]) > 0) OR (ISNUMERIC([Avg_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_68_02], '')) = 0 AND LEN([Avg_Q_68_02]) > 0) OR (ISNUMERIC([Avg_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_68_03], '')) = 0 AND LEN([Avg_Q_68_03]) > 0) OR (ISNUMERIC([Avg_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_68_04], '')) = 0 AND LEN([Avg_Q_68_04]) > 0) OR (ISNUMERIC([Avg_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_68_05], '')) = 0 AND LEN([Avg_Q_68_05]) > 0) OR (ISNUMERIC([Avg_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_68_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_69_01], '')) = 0 AND LEN([Avg_Q_69_01]) > 0) OR (ISNUMERIC([Avg_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_69_02], '')) = 0 AND LEN([Avg_Q_69_02]) > 0) OR (ISNUMERIC([Avg_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_69_03], '')) = 0 AND LEN([Avg_Q_69_03]) > 0) OR (ISNUMERIC([Avg_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_69_04], '')) = 0 AND LEN([Avg_Q_69_04]) > 0) OR (ISNUMERIC([Avg_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_69_05], '')) = 0 AND LEN([Avg_Q_69_05]) > 0) OR (ISNUMERIC([Avg_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_69_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_70_01], '')) = 0 AND LEN([Avg_Q_70_01]) > 0) OR (ISNUMERIC([Avg_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_01]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_70_02], '')) = 0 AND LEN([Avg_Q_70_02]) > 0) OR (ISNUMERIC([Avg_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_02]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_70_03], '')) = 0 AND LEN([Avg_Q_70_03]) > 0) OR (ISNUMERIC([Avg_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_03]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_70_04], '')) = 0 AND LEN([Avg_Q_70_04]) > 0) OR (ISNUMERIC([Avg_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_04]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Avg_Q_70_05], '')) = 0 AND LEN([Avg_Q_70_05]) > 0) OR (ISNUMERIC([Avg_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Avg_Q_70_05]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([NPS], '')) = 0 AND LEN([NPS]) > 0) OR (ISNUMERIC([NPS]) = 1 AND CONVERT(DECIMAL(20, 6), [NPS]) NOT BETWEEN -1.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([RPI_COM], '')) = 0 AND LEN([RPI_COM]) > 0) OR (ISNUMERIC([RPI_COM]) = 1 AND CONVERT(DECIMAL(20, 6), [RPI_COM]) NOT BETWEEN -1.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([RPI_IND], '')) = 0 AND LEN([RPI_IND]) > 0) OR (ISNUMERIC([RPI_IND]) = 1 AND CONVERT(DECIMAL(20, 6), [RPI_IND]) NOT BETWEEN -1.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Achievement Z-Score], '')) = 0 AND LEN([Achievement Z-Score]) > 0) OR (ISNUMERIC([Achievement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Achievement Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Belonging Z-Score], '')) = 0 AND LEN([Belonging Z-Score]) > 0) OR (ISNUMERIC([Belonging Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Belonging Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Character Z-Score], '')) = 0 AND LEN([Character Z-Score]) > 0) OR (ISNUMERIC([Character Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Character Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Giving Z-Score], '')) = 0 AND LEN([Giving Z-Score]) > 0) OR (ISNUMERIC([Giving Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Giving Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Health Z-Score], '')) = 0 AND LEN([Health Z-Score]) > 0) OR (ISNUMERIC([Health Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Health Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Inspiration Z-Score], '')) = 0 AND LEN([Inspiration Z-Score]) > 0) OR (ISNUMERIC([Inspiration Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Inspiration Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Meaning Z-Score], '')) = 0 AND LEN([Meaning Z-Score]) > 0) OR (ISNUMERIC([Meaning Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Meaning Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Relationship Z-Score], '')) = 0 AND LEN([Relationship Z-Score]) > 0) OR (ISNUMERIC([Relationship Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Relationship Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Safety Z-Score], '')) = 0 AND LEN([Safety Z-Score]) > 0) OR (ISNUMERIC([Safety Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Safety Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Achievement Percentile], '')) = 0 AND LEN([Achievement Percentile]) > 0) OR (ISNUMERIC([Achievement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Achievement Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Belonging Percentile], '')) = 0 AND LEN([Belonging Percentile]) > 0) OR (ISNUMERIC([Belonging Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Belonging Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Character Percentile], '')) = 0 AND LEN([Character Percentile]) > 0) OR (ISNUMERIC([Character Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Character Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Giving Percentile], '')) = 0 AND LEN([Giving Percentile]) > 0) OR (ISNUMERIC([Giving Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Giving Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Health Percentile], '')) = 0 AND LEN([Health Percentile]) > 0) OR (ISNUMERIC([Health Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Health Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Inspiration Percentile], '')) = 0 AND LEN([Inspiration Percentile]) > 0) OR (ISNUMERIC([Inspiration Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Inspiration Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Meaning Percentile], '')) = 0 AND LEN([Meaning Percentile]) > 0) OR (ISNUMERIC([Meaning Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Meaning Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Relationship Percentile], '')) = 0 AND LEN([Relationship Percentile]) > 0) OR (ISNUMERIC([Relationship Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Relationship Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Safety Percentile], '')) = 0 AND LEN([Safety Percentile]) > 0) OR (ISNUMERIC([Safety Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Safety Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Facilities Z-Score], '')) = 0 AND LEN([Facilities Z-Score]) > 0) OR (ISNUMERIC([Facilities Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Facilities Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Service Z-Score], '')) = 0 AND LEN([Service Z-Score]) > 0) OR (ISNUMERIC([Service Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Service Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Value Z-Score], '')) = 0 AND LEN([Value Z-Score]) > 0) OR (ISNUMERIC([Value Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Value Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Engagement Z-Score], '')) = 0 AND LEN([Engagement Z-Score]) > 0) OR (ISNUMERIC([Engagement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Engagement Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Health and Wellness Z-Score], '')) = 0 AND LEN([Health and Wellness Z-Score]) > 0) OR (ISNUMERIC([Health and Wellness Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Health and Wellness Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Involvement Z-Score], '')) = 0 AND LEN([Involvement Z-Score]) > 0) OR (ISNUMERIC([Involvement Z-Score]) = 1 AND CONVERT(DECIMAL(20, 6), [Involvement Z-Score]) NOT BETWEEN -10.00000 AND 10.00000))
			OR ((ISNUMERIC(COALESCE([Facilities Percentile], '')) = 0 AND LEN([Facilities Percentile]) > 0) OR (ISNUMERIC([Facilities Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Facilities Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Service Percentile], '')) = 0 AND LEN([Service Percentile]) > 0) OR (ISNUMERIC([Service Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Service Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Value Percentile], '')) = 0 AND LEN([Value Percentile]) > 0) OR (ISNUMERIC([Value Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Value Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Engagement Percentile], '')) = 0 AND LEN([Engagement Percentile]) > 0) OR (ISNUMERIC([Engagement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Engagement Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Health and Wellness Percentile], '')) = 0 AND LEN([Health and Wellness Percentile]) > 0) OR (ISNUMERIC([Health and Wellness Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Health and Wellness Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Involvement Percentile], '')) = 0 AND LEN([Involvement Percentile]) > 0) OR (ISNUMERIC([Involvement Percentile]) = 1 AND CONVERT(DECIMAL(20, 6), [Involvement Percentile]) NOT BETWEEN 0.00000 AND 1.00000))
			OR ((ISNUMERIC(COALESCE([Sum_M_01b_01], '')) = 0 AND LEN([Sum_M_01b_01]) > 0) OR (ISNUMERIC([Sum_M_01b_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01b_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_M_01c_01], '')) = 0 AND LEN([Sum_M_01c_01]) > 0) OR (ISNUMERIC([Sum_M_01c_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01c_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_M_01d_01], '')) = 0 AND LEN([Sum_M_01d_01]) > 0) OR (ISNUMERIC([Sum_M_01d_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_M_01d_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_01_01], '')) = 0 AND LEN([Sum_Q_01_01]) > 0) OR (ISNUMERIC([Sum_Q_01_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_01_02], '')) = 0 AND LEN([Sum_Q_01_02]) > 0) OR (ISNUMERIC([Sum_Q_01_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_01_03], '')) = 0 AND LEN([Sum_Q_01_03]) > 0) OR (ISNUMERIC([Sum_Q_01_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_01_04], '')) = 0 AND LEN([Sum_Q_01_04]) > 0) OR (ISNUMERIC([Sum_Q_01_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_01_05], '')) = 0 AND LEN([Sum_Q_01_05]) > 0) OR (ISNUMERIC([Sum_Q_01_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_01_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_02_01], '')) = 0 AND LEN([Sum_Q_02_01]) > 0) OR (ISNUMERIC([Sum_Q_02_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_02_02], '')) = 0 AND LEN([Sum_Q_02_02]) > 0) OR (ISNUMERIC([Sum_Q_02_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_02_03], '')) = 0 AND LEN([Sum_Q_02_03]) > 0) OR (ISNUMERIC([Sum_Q_02_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_02_04], '')) = 0 AND LEN([Sum_Q_02_04]) > 0) OR (ISNUMERIC([Sum_Q_02_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_02_05], '')) = 0 AND LEN([Sum_Q_02_05]) > 0) OR (ISNUMERIC([Sum_Q_02_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_02_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_03_01], '')) = 0 AND LEN([Sum_Q_03_01]) > 0) OR (ISNUMERIC([Sum_Q_03_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_03_02], '')) = 0 AND LEN([Sum_Q_03_02]) > 0) OR (ISNUMERIC([Sum_Q_03_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_03_03], '')) = 0 AND LEN([Sum_Q_03_03]) > 0) OR (ISNUMERIC([Sum_Q_03_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_03_04], '')) = 0 AND LEN([Sum_Q_03_04]) > 0) OR (ISNUMERIC([Sum_Q_03_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_03_05], '')) = 0 AND LEN([Sum_Q_03_05]) > 0) OR (ISNUMERIC([Sum_Q_03_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_03_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_04_01], '')) = 0 AND LEN([Sum_Q_04_01]) > 0) OR (ISNUMERIC([Sum_Q_04_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_04_02], '')) = 0 AND LEN([Sum_Q_04_02]) > 0) OR (ISNUMERIC([Sum_Q_04_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_04_03], '')) = 0 AND LEN([Sum_Q_04_03]) > 0) OR (ISNUMERIC([Sum_Q_04_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_04_04], '')) = 0 AND LEN([Sum_Q_04_04]) > 0) OR (ISNUMERIC([Sum_Q_04_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_04_05], '')) = 0 AND LEN([Sum_Q_04_05]) > 0) OR (ISNUMERIC([Sum_Q_04_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_04_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_05_01], '')) = 0 AND LEN([Sum_Q_05_01]) > 0) OR (ISNUMERIC([Sum_Q_05_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_05_02], '')) = 0 AND LEN([Sum_Q_05_02]) > 0) OR (ISNUMERIC([Sum_Q_05_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_05_03], '')) = 0 AND LEN([Sum_Q_05_03]) > 0) OR (ISNUMERIC([Sum_Q_05_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_05_04], '')) = 0 AND LEN([Sum_Q_05_04]) > 0) OR (ISNUMERIC([Sum_Q_05_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_05_05], '')) = 0 AND LEN([Sum_Q_05_05]) > 0) OR (ISNUMERIC([Sum_Q_05_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_05_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_06_01], '')) = 0 AND LEN([Sum_Q_06_01]) > 0) OR (ISNUMERIC([Sum_Q_06_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_06_02], '')) = 0 AND LEN([Sum_Q_06_02]) > 0) OR (ISNUMERIC([Sum_Q_06_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_06_03], '')) = 0 AND LEN([Sum_Q_06_03]) > 0) OR (ISNUMERIC([Sum_Q_06_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_06_04], '')) = 0 AND LEN([Sum_Q_06_04]) > 0) OR (ISNUMERIC([Sum_Q_06_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_06_05], '')) = 0 AND LEN([Sum_Q_06_05]) > 0) OR (ISNUMERIC([Sum_Q_06_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_06_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_07_01], '')) = 0 AND LEN([Sum_Q_07_01]) > 0) OR (ISNUMERIC([Sum_Q_07_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_07_02], '')) = 0 AND LEN([Sum_Q_07_02]) > 0) OR (ISNUMERIC([Sum_Q_07_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_07_03], '')) = 0 AND LEN([Sum_Q_07_03]) > 0) OR (ISNUMERIC([Sum_Q_07_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_07_04], '')) = 0 AND LEN([Sum_Q_07_04]) > 0) OR (ISNUMERIC([Sum_Q_07_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_07_05], '')) = 0 AND LEN([Sum_Q_07_05]) > 0) OR (ISNUMERIC([Sum_Q_07_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_07_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_08_01], '')) = 0 AND LEN([Sum_Q_08_01]) > 0) OR (ISNUMERIC([Sum_Q_08_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_08_02], '')) = 0 AND LEN([Sum_Q_08_02]) > 0) OR (ISNUMERIC([Sum_Q_08_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_08_03], '')) = 0 AND LEN([Sum_Q_08_03]) > 0) OR (ISNUMERIC([Sum_Q_08_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_08_04], '')) = 0 AND LEN([Sum_Q_08_04]) > 0) OR (ISNUMERIC([Sum_Q_08_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_08_05], '')) = 0 AND LEN([Sum_Q_08_05]) > 0) OR (ISNUMERIC([Sum_Q_08_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_08_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_09_01], '')) = 0 AND LEN([Sum_Q_09_01]) > 0) OR (ISNUMERIC([Sum_Q_09_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_09_02], '')) = 0 AND LEN([Sum_Q_09_02]) > 0) OR (ISNUMERIC([Sum_Q_09_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_09_03], '')) = 0 AND LEN([Sum_Q_09_03]) > 0) OR (ISNUMERIC([Sum_Q_09_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_09_04], '')) = 0 AND LEN([Sum_Q_09_04]) > 0) OR (ISNUMERIC([Sum_Q_09_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_09_05], '')) = 0 AND LEN([Sum_Q_09_05]) > 0) OR (ISNUMERIC([Sum_Q_09_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_09_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_10_01], '')) = 0 AND LEN([Sum_Q_10_01]) > 0) OR (ISNUMERIC([Sum_Q_10_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_10_02], '')) = 0 AND LEN([Sum_Q_10_02]) > 0) OR (ISNUMERIC([Sum_Q_10_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_10_03], '')) = 0 AND LEN([Sum_Q_10_03]) > 0) OR (ISNUMERIC([Sum_Q_10_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_10_04], '')) = 0 AND LEN([Sum_Q_10_04]) > 0) OR (ISNUMERIC([Sum_Q_10_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_10_05], '')) = 0 AND LEN([Sum_Q_10_05]) > 0) OR (ISNUMERIC([Sum_Q_10_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_10_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_11_01], '')) = 0 AND LEN([Sum_Q_11_01]) > 0) OR (ISNUMERIC([Sum_Q_11_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_11_02], '')) = 0 AND LEN([Sum_Q_11_02]) > 0) OR (ISNUMERIC([Sum_Q_11_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_11_03], '')) = 0 AND LEN([Sum_Q_11_03]) > 0) OR (ISNUMERIC([Sum_Q_11_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_11_04], '')) = 0 AND LEN([Sum_Q_11_04]) > 0) OR (ISNUMERIC([Sum_Q_11_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_11_05], '')) = 0 AND LEN([Sum_Q_11_05]) > 0) OR (ISNUMERIC([Sum_Q_11_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_11_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_12_01], '')) = 0 AND LEN([Sum_Q_12_01]) > 0) OR (ISNUMERIC([Sum_Q_12_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_12_02], '')) = 0 AND LEN([Sum_Q_12_02]) > 0) OR (ISNUMERIC([Sum_Q_12_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_12_03], '')) = 0 AND LEN([Sum_Q_12_03]) > 0) OR (ISNUMERIC([Sum_Q_12_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_12_04], '')) = 0 AND LEN([Sum_Q_12_04]) > 0) OR (ISNUMERIC([Sum_Q_12_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_12_05], '')) = 0 AND LEN([Sum_Q_12_05]) > 0) OR (ISNUMERIC([Sum_Q_12_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_12_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_13_01], '')) = 0 AND LEN([Sum_Q_13_01]) > 0) OR (ISNUMERIC([Sum_Q_13_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_13_02], '')) = 0 AND LEN([Sum_Q_13_02]) > 0) OR (ISNUMERIC([Sum_Q_13_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_13_03], '')) = 0 AND LEN([Sum_Q_13_03]) > 0) OR (ISNUMERIC([Sum_Q_13_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_13_04], '')) = 0 AND LEN([Sum_Q_13_04]) > 0) OR (ISNUMERIC([Sum_Q_13_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_13_05], '')) = 0 AND LEN([Sum_Q_13_05]) > 0) OR (ISNUMERIC([Sum_Q_13_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_13_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_14_01], '')) = 0 AND LEN([Sum_Q_14_01]) > 0) OR (ISNUMERIC([Sum_Q_14_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_14_02], '')) = 0 AND LEN([Sum_Q_14_02]) > 0) OR (ISNUMERIC([Sum_Q_14_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_14_03], '')) = 0 AND LEN([Sum_Q_14_03]) > 0) OR (ISNUMERIC([Sum_Q_14_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_14_04], '')) = 0 AND LEN([Sum_Q_14_04]) > 0) OR (ISNUMERIC([Sum_Q_14_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_14_05], '')) = 0 AND LEN([Sum_Q_14_05]) > 0) OR (ISNUMERIC([Sum_Q_14_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_14_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_15_01], '')) = 0 AND LEN([Sum_Q_15_01]) > 0) OR (ISNUMERIC([Sum_Q_15_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_15_02], '')) = 0 AND LEN([Sum_Q_15_02]) > 0) OR (ISNUMERIC([Sum_Q_15_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_15_03], '')) = 0 AND LEN([Sum_Q_15_03]) > 0) OR (ISNUMERIC([Sum_Q_15_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_15_04], '')) = 0 AND LEN([Sum_Q_15_04]) > 0) OR (ISNUMERIC([Sum_Q_15_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_15_05], '')) = 0 AND LEN([Sum_Q_15_05]) > 0) OR (ISNUMERIC([Sum_Q_15_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_15_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_16_01], '')) = 0 AND LEN([Sum_Q_16_01]) > 0) OR (ISNUMERIC([Sum_Q_16_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_16_02], '')) = 0 AND LEN([Sum_Q_16_02]) > 0) OR (ISNUMERIC([Sum_Q_16_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_16_03], '')) = 0 AND LEN([Sum_Q_16_03]) > 0) OR (ISNUMERIC([Sum_Q_16_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_16_04], '')) = 0 AND LEN([Sum_Q_16_04]) > 0) OR (ISNUMERIC([Sum_Q_16_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_16_05], '')) = 0 AND LEN([Sum_Q_16_05]) > 0) OR (ISNUMERIC([Sum_Q_16_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_16_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_17_01], '')) = 0 AND LEN([Sum_Q_17_01]) > 0) OR (ISNUMERIC([Sum_Q_17_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_17_02], '')) = 0 AND LEN([Sum_Q_17_02]) > 0) OR (ISNUMERIC([Sum_Q_17_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_17_03], '')) = 0 AND LEN([Sum_Q_17_03]) > 0) OR (ISNUMERIC([Sum_Q_17_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_17_04], '')) = 0 AND LEN([Sum_Q_17_04]) > 0) OR (ISNUMERIC([Sum_Q_17_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_17_05], '')) = 0 AND LEN([Sum_Q_17_05]) > 0) OR (ISNUMERIC([Sum_Q_17_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_17_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_18_01], '')) = 0 AND LEN([Sum_Q_18_01]) > 0) OR (ISNUMERIC([Sum_Q_18_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_18_02], '')) = 0 AND LEN([Sum_Q_18_02]) > 0) OR (ISNUMERIC([Sum_Q_18_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_18_03], '')) = 0 AND LEN([Sum_Q_18_03]) > 0) OR (ISNUMERIC([Sum_Q_18_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_18_04], '')) = 0 AND LEN([Sum_Q_18_04]) > 0) OR (ISNUMERIC([Sum_Q_18_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_18_05], '')) = 0 AND LEN([Sum_Q_18_05]) > 0) OR (ISNUMERIC([Sum_Q_18_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_18_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_19_01], '')) = 0 AND LEN([Sum_Q_19_01]) > 0) OR (ISNUMERIC([Sum_Q_19_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_19_02], '')) = 0 AND LEN([Sum_Q_19_02]) > 0) OR (ISNUMERIC([Sum_Q_19_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_19_03], '')) = 0 AND LEN([Sum_Q_19_03]) > 0) OR (ISNUMERIC([Sum_Q_19_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_19_04], '')) = 0 AND LEN([Sum_Q_19_04]) > 0) OR (ISNUMERIC([Sum_Q_19_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_19_05], '')) = 0 AND LEN([Sum_Q_19_05]) > 0) OR (ISNUMERIC([Sum_Q_19_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_19_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_20_01], '')) = 0 AND LEN([Sum_Q_20_01]) > 0) OR (ISNUMERIC([Sum_Q_20_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_20_02], '')) = 0 AND LEN([Sum_Q_20_02]) > 0) OR (ISNUMERIC([Sum_Q_20_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_20_03], '')) = 0 AND LEN([Sum_Q_20_03]) > 0) OR (ISNUMERIC([Sum_Q_20_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_20_04], '')) = 0 AND LEN([Sum_Q_20_04]) > 0) OR (ISNUMERIC([Sum_Q_20_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_20_05], '')) = 0 AND LEN([Sum_Q_20_05]) > 0) OR (ISNUMERIC([Sum_Q_20_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_20_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_21_01], '')) = 0 AND LEN([Sum_Q_21_01]) > 0) OR (ISNUMERIC([Sum_Q_21_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_21_02], '')) = 0 AND LEN([Sum_Q_21_02]) > 0) OR (ISNUMERIC([Sum_Q_21_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_21_03], '')) = 0 AND LEN([Sum_Q_21_03]) > 0) OR (ISNUMERIC([Sum_Q_21_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_21_04], '')) = 0 AND LEN([Sum_Q_21_04]) > 0) OR (ISNUMERIC([Sum_Q_21_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_21_05], '')) = 0 AND LEN([Sum_Q_21_05]) > 0) OR (ISNUMERIC([Sum_Q_21_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_21_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_22_01], '')) = 0 AND LEN([Sum_Q_22_01]) > 0) OR (ISNUMERIC([Sum_Q_22_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_22_02], '')) = 0 AND LEN([Sum_Q_22_02]) > 0) OR (ISNUMERIC([Sum_Q_22_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_22_03], '')) = 0 AND LEN([Sum_Q_22_03]) > 0) OR (ISNUMERIC([Sum_Q_22_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_22_04], '')) = 0 AND LEN([Sum_Q_22_04]) > 0) OR (ISNUMERIC([Sum_Q_22_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_22_05], '')) = 0 AND LEN([Sum_Q_22_05]) > 0) OR (ISNUMERIC([Sum_Q_22_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_22_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_23_01], '')) = 0 AND LEN([Sum_Q_23_01]) > 0) OR (ISNUMERIC([Sum_Q_23_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_23_02], '')) = 0 AND LEN([Sum_Q_23_02]) > 0) OR (ISNUMERIC([Sum_Q_23_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_23_03], '')) = 0 AND LEN([Sum_Q_23_03]) > 0) OR (ISNUMERIC([Sum_Q_23_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_23_04], '')) = 0 AND LEN([Sum_Q_23_04]) > 0) OR (ISNUMERIC([Sum_Q_23_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_23_05], '')) = 0 AND LEN([Sum_Q_23_05]) > 0) OR (ISNUMERIC([Sum_Q_23_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_23_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_24_01], '')) = 0 AND LEN([Sum_Q_24_01]) > 0) OR (ISNUMERIC([Sum_Q_24_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_24_02], '')) = 0 AND LEN([Sum_Q_24_02]) > 0) OR (ISNUMERIC([Sum_Q_24_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_24_03], '')) = 0 AND LEN([Sum_Q_24_03]) > 0) OR (ISNUMERIC([Sum_Q_24_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_24_04], '')) = 0 AND LEN([Sum_Q_24_04]) > 0) OR (ISNUMERIC([Sum_Q_24_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_24_05], '')) = 0 AND LEN([Sum_Q_24_05]) > 0) OR (ISNUMERIC([Sum_Q_24_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_24_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_25_01], '')) = 0 AND LEN([Sum_Q_25_01]) > 0) OR (ISNUMERIC([Sum_Q_25_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_25_02], '')) = 0 AND LEN([Sum_Q_25_02]) > 0) OR (ISNUMERIC([Sum_Q_25_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_25_03], '')) = 0 AND LEN([Sum_Q_25_03]) > 0) OR (ISNUMERIC([Sum_Q_25_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_25_04], '')) = 0 AND LEN([Sum_Q_25_04]) > 0) OR (ISNUMERIC([Sum_Q_25_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_25_05], '')) = 0 AND LEN([Sum_Q_25_05]) > 0) OR (ISNUMERIC([Sum_Q_25_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_25_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_26_01], '')) = 0 AND LEN([Sum_Q_26_01]) > 0) OR (ISNUMERIC([Sum_Q_26_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_26_02], '')) = 0 AND LEN([Sum_Q_26_02]) > 0) OR (ISNUMERIC([Sum_Q_26_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_26_03], '')) = 0 AND LEN([Sum_Q_26_03]) > 0) OR (ISNUMERIC([Sum_Q_26_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_26_04], '')) = 0 AND LEN([Sum_Q_26_04]) > 0) OR (ISNUMERIC([Sum_Q_26_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_26_05], '')) = 0 AND LEN([Sum_Q_26_05]) > 0) OR (ISNUMERIC([Sum_Q_26_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_26_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_27_01], '')) = 0 AND LEN([Sum_Q_27_01]) > 0) OR (ISNUMERIC([Sum_Q_27_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_27_02], '')) = 0 AND LEN([Sum_Q_27_02]) > 0) OR (ISNUMERIC([Sum_Q_27_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_27_03], '')) = 0 AND LEN([Sum_Q_27_03]) > 0) OR (ISNUMERIC([Sum_Q_27_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_27_04], '')) = 0 AND LEN([Sum_Q_27_04]) > 0) OR (ISNUMERIC([Sum_Q_27_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_27_05], '')) = 0 AND LEN([Sum_Q_27_05]) > 0) OR (ISNUMERIC([Sum_Q_27_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_27_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_28_01], '')) = 0 AND LEN([Sum_Q_28_01]) > 0) OR (ISNUMERIC([Sum_Q_28_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_28_02], '')) = 0 AND LEN([Sum_Q_28_02]) > 0) OR (ISNUMERIC([Sum_Q_28_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_28_03], '')) = 0 AND LEN([Sum_Q_28_03]) > 0) OR (ISNUMERIC([Sum_Q_28_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_28_04], '')) = 0 AND LEN([Sum_Q_28_04]) > 0) OR (ISNUMERIC([Sum_Q_28_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_28_05], '')) = 0 AND LEN([Sum_Q_28_05]) > 0) OR (ISNUMERIC([Sum_Q_28_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_28_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_29_01], '')) = 0 AND LEN([Sum_Q_29_01]) > 0) OR (ISNUMERIC([Sum_Q_29_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_29_02], '')) = 0 AND LEN([Sum_Q_29_02]) > 0) OR (ISNUMERIC([Sum_Q_29_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_29_03], '')) = 0 AND LEN([Sum_Q_29_03]) > 0) OR (ISNUMERIC([Sum_Q_29_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_29_04], '')) = 0 AND LEN([Sum_Q_29_04]) > 0) OR (ISNUMERIC([Sum_Q_29_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_29_05], '')) = 0 AND LEN([Sum_Q_29_05]) > 0) OR (ISNUMERIC([Sum_Q_29_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_29_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_30_01], '')) = 0 AND LEN([Sum_Q_30_01]) > 0) OR (ISNUMERIC([Sum_Q_30_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_30_02], '')) = 0 AND LEN([Sum_Q_30_02]) > 0) OR (ISNUMERIC([Sum_Q_30_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_30_03], '')) = 0 AND LEN([Sum_Q_30_03]) > 0) OR (ISNUMERIC([Sum_Q_30_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_30_04], '')) = 0 AND LEN([Sum_Q_30_04]) > 0) OR (ISNUMERIC([Sum_Q_30_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_30_05], '')) = 0 AND LEN([Sum_Q_30_05]) > 0) OR (ISNUMERIC([Sum_Q_30_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_30_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_31_01], '')) = 0 AND LEN([Sum_Q_31_01]) > 0) OR (ISNUMERIC([Sum_Q_31_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_31_02], '')) = 0 AND LEN([Sum_Q_31_02]) > 0) OR (ISNUMERIC([Sum_Q_31_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_31_03], '')) = 0 AND LEN([Sum_Q_31_03]) > 0) OR (ISNUMERIC([Sum_Q_31_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_31_04], '')) = 0 AND LEN([Sum_Q_31_04]) > 0) OR (ISNUMERIC([Sum_Q_31_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_31_05], '')) = 0 AND LEN([Sum_Q_31_05]) > 0) OR (ISNUMERIC([Sum_Q_31_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_31_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_00], '')) = 0 AND LEN([Sum_Q_32_00]) > 0) OR (ISNUMERIC([Sum_Q_32_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_00]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_01], '')) = 0 AND LEN([Sum_Q_32_01]) > 0) OR (ISNUMERIC([Sum_Q_32_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_10], '')) = 0 AND LEN([Sum_Q_32_10]) > 0) OR (ISNUMERIC([Sum_Q_32_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_10]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_02], '')) = 0 AND LEN([Sum_Q_32_02]) > 0) OR (ISNUMERIC([Sum_Q_32_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_03], '')) = 0 AND LEN([Sum_Q_32_03]) > 0) OR (ISNUMERIC([Sum_Q_32_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_04], '')) = 0 AND LEN([Sum_Q_32_04]) > 0) OR (ISNUMERIC([Sum_Q_32_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_05], '')) = 0 AND LEN([Sum_Q_32_05]) > 0) OR (ISNUMERIC([Sum_Q_32_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_06], '')) = 0 AND LEN([Sum_Q_32_06]) > 0) OR (ISNUMERIC([Sum_Q_32_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_06]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_07], '')) = 0 AND LEN([Sum_Q_32_07]) > 0) OR (ISNUMERIC([Sum_Q_32_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_07]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_08], '')) = 0 AND LEN([Sum_Q_32_08]) > 0) OR (ISNUMERIC([Sum_Q_32_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_08]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_32_09], '')) = 0 AND LEN([Sum_Q_32_09]) > 0) OR (ISNUMERIC([Sum_Q_32_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_32_09]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_33_01], '')) = 0 AND LEN([Sum_Q_33_01]) > 0) OR (ISNUMERIC([Sum_Q_33_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_33_02], '')) = 0 AND LEN([Sum_Q_33_02]) > 0) OR (ISNUMERIC([Sum_Q_33_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_33_03], '')) = 0 AND LEN([Sum_Q_33_03]) > 0) OR (ISNUMERIC([Sum_Q_33_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_33_04], '')) = 0 AND LEN([Sum_Q_33_04]) > 0) OR (ISNUMERIC([Sum_Q_33_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_33_05], '')) = 0 AND LEN([Sum_Q_33_05]) > 0) OR (ISNUMERIC([Sum_Q_33_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_33_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_34_01], '')) = 0 AND LEN([Sum_Q_34_01]) > 0) OR (ISNUMERIC([Sum_Q_34_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_34_02], '')) = 0 AND LEN([Sum_Q_34_02]) > 0) OR (ISNUMERIC([Sum_Q_34_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_34_03], '')) = 0 AND LEN([Sum_Q_34_03]) > 0) OR (ISNUMERIC([Sum_Q_34_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_34_04], '')) = 0 AND LEN([Sum_Q_34_04]) > 0) OR (ISNUMERIC([Sum_Q_34_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_34_05], '')) = 0 AND LEN([Sum_Q_34_05]) > 0) OR (ISNUMERIC([Sum_Q_34_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_34_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_00], '')) = 0 AND LEN([Sum_Q_35_00]) > 0) OR (ISNUMERIC([Sum_Q_35_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_00]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_01], '')) = 0 AND LEN([Sum_Q_35_01]) > 0) OR (ISNUMERIC([Sum_Q_35_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_10], '')) = 0 AND LEN([Sum_Q_35_10]) > 0) OR (ISNUMERIC([Sum_Q_35_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_10]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_02], '')) = 0 AND LEN([Sum_Q_35_02]) > 0) OR (ISNUMERIC([Sum_Q_35_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_03], '')) = 0 AND LEN([Sum_Q_35_03]) > 0) OR (ISNUMERIC([Sum_Q_35_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_04], '')) = 0 AND LEN([Sum_Q_35_04]) > 0) OR (ISNUMERIC([Sum_Q_35_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_05], '')) = 0 AND LEN([Sum_Q_35_05]) > 0) OR (ISNUMERIC([Sum_Q_35_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_06], '')) = 0 AND LEN([Sum_Q_35_06]) > 0) OR (ISNUMERIC([Sum_Q_35_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_06]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_07], '')) = 0 AND LEN([Sum_Q_35_07]) > 0) OR (ISNUMERIC([Sum_Q_35_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_07]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_08], '')) = 0 AND LEN([Sum_Q_35_08]) > 0) OR (ISNUMERIC([Sum_Q_35_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_08]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_35_09], '')) = 0 AND LEN([Sum_Q_35_09]) > 0) OR (ISNUMERIC([Sum_Q_35_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_35_09]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_36_01], '')) = 0 AND LEN([Sum_Q_36_01]) > 0) OR (ISNUMERIC([Sum_Q_36_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_36_02], '')) = 0 AND LEN([Sum_Q_36_02]) > 0) OR (ISNUMERIC([Sum_Q_36_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_36_03], '')) = 0 AND LEN([Sum_Q_36_03]) > 0) OR (ISNUMERIC([Sum_Q_36_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_36_04], '')) = 0 AND LEN([Sum_Q_36_04]) > 0) OR (ISNUMERIC([Sum_Q_36_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_36_05], '')) = 0 AND LEN([Sum_Q_36_05]) > 0) OR (ISNUMERIC([Sum_Q_36_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_36_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_37_01], '')) = 0 AND LEN([Sum_Q_37_01]) > 0) OR (ISNUMERIC([Sum_Q_37_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_37_02], '')) = 0 AND LEN([Sum_Q_37_02]) > 0) OR (ISNUMERIC([Sum_Q_37_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_37_03], '')) = 0 AND LEN([Sum_Q_37_03]) > 0) OR (ISNUMERIC([Sum_Q_37_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_37_04], '')) = 0 AND LEN([Sum_Q_37_04]) > 0) OR (ISNUMERIC([Sum_Q_37_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_37_05], '')) = 0 AND LEN([Sum_Q_37_05]) > 0) OR (ISNUMERIC([Sum_Q_37_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_37_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_38_01], '')) = 0 AND LEN([Sum_Q_38_01]) > 0) OR (ISNUMERIC([Sum_Q_38_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_38_02], '')) = 0 AND LEN([Sum_Q_38_02]) > 0) OR (ISNUMERIC([Sum_Q_38_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_38_03], '')) = 0 AND LEN([Sum_Q_38_03]) > 0) OR (ISNUMERIC([Sum_Q_38_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_38_04], '')) = 0 AND LEN([Sum_Q_38_04]) > 0) OR (ISNUMERIC([Sum_Q_38_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_38_05], '')) = 0 AND LEN([Sum_Q_38_05]) > 0) OR (ISNUMERIC([Sum_Q_38_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_38_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_39_01], '')) = 0 AND LEN([Sum_Q_39_01]) > 0) OR (ISNUMERIC([Sum_Q_39_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_39_02], '')) = 0 AND LEN([Sum_Q_39_02]) > 0) OR (ISNUMERIC([Sum_Q_39_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_39_03], '')) = 0 AND LEN([Sum_Q_39_03]) > 0) OR (ISNUMERIC([Sum_Q_39_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_39_04], '')) = 0 AND LEN([Sum_Q_39_04]) > 0) OR (ISNUMERIC([Sum_Q_39_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_39_05], '')) = 0 AND LEN([Sum_Q_39_05]) > 0) OR (ISNUMERIC([Sum_Q_39_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_39_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_40_01], '')) = 0 AND LEN([Sum_Q_40_01]) > 0) OR (ISNUMERIC([Sum_Q_40_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_40_02], '')) = 0 AND LEN([Sum_Q_40_02]) > 0) OR (ISNUMERIC([Sum_Q_40_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_40_03], '')) = 0 AND LEN([Sum_Q_40_03]) > 0) OR (ISNUMERIC([Sum_Q_40_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_40_04], '')) = 0 AND LEN([Sum_Q_40_04]) > 0) OR (ISNUMERIC([Sum_Q_40_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_40_05], '')) = 0 AND LEN([Sum_Q_40_05]) > 0) OR (ISNUMERIC([Sum_Q_40_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_40_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_41_01], '')) = 0 AND LEN([Sum_Q_41_01]) > 0) OR (ISNUMERIC([Sum_Q_41_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_41_02], '')) = 0 AND LEN([Sum_Q_41_02]) > 0) OR (ISNUMERIC([Sum_Q_41_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_41_03], '')) = 0 AND LEN([Sum_Q_41_03]) > 0) OR (ISNUMERIC([Sum_Q_41_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_41_04], '')) = 0 AND LEN([Sum_Q_41_04]) > 0) OR (ISNUMERIC([Sum_Q_41_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_41_05], '')) = 0 AND LEN([Sum_Q_41_05]) > 0) OR (ISNUMERIC([Sum_Q_41_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_41_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_42_01], '')) = 0 AND LEN([Sum_Q_42_01]) > 0) OR (ISNUMERIC([Sum_Q_42_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_42_02], '')) = 0 AND LEN([Sum_Q_42_02]) > 0) OR (ISNUMERIC([Sum_Q_42_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_42_03], '')) = 0 AND LEN([Sum_Q_42_03]) > 0) OR (ISNUMERIC([Sum_Q_42_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_42_04], '')) = 0 AND LEN([Sum_Q_42_04]) > 0) OR (ISNUMERIC([Sum_Q_42_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_42_05], '')) = 0 AND LEN([Sum_Q_42_05]) > 0) OR (ISNUMERIC([Sum_Q_42_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_42_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_43_01], '')) = 0 AND LEN([Sum_Q_43_01]) > 0) OR (ISNUMERIC([Sum_Q_43_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_43_02], '')) = 0 AND LEN([Sum_Q_43_02]) > 0) OR (ISNUMERIC([Sum_Q_43_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_43_03], '')) = 0 AND LEN([Sum_Q_43_03]) > 0) OR (ISNUMERIC([Sum_Q_43_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_43_04], '')) = 0 AND LEN([Sum_Q_43_04]) > 0) OR (ISNUMERIC([Sum_Q_43_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_43_05], '')) = 0 AND LEN([Sum_Q_43_05]) > 0) OR (ISNUMERIC([Sum_Q_43_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_43_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_44_01], '')) = 0 AND LEN([Sum_Q_44_01]) > 0) OR (ISNUMERIC([Sum_Q_44_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_44_02], '')) = 0 AND LEN([Sum_Q_44_02]) > 0) OR (ISNUMERIC([Sum_Q_44_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_44_03], '')) = 0 AND LEN([Sum_Q_44_03]) > 0) OR (ISNUMERIC([Sum_Q_44_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_44_04], '')) = 0 AND LEN([Sum_Q_44_04]) > 0) OR (ISNUMERIC([Sum_Q_44_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_44_05], '')) = 0 AND LEN([Sum_Q_44_05]) > 0) OR (ISNUMERIC([Sum_Q_44_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_44_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_45_01], '')) = 0 AND LEN([Sum_Q_45_01]) > 0) OR (ISNUMERIC([Sum_Q_45_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_45_02], '')) = 0 AND LEN([Sum_Q_45_02]) > 0) OR (ISNUMERIC([Sum_Q_45_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_45_03], '')) = 0 AND LEN([Sum_Q_45_03]) > 0) OR (ISNUMERIC([Sum_Q_45_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_45_04], '')) = 0 AND LEN([Sum_Q_45_04]) > 0) OR (ISNUMERIC([Sum_Q_45_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_45_05], '')) = 0 AND LEN([Sum_Q_45_05]) > 0) OR (ISNUMERIC([Sum_Q_45_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_45_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_00], '')) = 0 AND LEN([Sum_Q_46_00]) > 0) OR (ISNUMERIC([Sum_Q_46_00]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_00]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_01], '')) = 0 AND LEN([Sum_Q_46_01]) > 0) OR (ISNUMERIC([Sum_Q_46_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_10], '')) = 0 AND LEN([Sum_Q_46_10]) > 0) OR (ISNUMERIC([Sum_Q_46_10]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_10]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_02], '')) = 0 AND LEN([Sum_Q_46_02]) > 0) OR (ISNUMERIC([Sum_Q_46_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_03], '')) = 0 AND LEN([Sum_Q_46_03]) > 0) OR (ISNUMERIC([Sum_Q_46_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_04], '')) = 0 AND LEN([Sum_Q_46_04]) > 0) OR (ISNUMERIC([Sum_Q_46_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_05], '')) = 0 AND LEN([Sum_Q_46_05]) > 0) OR (ISNUMERIC([Sum_Q_46_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_06], '')) = 0 AND LEN([Sum_Q_46_06]) > 0) OR (ISNUMERIC([Sum_Q_46_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_06]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_07], '')) = 0 AND LEN([Sum_Q_46_07]) > 0) OR (ISNUMERIC([Sum_Q_46_07]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_07]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_08], '')) = 0 AND LEN([Sum_Q_46_08]) > 0) OR (ISNUMERIC([Sum_Q_46_08]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_08]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_46_09], '')) = 0 AND LEN([Sum_Q_46_09]) > 0) OR (ISNUMERIC([Sum_Q_46_09]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_46_09]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_47_01], '')) = 0 AND LEN([Sum_Q_47_01]) > 0) OR (ISNUMERIC([Sum_Q_47_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_47_02], '')) = 0 AND LEN([Sum_Q_47_02]) > 0) OR (ISNUMERIC([Sum_Q_47_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_47_03], '')) = 0 AND LEN([Sum_Q_47_03]) > 0) OR (ISNUMERIC([Sum_Q_47_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_47_04], '')) = 0 AND LEN([Sum_Q_47_04]) > 0) OR (ISNUMERIC([Sum_Q_47_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_47_05], '')) = 0 AND LEN([Sum_Q_47_05]) > 0) OR (ISNUMERIC([Sum_Q_47_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_47_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_48_01], '')) = 0 AND LEN([Sum_Q_48_01]) > 0) OR (ISNUMERIC([Sum_Q_48_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_48_02], '')) = 0 AND LEN([Sum_Q_48_02]) > 0) OR (ISNUMERIC([Sum_Q_48_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_48_03], '')) = 0 AND LEN([Sum_Q_48_03]) > 0) OR (ISNUMERIC([Sum_Q_48_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_48_04], '')) = 0 AND LEN([Sum_Q_48_04]) > 0) OR (ISNUMERIC([Sum_Q_48_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_48_05], '')) = 0 AND LEN([Sum_Q_48_05]) > 0) OR (ISNUMERIC([Sum_Q_48_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_48_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_49_01], '')) = 0 AND LEN([Sum_Q_49_01]) > 0) OR (ISNUMERIC([Sum_Q_49_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_49_02], '')) = 0 AND LEN([Sum_Q_49_02]) > 0) OR (ISNUMERIC([Sum_Q_49_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_49_03], '')) = 0 AND LEN([Sum_Q_49_03]) > 0) OR (ISNUMERIC([Sum_Q_49_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_49_04], '')) = 0 AND LEN([Sum_Q_49_04]) > 0) OR (ISNUMERIC([Sum_Q_49_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_49_05], '')) = 0 AND LEN([Sum_Q_49_05]) > 0) OR (ISNUMERIC([Sum_Q_49_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_49_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_50_01], '')) = 0 AND LEN([Sum_Q_50_01]) > 0) OR (ISNUMERIC([Sum_Q_50_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_50_02], '')) = 0 AND LEN([Sum_Q_50_02]) > 0) OR (ISNUMERIC([Sum_Q_50_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_50_03], '')) = 0 AND LEN([Sum_Q_50_03]) > 0) OR (ISNUMERIC([Sum_Q_50_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_50_04], '')) = 0 AND LEN([Sum_Q_50_04]) > 0) OR (ISNUMERIC([Sum_Q_50_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_50_05], '')) = 0 AND LEN([Sum_Q_50_05]) > 0) OR (ISNUMERIC([Sum_Q_50_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_50_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_51_01], '')) = 0 AND LEN([Sum_Q_51_01]) > 0) OR (ISNUMERIC([Sum_Q_51_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_51_02], '')) = 0 AND LEN([Sum_Q_51_02]) > 0) OR (ISNUMERIC([Sum_Q_51_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_51_03], '')) = 0 AND LEN([Sum_Q_51_03]) > 0) OR (ISNUMERIC([Sum_Q_51_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_51_04], '')) = 0 AND LEN([Sum_Q_51_04]) > 0) OR (ISNUMERIC([Sum_Q_51_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_51_05], '')) = 0 AND LEN([Sum_Q_51_05]) > 0) OR (ISNUMERIC([Sum_Q_51_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_51_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_52_01], '')) = 0 AND LEN([Sum_Q_52_01]) > 0) OR (ISNUMERIC([Sum_Q_52_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_52_02], '')) = 0 AND LEN([Sum_Q_52_02]) > 0) OR (ISNUMERIC([Sum_Q_52_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_52_03], '')) = 0 AND LEN([Sum_Q_52_03]) > 0) OR (ISNUMERIC([Sum_Q_52_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_52_04], '')) = 0 AND LEN([Sum_Q_52_04]) > 0) OR (ISNUMERIC([Sum_Q_52_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_52_05], '')) = 0 AND LEN([Sum_Q_52_05]) > 0) OR (ISNUMERIC([Sum_Q_52_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_52_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_53_01], '')) = 0 AND LEN([Sum_Q_53_01]) > 0) OR (ISNUMERIC([Sum_Q_53_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_53_02], '')) = 0 AND LEN([Sum_Q_53_02]) > 0) OR (ISNUMERIC([Sum_Q_53_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_53_03], '')) = 0 AND LEN([Sum_Q_53_03]) > 0) OR (ISNUMERIC([Sum_Q_53_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_53_04], '')) = 0 AND LEN([Sum_Q_53_04]) > 0) OR (ISNUMERIC([Sum_Q_53_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_53_05], '')) = 0 AND LEN([Sum_Q_53_05]) > 0) OR (ISNUMERIC([Sum_Q_53_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_53_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_54_01], '')) = 0 AND LEN([Sum_Q_54_01]) > 0) OR (ISNUMERIC([Sum_Q_54_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_54_02], '')) = 0 AND LEN([Sum_Q_54_02]) > 0) OR (ISNUMERIC([Sum_Q_54_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_54_03], '')) = 0 AND LEN([Sum_Q_54_03]) > 0) OR (ISNUMERIC([Sum_Q_54_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_54_04], '')) = 0 AND LEN([Sum_Q_54_04]) > 0) OR (ISNUMERIC([Sum_Q_54_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_54_05], '')) = 0 AND LEN([Sum_Q_54_05]) > 0) OR (ISNUMERIC([Sum_Q_54_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_54_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_55_01], '')) = 0 AND LEN([Sum_Q_55_01]) > 0) OR (ISNUMERIC([Sum_Q_55_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_55_02], '')) = 0 AND LEN([Sum_Q_55_02]) > 0) OR (ISNUMERIC([Sum_Q_55_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_55_03], '')) = 0 AND LEN([Sum_Q_55_03]) > 0) OR (ISNUMERIC([Sum_Q_55_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_55_04], '')) = 0 AND LEN([Sum_Q_55_04]) > 0) OR (ISNUMERIC([Sum_Q_55_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_55_05], '')) = 0 AND LEN([Sum_Q_55_05]) > 0) OR (ISNUMERIC([Sum_Q_55_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_55_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_56_01], '')) = 0 AND LEN([Sum_Q_56_01]) > 0) OR (ISNUMERIC([Sum_Q_56_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_56_02], '')) = 0 AND LEN([Sum_Q_56_02]) > 0) OR (ISNUMERIC([Sum_Q_56_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_56_03], '')) = 0 AND LEN([Sum_Q_56_03]) > 0) OR (ISNUMERIC([Sum_Q_56_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_56_04], '')) = 0 AND LEN([Sum_Q_56_04]) > 0) OR (ISNUMERIC([Sum_Q_56_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_56_05], '')) = 0 AND LEN([Sum_Q_56_05]) > 0) OR (ISNUMERIC([Sum_Q_56_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_56_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_57_01], '')) = 0 AND LEN([Sum_Q_57_01]) > 0) OR (ISNUMERIC([Sum_Q_57_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_57_02], '')) = 0 AND LEN([Sum_Q_57_02]) > 0) OR (ISNUMERIC([Sum_Q_57_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_57_03], '')) = 0 AND LEN([Sum_Q_57_03]) > 0) OR (ISNUMERIC([Sum_Q_57_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_57_04], '')) = 0 AND LEN([Sum_Q_57_04]) > 0) OR (ISNUMERIC([Sum_Q_57_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_57_05], '')) = 0 AND LEN([Sum_Q_57_05]) > 0) OR (ISNUMERIC([Sum_Q_57_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_57_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_58_01], '')) = 0 AND LEN([Sum_Q_58_01]) > 0) OR (ISNUMERIC([Sum_Q_58_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_58_02], '')) = 0 AND LEN([Sum_Q_58_02]) > 0) OR (ISNUMERIC([Sum_Q_58_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_58_03], '')) = 0 AND LEN([Sum_Q_58_03]) > 0) OR (ISNUMERIC([Sum_Q_58_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_58_04], '')) = 0 AND LEN([Sum_Q_58_04]) > 0) OR (ISNUMERIC([Sum_Q_58_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_58_05], '')) = 0 AND LEN([Sum_Q_58_05]) > 0) OR (ISNUMERIC([Sum_Q_58_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_58_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_59_01], '')) = 0 AND LEN([Sum_Q_59_01]) > 0) OR (ISNUMERIC([Sum_Q_59_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_59_02], '')) = 0 AND LEN([Sum_Q_59_02]) > 0) OR (ISNUMERIC([Sum_Q_59_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_59_03], '')) = 0 AND LEN([Sum_Q_59_03]) > 0) OR (ISNUMERIC([Sum_Q_59_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_59_04], '')) = 0 AND LEN([Sum_Q_59_04]) > 0) OR (ISNUMERIC([Sum_Q_59_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_59_05], '')) = 0 AND LEN([Sum_Q_59_05]) > 0) OR (ISNUMERIC([Sum_Q_59_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_59_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_60_01], '')) = 0 AND LEN([Sum_Q_60_01]) > 0) OR (ISNUMERIC([Sum_Q_60_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_60_02], '')) = 0 AND LEN([Sum_Q_60_02]) > 0) OR (ISNUMERIC([Sum_Q_60_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_60_03], '')) = 0 AND LEN([Sum_Q_60_03]) > 0) OR (ISNUMERIC([Sum_Q_60_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_60_04], '')) = 0 AND LEN([Sum_Q_60_04]) > 0) OR (ISNUMERIC([Sum_Q_60_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_60_05], '')) = 0 AND LEN([Sum_Q_60_05]) > 0) OR (ISNUMERIC([Sum_Q_60_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_60_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_61_01], '')) = 0 AND LEN([Sum_Q_61_01]) > 0) OR (ISNUMERIC([Sum_Q_61_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_61_02], '')) = 0 AND LEN([Sum_Q_61_02]) > 0) OR (ISNUMERIC([Sum_Q_61_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_61_03], '')) = 0 AND LEN([Sum_Q_61_03]) > 0) OR (ISNUMERIC([Sum_Q_61_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_61_04], '')) = 0 AND LEN([Sum_Q_61_04]) > 0) OR (ISNUMERIC([Sum_Q_61_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_61_05], '')) = 0 AND LEN([Sum_Q_61_05]) > 0) OR (ISNUMERIC([Sum_Q_61_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_61_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_62_01], '')) = 0 AND LEN([Sum_Q_62_01]) > 0) OR (ISNUMERIC([Sum_Q_62_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_62_02], '')) = 0 AND LEN([Sum_Q_62_02]) > 0) OR (ISNUMERIC([Sum_Q_62_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_62_03], '')) = 0 AND LEN([Sum_Q_62_03]) > 0) OR (ISNUMERIC([Sum_Q_62_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_62_04], '')) = 0 AND LEN([Sum_Q_62_04]) > 0) OR (ISNUMERIC([Sum_Q_62_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_62_05], '')) = 0 AND LEN([Sum_Q_62_05]) > 0) OR (ISNUMERIC([Sum_Q_62_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_62_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_63_01], '')) = 0 AND LEN([Sum_Q_63_01]) > 0) OR (ISNUMERIC([Sum_Q_63_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_63_02], '')) = 0 AND LEN([Sum_Q_63_02]) > 0) OR (ISNUMERIC([Sum_Q_63_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_63_03], '')) = 0 AND LEN([Sum_Q_63_03]) > 0) OR (ISNUMERIC([Sum_Q_63_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_63_04], '')) = 0 AND LEN([Sum_Q_63_04]) > 0) OR (ISNUMERIC([Sum_Q_63_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_63_05], '')) = 0 AND LEN([Sum_Q_63_05]) > 0) OR (ISNUMERIC([Sum_Q_63_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_63_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_01], '')) = 0 AND LEN([Sum_Q_64_01]) > 0) OR (ISNUMERIC([Sum_Q_64_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_02], '')) = 0 AND LEN([Sum_Q_64_02]) > 0) OR (ISNUMERIC([Sum_Q_64_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_03], '')) = 0 AND LEN([Sum_Q_64_03]) > 0) OR (ISNUMERIC([Sum_Q_64_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_04], '')) = 0 AND LEN([Sum_Q_64_04]) > 0) OR (ISNUMERIC([Sum_Q_64_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_05], '')) = 0 AND LEN([Sum_Q_64_05]) > 0) OR (ISNUMERIC([Sum_Q_64_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_64_06], '')) = 0 AND LEN([Sum_Q_64_06]) > 0) OR (ISNUMERIC([Sum_Q_64_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_64_06]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_01], '')) = 0 AND LEN([Sum_Q_65_01]) > 0) OR (ISNUMERIC([Sum_Q_65_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_02], '')) = 0 AND LEN([Sum_Q_65_02]) > 0) OR (ISNUMERIC([Sum_Q_65_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_03], '')) = 0 AND LEN([Sum_Q_65_03]) > 0) OR (ISNUMERIC([Sum_Q_65_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_04], '')) = 0 AND LEN([Sum_Q_65_04]) > 0) OR (ISNUMERIC([Sum_Q_65_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_05], '')) = 0 AND LEN([Sum_Q_65_05]) > 0) OR (ISNUMERIC([Sum_Q_65_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_65_06], '')) = 0 AND LEN([Sum_Q_65_06]) > 0) OR (ISNUMERIC([Sum_Q_65_06]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_65_06]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_66_01], '')) = 0 AND LEN([Sum_Q_66_01]) > 0) OR (ISNUMERIC([Sum_Q_66_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_66_02], '')) = 0 AND LEN([Sum_Q_66_02]) > 0) OR (ISNUMERIC([Sum_Q_66_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_66_03], '')) = 0 AND LEN([Sum_Q_66_03]) > 0) OR (ISNUMERIC([Sum_Q_66_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_66_04], '')) = 0 AND LEN([Sum_Q_66_04]) > 0) OR (ISNUMERIC([Sum_Q_66_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_66_05], '')) = 0 AND LEN([Sum_Q_66_05]) > 0) OR (ISNUMERIC([Sum_Q_66_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_66_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_67_01], '')) = 0 AND LEN([Sum_Q_67_01]) > 0) OR (ISNUMERIC([Sum_Q_67_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_67_02], '')) = 0 AND LEN([Sum_Q_67_02]) > 0) OR (ISNUMERIC([Sum_Q_67_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_67_03], '')) = 0 AND LEN([Sum_Q_67_03]) > 0) OR (ISNUMERIC([Sum_Q_67_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_67_04], '')) = 0 AND LEN([Sum_Q_67_04]) > 0) OR (ISNUMERIC([Sum_Q_67_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_67_05], '')) = 0 AND LEN([Sum_Q_67_05]) > 0) OR (ISNUMERIC([Sum_Q_67_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_67_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_68_01], '')) = 0 AND LEN([Sum_Q_68_01]) > 0) OR (ISNUMERIC([Sum_Q_68_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_68_02], '')) = 0 AND LEN([Sum_Q_68_02]) > 0) OR (ISNUMERIC([Sum_Q_68_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_68_03], '')) = 0 AND LEN([Sum_Q_68_03]) > 0) OR (ISNUMERIC([Sum_Q_68_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_68_04], '')) = 0 AND LEN([Sum_Q_68_04]) > 0) OR (ISNUMERIC([Sum_Q_68_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_68_05], '')) = 0 AND LEN([Sum_Q_68_05]) > 0) OR (ISNUMERIC([Sum_Q_68_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_68_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_69_01], '')) = 0 AND LEN([Sum_Q_69_01]) > 0) OR (ISNUMERIC([Sum_Q_69_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_69_02], '')) = 0 AND LEN([Sum_Q_69_02]) > 0) OR (ISNUMERIC([Sum_Q_69_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_69_03], '')) = 0 AND LEN([Sum_Q_69_03]) > 0) OR (ISNUMERIC([Sum_Q_69_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_69_04], '')) = 0 AND LEN([Sum_Q_69_04]) > 0) OR (ISNUMERIC([Sum_Q_69_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_69_05], '')) = 0 AND LEN([Sum_Q_69_05]) > 0) OR (ISNUMERIC([Sum_Q_69_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_69_05]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_70_01], '')) = 0 AND LEN([Sum_Q_70_01]) > 0) OR (ISNUMERIC([Sum_Q_70_01]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_01]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_70_02], '')) = 0 AND LEN([Sum_Q_70_02]) > 0) OR (ISNUMERIC([Sum_Q_70_02]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_02]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_70_03], '')) = 0 AND LEN([Sum_Q_70_03]) > 0) OR (ISNUMERIC([Sum_Q_70_03]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_03]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_70_04], '')) = 0 AND LEN([Sum_Q_70_04]) > 0) OR (ISNUMERIC([Sum_Q_70_04]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_04]) < 0))
			OR ((ISNUMERIC(COALESCE([Sum_Q_70_05], '')) = 0 AND LEN([Sum_Q_70_05]) > 0) OR (ISNUMERIC([Sum_Q_70_05]) = 1 AND CONVERT(DECIMAL(20, 6), [Sum_Q_70_05]) < 0))

;
COMMIT TRAN
END