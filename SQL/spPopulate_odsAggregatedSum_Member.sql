/*
truncate table Seer_ODS.dbo.Aggregated_Data_Sum
drop procedure spPopulate_odsAggregatedSum_Member
select * from Seer_ODS.dbo.Aggregated_Data_Sum
select * from Seer_CTRL.dbo.[Member Aggregated Data]
*/
CREATE PROCEDURE spPopulate_odsAggregatedSum_Member AS
BEGIN

--DECLARE @next_change_datetime datetime
--SET @next_change_datetime = getdate()

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Aggregated_Data_Sum AS target
	USING	(
			SELECT	B.aggregated_data_key,
					B.change_datetime,
					B.next_change_datetime,
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
					CASE WHEN LEN(COALESCE(A.[Involvement Percentile], '')) = 0 THEN '0' ELSE A.[Involvement Percentile] END [involvement_percentile],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01b_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01b_01] END [sum_m_01b_01],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01c_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01c_01] END [sum_m_01c_01],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01d_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01d_01] END [sum_m_01d_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_01] END [sum_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_02] END [sum_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_03] END [sum_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_04] END [sum_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_05] END [sum_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_01] END [sum_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_02] END [sum_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_03] END [sum_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_04] END [sum_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_05] END [sum_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_01] END [sum_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_02] END [sum_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_03] END [sum_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_04] END [sum_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_05] END [sum_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_01] END [sum_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_02] END [sum_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_03] END [sum_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_04] END [sum_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_05] END [sum_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_01] END [sum_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_02] END [sum_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_03] END [sum_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_04] END [sum_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_05] END [sum_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_01] END [sum_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_02] END [sum_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_03] END [sum_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_04] END [sum_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_05] END [sum_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_01] END [sum_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_02] END [sum_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_03] END [sum_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_04] END [sum_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_05] END [sum_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_01] END [sum_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_02] END [sum_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_03] END [sum_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_04] END [sum_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_05] END [sum_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_01] END [sum_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_02] END [sum_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_03] END [sum_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_04] END [sum_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_05] END [sum_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_01] END [sum_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_02] END [sum_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_03] END [sum_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_04] END [sum_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_05] END [sum_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_01] END [sum_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_02] END [sum_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_03] END [sum_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_04] END [sum_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_05] END [sum_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_01] END [sum_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_02] END [sum_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_03] END [sum_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_04] END [sum_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_05] END [sum_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_01] END [sum_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_02] END [sum_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_03] END [sum_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_04] END [sum_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_05] END [sum_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_01] END [sum_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_02] END [sum_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_03] END [sum_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_04] END [sum_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_05] END [sum_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_01] END [sum_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_02] END [sum_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_03] END [sum_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_04] END [sum_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_05] END [sum_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_01] END [sum_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_02] END [sum_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_03] END [sum_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_04] END [sum_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_05] END [sum_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_01] END [sum_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_02] END [sum_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_03] END [sum_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_04] END [sum_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_05] END [sum_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_01] END [sum_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_02] END [sum_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_03] END [sum_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_04] END [sum_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_05] END [sum_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_01] END [sum_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_02] END [sum_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_03] END [sum_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_04] END [sum_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_05] END [sum_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_01] END [sum_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_02] END [sum_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_03] END [sum_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_04] END [sum_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_05] END [sum_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_01] END [sum_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_02] END [sum_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_03] END [sum_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_04] END [sum_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_05] END [sum_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_01] END [sum_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_02] END [sum_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_03] END [sum_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_04] END [sum_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_05] END [sum_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_01] END [sum_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_02] END [sum_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_03] END [sum_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_04] END [sum_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_05] END [sum_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_01] END [sum_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_02] END [sum_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_03] END [sum_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_04] END [sum_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_05] END [sum_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_01] END [sum_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_02] END [sum_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_03] END [sum_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_04] END [sum_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_05] END [sum_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_01] END [sum_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_02] END [sum_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_03] END [sum_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_04] END [sum_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_05] END [sum_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_01] END [sum_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_02] END [sum_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_03] END [sum_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_04] END [sum_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_05] END [sum_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_01] END [sum_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_02] END [sum_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_03] END [sum_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_04] END [sum_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_05] END [sum_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_01] END [sum_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_02] END [sum_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_03] END [sum_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_04] END [sum_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_05] END [sum_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_01] END [sum_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_02] END [sum_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_03] END [sum_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_04] END [sum_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_05] END [sum_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_01] END [sum_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_02] END [sum_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_03] END [sum_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_04] END [sum_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_05] END [sum_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_00] END [sum_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_01] END [sum_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_10] END [sum_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_02] END [sum_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_03] END [sum_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_04] END [sum_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_05] END [sum_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_06] END [sum_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_07] END [sum_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_08] END [sum_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_09] END [sum_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_01] END [sum_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_02] END [sum_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_03] END [sum_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_04] END [sum_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_05] END [sum_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_01] END [sum_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_02] END [sum_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_03] END [sum_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_04] END [sum_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_05] END [sum_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_00] END [sum_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_01] END [sum_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_10] END [sum_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_02] END [sum_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_03] END [sum_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_04] END [sum_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_05] END [sum_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_06] END [sum_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_07] END [sum_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_08] END [sum_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_09] END [sum_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_01] END [sum_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_02] END [sum_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_03] END [sum_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_04] END [sum_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_05] END [sum_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_01] END [sum_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_02] END [sum_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_03] END [sum_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_04] END [sum_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_05] END [sum_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_01] END [sum_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_02] END [sum_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_03] END [sum_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_04] END [sum_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_05] END [sum_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_01] END [sum_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_02] END [sum_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_03] END [sum_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_04] END [sum_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_05] END [sum_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_01] END [sum_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_02] END [sum_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_03] END [sum_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_04] END [sum_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_05] END [sum_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_01] END [sum_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_02] END [sum_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_03] END [sum_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_04] END [sum_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_05] END [sum_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_01] END [sum_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_02] END [sum_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_03] END [sum_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_04] END [sum_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_05] END [sum_q_42_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_01] END [sum_q_43_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_02] END [sum_q_43_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_03] END [sum_q_43_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_04] END [sum_q_43_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_05] END [sum_q_43_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_01] END [sum_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_02] END [sum_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_03] END [sum_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_04] END [sum_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_05] END [sum_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_01] END [sum_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_02] END [sum_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_03] END [sum_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_04] END [sum_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_05] END [sum_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_00] END [sum_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_01] END [sum_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_10] END [sum_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_02] END [sum_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_03] END [sum_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_04] END [sum_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_05] END [sum_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_06] END [sum_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_07] END [sum_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_08] END [sum_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_09] END [sum_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_01] END [sum_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_02] END [sum_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_03] END [sum_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_04] END [sum_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_05] END [sum_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_01] END [sum_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_02] END [sum_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_03] END [sum_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_04] END [sum_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_05] END [sum_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_01] END [sum_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_02] END [sum_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_03] END [sum_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_04] END [sum_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_05] END [sum_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_01] END [sum_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_02] END [sum_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_03] END [sum_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_04] END [sum_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_05] END [sum_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_01] END [sum_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_02] END [sum_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_03] END [sum_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_04] END [sum_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_05] END [sum_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_01] END [sum_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_02] END [sum_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_03] END [sum_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_04] END [sum_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_05] END [sum_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_01] END [sum_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_02] END [sum_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_03] END [sum_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_04] END [sum_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_05] END [sum_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_01] END [sum_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_02] END [sum_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_03] END [sum_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_04] END [sum_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_05] END [sum_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_01] END [sum_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_02] END [sum_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_03] END [sum_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_04] END [sum_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_05] END [sum_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_01] END [sum_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_02] END [sum_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_03] END [sum_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_04] END [sum_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_05] END [sum_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_01] END [sum_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_02] END [sum_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_03] END [sum_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_04] END [sum_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_05] END [sum_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_01] END [sum_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_02] END [sum_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_03] END [sum_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_04] END [sum_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_05] END [sum_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_01] END [sum_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_02] END [sum_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_03] END [sum_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_04] END [sum_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_05] END [sum_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_01] END [sum_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_02] END [sum_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_03] END [sum_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_04] END [sum_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_05] END [sum_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_01] END [sum_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_02] END [sum_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_03] END [sum_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_04] END [sum_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_05] END [sum_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_01] END [sum_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_02] END [sum_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_03] END [sum_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_04] END [sum_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_05] END [sum_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_01] END [sum_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_02] END [sum_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_03] END [sum_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_04] END [sum_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_05] END [sum_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_01] END [sum_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_02] END [sum_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_03] END [sum_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_04] END [sum_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_05] END [sum_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_06] END [sum_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_01] END [sum_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_02] END [sum_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_03] END [sum_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_04] END [sum_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_05] END [sum_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_06] END [sum_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_01] END [sum_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_02] END [sum_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_03] END [sum_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_04] END [sum_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_05] END [sum_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_01] END [sum_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_02] END [sum_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_03] END [sum_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_04] END [sum_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_05] END [sum_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_01] END [sum_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_02] END [sum_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_03] END [sum_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_04] END [sum_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_05] END [sum_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_01] END [sum_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_02] END [sum_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_03] END [sum_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_04] END [sum_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_05] END [sum_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_01] END [sum_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_02] END [sum_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_03] END [sum_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_04] END [sum_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_05] END [sum_q_70_05]

			FROM	Seer_STG.dbo.[Member Aggregated Data] A
					INNER JOIN Seer_ODS.dbo.Aggregated_Data B
					ON A.aggregate_type = B.aggregate_type
						AND A.form_code = B.form_code
						AND CASE WHEN LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'National' THEN '0000'
								ELSE A.[OFF_ASSOC_NUM]
							END  = B.official_association_number
						AND CASE WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) <> 3 THEN A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'National' THEN '0000'
								WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
								ELSE COALESCE(A.[OFF_BR_Num], '')
							END = B.official_branch_number
						
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
					AND ((ISNUMERIC(A.[achievement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([achievement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[belonging z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([belonging z-score], '')) = 0))
					AND ((ISNUMERIC(A.[character z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([character z-score], '')) = 0))
					AND ((ISNUMERIC(A.[giving z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([giving z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health z-score], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([inspiration z-score], '')) = 0))
					AND ((ISNUMERIC(A.[meaning z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([meaning z-score], '')) = 0))
					AND ((ISNUMERIC(A.[relationship z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([relationship z-score], '')) = 0))
					AND ((ISNUMERIC(A.[safety z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([safety z-score], '')) = 0))
					AND ((ISNUMERIC(A.[achievement percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([achievement percentile], '')) = 0))
					AND ((ISNUMERIC(A.[belonging percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([belonging percentile], '')) = 0))
					AND ((ISNUMERIC(A.[character percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([character percentile], '')) = 0))
					AND ((ISNUMERIC(A.[giving percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([giving percentile], '')) = 0))
					AND ((ISNUMERIC(A.[health percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health percentile], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([inspiration percentile], '')) = 0))
					AND ((ISNUMERIC(A.[meaning percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([meaning percentile], '')) = 0))
					AND ((ISNUMERIC(A.[relationship percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([relationship percentile], '')) = 0))
					AND ((ISNUMERIC(A.[safety percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([safety percentile], '')) = 0))
					AND ((ISNUMERIC(A.[facilities z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[facilities z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([facilities z-score], '')) = 0))
					AND ((ISNUMERIC(A.[service z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[service z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([service z-score], '')) = 0))
					AND ((ISNUMERIC(A.[value z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[value z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([value z-score], '')) = 0))
					AND ((ISNUMERIC(A.[engagement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[engagement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([engagement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health and wellness z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health and wellness z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health and wellness z-score], '')) = 0))
					AND ((ISNUMERIC(A.[involvement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[involvement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([involvement z-score], '')) = 0))
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
			ON target.aggregated_data_key = source.aggregated_data_key
				AND target.current_indicator = source.current_indicator
			
			WHEN MATCHED AND (target.[Sum_M_01b_01] <> source.[Sum_M_01b_01]
								OR target.[Sum_M_01c_01] <> source.[Sum_M_01c_01]
								OR target.[Sum_M_01d_01] <> source.[Sum_M_01d_01]
								OR target.[Sum_Q_01_01] <> source.[Sum_Q_01_01]
								OR target.[Sum_Q_01_02] <> source.[Sum_Q_01_02]
								OR target.[Sum_Q_01_03] <> source.[Sum_Q_01_03]
								OR target.[Sum_Q_01_04] <> source.[Sum_Q_01_04]
								OR target.[Sum_Q_01_05] <> source.[Sum_Q_01_05]
								OR target.[Sum_Q_02_01] <> source.[Sum_Q_02_01]
								OR target.[Sum_Q_02_02] <> source.[Sum_Q_02_02]
								OR target.[Sum_Q_02_03] <> source.[Sum_Q_02_03]
								OR target.[Sum_Q_02_04] <> source.[Sum_Q_02_04]
								OR target.[Sum_Q_02_05] <> source.[Sum_Q_02_05]
								OR target.[Sum_Q_03_01] <> source.[Sum_Q_03_01]
								OR target.[Sum_Q_03_02] <> source.[Sum_Q_03_02]
								OR target.[Sum_Q_03_03] <> source.[Sum_Q_03_03]
								OR target.[Sum_Q_03_04] <> source.[Sum_Q_03_04]
								OR target.[Sum_Q_03_05] <> source.[Sum_Q_03_05]
								OR target.[Sum_Q_04_01] <> source.[Sum_Q_04_01]
								OR target.[Sum_Q_04_02] <> source.[Sum_Q_04_02]
								OR target.[Sum_Q_04_03] <> source.[Sum_Q_04_03]
								OR target.[Sum_Q_04_04] <> source.[Sum_Q_04_04]
								OR target.[Sum_Q_04_05] <> source.[Sum_Q_04_05]
								OR target.[Sum_Q_05_01] <> source.[Sum_Q_05_01]
								OR target.[Sum_Q_05_02] <> source.[Sum_Q_05_02]
								OR target.[Sum_Q_05_03] <> source.[Sum_Q_05_03]
								OR target.[Sum_Q_05_04] <> source.[Sum_Q_05_04]
								OR target.[Sum_Q_05_05] <> source.[Sum_Q_05_05]
								OR target.[Sum_Q_06_01] <> source.[Sum_Q_06_01]
								OR target.[Sum_Q_06_02] <> source.[Sum_Q_06_02]
								OR target.[Sum_Q_06_03] <> source.[Sum_Q_06_03]
								OR target.[Sum_Q_06_04] <> source.[Sum_Q_06_04]
								OR target.[Sum_Q_06_05] <> source.[Sum_Q_06_05]
								OR target.[Sum_Q_07_01] <> source.[Sum_Q_07_01]
								OR target.[Sum_Q_07_02] <> source.[Sum_Q_07_02]
								OR target.[Sum_Q_07_03] <> source.[Sum_Q_07_03]
								OR target.[Sum_Q_07_04] <> source.[Sum_Q_07_04]
								OR target.[Sum_Q_07_05] <> source.[Sum_Q_07_05]
								OR target.[Sum_Q_08_01] <> source.[Sum_Q_08_01]
								OR target.[Sum_Q_08_02] <> source.[Sum_Q_08_02]
								OR target.[Sum_Q_08_03] <> source.[Sum_Q_08_03]
								OR target.[Sum_Q_08_04] <> source.[Sum_Q_08_04]
								OR target.[Sum_Q_08_05] <> source.[Sum_Q_08_05]
								OR target.[Sum_Q_09_01] <> source.[Sum_Q_09_01]
								OR target.[Sum_Q_09_02] <> source.[Sum_Q_09_02]
								OR target.[Sum_Q_09_03] <> source.[Sum_Q_09_03]
								OR target.[Sum_Q_09_04] <> source.[Sum_Q_09_04]
								OR target.[Sum_Q_09_05] <> source.[Sum_Q_09_05]
								OR target.[Sum_Q_10_01] <> source.[Sum_Q_10_01]
								OR target.[Sum_Q_10_02] <> source.[Sum_Q_10_02]
								OR target.[Sum_Q_10_03] <> source.[Sum_Q_10_03]
								OR target.[Sum_Q_10_04] <> source.[Sum_Q_10_04]
								OR target.[Sum_Q_10_05] <> source.[Sum_Q_10_05]
								OR target.[Sum_Q_11_01] <> source.[Sum_Q_11_01]
								OR target.[Sum_Q_11_02] <> source.[Sum_Q_11_02]
								OR target.[Sum_Q_11_03] <> source.[Sum_Q_11_03]
								OR target.[Sum_Q_11_04] <> source.[Sum_Q_11_04]
								OR target.[Sum_Q_11_05] <> source.[Sum_Q_11_05]
								OR target.[Sum_Q_12_01] <> source.[Sum_Q_12_01]
								OR target.[Sum_Q_12_02] <> source.[Sum_Q_12_02]
								OR target.[Sum_Q_12_03] <> source.[Sum_Q_12_03]
								OR target.[Sum_Q_12_04] <> source.[Sum_Q_12_04]
								OR target.[Sum_Q_12_05] <> source.[Sum_Q_12_05]
								OR target.[Sum_Q_13_01] <> source.[Sum_Q_13_01]
								OR target.[Sum_Q_13_02] <> source.[Sum_Q_13_02]
								OR target.[Sum_Q_13_03] <> source.[Sum_Q_13_03]
								OR target.[Sum_Q_13_04] <> source.[Sum_Q_13_04]
								OR target.[Sum_Q_13_05] <> source.[Sum_Q_13_05]
								OR target.[Sum_Q_14_01] <> source.[Sum_Q_14_01]
								OR target.[Sum_Q_14_02] <> source.[Sum_Q_14_02]
								OR target.[Sum_Q_14_03] <> source.[Sum_Q_14_03]
								OR target.[Sum_Q_14_04] <> source.[Sum_Q_14_04]
								OR target.[Sum_Q_14_05] <> source.[Sum_Q_14_05]
								OR target.[Sum_Q_15_01] <> source.[Sum_Q_15_01]
								OR target.[Sum_Q_15_02] <> source.[Sum_Q_15_02]
								OR target.[Sum_Q_15_03] <> source.[Sum_Q_15_03]
								OR target.[Sum_Q_15_04] <> source.[Sum_Q_15_04]
								OR target.[Sum_Q_15_05] <> source.[Sum_Q_15_05]
								OR target.[Sum_Q_16_01] <> source.[Sum_Q_16_01]
								OR target.[Sum_Q_16_02] <> source.[Sum_Q_16_02]
								OR target.[Sum_Q_16_03] <> source.[Sum_Q_16_03]
								OR target.[Sum_Q_16_04] <> source.[Sum_Q_16_04]
								OR target.[Sum_Q_16_05] <> source.[Sum_Q_16_05]
								OR target.[Sum_Q_17_01] <> source.[Sum_Q_17_01]
								OR target.[Sum_Q_17_02] <> source.[Sum_Q_17_02]
								OR target.[Sum_Q_17_03] <> source.[Sum_Q_17_03]
								OR target.[Sum_Q_17_04] <> source.[Sum_Q_17_04]
								OR target.[Sum_Q_17_05] <> source.[Sum_Q_17_05]
								OR target.[Sum_Q_18_01] <> source.[Sum_Q_18_01]
								OR target.[Sum_Q_18_02] <> source.[Sum_Q_18_02]
								OR target.[Sum_Q_18_03] <> source.[Sum_Q_18_03]
								OR target.[Sum_Q_18_04] <> source.[Sum_Q_18_04]
								OR target.[Sum_Q_18_05] <> source.[Sum_Q_18_05]
								OR target.[Sum_Q_19_01] <> source.[Sum_Q_19_01]
								OR target.[Sum_Q_19_02] <> source.[Sum_Q_19_02]
								OR target.[Sum_Q_19_03] <> source.[Sum_Q_19_03]
								OR target.[Sum_Q_19_04] <> source.[Sum_Q_19_04]
								OR target.[Sum_Q_19_05] <> source.[Sum_Q_19_05]
								OR target.[Sum_Q_20_01] <> source.[Sum_Q_20_01]
								OR target.[Sum_Q_20_02] <> source.[Sum_Q_20_02]
								OR target.[Sum_Q_20_03] <> source.[Sum_Q_20_03]
								OR target.[Sum_Q_20_04] <> source.[Sum_Q_20_04]
								OR target.[Sum_Q_20_05] <> source.[Sum_Q_20_05]
								OR target.[Sum_Q_21_01] <> source.[Sum_Q_21_01]
								OR target.[Sum_Q_21_02] <> source.[Sum_Q_21_02]
								OR target.[Sum_Q_21_03] <> source.[Sum_Q_21_03]
								OR target.[Sum_Q_21_04] <> source.[Sum_Q_21_04]
								OR target.[Sum_Q_21_05] <> source.[Sum_Q_21_05]
								OR target.[Sum_Q_22_01] <> source.[Sum_Q_22_01]
								OR target.[Sum_Q_22_02] <> source.[Sum_Q_22_02]
								OR target.[Sum_Q_22_03] <> source.[Sum_Q_22_03]
								OR target.[Sum_Q_22_04] <> source.[Sum_Q_22_04]
								OR target.[Sum_Q_22_05] <> source.[Sum_Q_22_05]
								OR target.[Sum_Q_23_01] <> source.[Sum_Q_23_01]
								OR target.[Sum_Q_23_02] <> source.[Sum_Q_23_02]
								OR target.[Sum_Q_23_03] <> source.[Sum_Q_23_03]
								OR target.[Sum_Q_23_04] <> source.[Sum_Q_23_04]
								OR target.[Sum_Q_23_05] <> source.[Sum_Q_23_05]
								OR target.[Sum_Q_24_01] <> source.[Sum_Q_24_01]
								OR target.[Sum_Q_24_02] <> source.[Sum_Q_24_02]
								OR target.[Sum_Q_24_03] <> source.[Sum_Q_24_03]
								OR target.[Sum_Q_24_04] <> source.[Sum_Q_24_04]
								OR target.[Sum_Q_24_05] <> source.[Sum_Q_24_05]
								OR target.[Sum_Q_25_01] <> source.[Sum_Q_25_01]
								OR target.[Sum_Q_25_02] <> source.[Sum_Q_25_02]
								OR target.[Sum_Q_25_03] <> source.[Sum_Q_25_03]
								OR target.[Sum_Q_25_04] <> source.[Sum_Q_25_04]
								OR target.[Sum_Q_25_05] <> source.[Sum_Q_25_05]
								OR target.[Sum_Q_26_01] <> source.[Sum_Q_26_01]
								OR target.[Sum_Q_26_02] <> source.[Sum_Q_26_02]
								OR target.[Sum_Q_26_03] <> source.[Sum_Q_26_03]
								OR target.[Sum_Q_26_04] <> source.[Sum_Q_26_04]
								OR target.[Sum_Q_26_05] <> source.[Sum_Q_26_05]
								OR target.[Sum_Q_27_01] <> source.[Sum_Q_27_01]
								OR target.[Sum_Q_27_02] <> source.[Sum_Q_27_02]
								OR target.[Sum_Q_27_03] <> source.[Sum_Q_27_03]
								OR target.[Sum_Q_27_04] <> source.[Sum_Q_27_04]
								OR target.[Sum_Q_27_05] <> source.[Sum_Q_27_05]
								OR target.[Sum_Q_28_01] <> source.[Sum_Q_28_01]
								OR target.[Sum_Q_28_02] <> source.[Sum_Q_28_02]
								OR target.[Sum_Q_28_03] <> source.[Sum_Q_28_03]
								OR target.[Sum_Q_28_04] <> source.[Sum_Q_28_04]
								OR target.[Sum_Q_28_05] <> source.[Sum_Q_28_05]
								OR target.[Sum_Q_29_01] <> source.[Sum_Q_29_01]
								OR target.[Sum_Q_29_02] <> source.[Sum_Q_29_02]
								OR target.[Sum_Q_29_03] <> source.[Sum_Q_29_03]
								OR target.[Sum_Q_29_04] <> source.[Sum_Q_29_04]
								OR target.[Sum_Q_29_05] <> source.[Sum_Q_29_05]
								OR target.[Sum_Q_30_01] <> source.[Sum_Q_30_01]
								OR target.[Sum_Q_30_02] <> source.[Sum_Q_30_02]
								OR target.[Sum_Q_30_03] <> source.[Sum_Q_30_03]
								OR target.[Sum_Q_30_04] <> source.[Sum_Q_30_04]
								OR target.[Sum_Q_30_05] <> source.[Sum_Q_30_05]
								OR target.[Sum_Q_31_01] <> source.[Sum_Q_31_01]
								OR target.[Sum_Q_31_02] <> source.[Sum_Q_31_02]
								OR target.[Sum_Q_31_03] <> source.[Sum_Q_31_03]
								OR target.[Sum_Q_31_04] <> source.[Sum_Q_31_04]
								OR target.[Sum_Q_31_05] <> source.[Sum_Q_31_05]
								OR target.[Sum_Q_32_00] <> source.[Sum_Q_32_00]
								OR target.[Sum_Q_32_01] <> source.[Sum_Q_32_01]
								OR target.[Sum_Q_32_10] <> source.[Sum_Q_32_10]
								OR target.[Sum_Q_32_02] <> source.[Sum_Q_32_02]
								OR target.[Sum_Q_32_03] <> source.[Sum_Q_32_03]
								OR target.[Sum_Q_32_04] <> source.[Sum_Q_32_04]
								OR target.[Sum_Q_32_05] <> source.[Sum_Q_32_05]
								OR target.[Sum_Q_32_06] <> source.[Sum_Q_32_06]
								OR target.[Sum_Q_32_07] <> source.[Sum_Q_32_07]
								OR target.[Sum_Q_32_08] <> source.[Sum_Q_32_08]
								OR target.[Sum_Q_32_09] <> source.[Sum_Q_32_09]
								OR target.[Sum_Q_33_01] <> source.[Sum_Q_33_01]
								OR target.[Sum_Q_33_02] <> source.[Sum_Q_33_02]
								OR target.[Sum_Q_33_03] <> source.[Sum_Q_33_03]
								OR target.[Sum_Q_33_04] <> source.[Sum_Q_33_04]
								OR target.[Sum_Q_33_05] <> source.[Sum_Q_33_05]
								OR target.[Sum_Q_34_01] <> source.[Sum_Q_34_01]
								OR target.[Sum_Q_34_02] <> source.[Sum_Q_34_02]
								OR target.[Sum_Q_34_03] <> source.[Sum_Q_34_03]
								OR target.[Sum_Q_34_04] <> source.[Sum_Q_34_04]
								OR target.[Sum_Q_34_05] <> source.[Sum_Q_34_05]
								OR target.[Sum_Q_35_00] <> source.[Sum_Q_35_00]
								OR target.[Sum_Q_35_01] <> source.[Sum_Q_35_01]
								OR target.[Sum_Q_35_10] <> source.[Sum_Q_35_10]
								OR target.[Sum_Q_35_02] <> source.[Sum_Q_35_02]
								OR target.[Sum_Q_35_03] <> source.[Sum_Q_35_03]
								OR target.[Sum_Q_35_04] <> source.[Sum_Q_35_04]
								OR target.[Sum_Q_35_05] <> source.[Sum_Q_35_05]
								OR target.[Sum_Q_35_06] <> source.[Sum_Q_35_06]
								OR target.[Sum_Q_35_07] <> source.[Sum_Q_35_07]
								OR target.[Sum_Q_35_08] <> source.[Sum_Q_35_08]
								OR target.[Sum_Q_35_09] <> source.[Sum_Q_35_09]
								OR target.[Sum_Q_36_01] <> source.[Sum_Q_36_01]
								OR target.[Sum_Q_36_02] <> source.[Sum_Q_36_02]
								OR target.[Sum_Q_36_03] <> source.[Sum_Q_36_03]
								OR target.[Sum_Q_36_04] <> source.[Sum_Q_36_04]
								OR target.[Sum_Q_36_05] <> source.[Sum_Q_36_05]
								OR target.[Sum_Q_37_01] <> source.[Sum_Q_37_01]
								OR target.[Sum_Q_37_02] <> source.[Sum_Q_37_02]
								OR target.[Sum_Q_37_03] <> source.[Sum_Q_37_03]
								OR target.[Sum_Q_37_04] <> source.[Sum_Q_37_04]
								OR target.[Sum_Q_37_05] <> source.[Sum_Q_37_05]
								OR target.[Sum_Q_38_01] <> source.[Sum_Q_38_01]
								OR target.[Sum_Q_38_02] <> source.[Sum_Q_38_02]
								OR target.[Sum_Q_38_03] <> source.[Sum_Q_38_03]
								OR target.[Sum_Q_38_04] <> source.[Sum_Q_38_04]
								OR target.[Sum_Q_38_05] <> source.[Sum_Q_38_05]
								OR target.[Sum_Q_39_01] <> source.[Sum_Q_39_01]
								OR target.[Sum_Q_39_02] <> source.[Sum_Q_39_02]
								OR target.[Sum_Q_39_03] <> source.[Sum_Q_39_03]
								OR target.[Sum_Q_39_04] <> source.[Sum_Q_39_04]
								OR target.[Sum_Q_39_05] <> source.[Sum_Q_39_05]
								OR target.[Sum_Q_40_01] <> source.[Sum_Q_40_01]
								OR target.[Sum_Q_40_02] <> source.[Sum_Q_40_02]
								OR target.[Sum_Q_40_03] <> source.[Sum_Q_40_03]
								OR target.[Sum_Q_40_04] <> source.[Sum_Q_40_04]
								OR target.[Sum_Q_40_05] <> source.[Sum_Q_40_05]
								OR target.[Sum_Q_41_01] <> source.[Sum_Q_41_01]
								OR target.[Sum_Q_41_02] <> source.[Sum_Q_41_02]
								OR target.[Sum_Q_41_03] <> source.[Sum_Q_41_03]
								OR target.[Sum_Q_41_04] <> source.[Sum_Q_41_04]
								OR target.[Sum_Q_41_05] <> source.[Sum_Q_41_05]
								OR target.[Sum_Q_42_01] <> source.[Sum_Q_42_01]
								OR target.[Sum_Q_42_02] <> source.[Sum_Q_42_02]
								OR target.[Sum_Q_42_03] <> source.[Sum_Q_42_03]
								OR target.[Sum_Q_42_04] <> source.[Sum_Q_42_04]
								OR target.[Sum_Q_42_05] <> source.[Sum_Q_42_05]
								OR target.[Sum_Q_43_01] <> source.[Sum_Q_43_01]
								OR target.[Sum_Q_43_02] <> source.[Sum_Q_43_02]
								OR target.[Sum_Q_43_03] <> source.[Sum_Q_43_03]
								OR target.[Sum_Q_43_04] <> source.[Sum_Q_43_04]
								OR target.[Sum_Q_43_05] <> source.[Sum_Q_43_05]
								OR target.[Sum_Q_44_01] <> source.[Sum_Q_44_01]
								OR target.[Sum_Q_44_02] <> source.[Sum_Q_44_02]
								OR target.[Sum_Q_44_03] <> source.[Sum_Q_44_03]
								OR target.[Sum_Q_44_04] <> source.[Sum_Q_44_04]
								OR target.[Sum_Q_44_05] <> source.[Sum_Q_44_05]
								OR target.[Sum_Q_45_01] <> source.[Sum_Q_45_01]
								OR target.[Sum_Q_45_02] <> source.[Sum_Q_45_02]
								OR target.[Sum_Q_45_03] <> source.[Sum_Q_45_03]
								OR target.[Sum_Q_45_04] <> source.[Sum_Q_45_04]
								OR target.[Sum_Q_45_05] <> source.[Sum_Q_45_05]
								OR target.[Sum_Q_46_00] <> source.[Sum_Q_46_00]
								OR target.[Sum_Q_46_01] <> source.[Sum_Q_46_01]
								OR target.[Sum_Q_46_10] <> source.[Sum_Q_46_10]
								OR target.[Sum_Q_46_02] <> source.[Sum_Q_46_02]
								OR target.[Sum_Q_46_03] <> source.[Sum_Q_46_03]
								OR target.[Sum_Q_46_04] <> source.[Sum_Q_46_04]
								OR target.[Sum_Q_46_05] <> source.[Sum_Q_46_05]
								OR target.[Sum_Q_46_06] <> source.[Sum_Q_46_06]
								OR target.[Sum_Q_46_07] <> source.[Sum_Q_46_07]
								OR target.[Sum_Q_46_08] <> source.[Sum_Q_46_08]
								OR target.[Sum_Q_46_09] <> source.[Sum_Q_46_09]
								OR target.[Sum_Q_47_01] <> source.[Sum_Q_47_01]
								OR target.[Sum_Q_47_02] <> source.[Sum_Q_47_02]
								OR target.[Sum_Q_47_03] <> source.[Sum_Q_47_03]
								OR target.[Sum_Q_47_04] <> source.[Sum_Q_47_04]
								OR target.[Sum_Q_47_05] <> source.[Sum_Q_47_05]
								OR target.[Sum_Q_48_01] <> source.[Sum_Q_48_01]
								OR target.[Sum_Q_48_02] <> source.[Sum_Q_48_02]
								OR target.[Sum_Q_48_03] <> source.[Sum_Q_48_03]
								OR target.[Sum_Q_48_04] <> source.[Sum_Q_48_04]
								OR target.[Sum_Q_48_05] <> source.[Sum_Q_48_05]
								OR target.[Sum_Q_49_01] <> source.[Sum_Q_49_01]
								OR target.[Sum_Q_49_02] <> source.[Sum_Q_49_02]
								OR target.[Sum_Q_49_03] <> source.[Sum_Q_49_03]
								OR target.[Sum_Q_49_04] <> source.[Sum_Q_49_04]
								OR target.[Sum_Q_49_05] <> source.[Sum_Q_49_05]
								OR target.[Sum_Q_50_01] <> source.[Sum_Q_50_01]
								OR target.[Sum_Q_50_02] <> source.[Sum_Q_50_02]
								OR target.[Sum_Q_50_03] <> source.[Sum_Q_50_03]
								OR target.[Sum_Q_50_04] <> source.[Sum_Q_50_04]
								OR target.[Sum_Q_50_05] <> source.[Sum_Q_50_05]
								OR target.[Sum_Q_51_01] <> source.[Sum_Q_51_01]
								OR target.[Sum_Q_51_02] <> source.[Sum_Q_51_02]
								OR target.[Sum_Q_51_03] <> source.[Sum_Q_51_03]
								OR target.[Sum_Q_51_04] <> source.[Sum_Q_51_04]
								OR target.[Sum_Q_51_05] <> source.[Sum_Q_51_05]
								OR target.[Sum_Q_52_01] <> source.[Sum_Q_52_01]
								OR target.[Sum_Q_52_02] <> source.[Sum_Q_52_02]
								OR target.[Sum_Q_52_03] <> source.[Sum_Q_52_03]
								OR target.[Sum_Q_52_04] <> source.[Sum_Q_52_04]
								OR target.[Sum_Q_52_05] <> source.[Sum_Q_52_05]
								OR target.[Sum_Q_53_01] <> source.[Sum_Q_53_01]
								OR target.[Sum_Q_53_02] <> source.[Sum_Q_53_02]
								OR target.[Sum_Q_53_03] <> source.[Sum_Q_53_03]
								OR target.[Sum_Q_53_04] <> source.[Sum_Q_53_04]
								OR target.[Sum_Q_53_05] <> source.[Sum_Q_53_05]
								OR target.[Sum_Q_54_01] <> source.[Sum_Q_54_01]
								OR target.[Sum_Q_54_02] <> source.[Sum_Q_54_02]
								OR target.[Sum_Q_54_03] <> source.[Sum_Q_54_03]
								OR target.[Sum_Q_54_04] <> source.[Sum_Q_54_04]
								OR target.[Sum_Q_54_05] <> source.[Sum_Q_54_05]
								OR target.[Sum_Q_55_01] <> source.[Sum_Q_55_01]
								OR target.[Sum_Q_55_02] <> source.[Sum_Q_55_02]
								OR target.[Sum_Q_55_03] <> source.[Sum_Q_55_03]
								OR target.[Sum_Q_55_04] <> source.[Sum_Q_55_04]
								OR target.[Sum_Q_55_05] <> source.[Sum_Q_55_05]
								OR target.[Sum_Q_56_01] <> source.[Sum_Q_56_01]
								OR target.[Sum_Q_56_02] <> source.[Sum_Q_56_02]
								OR target.[Sum_Q_56_03] <> source.[Sum_Q_56_03]
								OR target.[Sum_Q_56_04] <> source.[Sum_Q_56_04]
								OR target.[Sum_Q_56_05] <> source.[Sum_Q_56_05]
								OR target.[Sum_Q_57_01] <> source.[Sum_Q_57_01]
								OR target.[Sum_Q_57_02] <> source.[Sum_Q_57_02]
								OR target.[Sum_Q_57_03] <> source.[Sum_Q_57_03]
								OR target.[Sum_Q_57_04] <> source.[Sum_Q_57_04]
								OR target.[Sum_Q_57_05] <> source.[Sum_Q_57_05]
								OR target.[Sum_Q_58_01] <> source.[Sum_Q_58_01]
								OR target.[Sum_Q_58_02] <> source.[Sum_Q_58_02]
								OR target.[Sum_Q_58_03] <> source.[Sum_Q_58_03]
								OR target.[Sum_Q_58_04] <> source.[Sum_Q_58_04]
								OR target.[Sum_Q_58_05] <> source.[Sum_Q_58_05]
								OR target.[Sum_Q_59_01] <> source.[Sum_Q_59_01]
								OR target.[Sum_Q_59_02] <> source.[Sum_Q_59_02]
								OR target.[Sum_Q_59_03] <> source.[Sum_Q_59_03]
								OR target.[Sum_Q_59_04] <> source.[Sum_Q_59_04]
								OR target.[Sum_Q_59_05] <> source.[Sum_Q_59_05]
								OR target.[Sum_Q_60_01] <> source.[Sum_Q_60_01]
								OR target.[Sum_Q_60_02] <> source.[Sum_Q_60_02]
								OR target.[Sum_Q_60_03] <> source.[Sum_Q_60_03]
								OR target.[Sum_Q_60_04] <> source.[Sum_Q_60_04]
								OR target.[Sum_Q_60_05] <> source.[Sum_Q_60_05]
								OR target.[Sum_Q_61_01] <> source.[Sum_Q_61_01]
								OR target.[Sum_Q_61_02] <> source.[Sum_Q_61_02]
								OR target.[Sum_Q_61_03] <> source.[Sum_Q_61_03]
								OR target.[Sum_Q_61_04] <> source.[Sum_Q_61_04]
								OR target.[Sum_Q_61_05] <> source.[Sum_Q_61_05]
								OR target.[Sum_Q_62_01] <> source.[Sum_Q_62_01]
								OR target.[Sum_Q_62_02] <> source.[Sum_Q_62_02]
								OR target.[Sum_Q_62_03] <> source.[Sum_Q_62_03]
								OR target.[Sum_Q_62_04] <> source.[Sum_Q_62_04]
								OR target.[Sum_Q_62_05] <> source.[Sum_Q_62_05]
								OR target.[Sum_Q_63_01] <> source.[Sum_Q_63_01]
								OR target.[Sum_Q_63_02] <> source.[Sum_Q_63_02]
								OR target.[Sum_Q_63_03] <> source.[Sum_Q_63_03]
								OR target.[Sum_Q_63_04] <> source.[Sum_Q_63_04]
								OR target.[Sum_Q_63_05] <> source.[Sum_Q_63_05]
								OR target.[Sum_Q_64_01] <> source.[Sum_Q_64_01]
								OR target.[Sum_Q_64_02] <> source.[Sum_Q_64_02]
								OR target.[Sum_Q_64_03] <> source.[Sum_Q_64_03]
								OR target.[Sum_Q_64_04] <> source.[Sum_Q_64_04]
								OR target.[Sum_Q_64_05] <> source.[Sum_Q_64_05]
								OR target.[Sum_Q_64_06] <> source.[Sum_Q_64_06]
								OR target.[Sum_Q_65_01] <> source.[Sum_Q_65_01]
								OR target.[Sum_Q_65_02] <> source.[Sum_Q_65_02]
								OR target.[Sum_Q_65_03] <> source.[Sum_Q_65_03]
								OR target.[Sum_Q_65_04] <> source.[Sum_Q_65_04]
								OR target.[Sum_Q_65_05] <> source.[Sum_Q_65_05]
								OR target.[Sum_Q_65_06] <> source.[Sum_Q_65_06]
								OR target.[Sum_Q_66_01] <> source.[Sum_Q_66_01]
								OR target.[Sum_Q_66_02] <> source.[Sum_Q_66_02]
								OR target.[Sum_Q_66_03] <> source.[Sum_Q_66_03]
								OR target.[Sum_Q_66_04] <> source.[Sum_Q_66_04]
								OR target.[Sum_Q_66_05] <> source.[Sum_Q_66_05]
								OR target.[Sum_Q_67_01] <> source.[Sum_Q_67_01]
								OR target.[Sum_Q_67_02] <> source.[Sum_Q_67_02]
								OR target.[Sum_Q_67_03] <> source.[Sum_Q_67_03]
								OR target.[Sum_Q_67_04] <> source.[Sum_Q_67_04]
								OR target.[Sum_Q_67_05] <> source.[Sum_Q_67_05]
								OR target.[Sum_Q_68_01] <> source.[Sum_Q_68_01]
								OR target.[Sum_Q_68_02] <> source.[Sum_Q_68_02]
								OR target.[Sum_Q_68_03] <> source.[Sum_Q_68_03]
								OR target.[Sum_Q_68_04] <> source.[Sum_Q_68_04]
								OR target.[Sum_Q_68_05] <> source.[Sum_Q_68_05]
								OR target.[Sum_Q_69_01] <> source.[Sum_Q_69_01]
								OR target.[Sum_Q_69_02] <> source.[Sum_Q_69_02]
								OR target.[Sum_Q_69_03] <> source.[Sum_Q_69_03]
								OR target.[Sum_Q_69_04] <> source.[Sum_Q_69_04]
								OR target.[Sum_Q_69_05] <> source.[Sum_Q_69_05]
								OR target.[Sum_Q_70_01] <> source.[Sum_Q_70_01]
								OR target.[Sum_Q_70_02] <> source.[Sum_Q_70_02]
								OR target.[Sum_Q_70_03] <> source.[Sum_Q_70_03]
								OR target.[Sum_Q_70_04] <> source.[Sum_Q_70_04]
								OR target.[Sum_Q_70_05] <> source.[Sum_Q_70_05]
					)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = source.next_change_datetime
					
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
		 AND LEN(source.official_association_number) > 0
		 AND LEN(source.official_branch_number) > 0
		)
		THEN 
			INSERT ([aggregated_data_key],
					[change_datetime],
					[next_change_datetime],
					[sum_m_01b_01],
					[sum_m_01c_01],
					[sum_m_01d_01],
					[sum_q_01_01],
					[sum_q_01_02],
					[sum_q_01_03],
					[sum_q_01_04],
					[sum_q_01_05],
					[sum_q_02_01],
					[sum_q_02_02],
					[sum_q_02_03],
					[sum_q_02_04],
					[sum_q_02_05],
					[sum_q_03_01],
					[sum_q_03_02],
					[sum_q_03_03],
					[sum_q_03_04],
					[sum_q_03_05],
					[sum_q_04_01],
					[sum_q_04_02],
					[sum_q_04_03],
					[sum_q_04_04],
					[sum_q_04_05],
					[sum_q_05_01],
					[sum_q_05_02],
					[sum_q_05_03],
					[sum_q_05_04],
					[sum_q_05_05],
					[sum_q_06_01],
					[sum_q_06_02],
					[sum_q_06_03],
					[sum_q_06_04],
					[sum_q_06_05],
					[sum_q_07_01],
					[sum_q_07_02],
					[sum_q_07_03],
					[sum_q_07_04],
					[sum_q_07_05],
					[sum_q_08_01],
					[sum_q_08_02],
					[sum_q_08_03],
					[sum_q_08_04],
					[sum_q_08_05],
					[sum_q_09_01],
					[sum_q_09_02],
					[sum_q_09_03],
					[sum_q_09_04],
					[sum_q_09_05],
					[sum_q_10_01],
					[sum_q_10_02],
					[sum_q_10_03],
					[sum_q_10_04],
					[sum_q_10_05],
					[sum_q_11_01],
					[sum_q_11_02],
					[sum_q_11_03],
					[sum_q_11_04],
					[sum_q_11_05],
					[sum_q_12_01],
					[sum_q_12_02],
					[sum_q_12_03],
					[sum_q_12_04],
					[sum_q_12_05],
					[sum_q_13_01],
					[sum_q_13_02],
					[sum_q_13_03],
					[sum_q_13_04],
					[sum_q_13_05],
					[sum_q_14_01],
					[sum_q_14_02],
					[sum_q_14_03],
					[sum_q_14_04],
					[sum_q_14_05],
					[sum_q_15_01],
					[sum_q_15_02],
					[sum_q_15_03],
					[sum_q_15_04],
					[sum_q_15_05],
					[sum_q_16_01],
					[sum_q_16_02],
					[sum_q_16_03],
					[sum_q_16_04],
					[sum_q_16_05],
					[sum_q_17_01],
					[sum_q_17_02],
					[sum_q_17_03],
					[sum_q_17_04],
					[sum_q_17_05],
					[sum_q_18_01],
					[sum_q_18_02],
					[sum_q_18_03],
					[sum_q_18_04],
					[sum_q_18_05],
					[sum_q_19_01],
					[sum_q_19_02],
					[sum_q_19_03],
					[sum_q_19_04],
					[sum_q_19_05],
					[sum_q_20_01],
					[sum_q_20_02],
					[sum_q_20_03],
					[sum_q_20_04],
					[sum_q_20_05],
					[sum_q_21_01],
					[sum_q_21_02],
					[sum_q_21_03],
					[sum_q_21_04],
					[sum_q_21_05],
					[sum_q_22_01],
					[sum_q_22_02],
					[sum_q_22_03],
					[sum_q_22_04],
					[sum_q_22_05],
					[sum_q_23_01],
					[sum_q_23_02],
					[sum_q_23_03],
					[sum_q_23_04],
					[sum_q_23_05],
					[sum_q_24_01],
					[sum_q_24_02],
					[sum_q_24_03],
					[sum_q_24_04],
					[sum_q_24_05],
					[sum_q_25_01],
					[sum_q_25_02],
					[sum_q_25_03],
					[sum_q_25_04],
					[sum_q_25_05],
					[sum_q_26_01],
					[sum_q_26_02],
					[sum_q_26_03],
					[sum_q_26_04],
					[sum_q_26_05],
					[sum_q_27_01],
					[sum_q_27_02],
					[sum_q_27_03],
					[sum_q_27_04],
					[sum_q_27_05],
					[sum_q_28_01],
					[sum_q_28_02],
					[sum_q_28_03],
					[sum_q_28_04],
					[sum_q_28_05],
					[sum_q_29_01],
					[sum_q_29_02],
					[sum_q_29_03],
					[sum_q_29_04],
					[sum_q_29_05],
					[sum_q_30_01],
					[sum_q_30_02],
					[sum_q_30_03],
					[sum_q_30_04],
					[sum_q_30_05],
					[sum_q_31_01],
					[sum_q_31_02],
					[sum_q_31_03],
					[sum_q_31_04],
					[sum_q_31_05],
					[sum_q_32_00],
					[sum_q_32_01],
					[sum_q_32_10],
					[sum_q_32_02],
					[sum_q_32_03],
					[sum_q_32_04],
					[sum_q_32_05],
					[sum_q_32_06],
					[sum_q_32_07],
					[sum_q_32_08],
					[sum_q_32_09],
					[sum_q_33_01],
					[sum_q_33_02],
					[sum_q_33_03],
					[sum_q_33_04],
					[sum_q_33_05],
					[sum_q_34_01],
					[sum_q_34_02],
					[sum_q_34_03],
					[sum_q_34_04],
					[sum_q_34_05],
					[sum_q_35_00],
					[sum_q_35_01],
					[sum_q_35_10],
					[sum_q_35_02],
					[sum_q_35_03],
					[sum_q_35_04],
					[sum_q_35_05],
					[sum_q_35_06],
					[sum_q_35_07],
					[sum_q_35_08],
					[sum_q_35_09],
					[sum_q_36_01],
					[sum_q_36_02],
					[sum_q_36_03],
					[sum_q_36_04],
					[sum_q_36_05],
					[sum_q_37_01],
					[sum_q_37_02],
					[sum_q_37_03],
					[sum_q_37_04],
					[sum_q_37_05],
					[sum_q_38_01],
					[sum_q_38_02],
					[sum_q_38_03],
					[sum_q_38_04],
					[sum_q_38_05],
					[sum_q_39_01],
					[sum_q_39_02],
					[sum_q_39_03],
					[sum_q_39_04],
					[sum_q_39_05],
					[sum_q_40_01],
					[sum_q_40_02],
					[sum_q_40_03],
					[sum_q_40_04],
					[sum_q_40_05],
					[sum_q_41_01],
					[sum_q_41_02],
					[sum_q_41_03],
					[sum_q_41_04],
					[sum_q_41_05],
					[sum_q_42_01],
					[sum_q_42_02],
					[sum_q_42_03],
					[sum_q_42_04],
					[sum_q_42_05],
					[sum_q_43_01],
					[sum_q_43_02],
					[sum_q_43_03],
					[sum_q_43_04],
					[sum_q_43_05],
					[sum_q_44_01],
					[sum_q_44_02],
					[sum_q_44_03],
					[sum_q_44_04],
					[sum_q_44_05],
					[sum_q_45_01],
					[sum_q_45_02],
					[sum_q_45_03],
					[sum_q_45_04],
					[sum_q_45_05],
					[sum_q_46_00],
					[sum_q_46_01],
					[sum_q_46_10],
					[sum_q_46_02],
					[sum_q_46_03],
					[sum_q_46_04],
					[sum_q_46_05],
					[sum_q_46_06],
					[sum_q_46_07],
					[sum_q_46_08],
					[sum_q_46_09],
					[sum_q_47_01],
					[sum_q_47_02],
					[sum_q_47_03],
					[sum_q_47_04],
					[sum_q_47_05],
					[sum_q_48_01],
					[sum_q_48_02],
					[sum_q_48_03],
					[sum_q_48_04],
					[sum_q_48_05],
					[sum_q_49_01],
					[sum_q_49_02],
					[sum_q_49_03],
					[sum_q_49_04],
					[sum_q_49_05],
					[sum_q_50_01],
					[sum_q_50_02],
					[sum_q_50_03],
					[sum_q_50_04],
					[sum_q_50_05],
					[sum_q_51_01],
					[sum_q_51_02],
					[sum_q_51_03],
					[sum_q_51_04],
					[sum_q_51_05],
					[sum_q_52_01],
					[sum_q_52_02],
					[sum_q_52_03],
					[sum_q_52_04],
					[sum_q_52_05],
					[sum_q_53_01],
					[sum_q_53_02],
					[sum_q_53_03],
					[sum_q_53_04],
					[sum_q_53_05],
					[sum_q_54_01],
					[sum_q_54_02],
					[sum_q_54_03],
					[sum_q_54_04],
					[sum_q_54_05],
					[sum_q_55_01],
					[sum_q_55_02],
					[sum_q_55_03],
					[sum_q_55_04],
					[sum_q_55_05],
					[sum_q_56_01],
					[sum_q_56_02],
					[sum_q_56_03],
					[sum_q_56_04],
					[sum_q_56_05],
					[sum_q_57_01],
					[sum_q_57_02],
					[sum_q_57_03],
					[sum_q_57_04],
					[sum_q_57_05],
					[sum_q_58_01],
					[sum_q_58_02],
					[sum_q_58_03],
					[sum_q_58_04],
					[sum_q_58_05],
					[sum_q_59_01],
					[sum_q_59_02],
					[sum_q_59_03],
					[sum_q_59_04],
					[sum_q_59_05],
					[sum_q_60_01],
					[sum_q_60_02],
					[sum_q_60_03],
					[sum_q_60_04],
					[sum_q_60_05],
					[sum_q_61_01],
					[sum_q_61_02],
					[sum_q_61_03],
					[sum_q_61_04],
					[sum_q_61_05],
					[sum_q_62_01],
					[sum_q_62_02],
					[sum_q_62_03],
					[sum_q_62_04],
					[sum_q_62_05],
					[sum_q_63_01],
					[sum_q_63_02],
					[sum_q_63_03],
					[sum_q_63_04],
					[sum_q_63_05],
					[sum_q_64_01],
					[sum_q_64_02],
					[sum_q_64_03],
					[sum_q_64_04],
					[sum_q_64_05],
					[sum_q_64_06],
					[sum_q_65_01],
					[sum_q_65_02],
					[sum_q_65_03],
					[sum_q_65_04],
					[sum_q_65_05],
					[sum_q_65_06],
					[sum_q_66_01],
					[sum_q_66_02],
					[sum_q_66_03],
					[sum_q_66_04],
					[sum_q_66_05],
					[sum_q_67_01],
					[sum_q_67_02],
					[sum_q_67_03],
					[sum_q_67_04],
					[sum_q_67_05],
					[sum_q_68_01],
					[sum_q_68_02],
					[sum_q_68_03],
					[sum_q_68_04],
					[sum_q_68_05],
					[sum_q_69_01],
					[sum_q_69_02],
					[sum_q_69_03],
					[sum_q_69_04],
					[sum_q_69_05],
					[sum_q_70_01],
					[sum_q_70_02],
					[sum_q_70_03],
					[sum_q_70_04],
					[sum_q_70_05]

					)
			VALUES ([aggregated_data_key],
					[change_datetime],
					[next_change_datetime],
					[sum_m_01b_01],
					[sum_m_01c_01],
					[sum_m_01d_01],
					[sum_q_01_01],
					[sum_q_01_02],
					[sum_q_01_03],
					[sum_q_01_04],
					[sum_q_01_05],
					[sum_q_02_01],
					[sum_q_02_02],
					[sum_q_02_03],
					[sum_q_02_04],
					[sum_q_02_05],
					[sum_q_03_01],
					[sum_q_03_02],
					[sum_q_03_03],
					[sum_q_03_04],
					[sum_q_03_05],
					[sum_q_04_01],
					[sum_q_04_02],
					[sum_q_04_03],
					[sum_q_04_04],
					[sum_q_04_05],
					[sum_q_05_01],
					[sum_q_05_02],
					[sum_q_05_03],
					[sum_q_05_04],
					[sum_q_05_05],
					[sum_q_06_01],
					[sum_q_06_02],
					[sum_q_06_03],
					[sum_q_06_04],
					[sum_q_06_05],
					[sum_q_07_01],
					[sum_q_07_02],
					[sum_q_07_03],
					[sum_q_07_04],
					[sum_q_07_05],
					[sum_q_08_01],
					[sum_q_08_02],
					[sum_q_08_03],
					[sum_q_08_04],
					[sum_q_08_05],
					[sum_q_09_01],
					[sum_q_09_02],
					[sum_q_09_03],
					[sum_q_09_04],
					[sum_q_09_05],
					[sum_q_10_01],
					[sum_q_10_02],
					[sum_q_10_03],
					[sum_q_10_04],
					[sum_q_10_05],
					[sum_q_11_01],
					[sum_q_11_02],
					[sum_q_11_03],
					[sum_q_11_04],
					[sum_q_11_05],
					[sum_q_12_01],
					[sum_q_12_02],
					[sum_q_12_03],
					[sum_q_12_04],
					[sum_q_12_05],
					[sum_q_13_01],
					[sum_q_13_02],
					[sum_q_13_03],
					[sum_q_13_04],
					[sum_q_13_05],
					[sum_q_14_01],
					[sum_q_14_02],
					[sum_q_14_03],
					[sum_q_14_04],
					[sum_q_14_05],
					[sum_q_15_01],
					[sum_q_15_02],
					[sum_q_15_03],
					[sum_q_15_04],
					[sum_q_15_05],
					[sum_q_16_01],
					[sum_q_16_02],
					[sum_q_16_03],
					[sum_q_16_04],
					[sum_q_16_05],
					[sum_q_17_01],
					[sum_q_17_02],
					[sum_q_17_03],
					[sum_q_17_04],
					[sum_q_17_05],
					[sum_q_18_01],
					[sum_q_18_02],
					[sum_q_18_03],
					[sum_q_18_04],
					[sum_q_18_05],
					[sum_q_19_01],
					[sum_q_19_02],
					[sum_q_19_03],
					[sum_q_19_04],
					[sum_q_19_05],
					[sum_q_20_01],
					[sum_q_20_02],
					[sum_q_20_03],
					[sum_q_20_04],
					[sum_q_20_05],
					[sum_q_21_01],
					[sum_q_21_02],
					[sum_q_21_03],
					[sum_q_21_04],
					[sum_q_21_05],
					[sum_q_22_01],
					[sum_q_22_02],
					[sum_q_22_03],
					[sum_q_22_04],
					[sum_q_22_05],
					[sum_q_23_01],
					[sum_q_23_02],
					[sum_q_23_03],
					[sum_q_23_04],
					[sum_q_23_05],
					[sum_q_24_01],
					[sum_q_24_02],
					[sum_q_24_03],
					[sum_q_24_04],
					[sum_q_24_05],
					[sum_q_25_01],
					[sum_q_25_02],
					[sum_q_25_03],
					[sum_q_25_04],
					[sum_q_25_05],
					[sum_q_26_01],
					[sum_q_26_02],
					[sum_q_26_03],
					[sum_q_26_04],
					[sum_q_26_05],
					[sum_q_27_01],
					[sum_q_27_02],
					[sum_q_27_03],
					[sum_q_27_04],
					[sum_q_27_05],
					[sum_q_28_01],
					[sum_q_28_02],
					[sum_q_28_03],
					[sum_q_28_04],
					[sum_q_28_05],
					[sum_q_29_01],
					[sum_q_29_02],
					[sum_q_29_03],
					[sum_q_29_04],
					[sum_q_29_05],
					[sum_q_30_01],
					[sum_q_30_02],
					[sum_q_30_03],
					[sum_q_30_04],
					[sum_q_30_05],
					[sum_q_31_01],
					[sum_q_31_02],
					[sum_q_31_03],
					[sum_q_31_04],
					[sum_q_31_05],
					[sum_q_32_00],
					[sum_q_32_01],
					[sum_q_32_10],
					[sum_q_32_02],
					[sum_q_32_03],
					[sum_q_32_04],
					[sum_q_32_05],
					[sum_q_32_06],
					[sum_q_32_07],
					[sum_q_32_08],
					[sum_q_32_09],
					[sum_q_33_01],
					[sum_q_33_02],
					[sum_q_33_03],
					[sum_q_33_04],
					[sum_q_33_05],
					[sum_q_34_01],
					[sum_q_34_02],
					[sum_q_34_03],
					[sum_q_34_04],
					[sum_q_34_05],
					[sum_q_35_00],
					[sum_q_35_01],
					[sum_q_35_10],
					[sum_q_35_02],
					[sum_q_35_03],
					[sum_q_35_04],
					[sum_q_35_05],
					[sum_q_35_06],
					[sum_q_35_07],
					[sum_q_35_08],
					[sum_q_35_09],
					[sum_q_36_01],
					[sum_q_36_02],
					[sum_q_36_03],
					[sum_q_36_04],
					[sum_q_36_05],
					[sum_q_37_01],
					[sum_q_37_02],
					[sum_q_37_03],
					[sum_q_37_04],
					[sum_q_37_05],
					[sum_q_38_01],
					[sum_q_38_02],
					[sum_q_38_03],
					[sum_q_38_04],
					[sum_q_38_05],
					[sum_q_39_01],
					[sum_q_39_02],
					[sum_q_39_03],
					[sum_q_39_04],
					[sum_q_39_05],
					[sum_q_40_01],
					[sum_q_40_02],
					[sum_q_40_03],
					[sum_q_40_04],
					[sum_q_40_05],
					[sum_q_41_01],
					[sum_q_41_02],
					[sum_q_41_03],
					[sum_q_41_04],
					[sum_q_41_05],
					[sum_q_42_01],
					[sum_q_42_02],
					[sum_q_42_03],
					[sum_q_42_04],
					[sum_q_42_05],
					[sum_q_43_01],
					[sum_q_43_02],
					[sum_q_43_03],
					[sum_q_43_04],
					[sum_q_43_05],
					[sum_q_44_01],
					[sum_q_44_02],
					[sum_q_44_03],
					[sum_q_44_04],
					[sum_q_44_05],
					[sum_q_45_01],
					[sum_q_45_02],
					[sum_q_45_03],
					[sum_q_45_04],
					[sum_q_45_05],
					[sum_q_46_00],
					[sum_q_46_01],
					[sum_q_46_10],
					[sum_q_46_02],
					[sum_q_46_03],
					[sum_q_46_04],
					[sum_q_46_05],
					[sum_q_46_06],
					[sum_q_46_07],
					[sum_q_46_08],
					[sum_q_46_09],
					[sum_q_47_01],
					[sum_q_47_02],
					[sum_q_47_03],
					[sum_q_47_04],
					[sum_q_47_05],
					[sum_q_48_01],
					[sum_q_48_02],
					[sum_q_48_03],
					[sum_q_48_04],
					[sum_q_48_05],
					[sum_q_49_01],
					[sum_q_49_02],
					[sum_q_49_03],
					[sum_q_49_04],
					[sum_q_49_05],
					[sum_q_50_01],
					[sum_q_50_02],
					[sum_q_50_03],
					[sum_q_50_04],
					[sum_q_50_05],
					[sum_q_51_01],
					[sum_q_51_02],
					[sum_q_51_03],
					[sum_q_51_04],
					[sum_q_51_05],
					[sum_q_52_01],
					[sum_q_52_02],
					[sum_q_52_03],
					[sum_q_52_04],
					[sum_q_52_05],
					[sum_q_53_01],
					[sum_q_53_02],
					[sum_q_53_03],
					[sum_q_53_04],
					[sum_q_53_05],
					[sum_q_54_01],
					[sum_q_54_02],
					[sum_q_54_03],
					[sum_q_54_04],
					[sum_q_54_05],
					[sum_q_55_01],
					[sum_q_55_02],
					[sum_q_55_03],
					[sum_q_55_04],
					[sum_q_55_05],
					[sum_q_56_01],
					[sum_q_56_02],
					[sum_q_56_03],
					[sum_q_56_04],
					[sum_q_56_05],
					[sum_q_57_01],
					[sum_q_57_02],
					[sum_q_57_03],
					[sum_q_57_04],
					[sum_q_57_05],
					[sum_q_58_01],
					[sum_q_58_02],
					[sum_q_58_03],
					[sum_q_58_04],
					[sum_q_58_05],
					[sum_q_59_01],
					[sum_q_59_02],
					[sum_q_59_03],
					[sum_q_59_04],
					[sum_q_59_05],
					[sum_q_60_01],
					[sum_q_60_02],
					[sum_q_60_03],
					[sum_q_60_04],
					[sum_q_60_05],
					[sum_q_61_01],
					[sum_q_61_02],
					[sum_q_61_03],
					[sum_q_61_04],
					[sum_q_61_05],
					[sum_q_62_01],
					[sum_q_62_02],
					[sum_q_62_03],
					[sum_q_62_04],
					[sum_q_62_05],
					[sum_q_63_01],
					[sum_q_63_02],
					[sum_q_63_03],
					[sum_q_63_04],
					[sum_q_63_05],
					[sum_q_64_01],
					[sum_q_64_02],
					[sum_q_64_03],
					[sum_q_64_04],
					[sum_q_64_05],
					[sum_q_64_06],
					[sum_q_65_01],
					[sum_q_65_02],
					[sum_q_65_03],
					[sum_q_65_04],
					[sum_q_65_05],
					[sum_q_65_06],
					[sum_q_66_01],
					[sum_q_66_02],
					[sum_q_66_03],
					[sum_q_66_04],
					[sum_q_66_05],
					[sum_q_67_01],
					[sum_q_67_02],
					[sum_q_67_03],
					[sum_q_67_04],
					[sum_q_67_05],
					[sum_q_68_01],
					[sum_q_68_02],
					[sum_q_68_03],
					[sum_q_68_04],
					[sum_q_68_05],
					[sum_q_69_01],
					[sum_q_69_02],
					[sum_q_69_03],
					[sum_q_69_04],
					[sum_q_69_05],
					[sum_q_70_01],
					[sum_q_70_02],
					[sum_q_70_03],
					[sum_q_70_04],
					[sum_q_70_05]
					)				
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.Aggregated_Data_Sum AS target
	USING	(
			SELECT	B.aggregated_data_key,
					B.change_datetime,
					B.next_change_datetime,
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
					CASE WHEN LEN(COALESCE(A.[Involvement Percentile], '')) = 0 THEN '0' ELSE A.[Involvement Percentile] END [involvement_percentile],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01b_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01b_01] END [sum_m_01b_01],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01c_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01c_01] END [sum_m_01c_01],
					CASE WHEN LEN(COALESCE(A.[Sum_M_01d_01], '')) = 0 THEN '0' ELSE A.[Sum_M_01d_01] END [sum_m_01d_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_01] END [sum_q_01_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_02] END [sum_q_01_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_03] END [sum_q_01_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_04] END [sum_q_01_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_01_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_01_05] END [sum_q_01_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_01] END [sum_q_02_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_02] END [sum_q_02_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_03] END [sum_q_02_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_04] END [sum_q_02_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_02_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_02_05] END [sum_q_02_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_01] END [sum_q_03_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_02] END [sum_q_03_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_03] END [sum_q_03_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_04] END [sum_q_03_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_03_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_03_05] END [sum_q_03_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_01] END [sum_q_04_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_02] END [sum_q_04_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_03] END [sum_q_04_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_04] END [sum_q_04_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_04_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_04_05] END [sum_q_04_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_01] END [sum_q_05_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_02] END [sum_q_05_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_03] END [sum_q_05_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_04] END [sum_q_05_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_05_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_05_05] END [sum_q_05_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_01] END [sum_q_06_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_02] END [sum_q_06_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_03] END [sum_q_06_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_04] END [sum_q_06_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_06_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_06_05] END [sum_q_06_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_01] END [sum_q_07_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_02] END [sum_q_07_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_03] END [sum_q_07_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_04] END [sum_q_07_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_07_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_07_05] END [sum_q_07_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_01] END [sum_q_08_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_02] END [sum_q_08_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_03] END [sum_q_08_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_04] END [sum_q_08_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_08_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_08_05] END [sum_q_08_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_01] END [sum_q_09_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_02] END [sum_q_09_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_03] END [sum_q_09_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_04] END [sum_q_09_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_09_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_09_05] END [sum_q_09_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_01] END [sum_q_10_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_02] END [sum_q_10_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_03] END [sum_q_10_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_04] END [sum_q_10_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_10_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_10_05] END [sum_q_10_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_01] END [sum_q_11_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_02] END [sum_q_11_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_03] END [sum_q_11_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_04] END [sum_q_11_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_11_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_11_05] END [sum_q_11_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_01] END [sum_q_12_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_02] END [sum_q_12_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_03] END [sum_q_12_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_04] END [sum_q_12_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_12_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_12_05] END [sum_q_12_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_01] END [sum_q_13_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_02] END [sum_q_13_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_03] END [sum_q_13_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_04] END [sum_q_13_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_13_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_13_05] END [sum_q_13_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_01] END [sum_q_14_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_02] END [sum_q_14_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_03] END [sum_q_14_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_04] END [sum_q_14_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_14_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_14_05] END [sum_q_14_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_01] END [sum_q_15_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_02] END [sum_q_15_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_03] END [sum_q_15_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_04] END [sum_q_15_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_15_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_15_05] END [sum_q_15_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_01] END [sum_q_16_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_02] END [sum_q_16_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_03] END [sum_q_16_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_04] END [sum_q_16_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_16_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_16_05] END [sum_q_16_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_01] END [sum_q_17_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_02] END [sum_q_17_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_03] END [sum_q_17_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_04] END [sum_q_17_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_17_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_17_05] END [sum_q_17_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_01] END [sum_q_18_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_02] END [sum_q_18_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_03] END [sum_q_18_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_04] END [sum_q_18_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_18_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_18_05] END [sum_q_18_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_01] END [sum_q_19_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_02] END [sum_q_19_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_03] END [sum_q_19_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_04] END [sum_q_19_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_19_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_19_05] END [sum_q_19_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_01] END [sum_q_20_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_02] END [sum_q_20_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_03] END [sum_q_20_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_04] END [sum_q_20_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_20_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_20_05] END [sum_q_20_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_01] END [sum_q_21_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_02] END [sum_q_21_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_03] END [sum_q_21_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_04] END [sum_q_21_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_21_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_21_05] END [sum_q_21_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_01] END [sum_q_22_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_02] END [sum_q_22_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_03] END [sum_q_22_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_04] END [sum_q_22_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_22_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_22_05] END [sum_q_22_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_01] END [sum_q_23_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_02] END [sum_q_23_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_03] END [sum_q_23_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_04] END [sum_q_23_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_23_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_23_05] END [sum_q_23_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_01] END [sum_q_24_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_02] END [sum_q_24_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_03] END [sum_q_24_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_04] END [sum_q_24_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_24_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_24_05] END [sum_q_24_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_01] END [sum_q_25_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_02] END [sum_q_25_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_03] END [sum_q_25_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_04] END [sum_q_25_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_25_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_25_05] END [sum_q_25_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_01] END [sum_q_26_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_02] END [sum_q_26_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_03] END [sum_q_26_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_04] END [sum_q_26_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_26_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_26_05] END [sum_q_26_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_01] END [sum_q_27_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_02] END [sum_q_27_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_03] END [sum_q_27_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_04] END [sum_q_27_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_27_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_27_05] END [sum_q_27_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_01] END [sum_q_28_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_02] END [sum_q_28_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_03] END [sum_q_28_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_04] END [sum_q_28_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_28_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_28_05] END [sum_q_28_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_01] END [sum_q_29_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_02] END [sum_q_29_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_03] END [sum_q_29_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_04] END [sum_q_29_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_29_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_29_05] END [sum_q_29_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_01] END [sum_q_30_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_02] END [sum_q_30_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_03] END [sum_q_30_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_04] END [sum_q_30_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_30_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_30_05] END [sum_q_30_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_01] END [sum_q_31_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_02] END [sum_q_31_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_03] END [sum_q_31_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_04] END [sum_q_31_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_31_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_31_05] END [sum_q_31_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_00] END [sum_q_32_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_01] END [sum_q_32_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_10] END [sum_q_32_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_02] END [sum_q_32_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_03] END [sum_q_32_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_04] END [sum_q_32_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_05] END [sum_q_32_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_06] END [sum_q_32_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_07] END [sum_q_32_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_08] END [sum_q_32_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_32_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_32_09] END [sum_q_32_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_01] END [sum_q_33_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_02] END [sum_q_33_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_03] END [sum_q_33_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_04] END [sum_q_33_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_33_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_33_05] END [sum_q_33_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_01] END [sum_q_34_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_02] END [sum_q_34_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_03] END [sum_q_34_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_04] END [sum_q_34_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_34_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_34_05] END [sum_q_34_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_00] END [sum_q_35_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_01] END [sum_q_35_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_10] END [sum_q_35_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_02] END [sum_q_35_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_03] END [sum_q_35_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_04] END [sum_q_35_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_05] END [sum_q_35_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_06] END [sum_q_35_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_07] END [sum_q_35_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_08] END [sum_q_35_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_35_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_35_09] END [sum_q_35_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_01] END [sum_q_36_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_02] END [sum_q_36_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_03] END [sum_q_36_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_04] END [sum_q_36_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_36_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_36_05] END [sum_q_36_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_01] END [sum_q_37_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_02] END [sum_q_37_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_03] END [sum_q_37_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_04] END [sum_q_37_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_37_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_37_05] END [sum_q_37_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_01] END [sum_q_38_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_02] END [sum_q_38_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_03] END [sum_q_38_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_04] END [sum_q_38_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_38_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_38_05] END [sum_q_38_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_01] END [sum_q_39_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_02] END [sum_q_39_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_03] END [sum_q_39_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_04] END [sum_q_39_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_39_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_39_05] END [sum_q_39_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_01] END [sum_q_40_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_02] END [sum_q_40_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_03] END [sum_q_40_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_04] END [sum_q_40_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_40_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_40_05] END [sum_q_40_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_01] END [sum_q_41_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_02] END [sum_q_41_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_03] END [sum_q_41_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_04] END [sum_q_41_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_41_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_41_05] END [sum_q_41_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_01] END [sum_q_42_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_02] END [sum_q_42_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_03] END [sum_q_42_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_04] END [sum_q_42_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_42_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_42_05] END [sum_q_42_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_01] END [sum_q_43_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_02] END [sum_q_43_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_03] END [sum_q_43_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_04] END [sum_q_43_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_43_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_43_05] END [sum_q_43_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_01] END [sum_q_44_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_02] END [sum_q_44_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_03] END [sum_q_44_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_04] END [sum_q_44_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_44_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_44_05] END [sum_q_44_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_01] END [sum_q_45_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_02] END [sum_q_45_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_03] END [sum_q_45_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_04] END [sum_q_45_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_45_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_45_05] END [sum_q_45_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_00], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_00] END [sum_q_46_00],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_01] END [sum_q_46_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_10], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_10] END [sum_q_46_10],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_02] END [sum_q_46_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_03] END [sum_q_46_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_04] END [sum_q_46_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_05] END [sum_q_46_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_06] END [sum_q_46_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_07], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_07] END [sum_q_46_07],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_08], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_08] END [sum_q_46_08],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_46_09], '')) = 0 THEN '0' ELSE A.[Sum_Q_46_09] END [sum_q_46_09],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_01] END [sum_q_47_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_02] END [sum_q_47_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_03] END [sum_q_47_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_04] END [sum_q_47_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_47_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_47_05] END [sum_q_47_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_01] END [sum_q_48_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_02] END [sum_q_48_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_03] END [sum_q_48_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_04] END [sum_q_48_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_48_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_48_05] END [sum_q_48_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_01] END [sum_q_49_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_02] END [sum_q_49_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_03] END [sum_q_49_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_04] END [sum_q_49_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_49_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_49_05] END [sum_q_49_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_01] END [sum_q_50_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_02] END [sum_q_50_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_03] END [sum_q_50_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_04] END [sum_q_50_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_50_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_50_05] END [sum_q_50_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_01] END [sum_q_51_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_02] END [sum_q_51_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_03] END [sum_q_51_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_04] END [sum_q_51_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_51_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_51_05] END [sum_q_51_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_01] END [sum_q_52_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_02] END [sum_q_52_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_03] END [sum_q_52_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_04] END [sum_q_52_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_52_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_52_05] END [sum_q_52_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_01] END [sum_q_53_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_02] END [sum_q_53_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_03] END [sum_q_53_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_04] END [sum_q_53_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_53_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_53_05] END [sum_q_53_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_01] END [sum_q_54_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_02] END [sum_q_54_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_03] END [sum_q_54_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_04] END [sum_q_54_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_54_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_54_05] END [sum_q_54_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_01] END [sum_q_55_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_02] END [sum_q_55_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_03] END [sum_q_55_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_04] END [sum_q_55_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_55_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_55_05] END [sum_q_55_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_01] END [sum_q_56_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_02] END [sum_q_56_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_03] END [sum_q_56_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_04] END [sum_q_56_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_56_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_56_05] END [sum_q_56_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_01] END [sum_q_57_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_02] END [sum_q_57_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_03] END [sum_q_57_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_04] END [sum_q_57_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_57_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_57_05] END [sum_q_57_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_01] END [sum_q_58_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_02] END [sum_q_58_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_03] END [sum_q_58_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_04] END [sum_q_58_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_58_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_58_05] END [sum_q_58_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_01] END [sum_q_59_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_02] END [sum_q_59_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_03] END [sum_q_59_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_04] END [sum_q_59_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_59_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_59_05] END [sum_q_59_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_01] END [sum_q_60_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_02] END [sum_q_60_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_03] END [sum_q_60_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_04] END [sum_q_60_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_60_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_60_05] END [sum_q_60_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_01] END [sum_q_61_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_02] END [sum_q_61_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_03] END [sum_q_61_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_04] END [sum_q_61_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_61_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_61_05] END [sum_q_61_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_01] END [sum_q_62_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_02] END [sum_q_62_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_03] END [sum_q_62_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_04] END [sum_q_62_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_62_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_62_05] END [sum_q_62_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_01] END [sum_q_63_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_02] END [sum_q_63_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_03] END [sum_q_63_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_04] END [sum_q_63_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_63_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_63_05] END [sum_q_63_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_01] END [sum_q_64_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_02] END [sum_q_64_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_03] END [sum_q_64_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_04] END [sum_q_64_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_05] END [sum_q_64_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_64_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_64_06] END [sum_q_64_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_01] END [sum_q_65_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_02] END [sum_q_65_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_03] END [sum_q_65_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_04] END [sum_q_65_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_05] END [sum_q_65_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_65_06], '')) = 0 THEN '0' ELSE A.[Sum_Q_65_06] END [sum_q_65_06],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_01] END [sum_q_66_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_02] END [sum_q_66_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_03] END [sum_q_66_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_04] END [sum_q_66_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_66_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_66_05] END [sum_q_66_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_01] END [sum_q_67_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_02] END [sum_q_67_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_03] END [sum_q_67_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_04] END [sum_q_67_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_67_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_67_05] END [sum_q_67_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_01] END [sum_q_68_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_02] END [sum_q_68_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_03] END [sum_q_68_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_04] END [sum_q_68_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_68_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_68_05] END [sum_q_68_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_01] END [sum_q_69_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_02] END [sum_q_69_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_03] END [sum_q_69_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_04] END [sum_q_69_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_69_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_69_05] END [sum_q_69_05],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_01], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_01] END [sum_q_70_01],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_02], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_02] END [sum_q_70_02],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_03], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_03] END [sum_q_70_03],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_04], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_04] END [sum_q_70_04],
					CASE WHEN LEN(COALESCE(A.[Sum_Q_70_05], '')) = 0 THEN '0' ELSE A.[Sum_Q_70_05] END [sum_q_70_05]

			FROM	Seer_STG.dbo.[Member Aggregated Data] A
					INNER JOIN Seer_ODS.dbo.Aggregated_Data B
					ON A.aggregate_type = B.aggregate_type
						AND A.form_code = B.form_code
						AND CASE WHEN LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'National' THEN '0000'
								ELSE A.[OFF_ASSOC_NUM]
							END  = B.official_association_number
						AND CASE WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) = 3 THEN '0' + A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'Association' AND LEN(A.[OFF_ASSOC_NUM]) <> 3 THEN A.[OFF_ASSOC_NUM]
								WHEN A.[Aggregate_Type] = 'National' THEN '0000'
								WHEN LEN(COALESCE(A.[OFF_BR_NUM], '')) = 3 THEN '0' + A.[OFF_BR_NUM]
								ELSE COALESCE(A.[OFF_BR_Num], '')
							END = B.official_branch_number
						
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
					AND ((ISNUMERIC(A.[achievement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([achievement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[belonging z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([belonging z-score], '')) = 0))
					AND ((ISNUMERIC(A.[character z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([character z-score], '')) = 0))
					AND ((ISNUMERIC(A.[giving z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([giving z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health z-score], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([inspiration z-score], '')) = 0))
					AND ((ISNUMERIC(A.[meaning z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([meaning z-score], '')) = 0))
					AND ((ISNUMERIC(A.[relationship z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([relationship z-score], '')) = 0))
					AND ((ISNUMERIC(A.[safety z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([safety z-score], '')) = 0))
					AND ((ISNUMERIC(A.[achievement percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[achievement percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([achievement percentile], '')) = 0))
					AND ((ISNUMERIC(A.[belonging percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[belonging percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([belonging percentile], '')) = 0))
					AND ((ISNUMERIC(A.[character percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[character percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([character percentile], '')) = 0))
					AND ((ISNUMERIC(A.[giving percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[giving percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([giving percentile], '')) = 0))
					AND ((ISNUMERIC(A.[health percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health percentile], '')) = 0))
					AND ((ISNUMERIC(A.[inspiration percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[inspiration percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([inspiration percentile], '')) = 0))
					AND ((ISNUMERIC(A.[meaning percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[meaning percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([meaning percentile], '')) = 0))
					AND ((ISNUMERIC(A.[relationship percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[relationship percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([relationship percentile], '')) = 0))
					AND ((ISNUMERIC(A.[safety percentile]) = 1 AND CONVERT(DECIMAL(20, 6), A.[safety percentile]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([safety percentile], '')) = 0))
					AND ((ISNUMERIC(A.[facilities z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[facilities z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([facilities z-score], '')) = 0))
					AND ((ISNUMERIC(A.[service z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[service z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([service z-score], '')) = 0))
					AND ((ISNUMERIC(A.[value z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[value z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([value z-score], '')) = 0))
					AND ((ISNUMERIC(A.[engagement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[engagement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([engagement z-score], '')) = 0))
					AND ((ISNUMERIC(A.[health and wellness z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[health and wellness z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([health and wellness z-score], '')) = 0))
					AND ((ISNUMERIC(A.[involvement z-score]) = 1 AND CONVERT(DECIMAL(20, 6), A.[involvement z-score]) BETWEEN 0.000000 AND 1.000000) OR (LEN(COALESCE([involvement z-score], '')) = 0))
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
			ON target.aggregated_data_key = source.aggregated_data_key
				AND target.current_indicator = source.current_indicator
					
	WHEN NOT MATCHED BY target AND
		(LEN(source.form_code) > 0
		 AND LEN(source.official_association_number) > 0
		 AND LEN(source.official_branch_number) > 0
		)
		THEN 
			INSERT ([aggregated_data_key],
					[change_datetime],
					[next_change_datetime],
					[sum_m_01b_01],
					[sum_m_01c_01],
					[sum_m_01d_01],
					[sum_q_01_01],
					[sum_q_01_02],
					[sum_q_01_03],
					[sum_q_01_04],
					[sum_q_01_05],
					[sum_q_02_01],
					[sum_q_02_02],
					[sum_q_02_03],
					[sum_q_02_04],
					[sum_q_02_05],
					[sum_q_03_01],
					[sum_q_03_02],
					[sum_q_03_03],
					[sum_q_03_04],
					[sum_q_03_05],
					[sum_q_04_01],
					[sum_q_04_02],
					[sum_q_04_03],
					[sum_q_04_04],
					[sum_q_04_05],
					[sum_q_05_01],
					[sum_q_05_02],
					[sum_q_05_03],
					[sum_q_05_04],
					[sum_q_05_05],
					[sum_q_06_01],
					[sum_q_06_02],
					[sum_q_06_03],
					[sum_q_06_04],
					[sum_q_06_05],
					[sum_q_07_01],
					[sum_q_07_02],
					[sum_q_07_03],
					[sum_q_07_04],
					[sum_q_07_05],
					[sum_q_08_01],
					[sum_q_08_02],
					[sum_q_08_03],
					[sum_q_08_04],
					[sum_q_08_05],
					[sum_q_09_01],
					[sum_q_09_02],
					[sum_q_09_03],
					[sum_q_09_04],
					[sum_q_09_05],
					[sum_q_10_01],
					[sum_q_10_02],
					[sum_q_10_03],
					[sum_q_10_04],
					[sum_q_10_05],
					[sum_q_11_01],
					[sum_q_11_02],
					[sum_q_11_03],
					[sum_q_11_04],
					[sum_q_11_05],
					[sum_q_12_01],
					[sum_q_12_02],
					[sum_q_12_03],
					[sum_q_12_04],
					[sum_q_12_05],
					[sum_q_13_01],
					[sum_q_13_02],
					[sum_q_13_03],
					[sum_q_13_04],
					[sum_q_13_05],
					[sum_q_14_01],
					[sum_q_14_02],
					[sum_q_14_03],
					[sum_q_14_04],
					[sum_q_14_05],
					[sum_q_15_01],
					[sum_q_15_02],
					[sum_q_15_03],
					[sum_q_15_04],
					[sum_q_15_05],
					[sum_q_16_01],
					[sum_q_16_02],
					[sum_q_16_03],
					[sum_q_16_04],
					[sum_q_16_05],
					[sum_q_17_01],
					[sum_q_17_02],
					[sum_q_17_03],
					[sum_q_17_04],
					[sum_q_17_05],
					[sum_q_18_01],
					[sum_q_18_02],
					[sum_q_18_03],
					[sum_q_18_04],
					[sum_q_18_05],
					[sum_q_19_01],
					[sum_q_19_02],
					[sum_q_19_03],
					[sum_q_19_04],
					[sum_q_19_05],
					[sum_q_20_01],
					[sum_q_20_02],
					[sum_q_20_03],
					[sum_q_20_04],
					[sum_q_20_05],
					[sum_q_21_01],
					[sum_q_21_02],
					[sum_q_21_03],
					[sum_q_21_04],
					[sum_q_21_05],
					[sum_q_22_01],
					[sum_q_22_02],
					[sum_q_22_03],
					[sum_q_22_04],
					[sum_q_22_05],
					[sum_q_23_01],
					[sum_q_23_02],
					[sum_q_23_03],
					[sum_q_23_04],
					[sum_q_23_05],
					[sum_q_24_01],
					[sum_q_24_02],
					[sum_q_24_03],
					[sum_q_24_04],
					[sum_q_24_05],
					[sum_q_25_01],
					[sum_q_25_02],
					[sum_q_25_03],
					[sum_q_25_04],
					[sum_q_25_05],
					[sum_q_26_01],
					[sum_q_26_02],
					[sum_q_26_03],
					[sum_q_26_04],
					[sum_q_26_05],
					[sum_q_27_01],
					[sum_q_27_02],
					[sum_q_27_03],
					[sum_q_27_04],
					[sum_q_27_05],
					[sum_q_28_01],
					[sum_q_28_02],
					[sum_q_28_03],
					[sum_q_28_04],
					[sum_q_28_05],
					[sum_q_29_01],
					[sum_q_29_02],
					[sum_q_29_03],
					[sum_q_29_04],
					[sum_q_29_05],
					[sum_q_30_01],
					[sum_q_30_02],
					[sum_q_30_03],
					[sum_q_30_04],
					[sum_q_30_05],
					[sum_q_31_01],
					[sum_q_31_02],
					[sum_q_31_03],
					[sum_q_31_04],
					[sum_q_31_05],
					[sum_q_32_00],
					[sum_q_32_01],
					[sum_q_32_10],
					[sum_q_32_02],
					[sum_q_32_03],
					[sum_q_32_04],
					[sum_q_32_05],
					[sum_q_32_06],
					[sum_q_32_07],
					[sum_q_32_08],
					[sum_q_32_09],
					[sum_q_33_01],
					[sum_q_33_02],
					[sum_q_33_03],
					[sum_q_33_04],
					[sum_q_33_05],
					[sum_q_34_01],
					[sum_q_34_02],
					[sum_q_34_03],
					[sum_q_34_04],
					[sum_q_34_05],
					[sum_q_35_00],
					[sum_q_35_01],
					[sum_q_35_10],
					[sum_q_35_02],
					[sum_q_35_03],
					[sum_q_35_04],
					[sum_q_35_05],
					[sum_q_35_06],
					[sum_q_35_07],
					[sum_q_35_08],
					[sum_q_35_09],
					[sum_q_36_01],
					[sum_q_36_02],
					[sum_q_36_03],
					[sum_q_36_04],
					[sum_q_36_05],
					[sum_q_37_01],
					[sum_q_37_02],
					[sum_q_37_03],
					[sum_q_37_04],
					[sum_q_37_05],
					[sum_q_38_01],
					[sum_q_38_02],
					[sum_q_38_03],
					[sum_q_38_04],
					[sum_q_38_05],
					[sum_q_39_01],
					[sum_q_39_02],
					[sum_q_39_03],
					[sum_q_39_04],
					[sum_q_39_05],
					[sum_q_40_01],
					[sum_q_40_02],
					[sum_q_40_03],
					[sum_q_40_04],
					[sum_q_40_05],
					[sum_q_41_01],
					[sum_q_41_02],
					[sum_q_41_03],
					[sum_q_41_04],
					[sum_q_41_05],
					[sum_q_42_01],
					[sum_q_42_02],
					[sum_q_42_03],
					[sum_q_42_04],
					[sum_q_42_05],
					[sum_q_43_01],
					[sum_q_43_02],
					[sum_q_43_03],
					[sum_q_43_04],
					[sum_q_43_05],
					[sum_q_44_01],
					[sum_q_44_02],
					[sum_q_44_03],
					[sum_q_44_04],
					[sum_q_44_05],
					[sum_q_45_01],
					[sum_q_45_02],
					[sum_q_45_03],
					[sum_q_45_04],
					[sum_q_45_05],
					[sum_q_46_00],
					[sum_q_46_01],
					[sum_q_46_10],
					[sum_q_46_02],
					[sum_q_46_03],
					[sum_q_46_04],
					[sum_q_46_05],
					[sum_q_46_06],
					[sum_q_46_07],
					[sum_q_46_08],
					[sum_q_46_09],
					[sum_q_47_01],
					[sum_q_47_02],
					[sum_q_47_03],
					[sum_q_47_04],
					[sum_q_47_05],
					[sum_q_48_01],
					[sum_q_48_02],
					[sum_q_48_03],
					[sum_q_48_04],
					[sum_q_48_05],
					[sum_q_49_01],
					[sum_q_49_02],
					[sum_q_49_03],
					[sum_q_49_04],
					[sum_q_49_05],
					[sum_q_50_01],
					[sum_q_50_02],
					[sum_q_50_03],
					[sum_q_50_04],
					[sum_q_50_05],
					[sum_q_51_01],
					[sum_q_51_02],
					[sum_q_51_03],
					[sum_q_51_04],
					[sum_q_51_05],
					[sum_q_52_01],
					[sum_q_52_02],
					[sum_q_52_03],
					[sum_q_52_04],
					[sum_q_52_05],
					[sum_q_53_01],
					[sum_q_53_02],
					[sum_q_53_03],
					[sum_q_53_04],
					[sum_q_53_05],
					[sum_q_54_01],
					[sum_q_54_02],
					[sum_q_54_03],
					[sum_q_54_04],
					[sum_q_54_05],
					[sum_q_55_01],
					[sum_q_55_02],
					[sum_q_55_03],
					[sum_q_55_04],
					[sum_q_55_05],
					[sum_q_56_01],
					[sum_q_56_02],
					[sum_q_56_03],
					[sum_q_56_04],
					[sum_q_56_05],
					[sum_q_57_01],
					[sum_q_57_02],
					[sum_q_57_03],
					[sum_q_57_04],
					[sum_q_57_05],
					[sum_q_58_01],
					[sum_q_58_02],
					[sum_q_58_03],
					[sum_q_58_04],
					[sum_q_58_05],
					[sum_q_59_01],
					[sum_q_59_02],
					[sum_q_59_03],
					[sum_q_59_04],
					[sum_q_59_05],
					[sum_q_60_01],
					[sum_q_60_02],
					[sum_q_60_03],
					[sum_q_60_04],
					[sum_q_60_05],
					[sum_q_61_01],
					[sum_q_61_02],
					[sum_q_61_03],
					[sum_q_61_04],
					[sum_q_61_05],
					[sum_q_62_01],
					[sum_q_62_02],
					[sum_q_62_03],
					[sum_q_62_04],
					[sum_q_62_05],
					[sum_q_63_01],
					[sum_q_63_02],
					[sum_q_63_03],
					[sum_q_63_04],
					[sum_q_63_05],
					[sum_q_64_01],
					[sum_q_64_02],
					[sum_q_64_03],
					[sum_q_64_04],
					[sum_q_64_05],
					[sum_q_64_06],
					[sum_q_65_01],
					[sum_q_65_02],
					[sum_q_65_03],
					[sum_q_65_04],
					[sum_q_65_05],
					[sum_q_65_06],
					[sum_q_66_01],
					[sum_q_66_02],
					[sum_q_66_03],
					[sum_q_66_04],
					[sum_q_66_05],
					[sum_q_67_01],
					[sum_q_67_02],
					[sum_q_67_03],
					[sum_q_67_04],
					[sum_q_67_05],
					[sum_q_68_01],
					[sum_q_68_02],
					[sum_q_68_03],
					[sum_q_68_04],
					[sum_q_68_05],
					[sum_q_69_01],
					[sum_q_69_02],
					[sum_q_69_03],
					[sum_q_69_04],
					[sum_q_69_05],
					[sum_q_70_01],
					[sum_q_70_02],
					[sum_q_70_03],
					[sum_q_70_04],
					[sum_q_70_05]

					)
			VALUES ([aggregated_data_key],
					[change_datetime],
					[next_change_datetime],
					[sum_m_01b_01],
					[sum_m_01c_01],
					[sum_m_01d_01],
					[sum_q_01_01],
					[sum_q_01_02],
					[sum_q_01_03],
					[sum_q_01_04],
					[sum_q_01_05],
					[sum_q_02_01],
					[sum_q_02_02],
					[sum_q_02_03],
					[sum_q_02_04],
					[sum_q_02_05],
					[sum_q_03_01],
					[sum_q_03_02],
					[sum_q_03_03],
					[sum_q_03_04],
					[sum_q_03_05],
					[sum_q_04_01],
					[sum_q_04_02],
					[sum_q_04_03],
					[sum_q_04_04],
					[sum_q_04_05],
					[sum_q_05_01],
					[sum_q_05_02],
					[sum_q_05_03],
					[sum_q_05_04],
					[sum_q_05_05],
					[sum_q_06_01],
					[sum_q_06_02],
					[sum_q_06_03],
					[sum_q_06_04],
					[sum_q_06_05],
					[sum_q_07_01],
					[sum_q_07_02],
					[sum_q_07_03],
					[sum_q_07_04],
					[sum_q_07_05],
					[sum_q_08_01],
					[sum_q_08_02],
					[sum_q_08_03],
					[sum_q_08_04],
					[sum_q_08_05],
					[sum_q_09_01],
					[sum_q_09_02],
					[sum_q_09_03],
					[sum_q_09_04],
					[sum_q_09_05],
					[sum_q_10_01],
					[sum_q_10_02],
					[sum_q_10_03],
					[sum_q_10_04],
					[sum_q_10_05],
					[sum_q_11_01],
					[sum_q_11_02],
					[sum_q_11_03],
					[sum_q_11_04],
					[sum_q_11_05],
					[sum_q_12_01],
					[sum_q_12_02],
					[sum_q_12_03],
					[sum_q_12_04],
					[sum_q_12_05],
					[sum_q_13_01],
					[sum_q_13_02],
					[sum_q_13_03],
					[sum_q_13_04],
					[sum_q_13_05],
					[sum_q_14_01],
					[sum_q_14_02],
					[sum_q_14_03],
					[sum_q_14_04],
					[sum_q_14_05],
					[sum_q_15_01],
					[sum_q_15_02],
					[sum_q_15_03],
					[sum_q_15_04],
					[sum_q_15_05],
					[sum_q_16_01],
					[sum_q_16_02],
					[sum_q_16_03],
					[sum_q_16_04],
					[sum_q_16_05],
					[sum_q_17_01],
					[sum_q_17_02],
					[sum_q_17_03],
					[sum_q_17_04],
					[sum_q_17_05],
					[sum_q_18_01],
					[sum_q_18_02],
					[sum_q_18_03],
					[sum_q_18_04],
					[sum_q_18_05],
					[sum_q_19_01],
					[sum_q_19_02],
					[sum_q_19_03],
					[sum_q_19_04],
					[sum_q_19_05],
					[sum_q_20_01],
					[sum_q_20_02],
					[sum_q_20_03],
					[sum_q_20_04],
					[sum_q_20_05],
					[sum_q_21_01],
					[sum_q_21_02],
					[sum_q_21_03],
					[sum_q_21_04],
					[sum_q_21_05],
					[sum_q_22_01],
					[sum_q_22_02],
					[sum_q_22_03],
					[sum_q_22_04],
					[sum_q_22_05],
					[sum_q_23_01],
					[sum_q_23_02],
					[sum_q_23_03],
					[sum_q_23_04],
					[sum_q_23_05],
					[sum_q_24_01],
					[sum_q_24_02],
					[sum_q_24_03],
					[sum_q_24_04],
					[sum_q_24_05],
					[sum_q_25_01],
					[sum_q_25_02],
					[sum_q_25_03],
					[sum_q_25_04],
					[sum_q_25_05],
					[sum_q_26_01],
					[sum_q_26_02],
					[sum_q_26_03],
					[sum_q_26_04],
					[sum_q_26_05],
					[sum_q_27_01],
					[sum_q_27_02],
					[sum_q_27_03],
					[sum_q_27_04],
					[sum_q_27_05],
					[sum_q_28_01],
					[sum_q_28_02],
					[sum_q_28_03],
					[sum_q_28_04],
					[sum_q_28_05],
					[sum_q_29_01],
					[sum_q_29_02],
					[sum_q_29_03],
					[sum_q_29_04],
					[sum_q_29_05],
					[sum_q_30_01],
					[sum_q_30_02],
					[sum_q_30_03],
					[sum_q_30_04],
					[sum_q_30_05],
					[sum_q_31_01],
					[sum_q_31_02],
					[sum_q_31_03],
					[sum_q_31_04],
					[sum_q_31_05],
					[sum_q_32_00],
					[sum_q_32_01],
					[sum_q_32_10],
					[sum_q_32_02],
					[sum_q_32_03],
					[sum_q_32_04],
					[sum_q_32_05],
					[sum_q_32_06],
					[sum_q_32_07],
					[sum_q_32_08],
					[sum_q_32_09],
					[sum_q_33_01],
					[sum_q_33_02],
					[sum_q_33_03],
					[sum_q_33_04],
					[sum_q_33_05],
					[sum_q_34_01],
					[sum_q_34_02],
					[sum_q_34_03],
					[sum_q_34_04],
					[sum_q_34_05],
					[sum_q_35_00],
					[sum_q_35_01],
					[sum_q_35_10],
					[sum_q_35_02],
					[sum_q_35_03],
					[sum_q_35_04],
					[sum_q_35_05],
					[sum_q_35_06],
					[sum_q_35_07],
					[sum_q_35_08],
					[sum_q_35_09],
					[sum_q_36_01],
					[sum_q_36_02],
					[sum_q_36_03],
					[sum_q_36_04],
					[sum_q_36_05],
					[sum_q_37_01],
					[sum_q_37_02],
					[sum_q_37_03],
					[sum_q_37_04],
					[sum_q_37_05],
					[sum_q_38_01],
					[sum_q_38_02],
					[sum_q_38_03],
					[sum_q_38_04],
					[sum_q_38_05],
					[sum_q_39_01],
					[sum_q_39_02],
					[sum_q_39_03],
					[sum_q_39_04],
					[sum_q_39_05],
					[sum_q_40_01],
					[sum_q_40_02],
					[sum_q_40_03],
					[sum_q_40_04],
					[sum_q_40_05],
					[sum_q_41_01],
					[sum_q_41_02],
					[sum_q_41_03],
					[sum_q_41_04],
					[sum_q_41_05],
					[sum_q_42_01],
					[sum_q_42_02],
					[sum_q_42_03],
					[sum_q_42_04],
					[sum_q_42_05],
					[sum_q_43_01],
					[sum_q_43_02],
					[sum_q_43_03],
					[sum_q_43_04],
					[sum_q_43_05],
					[sum_q_44_01],
					[sum_q_44_02],
					[sum_q_44_03],
					[sum_q_44_04],
					[sum_q_44_05],
					[sum_q_45_01],
					[sum_q_45_02],
					[sum_q_45_03],
					[sum_q_45_04],
					[sum_q_45_05],
					[sum_q_46_00],
					[sum_q_46_01],
					[sum_q_46_10],
					[sum_q_46_02],
					[sum_q_46_03],
					[sum_q_46_04],
					[sum_q_46_05],
					[sum_q_46_06],
					[sum_q_46_07],
					[sum_q_46_08],
					[sum_q_46_09],
					[sum_q_47_01],
					[sum_q_47_02],
					[sum_q_47_03],
					[sum_q_47_04],
					[sum_q_47_05],
					[sum_q_48_01],
					[sum_q_48_02],
					[sum_q_48_03],
					[sum_q_48_04],
					[sum_q_48_05],
					[sum_q_49_01],
					[sum_q_49_02],
					[sum_q_49_03],
					[sum_q_49_04],
					[sum_q_49_05],
					[sum_q_50_01],
					[sum_q_50_02],
					[sum_q_50_03],
					[sum_q_50_04],
					[sum_q_50_05],
					[sum_q_51_01],
					[sum_q_51_02],
					[sum_q_51_03],
					[sum_q_51_04],
					[sum_q_51_05],
					[sum_q_52_01],
					[sum_q_52_02],
					[sum_q_52_03],
					[sum_q_52_04],
					[sum_q_52_05],
					[sum_q_53_01],
					[sum_q_53_02],
					[sum_q_53_03],
					[sum_q_53_04],
					[sum_q_53_05],
					[sum_q_54_01],
					[sum_q_54_02],
					[sum_q_54_03],
					[sum_q_54_04],
					[sum_q_54_05],
					[sum_q_55_01],
					[sum_q_55_02],
					[sum_q_55_03],
					[sum_q_55_04],
					[sum_q_55_05],
					[sum_q_56_01],
					[sum_q_56_02],
					[sum_q_56_03],
					[sum_q_56_04],
					[sum_q_56_05],
					[sum_q_57_01],
					[sum_q_57_02],
					[sum_q_57_03],
					[sum_q_57_04],
					[sum_q_57_05],
					[sum_q_58_01],
					[sum_q_58_02],
					[sum_q_58_03],
					[sum_q_58_04],
					[sum_q_58_05],
					[sum_q_59_01],
					[sum_q_59_02],
					[sum_q_59_03],
					[sum_q_59_04],
					[sum_q_59_05],
					[sum_q_60_01],
					[sum_q_60_02],
					[sum_q_60_03],
					[sum_q_60_04],
					[sum_q_60_05],
					[sum_q_61_01],
					[sum_q_61_02],
					[sum_q_61_03],
					[sum_q_61_04],
					[sum_q_61_05],
					[sum_q_62_01],
					[sum_q_62_02],
					[sum_q_62_03],
					[sum_q_62_04],
					[sum_q_62_05],
					[sum_q_63_01],
					[sum_q_63_02],
					[sum_q_63_03],
					[sum_q_63_04],
					[sum_q_63_05],
					[sum_q_64_01],
					[sum_q_64_02],
					[sum_q_64_03],
					[sum_q_64_04],
					[sum_q_64_05],
					[sum_q_64_06],
					[sum_q_65_01],
					[sum_q_65_02],
					[sum_q_65_03],
					[sum_q_65_04],
					[sum_q_65_05],
					[sum_q_65_06],
					[sum_q_66_01],
					[sum_q_66_02],
					[sum_q_66_03],
					[sum_q_66_04],
					[sum_q_66_05],
					[sum_q_67_01],
					[sum_q_67_02],
					[sum_q_67_03],
					[sum_q_67_04],
					[sum_q_67_05],
					[sum_q_68_01],
					[sum_q_68_02],
					[sum_q_68_03],
					[sum_q_68_04],
					[sum_q_68_05],
					[sum_q_69_01],
					[sum_q_69_02],
					[sum_q_69_03],
					[sum_q_69_04],
					[sum_q_69_05],
					[sum_q_70_01],
					[sum_q_70_02],
					[sum_q_70_03],
					[sum_q_70_04],
					[sum_q_70_05]
					)				
	;
COMMIT TRAN

END