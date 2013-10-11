CREATE PROCEDURE spPopulate_odsResponse_Member AS
BEGIN
	MERGE	Seer_ODS.dbo.Response_Data AS target
	USING	(
			SELECT	'Member' module,
					A.[Date_Recd_C] date_received,
					COALESCE(C.member_key, B.member_key) member_key,
					A.[SEERKEY] seer_key,
					A.[CFID] cfid,
					A.[MFID] mfid,
					A.[ASSOCIATION_NAME] association_name,
					A.[OFF_ASSOC_NUM] official_association_number,
					A.[BRANCH_NAME] branch_name,
					A.[OFF_BR_NUM] official_branch_number,
					A.[LOC_BR_NUM] local_branch_number,
					A.[BR_ADDR_1] branch_address_1,
					A.[BR_ADDR_2] branch_address_2,
					A.[BR_CITY] branch_city,
					A.[BR_STATE] branch_state,
					A.[BR_ZIP] branch_zip,
					A.[CUTOFFDAYS] cut_off_days,
					A.[CALL_NAME] call_name,
					A.[CALLBR] call_branch,
					A.[CALL_PHONE] call_phone,
					A.[HR_SIGN] human_resources_sign,
					A.[HR_TITLE] human_resources_title,
					A.[FORM_CODE] form_code,
					A.[LANGUAGE] language,
					A.[Y_EMP_ID] y_employee_id,
					A.[MAIL_IND] mail_indicator,
					A.[FIRST_NAME] first_name,
					A.[MID_NAME] middle_name,
					A.[LAST_NAME] last_name,
					A.[SUFFIX] suffix,
					A.[ADDRESS1] address_1,
					A.[ADDRESS2] address_2,
					A.[CITY] city,
					A.[STATE] state,
					A.[ZIP] zip,
					A.[PHONE] phone,
					A.[HH_ID] household_id,
					A.[EMAIL] email,
					A.[CQ_1] cq_1,
					A.[CQ_2] cq_2,
					A.[CQ_3] cq_3,
					A.[CQ_4] cq_4,
					A.[CQ_5] cq_5,
					A.[CQ_6] cq_6,
					A.[SEQ_NUM] sequence_number,
					A.[PURL] purl,
					A.[Response_Load_Date] response_load_date,
					A.[Response_Language] response_language,
					A.[Response_Channel] response_channel,
					A.[Q_01] q_01,
					A.[Q_02] q_02,
					A.[Q_03] q_03,
					A.[Q_04] q_04,
					A.[Q_05] q_05,
					A.[Q_06] q_06,
					A.[Q_07] q_07,
					A.[Q_08] q_08,
					A.[Q_09] q_09,
					A.[Q_10] q_10,
					A.[Q_11] q_11,
					A.[Q_12] q_12,
					A.[Q_13] q_13,
					A.[Q_14] q_14,
					A.[Q_15] q_15,
					A.[Q_16] q_16,
					A.[Q_17] q_17,
					A.[Q_18] q_18,
					A.[Q_19] q_19,
					A.[Q_20] q_20,
					A.[Q_21] q_21,
					A.[Q_22] q_22,
					A.[Q_23] q_23,
					A.[Q_24] q_24,
					A.[Q_25] q_25,
					A.[Q_26] q_26,
					A.[Q_27] q_27,
					A.[Q_28] q_28,
					A.[Q_29] q_29,
					A.[Q_30] q_30,
					A.[Q_31] q_31,
					A.[Q_32] q_32,
					A.[Q_33] q_33,
					A.[Q_34] q_34,
					A.[Q_35] q_35,
					A.[Q_36] q_36,
					A.[Q_37] q_37,
					A.[Q_38] q_38,
					A.[Q_39] q_39,
					A.[Q_40] q_40,
					A.[Q_41] q_41,
					A.[Q_42] q_42,
					A.[Q_43] q_43,
					A.[Q_44] q_44,
					A.[Q_45] q_45,
					A.[Q_46] q_46,
					A.[Q_47] q_47,
					A.[Q_48] q_48,
					A.[Q_49] q_49,
					A.[Q_50] q_50,
					A.[Q_51] q_51,
					A.[Q_52] q_52,
					A.[Q_53] q_53,
					A.[Q_54] q_54,
					A.[Q_55] q_55,
					A.[Q_56] q_56,
					A.[Q_57] q_57,
					A.[Q_58] q_58,
					A.[Q_59] q_59,
					A.[Q_60] q_60,
					A.[Q_61] q_61,
					A.[Q_62] q_62,
					A.[Q_63] q_63,
					A.[Q_64] q_64,
					A.[Q_65] q_65,
					A.[Q_66] q_66,
					A.[Q_67] q_67,
					A.[Q_68] q_68,
					A.[Q_69] q_69,
					A.[Q_70] q_70,
					A.[Q_71] q_71,
					A.[Q_72] q_72,
					A.[Q_73] q_73,
					A.[Q_74] q_74,
					A.[Q_75] q_75,
					A.[Q_76] q_76,
					A.[Q_77] q_77,
					A.[Q_78] q_78,
					A.[Q_79] q_79,
					A.[Q_80] q_80,
					A.[Q_81] q_81,
					A.[Q_82] q_82,
					A.[Q_83] q_83,
					A.[Q_84] q_84,
					A.[Q_85] q_85,
					A.[Q_86] q_86,
					A.[Q_87] q_87,
					A.[Q_88] q_88,
					A.[Q_89] q_89,
					A.[Q_90] q_90,
					A.[Q_91] q_91,
					A.[Q_92] q_92,
					A.[Q_93] q_93,
					A.[Q_94] q_94,
					A.[Q_95] q_95,
					A.[Q_96] q_96,
					A.[Q_97] q_97,
					A.[Q_98] q_98,
					A.[Q_99] q_99,
					A.[T_01] t_01,
					A.[T_01_Category] t_01_category,
					A.[T_01_Questionable] t_01_questionable,
					A.[T_02] t_02,
					A.[T_02_Category] t_02_category,
					A.[T_02_Questionable] t_02_questionable,
					A.[T_03] t_03,
					A.[T_03_Category] t_03_category,
					A.[T_03_Questionable] t_03_questionable,
					A.[T_04] t_04,
					A.[T_04_Category] t_04_category,
					A.[T_04_Questionable] t_04_questionable,
					A.[T_05] t_05,
					A.[T_05_Category] t_05_category,
					A.[T_05_Questionable] t_05_questionable,
					A.[T_06] t_06,
					A.[T_06_Category] t_06_category,
					A.[T_06_Questionable] t_06_questionable,
					A.[T_07] t_07,
					A.[T_07_Category] t_07_category,
					A.[T_07_Questionable] t_07_questionable,
					A.[T_08] t_08,
					A.[T_08_Category] t_08_category,
					A.[T_08_Questionable] t_08_questionable,
					A.[T_09] t_09,
					A.[T_09_Category] t_09_category,
					A.[T_09_Questionable] t_09_questionable,
					A.[T_10] t_10,
					A.[T_10_Category] t_10_category,
					A.[T_10_Questionable] t_10_questionable,
					A.[T_01_Image] t_01_image,
					A.[T_02_Image] t_02_image,
					A.[T_03_Image] t_03_image,
					A.[T_04_Image] t_04_image,
					A.[T_05_Image] t_05_image,
					A.[T_06_Image] t_06_image,
					A.[T_07_Image] t_07_image,
					A.[T_08_Image] t_08_image,
					A.[T_09_Image] t_09_image,
					A.[T_10_Image] t_10_image,
					A.[M_01a] m_01a,
					A.[M_01b] m_01b,
					A.[M_01c] m_01c,
					A.[M_01d] m_01d,
					A.[M_01e] m_01e,
					A.[M_01f] m_01f,
					A.[M_02a] m_02a,
					A.[M_02b] m_02b,
					A.[M_02c] m_02c,
					A.[M_02d] m_02d,
					A.[M_02e] m_02e,
					A.[M_02f] m_02f,
					A.[M_03a] m_03a,
					A.[M_03b] m_03b,
					A.[M_03c] m_03c,
					A.[M_03d] m_03d,
					A.[M_03e] m_03e,
					A.[M_03f] m_03f,
					A.[M_04a] m_04a,
					A.[M_04b] m_04b,
					A.[M_04c] m_04c,
					A.[M_04d] m_04d,
					A.[M_04e] m_04e,
					A.[M_04f] m_04f,
					A.[M_05a] m_05a,
					A.[M_05b] m_05b,
					A.[M_05c] m_05c,
					A.[M_05d] m_05d,
					A.[M_05e] m_05e,
					A.[M_05f] m_05f,
					A.[C_01] c_01,
					A.[C_02] c_02,
					A.[C_03] c_03,
					A.[C_04] c_04,
					A.[C_05] c_05,
					A.[C_06] c_06,
					A.[Survey_Image] survey_image,
					A.[Date_Data_Entered] date_data_entered,
					A.[Data_Enter_Status] data_enter_status,
					A.[Response_Coded_Date] response_coded_date,
					A.[Response_Coded_Status] response_coded_status,
					A.[Date_Sent_To_Seer] date_sent_to_seer,
					A.[Seer_Status] seer_status,
					A.[Total_Questions_Answered] total_questions_answered,
					COALESCE(A.Batch_Number, '') batch_number,
					A.[JOB_ORD] job_order_number,
					A.[ASSOC_EMP] association_employee,
					A.[MailDate01] mail_date_01,
					A.[MailChan01] mail_channel_01,
					A.[MailDate02] mail_date_02,
					A.[MailChan02] mail_channel_02,
					A.[MailDate03] mail_date_03,
					A.[MailChan03] mail_channel_03,
					A.[MailDate04] mail_date_04,
					A.[MailChan04] mail_channel_04,
					A.[MailDate05] mail_date_05,
					A.[MailChan05] mail_channel_05,
					A.[MailDate06] mail_date_06,
					A.[MailChan06] mail_channel_06,
					A.[FileName] file_name

			FROM	Seer_STG.dbo.[Member Response Data] A
					LEFT JOIN Seer_MDM.dbo.Member_Map B
						ON A.SeerKey = B.seer_key
					LEFT JOIN Seer_MDM.dbo.Member C
						ON A.Member_Key = C.member_key
						
			WHERE	COALESCE(A.[Q_01], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_02], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_03], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_04], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_05], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_06], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_07], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_08], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_09], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_10], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_11], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_12], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_13], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_14], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_15], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_16], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_17], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_18], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_19], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_20], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_21], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_22], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_23], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_24], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_25], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_26], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_27], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_28], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_29], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_30], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_31], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_32], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_33], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_34], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_35], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_36], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_37], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_38], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_39], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_40], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_41], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_42], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_43], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_44], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_45], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_46], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_47], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_48], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_49], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_50], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_51], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_52], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_53], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_54], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_55], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_56], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_57], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_58], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_59], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_60], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_61], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_62], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_63], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_64], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_65], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_66], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_67], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_68], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_69], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_70], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_71], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_72], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_73], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_74], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_75], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_76], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_77], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_78], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_79], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_80], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_81], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_82], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_83], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_84], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_85], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_86], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_87], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_88], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_89], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_90], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_91], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_92], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_93], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_94], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_95], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_96], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_97], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_98], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
					AND COALESCE(A.[Q_99], '') IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')	
			
			) AS source
			ON target.member_key = source.member_key
				AND target.form_code = source.form_code
			
	WHEN MATCHED AND (target.module	 <>  	source.module
						OR target.date_received	 <>  	source.date_received
						OR target.seer_key	 <>  	source.seer_key
						OR target.cfid	 <>  	source.cfid
						OR target.mfid	 <>  	source.mfid
						OR target.batch_number	 <>  	source.batch_number
						OR target.job_order_number	 <>  	source.job_order_number
						OR target.association_name	 <>  	source.association_name
						OR target.official_association_number	 <>  	source.official_association_number
						OR target.branch_name	 <>  	source.branch_name
						OR target.official_branch_number	 <>  	source.official_branch_number
						OR target.local_branch_number	 <>  	source.local_branch_number
						OR target.branch_address_1	 <>  	source.branch_address_1
						OR target.branch_address_2	 <>  	source.branch_address_2
						OR target.branch_city	 <>  	source.branch_city
						OR target.branch_state	 <>  	source.branch_state
						OR target.branch_zip	 <>  	source.branch_zip
						--OR target.association_approximate_employees	 <>  	source.association_approximate_employees
						OR target.cut_off_days	 <>  	source.cut_off_days
						OR target.call_name	 <>  	source.call_name
						OR target.call_branch	 <>  	source.call_branch
						OR target.call_phone	 <>  	source.call_phone
						OR target.human_resources_sign	 <>  	source.human_resources_sign
						OR target.human_resources_title	 <>  	source.human_resources_title
						OR target.language	 <>  	source.language
						OR target.y_employee_id	 <>  	source.y_employee_id
						OR target.mail_indicator	 <>  	source.mail_indicator
						OR target.first_name	 <>  	source.first_name
						OR target.middle_name	 <>  	source.middle_name
						OR target.last_name	 <>  	source.last_name
						OR target.suffix	 <>  	source.suffix
						OR target.address_1	 <>  	source.address_1
						OR target.address_2	 <>  	source.address_2
						OR target.city	 <>  	source.city
						OR target.state	 <>  	source.state
						OR target.zip	 <>  	source.zip
						OR target.phone	 <>  	source.phone
						OR target.household_id	 <>  	source.household_id
						OR target.email	 <>  	source.email
						OR target.cq_1	 <>  	source.cq_1
						OR target.cq_2	 <>  	source.cq_2
						OR target.cq_3	 <>  	source.cq_3
						OR target.cq_4	 <>  	source.cq_4
						OR target.cq_5	 <>  	source.cq_5
						OR target.cq_6	 <>  	source.cq_6
						OR target.sequence_number	 <>  	source.sequence_number
						OR target.purl	 <>  	source.purl
						--OR target.mail_date_01_c	 <>  	source.mail_date_01_c
						OR target.mail_channel_01	 <>  	source.mail_channel_01
						--OR target.mail_date_02_c	 <>  	source.mail_date_02_c
						OR target.mail_channel_02	 <>  	source.mail_channel_02
						--OR target.mail_date_03_c	 <>  	source.mail_date_03_c
						OR target.mail_channel_03	 <>  	source.mail_channel_03
						--OR target.mail_date_04_c	 <>  	source.mail_date_04_c
						OR target.mail_channel_04	 <>  	source.mail_channel_04
						--OR target.mail_date_05_c	 <>  	source.mail_date_05_c
						OR target.mail_channel_05	 <>  	source.mail_channel_05
						--OR target.mail_date_06_c	 <>  	source.mail_date_06_c
						OR target.mail_channel_06	 <>  	source.mail_channel_06
						OR target.response_load_date	 <>  	source.response_load_date
						OR target.response_language	 <>  	source.response_language
						OR target.response_channel	 <>  	source.response_channel
						OR target.q_01	 <>  	source.q_01
						OR target.q_02	 <>  	source.q_02
						OR target.q_03	 <>  	source.q_03
						OR target.q_04	 <>  	source.q_04
						OR target.q_05	 <>  	source.q_05
						OR target.q_06	 <>  	source.q_06
						OR target.q_07	 <>  	source.q_07
						OR target.q_08	 <>  	source.q_08
						OR target.q_09	 <>  	source.q_09
						OR target.q_10	 <>  	source.q_10
						OR target.q_11	 <>  	source.q_11
						OR target.q_12	 <>  	source.q_12
						OR target.q_13	 <>  	source.q_13
						OR target.q_14	 <>  	source.q_14
						OR target.q_15	 <>  	source.q_15
						OR target.q_16	 <>  	source.q_16
						OR target.q_17	 <>  	source.q_17
						OR target.q_18	 <>  	source.q_18
						OR target.q_19	 <>  	source.q_19
						OR target.q_20	 <>  	source.q_20
						OR target.q_21	 <>  	source.q_21
						OR target.q_22	 <>  	source.q_22
						OR target.q_23	 <>  	source.q_23
						OR target.q_24	 <>  	source.q_24
						OR target.q_25	 <>  	source.q_25
						OR target.q_26	 <>  	source.q_26
						OR target.q_27	 <>  	source.q_27
						OR target.q_28	 <>  	source.q_28
						OR target.q_29	 <>  	source.q_29
						OR target.q_30	 <>  	source.q_30
						OR target.q_31	 <>  	source.q_31
						OR target.q_32	 <>  	source.q_32
						OR target.q_33	 <>  	source.q_33
						OR target.q_34	 <>  	source.q_34
						OR target.q_35	 <>  	source.q_35
						OR target.q_36	 <>  	source.q_36
						OR target.q_37	 <>  	source.q_37
						OR target.q_38	 <>  	source.q_38
						OR target.q_39	 <>  	source.q_39
						OR target.q_40	 <>  	source.q_40
						OR target.q_41	 <>  	source.q_41
						OR target.q_42	 <>  	source.q_42
						OR target.q_43	 <>  	source.q_43
						OR target.q_44	 <>  	source.q_44
						OR target.q_45	 <>  	source.q_45
						OR target.q_46	 <>  	source.q_46
						OR target.q_47	 <>  	source.q_47
						OR target.q_48	 <>  	source.q_48
						OR target.q_49	 <>  	source.q_49
						OR target.q_50	 <>  	source.q_50
						OR target.q_51	 <>  	source.q_51
						OR target.q_52	 <>  	source.q_52
						OR target.q_53	 <>  	source.q_53
						OR target.q_54	 <>  	source.q_54
						OR target.q_55	 <>  	source.q_55
						OR target.q_56	 <>  	source.q_56
						OR target.q_57	 <>  	source.q_57
						OR target.q_58	 <>  	source.q_58
						OR target.q_59	 <>  	source.q_59
						OR target.q_60	 <>  	source.q_60
						OR target.q_61	 <>  	source.q_61
						OR target.q_62	 <>  	source.q_62
						OR target.q_63	 <>  	source.q_63
						OR target.q_64	 <>  	source.q_64
						OR target.q_65	 <>  	source.q_65
						OR target.q_66	 <>  	source.q_66
						OR target.q_67	 <>  	source.q_67
						OR target.q_68	 <>  	source.q_68
						OR target.q_69	 <>  	source.q_69
						OR target.q_70	 <>  	source.q_70
						OR target.q_71	 <>  	source.q_71
						OR target.q_72	 <>  	source.q_72
						OR target.q_73	 <>  	source.q_73
						OR target.q_74	 <>  	source.q_74
						OR target.q_75	 <>  	source.q_75
						OR target.t_01	 <>  	source.t_01
						OR target.t_01_category	 <>  	source.t_01_category
						OR target.t_01_Questionable	 <>  	source.t_01_Questionable
						OR target.t_02	 <>  	source.t_02
						OR target.t_02_category	 <>  	source.t_02_category
						OR target.t_02_Questionable	 <>  	source.t_02_Questionable
						OR target.t_03	 <>  	source.t_03
						OR target.t_03_category	 <>  	source.t_03_category
						OR target.t_03_Questionable	 <>  	source.t_03_Questionable
						OR target.t_04	 <>  	source.t_04
						OR target.t_04_category	 <>  	source.t_04_category
						OR target.t_04_Questionable	 <>  	source.t_04_Questionable
						OR target.t_05	 <>  	source.t_05
						OR target.t_05_category	 <>  	source.t_05_category
						OR target.t_05_Questionable	 <>  	source.t_05_Questionable
						OR target.t_06	 <>  	source.t_06
						OR target.t_06_category	 <>  	source.t_06_category
						OR target.t_06_Questionable	 <>  	source.t_06_Questionable
						OR target.t_07	 <>  	source.t_07
						OR target.t_07_category	 <>  	source.t_07_category
						OR target.t_07_Questionable	 <>  	source.t_07_Questionable
						OR target.t_08	 <>  	source.t_08
						OR target.t_08_category	 <>  	source.t_08_category
						OR target.t_08_Questionable	 <>  	source.t_08_Questionable
						OR target.t_09	 <>  	source.t_09
						OR target.t_09_category	 <>  	source.t_09_category
						OR target.t_09_Questionable	 <>  	source.t_09_Questionable
						OR target.t_10	 <>  	source.t_10
						OR target.t_10_category	 <>  	source.t_10_category
						OR target.t_10_Questionable	 <>  	source.t_10_Questionable
						OR target.t_01_Image	 <>  	source.t_01_Image
						OR target.t_02_Image	 <>  	source.t_02_Image
						OR target.t_03_Image	 <>  	source.t_03_Image
						OR target.t_04_Image	 <>  	source.t_04_Image
						OR target.t_05_Image	 <>  	source.t_05_Image
						OR target.t_06_Image	 <>  	source.t_06_Image
						OR target.t_07_Image	 <>  	source.t_07_Image
						OR target.t_08_Image	 <>  	source.t_08_Image
						OR target.t_09_Image	 <>  	source.t_09_Image
						OR target.t_10_Image	 <>  	source.t_10_Image
						OR target.m_01a	 <>  	source.m_01a
						OR target.m_01b	 <>  	source.m_01b
						OR target.m_01c	 <>  	source.m_01c
						OR target.m_01d	 <>  	source.m_01d
						OR target.m_01e	 <>  	source.m_01e
						OR target.m_01f	 <>  	source.m_01f
						OR target.m_02a	 <>  	source.m_02a
						OR target.m_02b	 <>  	source.m_02b
						OR target.m_02c	 <>  	source.m_02c
						OR target.m_02d	 <>  	source.m_02d
						OR target.m_02e	 <>  	source.m_02e
						OR target.m_02f	 <>  	source.m_02f
						OR target.m_03a	 <>  	source.m_03a
						OR target.m_03b	 <>  	source.m_03b
						OR target.m_03c	 <>  	source.m_03c
						OR target.m_03d	 <>  	source.m_03d
						OR target.m_03e	 <>  	source.m_03e
						OR target.m_03f	 <>  	source.m_03f
						OR target.m_04a	 <>  	source.m_04a
						OR target.m_04b	 <>  	source.m_04b
						OR target.m_04c	 <>  	source.m_04c
						OR target.m_04d	 <>  	source.m_04d
						OR target.m_04e	 <>  	source.m_04e
						OR target.m_04f	 <>  	source.m_04f
						OR target.m_05a	 <>  	source.m_05a
						OR target.m_05b	 <>  	source.m_05b
						OR target.m_05c	 <>  	source.m_05c
						OR target.m_05d	 <>  	source.m_05d
						OR target.m_05e	 <>  	source.m_05e
						OR target.m_05f	 <>  	source.m_05f
						OR target.c_01	 <>  	source.c_01
						OR target.c_02	 <>  	source.c_02
						OR target.c_03	 <>  	source.c_03
						OR target.c_04	 <>  	source.c_04
						OR target.c_05	 <>  	source.c_05
						OR target.c_06	 <>  	source.c_06
						OR target.survey_image	 <>  	source.survey_image
						OR target.date_data_entered	 <>  	source.date_data_entered
						OR target.data_enter_status	 <>  	source.data_enter_status
						OR target.response_coded_date	 <>  	source.response_coded_date
						OR target.response_coded_status	 <>  	source.response_coded_status
						OR target.date_sent_to_seer	 <>  	source.date_sent_to_seer
						OR target.seer_status	 <>  	source.seer_status
						OR target.total_questions_answered	 <>  	source.total_questions_answered
						OR target.file_name	 <>  	source.file_name
						--OR target.right_file_name	 <>  	source.right_file_name

)
		THEN
			UPDATE	
			SET		date_received	 =  	source.date_received,
					seer_key	 =  	source.seer_key,
					cfid	 =  	source.cfid,
					mfid	 =  	source.mfid,
					batch_number	 =  	source.batch_number,
					job_order_number	 =  	source.job_order_number,
					association_name	 =  	source.association_name,
					official_association_number	 =  	source.official_association_number,
					branch_name	 =  	source.branch_name,
					official_branch_number	 =  	source.official_branch_number,
					local_branch_number	 =  	source.local_branch_number,
					branch_address_1	 =  	source.branch_address_1,
					branch_address_2	 =  	source.branch_address_2,
					branch_city	 =  	source.branch_city,
					branch_state	 =  	source.branch_state,
					branch_zip	 =  	source.branch_zip,
					--association_approximate_employees	 =  	source.association_approximate_employees,
					cut_off_days	 =  	source.cut_off_days,
					call_name	 =  	source.call_name,
					call_branch	 =  	source.call_branch,
					call_phone	 =  	source.call_phone,
					human_resources_sign	 =  	source.human_resources_sign,
					human_resources_title	 =  	source.human_resources_title,
					form_code	 =  	source.form_code,
					language	 =  	source.language,
					y_employee_id	 =  	source.y_employee_id,
					mail_indicator	 =  	source.mail_indicator,
					first_name	 =  	source.first_name,
					middle_name	 =  	source.middle_name,
					last_name	 =  	source.last_name,
					suffix	 =  	source.suffix,
					address_1	 =  	source.address_1,
					address_2	 =  	source.address_2,
					city	 =  	source.city,
					state	 =  	source.state,
					zip	 =  	source.zip,
					phone	 =  	source.phone,
					household_id	 =  	source.household_id,
					email	 =  	source.email,
					cq_1	 =  	source.cq_1,
					cq_2	 =  	source.cq_2,
					cq_3	 =  	source.cq_3,
					cq_4	 =  	source.cq_4,
					cq_5	 =  	source.cq_5,
					cq_6	 =  	source.cq_6,
					sequence_number	 =  	source.sequence_number,
					purl	 =  	source.purl,
					--mail_date_01_c	 =  	source.mail_date_01_c,
					mail_channel_01	 =  	source.mail_channel_01,
					--mail_date_02_c	 =  	source.mail_date_02_c,
					mail_channel_02	 =  	source.mail_channel_02,
					--mail_date_03_c	 =  	source.mail_date_03_c,
					mail_channel_03	 =  	source.mail_channel_03,
					--mail_date_04_c	 =  	source.mail_date_04_c,
					mail_channel_04	 =  	source.mail_channel_04,
					--mail_date_05_c	 =  	source.mail_date_05_c,
					mail_channel_05	 =  	source.mail_channel_05,
					--mail_date_06_c	 =  	source.mail_date_06_c,
					mail_channel_06	 =  	source.mail_channel_06,
					response_load_date	 =  	source.response_load_date,
					response_language	 =  	source.response_language,
					response_channel	 =  	source.response_channel,
					q_01	 =  	source.q_01,
					q_02	 =  	source.q_02,
					q_03	 =  	source.q_03,
					q_04	 =  	source.q_04,
					q_05	 =  	source.q_05,
					q_06	 =  	source.q_06,
					q_07	 =  	source.q_07,
					q_08	 =  	source.q_08,
					q_09	 =  	source.q_09,
					q_10	 =  	source.q_10,
					q_11	 =  	source.q_11,
					q_12	 =  	source.q_12,
					q_13	 =  	source.q_13,
					q_14	 =  	source.q_14,
					q_15	 =  	source.q_15,
					q_16	 =  	source.q_16,
					q_17	 =  	source.q_17,
					q_18	 =  	source.q_18,
					q_19	 =  	source.q_19,
					q_20	 =  	source.q_20,
					q_21	 =  	source.q_21,
					q_22	 =  	source.q_22,
					q_23	 =  	source.q_23,
					q_24	 =  	source.q_24,
					q_25	 =  	source.q_25,
					q_26	 =  	source.q_26,
					q_27	 =  	source.q_27,
					q_28	 =  	source.q_28,
					q_29	 =  	source.q_29,
					q_30	 =  	source.q_30,
					q_31	 =  	source.q_31,
					q_32	 =  	source.q_32,
					q_33	 =  	source.q_33,
					q_34	 =  	source.q_34,
					q_35	 =  	source.q_35,
					q_36	 =  	source.q_36,
					q_37	 =  	source.q_37,
					q_38	 =  	source.q_38,
					q_39	 =  	source.q_39,
					q_40	 =  	source.q_40,
					q_41	 =  	source.q_41,
					q_42	 =  	source.q_42,
					q_43	 =  	source.q_43,
					q_44	 =  	source.q_44,
					q_45	 =  	source.q_45,
					q_46	 =  	source.q_46,
					q_47	 =  	source.q_47,
					q_48	 =  	source.q_48,
					q_49	 =  	source.q_49,
					q_50	 =  	source.q_50,
					q_51	 =  	source.q_51,
					q_52	 =  	source.q_52,
					q_53	 =  	source.q_53,
					q_54	 =  	source.q_54,
					q_55	 =  	source.q_55,
					q_56	 =  	source.q_56,
					q_57	 =  	source.q_57,
					q_58	 =  	source.q_58,
					q_59	 =  	source.q_59,
					q_60	 =  	source.q_60,
					q_61	 =  	source.q_61,
					q_62	 =  	source.q_62,
					q_63	 =  	source.q_63,
					q_64	 =  	source.q_64,
					q_65	 =  	source.q_65,
					q_66	 =  	source.q_66,
					q_67	 =  	source.q_67,
					q_68	 =  	source.q_68,
					q_69	 =  	source.q_69,
					q_70	 =  	source.q_70,
					q_71	 =  	source.q_71,
					q_72	 =  	source.q_72,
					q_73	 =  	source.q_73,
					q_74	 =  	source.q_74,
					q_75	 =  	source.q_75,
					t_01	 =  	source.t_01,
					t_01_category	 =  	source.t_01_category,
					t_01_Questionable	 =  	source.t_01_Questionable,
					t_02	 =  	source.t_02,
					t_02_category	 =  	source.t_02_category,
					t_02_Questionable	 =  	source.t_02_Questionable,
					t_03	 =  	source.t_03,
					t_03_category	 =  	source.t_03_category,
					t_03_Questionable	 =  	source.t_03_Questionable,
					t_04	 =  	source.t_04,
					t_04_category	 =  	source.t_04_category,
					t_04_Questionable	 =  	source.t_04_Questionable,
					t_05	 =  	source.t_05,
					t_05_category	 =  	source.t_05_category,
					t_05_Questionable	 =  	source.t_05_Questionable,
					t_06	 =  	source.t_06,
					t_06_category	 =  	source.t_06_category,
					t_06_Questionable	 =  	source.t_06_Questionable,
					t_07	 =  	source.t_07,
					t_07_category	 =  	source.t_07_category,
					t_07_Questionable	 =  	source.t_07_Questionable,
					t_08	 =  	source.t_08,
					t_08_category	 =  	source.t_08_category,
					t_08_Questionable	 =  	source.t_08_Questionable,
					t_09	 =  	source.t_09,
					t_09_category	 =  	source.t_09_category,
					t_09_Questionable	 =  	source.t_09_Questionable,
					t_10	 =  	source.t_10,
					t_10_category	 =  	source.t_10_category,
					t_10_Questionable	 =  	source.t_10_Questionable,
					t_01_Image	 =  	source.t_01_Image,
					t_02_Image	 =  	source.t_02_Image,
					t_03_Image	 =  	source.t_03_Image,
					t_04_Image	 =  	source.t_04_Image,
					t_05_Image	 =  	source.t_05_Image,
					t_06_Image	 =  	source.t_06_Image,
					t_07_Image	 =  	source.t_07_Image,
					t_08_Image	 =  	source.t_08_Image,
					t_09_Image	 =  	source.t_09_Image,
					t_10_Image	 =  	source.t_10_Image,
					m_01a	 =  	source.m_01a,
					m_01b	 =  	source.m_01b,
					m_01c	 =  	source.m_01c,
					m_01d	 =  	source.m_01d,
					m_01e	 =  	source.m_01e,
					m_01f	 =  	source.m_01f,
					m_02a	 =  	source.m_02a,
					m_02b	 =  	source.m_02b,
					m_02c	 =  	source.m_02c,
					m_02d	 =  	source.m_02d,
					m_02e	 =  	source.m_02e,
					m_02f	 =  	source.m_02f,
					m_03a	 =  	source.m_03a,
					m_03b	 =  	source.m_03b,
					m_03c	 =  	source.m_03c,
					m_03d	 =  	source.m_03d,
					m_03e	 =  	source.m_03e,
					m_03f	 =  	source.m_03f,
					m_04a	 =  	source.m_04a,
					m_04b	 =  	source.m_04b,
					m_04c	 =  	source.m_04c,
					m_04d	 =  	source.m_04d,
					m_04e	 =  	source.m_04e,
					m_04f	 =  	source.m_04f,
					m_05a	 =  	source.m_05a,
					m_05b	 =  	source.m_05b,
					m_05c	 =  	source.m_05c,
					m_05d	 =  	source.m_05d,
					m_05e	 =  	source.m_05e,
					m_05f	 =  	source.m_05f,
					c_01	 =  	source.c_01,
					c_02	 =  	source.c_02,
					c_03	 =  	source.c_03,
					c_04	 =  	source.c_04,
					c_05	 =  	source.c_05,
					c_06	 =  	source.c_06,
					survey_image	 =  	source.survey_image,
					date_data_entered	 =  	source.date_data_entered,
					data_enter_status	 =  	source.data_enter_status,
					response_coded_date	 =  	source.response_coded_date,
					response_coded_status	 =  	source.response_coded_status,
					date_sent_to_seer	 =  	source.date_sent_to_seer,
					seer_status	 =  	source.seer_status,
					total_questions_answered	 =  	source.total_questions_answered,
					file_name	 =  	source.file_name--,
					--right_file_name	 =  	source.right_file_name

						
	WHEN NOT MATCHED BY target AND
		(source.member_key IS NOT NULL
			AND LEN(source.form_code) > 0
			AND ((LEN(source.date_received) > 0 AND ISDATE(source.date_received) = 1)
					OR LEN(COALESCE(source.date_received, '')) = 0
				)
			AND ((LEN(source.date_data_entered) > 0 AND ISDATE(source.date_data_entered) = 1)
					OR LEN(COALESCE(source.date_data_entered, '')) = 0
				)
			AND ((LEN(source.response_coded_date) > 0 AND ISDATE(source.response_coded_date) = 1)
					OR LEN(COALESCE(source.response_coded_date, '')) = 0
				)
			AND ((LEN(source.date_sent_to_seer) > 0 AND ISDATE(source.date_sent_to_seer) = 1)
					OR LEN(COALESCE(source.date_sent_to_seer, '')) = 0
				)
			AND ((LEN(source.total_questions_answered) > 0 AND ISNUMERIC(source.total_questions_answered) = 1)
					OR LEN(COALESCE(source.total_questions_answered, '')) = 0
				)
		)
		THEN 
			INSERT (module,
					date_received,
					member_key,
					seer_key,
					cfid,
					mfid,
					batch_number,
					job_order_number,
					association_name,
					official_association_number,
					branch_name,
					official_branch_number,
					local_branch_number,
					branch_address_1,
					branch_address_2,
					branch_city,
					branch_state,
					branch_zip,
					--association_approximate_employees,
					cut_off_days,
					call_name,
					call_branch,
					call_phone,
					human_resources_sign,
					human_resources_title,
					form_code,
					language,
					y_employee_id,
					mail_indicator,
					first_name,
					middle_name,
					last_name,
					suffix,
					address_1,
					address_2,
					city,
					state,
					zip,
					phone,
					household_id,
					email,
					cq_1,
					cq_2,
					cq_3,
					cq_4,
					cq_5,
					cq_6,
					sequence_number,
					purl,
					--mail_date_01_c,
					mail_channel_01,
					--mail_date_02_c,
					mail_channel_02,
					--mail_date_03_c,
					mail_channel_03,
					--mail_date_04_c,
					mail_channel_04,
					--mail_date_05_c,
					mail_channel_05,
					--mail_date_06_c,
					mail_channel_06,
					response_load_date,
					response_language,
					response_channel,
					q_01,
					q_02,
					q_03,
					q_04,
					q_05,
					q_06,
					q_07,
					q_08,
					q_09,
					q_10,
					q_11,
					q_12,
					q_13,
					q_14,
					q_15,
					q_16,
					q_17,
					q_18,
					q_19,
					q_20,
					q_21,
					q_22,
					q_23,
					q_24,
					q_25,
					q_26,
					q_27,
					q_28,
					q_29,
					q_30,
					q_31,
					q_32,
					q_33,
					q_34,
					q_35,
					q_36,
					q_37,
					q_38,
					q_39,
					q_40,
					q_41,
					q_42,
					q_43,
					q_44,
					q_45,
					q_46,
					q_47,
					q_48,
					q_49,
					q_50,
					q_51,
					q_52,
					q_53,
					q_54,
					q_55,
					q_56,
					q_57,
					q_58,
					q_59,
					q_60,
					q_61,
					q_62,
					q_63,
					q_64,
					q_65,
					q_66,
					q_67,
					q_68,
					q_69,
					q_70,
					q_71,
					q_72,
					q_73,
					q_74,
					q_75,
					t_01,
					t_01_category,
					t_01_Questionable,
					t_02,
					t_02_category,
					t_02_Questionable,
					t_03,
					t_03_category,
					t_03_Questionable,
					t_04,
					t_04_category,
					t_04_Questionable,
					t_05,
					t_05_category,
					t_05_Questionable,
					t_06,
					t_06_category,
					t_06_Questionable,
					t_07,
					t_07_category,
					t_07_Questionable,
					t_08,
					t_08_category,
					t_08_Questionable,
					t_09,
					t_09_category,
					t_09_Questionable,
					t_10,
					t_10_category,
					t_10_Questionable,
					t_01_Image,
					t_02_Image,
					t_03_Image,
					t_04_Image,
					t_05_Image,
					t_06_Image,
					t_07_Image,
					t_08_Image,
					t_09_Image,
					t_10_Image,
					m_01a,
					m_01b,
					m_01c,
					m_01d,
					m_01e,
					m_01f,
					m_02a,
					m_02b,
					m_02c,
					m_02d,
					m_02e,
					m_02f,
					m_03a,
					m_03b,
					m_03c,
					m_03d,
					m_03e,
					m_03f,
					m_04a,
					m_04b,
					m_04c,
					m_04d,
					m_04e,
					m_04f,
					m_05a,
					m_05b,
					m_05c,
					m_05d,
					m_05e,
					m_05f,
					c_01,
					c_02,
					c_03,
					c_04,
					c_05,
					c_06,
					survey_image,
					date_data_entered,
					data_enter_status,
					response_coded_date,
					response_coded_status,
					date_sent_to_seer,
					seer_status,
					total_questions_answered,
					file_name--,
					--right_file_name
					)
			VALUES (module,
					date_received,
					member_key,
					seer_key,
					cfid,
					mfid,
					batch_number,
					job_order_number,
					association_name,
					official_association_number,
					branch_name,
					official_branch_number,
					local_branch_number,
					branch_address_1,
					branch_address_2,
					branch_city,
					branch_state,
					branch_zip,
					--association_approximate_employees,
					cut_off_days,
					call_name,
					call_branch,
					call_phone,
					human_resources_sign,
					human_resources_title,
					form_code,
					language,
					y_employee_id,
					mail_indicator,
					first_name,
					middle_name,
					last_name,
					suffix,
					address_1,
					address_2,
					city,
					state,
					zip,
					phone,
					household_id,
					email,
					cq_1,
					cq_2,
					cq_3,
					cq_4,
					cq_5,
					cq_6,
					sequence_number,
					purl,
					--mail_date_01_c,
					mail_channel_01,
					--mail_date_02_c,
					mail_channel_02,
					--mail_date_03_c,
					mail_channel_03,
					--mail_date_04_c,
					mail_channel_04,
					--mail_date_05_c,
					mail_channel_05,
					--mail_date_06_c,
					mail_channel_06,
					response_load_date,
					response_language,
					response_channel,
					q_01,
					q_02,
					q_03,
					q_04,
					q_05,
					q_06,
					q_07,
					q_08,
					q_09,
					q_10,
					q_11,
					q_12,
					q_13,
					q_14,
					q_15,
					q_16,
					q_17,
					q_18,
					q_19,
					q_20,
					q_21,
					q_22,
					q_23,
					q_24,
					q_25,
					q_26,
					q_27,
					q_28,
					q_29,
					q_30,
					q_31,
					q_32,
					q_33,
					q_34,
					q_35,
					q_36,
					q_37,
					q_38,
					q_39,
					q_40,
					q_41,
					q_42,
					q_43,
					q_44,
					q_45,
					q_46,
					q_47,
					q_48,
					q_49,
					q_50,
					q_51,
					q_52,
					q_53,
					q_54,
					q_55,
					q_56,
					q_57,
					q_58,
					q_59,
					q_60,
					q_61,
					q_62,
					q_63,
					q_64,
					q_65,
					q_66,
					q_67,
					q_68,
					q_69,
					q_70,
					q_71,
					q_72,
					q_73,
					q_74,
					q_75,
					t_01,
					t_01_category,
					t_01_Questionable,
					t_02,
					t_02_category,
					t_02_Questionable,
					t_03,
					t_03_category,
					t_03_Questionable,
					t_04,
					t_04_category,
					t_04_Questionable,
					t_05,
					t_05_category,
					t_05_Questionable,
					t_06,
					t_06_category,
					t_06_Questionable,
					t_07,
					t_07_category,
					t_07_Questionable,
					t_08,
					t_08_category,
					t_08_Questionable,
					t_09,
					t_09_category,
					t_09_Questionable,
					t_10,
					t_10_category,
					t_10_Questionable,
					t_01_Image,
					t_02_Image,
					t_03_Image,
					t_04_Image,
					t_05_Image,
					t_06_Image,
					t_07_Image,
					t_08_Image,
					t_09_Image,
					t_10_Image,
					m_01a,
					m_01b,
					m_01c,
					m_01d,
					m_01e,
					m_01f,
					m_02a,
					m_02b,
					m_02c,
					m_02d,
					m_02e,
					m_02f,
					m_03a,
					m_03b,
					m_03c,
					m_03d,
					m_03e,
					m_03f,
					m_04a,
					m_04b,
					m_04c,
					m_04d,
					m_04e,
					m_04f,
					m_05a,
					m_05b,
					m_05c,
					m_05d,
					m_05e,
					m_05f,
					c_01,
					c_02,
					c_03,
					c_04,
					c_05,
					c_06,
					survey_image,
					date_data_entered,
					data_enter_status,
					response_coded_date,
					response_coded_status,
					date_sent_to_seer,
					seer_status,
					total_questions_answered,
					file_name--,
					--right_file_name
					)
					
	;
	INSERT INTO Seer_CTRL.dbo.[Member Response Data]([Date_Recd_C],
														[Member_Key],
														[SEERKEY],
														[CFID],
														[MFID],
														[ASSOCIATION_NAME],
														[OFF_ASSOC_NUM],
														[BRANCH_NAME],
														[OFF_BR_NUM],
														[LOC_BR_NUM],
														[BR_ADDR_1],
														[BR_ADDR_2],
														[BR_CITY],
														[BR_STATE],
														[BR_ZIP],
														[CUTOFFDAYS],
														[CALL_NAME],
														[CALLBR],
														[CALL_PHONE],
														[HR_SIGN],
														[HR_TITLE],
														[FORM_CODE],
														[LANGUAGE],
														[Y_EMP_ID],
														[MAIL_IND],
														[FIRST_NAME],
														[MID_NAME],
														[LAST_NAME],
														[SUFFIX],
														[ADDRESS1],
														[ADDRESS2],
														[CITY],
														[STATE],
														[ZIP],
														[PHONE],
														[HH_ID],
														[EMAIL],
														[CQ_1],
														[CQ_2],
														[CQ_3],
														[CQ_4],
														[CQ_5],
														[CQ_6],
														[SEQ_NUM],
														[PURL],
														[Response_Load_Date],
														[Response_Language],
														[Response_Channel],
														[Q_01],
														[Q_02],
														[Q_03],
														[Q_04],
														[Q_05],
														[Q_06],
														[Q_07],
														[Q_08],
														[Q_09],
														[Q_10],
														[Q_11],
														[Q_12],
														[Q_13],
														[Q_14],
														[Q_15],
														[Q_16],
														[Q_17],
														[Q_18],
														[Q_19],
														[Q_20],
														[Q_21],
														[Q_22],
														[Q_23],
														[Q_24],
														[Q_25],
														[Q_26],
														[Q_27],
														[Q_28],
														[Q_29],
														[Q_30],
														[Q_31],
														[Q_32],
														[Q_33],
														[Q_34],
														[Q_35],
														[Q_36],
														[Q_37],
														[Q_38],
														[Q_39],
														[Q_40],
														[Q_41],
														[Q_42],
														[Q_43],
														[Q_44],
														[Q_45],
														[Q_46],
														[Q_47],
														[Q_48],
														[Q_49],
														[Q_50],
														[Q_51],
														[Q_52],
														[Q_53],
														[Q_54],
														[Q_55],
														[Q_56],
														[Q_57],
														[Q_58],
														[Q_59],
														[Q_60],
														[Q_61],
														[Q_62],
														[Q_63],
														[Q_64],
														[Q_65],
														[Q_66],
														[Q_67],
														[Q_68],
														[Q_69],
														[Q_70],
														[Q_71],
														[Q_72],
														[Q_73],
														[Q_74],
														[Q_75],
														[Q_76],
														[Q_77],
														[Q_78],
														[Q_79],
														[Q_80],
														[Q_81],
														[Q_82],
														[Q_83],
														[Q_84],
														[Q_85],
														[Q_86],
														[Q_87],
														[Q_88],
														[Q_89],
														[Q_90],
														[Q_91],
														[Q_92],
														[Q_93],
														[Q_94],
														[Q_95],
														[Q_96],
														[Q_97],
														[Q_98],
														[Q_99],
														[T_01],
														[T_01_Category],
														[T_01_Questionable],
														[T_02],
														[T_02_Category],
														[T_02_Questionable],
														[T_03],
														[T_03_Category],
														[T_03_Questionable],
														[T_04],
														[T_04_Category],
														[T_04_Questionable],
														[T_05],
														[T_05_Category],
														[T_05_Questionable],
														[T_06],
														[T_06_Category],
														[T_06_Questionable],
														[T_07],
														[T_07_Category],
														[T_07_Questionable],
														[T_08],
														[T_08_Category],
														[T_08_Questionable],
														[T_09],
														[T_09_Category],
														[T_09_Questionable],
														[T_10],
														[T_10_Category],
														[T_10_Questionable],
														[T_01_Image],
														[T_02_Image],
														[T_03_Image],
														[T_04_Image],
														[T_05_Image],
														[T_06_Image],
														[T_07_Image],
														[T_08_Image],
														[T_09_Image],
														[T_10_Image],
														[M_01a],
														[M_01b],
														[M_01c],
														[M_01d],
														[M_01e],
														[M_01f],
														[M_02a],
														[M_02b],
														[M_02c],
														[M_02d],
														[M_02e],
														[M_02f],
														[M_03a],
														[M_03b],
														[M_03c],
														[M_03d],
														[M_03e],
														[M_03f],
														[M_04a],
														[M_04b],
														[M_04c],
														[M_04d],
														[M_04e],
														[M_04f],
														[M_05a],
														[M_05b],
														[M_05c],
														[M_05d],
														[M_05e],
														[M_05f],
														[C_01],
														[C_02],
														[C_03],
														[C_04],
														[C_05],
														[C_06],
														[Survey_Image],
														[Date_Data_Entered],
														[Data_Enter_Status],
														[Response_Coded_Date],
														[Response_Coded_Status],
														[Date_Sent_To_Seer],
														[Seer_Status],
														[Total_Questions_Answered],
														[Date_Recd],
														[Batch_Number],
														[JOB_ORD],
														[ASSOC_EMP],
														[MailDate01],
														[MailChan01],
														[MailDate02],
														[MailChan02],
														[MailDate03],
														[MailChan03],
														[MailDate04],
														[MailChan04],
														[MailDate05],
														[MailChan05],
														[MailDate06],
														[MailChan06],
														[FileName],
														[CreateDatetime]
	)
	SELECT	A.[Date_Recd_C],
			COALESCE(B.[member_key], C.[member_key]),
			A.[SEERKEY],
			A.[CFID],
			A.[MFID],
			A.[ASSOCIATION_NAME],
			A.[OFF_ASSOC_NUM],
			A.[BRANCH_NAME],
			A.[OFF_BR_NUM],
			A.[LOC_BR_NUM],
			A.[BR_ADDR_1],
			A.[BR_ADDR_2],
			A.[BR_CITY],
			A.[BR_STATE],
			A.[BR_ZIP],
			A.[CUTOFFDAYS],
			A.[CALL_NAME],
			A.[CALLBR],
			A.[CALL_PHONE],
			A.[HR_SIGN],
			A.[HR_TITLE],
			A.[FORM_CODE],
			A.[LANGUAGE],
			A.[Y_EMP_ID],
			A.[MAIL_IND],
			A.[FIRST_NAME],
			A.[MID_NAME],
			A.[LAST_NAME],
			A.[SUFFIX],
			A.[ADDRESS1],
			A.[ADDRESS2],
			A.[CITY],
			A.[STATE],
			A.[ZIP],
			A.[PHONE],
			A.[HH_ID],
			A.[EMAIL],
			A.[CQ_1],
			A.[CQ_2],
			A.[CQ_3],
			A.[CQ_4],
			A.[CQ_5],
			A.[CQ_6],
			A.[SEQ_NUM],
			A.[PURL],
			A.[Response_Load_Date],
			A.[Response_Language],
			A.[Response_Channel],
			A.[Q_01],
			A.[Q_02],
			A.[Q_03],
			A.[Q_04],
			A.[Q_05],
			A.[Q_06],
			A.[Q_07],
			A.[Q_08],
			A.[Q_09],
			A.[Q_10],
			A.[Q_11],
			A.[Q_12],
			A.[Q_13],
			A.[Q_14],
			A.[Q_15],
			A.[Q_16],
			A.[Q_17],
			A.[Q_18],
			A.[Q_19],
			A.[Q_20],
			A.[Q_21],
			A.[Q_22],
			A.[Q_23],
			A.[Q_24],
			A.[Q_25],
			A.[Q_26],
			A.[Q_27],
			A.[Q_28],
			A.[Q_29],
			A.[Q_30],
			A.[Q_31],
			A.[Q_32],
			A.[Q_33],
			A.[Q_34],
			A.[Q_35],
			A.[Q_36],
			A.[Q_37],
			A.[Q_38],
			A.[Q_39],
			A.[Q_40],
			A.[Q_41],
			A.[Q_42],
			A.[Q_43],
			A.[Q_44],
			A.[Q_45],
			A.[Q_46],
			A.[Q_47],
			A.[Q_48],
			A.[Q_49],
			A.[Q_50],
			A.[Q_51],
			A.[Q_52],
			A.[Q_53],
			A.[Q_54],
			A.[Q_55],
			A.[Q_56],
			A.[Q_57],
			A.[Q_58],
			A.[Q_59],
			A.[Q_60],
			A.[Q_61],
			A.[Q_62],
			A.[Q_63],
			A.[Q_64],
			A.[Q_65],
			A.[Q_66],
			A.[Q_67],
			A.[Q_68],
			A.[Q_69],
			A.[Q_70],
			A.[Q_71],
			A.[Q_72],
			A.[Q_73],
			A.[Q_74],
			A.[Q_75],
			A.[Q_76],
			A.[Q_77],
			A.[Q_78],
			A.[Q_79],
			A.[Q_80],
			A.[Q_81],
			A.[Q_82],
			A.[Q_83],
			A.[Q_84],
			A.[Q_85],
			A.[Q_86],
			A.[Q_87],
			A.[Q_88],
			A.[Q_89],
			A.[Q_90],
			A.[Q_91],
			A.[Q_92],
			A.[Q_93],
			A.[Q_94],
			A.[Q_95],
			A.[Q_96],
			A.[Q_97],
			A.[Q_98],
			A.[Q_99],
			A.[T_01],
			A.[T_01_Category],
			A.[T_01_Questionable],
			A.[T_02],
			A.[T_02_Category],
			A.[T_02_Questionable],
			A.[T_03],
			A.[T_03_Category],
			A.[T_03_Questionable],
			A.[T_04],
			A.[T_04_Category],
			A.[T_04_Questionable],
			A.[T_05],
			A.[T_05_Category],
			A.[T_05_Questionable],
			A.[T_06],
			A.[T_06_Category],
			A.[T_06_Questionable],
			A.[T_07],
			A.[T_07_Category],
			A.[T_07_Questionable],
			A.[T_08],
			A.[T_08_Category],
			A.[T_08_Questionable],
			A.[T_09],
			A.[T_09_Category],
			A.[T_09_Questionable],
			A.[T_10],
			A.[T_10_Category],
			A.[T_10_Questionable],
			A.[T_01_Image],
			A.[T_02_Image],
			A.[T_03_Image],
			A.[T_04_Image],
			A.[T_05_Image],
			A.[T_06_Image],
			A.[T_07_Image],
			A.[T_08_Image],
			A.[T_09_Image],
			A.[T_10_Image],
			A.[M_01a],
			A.[M_01b],
			A.[M_01c],
			A.[M_01d],
			A.[M_01e],
			A.[M_01f],
			A.[M_02a],
			A.[M_02b],
			A.[M_02c],
			A.[M_02d],
			A.[M_02e],
			A.[M_02f],
			A.[M_03a],
			A.[M_03b],
			A.[M_03c],
			A.[M_03d],
			A.[M_03e],
			A.[M_03f],
			A.[M_04a],
			A.[M_04b],
			A.[M_04c],
			A.[M_04d],
			A.[M_04e],
			A.[M_04f],
			A.[M_05a],
			A.[M_05b],
			A.[M_05c],
			A.[M_05d],
			A.[M_05e],
			A.[M_05f],
			A.[C_01],
			A.[C_02],
			A.[C_03],
			A.[C_04],
			A.[C_05],
			A.[C_06],
			A.[Survey_Image],
			A.[Date_Data_Entered],
			A.[Data_Enter_Status],
			A.[Response_Coded_Date],
			A.[Response_Coded_Status],
			A.[Date_Sent_To_Seer],
			A.[Seer_Status],
			A.[Batch_Number],
			A.[Total_Questions_Answered],
			A.[Date_Recd],
			A.[JOB_ORD],
			A.[ASSOC_EMP],
			A.[MailDate01],
			A.[MailChan01],
			A.[MailDate02],
			A.[MailChan02],
			A.[MailDate03],
			A.[MailChan03],
			A.[MailDate04],
			A.[MailChan04],
			A.[MailDate05],
			A.[MailChan05],
			A.[MailDate06],
			A.[MailChan06],
			A.[FileName],
			A.[CreateDatetime]
			
	FROM	Seer_STG.dbo.[Member Response Data] A
			LEFT JOIN Seer_MDM.dbo.Member_Map B
				ON A.SeerKey = B.seer_key
			LEFT JOIN Seer_MDM.dbo.Member C
				ON A.Member_Key = C.member_key

	WHERE	LEN(A.Form_Code) = 0
			OR COALESCE(B.member_key, C.member_key) IS NULL
			OR COALESCE(A.[Q_01], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_02], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_03], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_04], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_05], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_06], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_07], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_08], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_09], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_10], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_11], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_12], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_13], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_14], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_15], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_16], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_17], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_18], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_19], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_20], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_21], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_22], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_23], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_24], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_25], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_26], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_27], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_28], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_29], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_30], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_31], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_32], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_33], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_34], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_35], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_36], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_37], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_38], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_39], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_40], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_41], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_42], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_43], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_44], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_45], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_46], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_47], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_48], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_49], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_50], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_51], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_52], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_53], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_54], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_55], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_56], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_57], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_58], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_59], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_60], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_61], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_62], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_63], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_64], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_65], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_66], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_67], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_68], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_69], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_70], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_71], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_72], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_73], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_74], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_75], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_76], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_77], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_78], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_79], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_80], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_81], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_82], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_83], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_84], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_85], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_86], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_87], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_88], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_89], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_90], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_91], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_92], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_93], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_94], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_95], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_96], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_97], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_98], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR COALESCE(A.[Q_99], '') NOT IN ('', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10')
			OR (LEN(A.Date_Recd) > 0 AND ISDATE(A.Date_Recd) = 0)
			OR (LEN(A.Date_Data_Entered) > 0 AND ISDATE(A.Date_Data_Entered) = 0)
			OR (LEN(A.Response_Coded_Date) > 0 AND ISDATE(A.Response_Coded_Date) = 0)
			OR (LEN(A.Date_Sent_To_Seer) > 0 AND ISDATE(A.Date_Sent_To_Seer) = 0)
			OR (LEN(A.Total_Questions_Answered) > 0 AND ISNUMERIC(A.Total_Questions_Answered) = 0)

	;
END