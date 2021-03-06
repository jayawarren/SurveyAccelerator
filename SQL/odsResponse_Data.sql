CREATE TABLE [dbo].[Response_Data](
	[response_data_key] bigint identity (1, 1) NOT NULL PRIMARY KEY,
	[create_datetime] [datetime] default getdate(),
	[current_indicator] [bit] default 1,
	[module] [varchar](50) not null default '',
	[date_received] datetime not null default '',
	[member_key] bigint not null default 0,
	[seer_key] bigint not null default 0,
	[cfid] bigint not null default 0,
	[mfid] bigint not null default 0,
	[batch_number] [varchar](50) not null default '',
	[job_order_number] [varchar](50) not null default '',
	[association_name] [varchar](75) not null default '',
	[official_association_number] [varchar](10) not null default '',
	[branch_name] [varchar](75) not null default '',
	[official_branch_number] [varchar](10) not null default '',
	[local_branch_number] [varchar](10) not null default '',
	[branch_address_1] [varchar](50) not null default '',
	[branch_address_2] [varchar](50) not null default '',
	[branch_city] [varchar](50) not null default '',
	[branch_state] [varchar](50) not null default '',
	[branch_zip] [varchar](50) not null default '',
	[association_approximate_employees] int not null default 0,
	[cut_off_days] int not null default 0,
	[call_name] [varchar](75) not null default '',
	[call_branch] [varchar](50) not null default '',
	[call_phone] [varchar](50) not null default '',
	[human_resources_sign] [varchar](75) not null default '',
	[human_resources_title] [varchar](75) not null default '',
	[form_code] [varchar](25) not null default '',
	[language] [varchar](50) not null default '',
	[y_employee_id] [varchar](50) not null default '',
	[mail_indicator] [varchar](1) not null default '',
	[first_name] [varchar](75) not null default '',
	[middle_name] [varchar](75) not null default '',
	[last_name] [varchar](75) not null default '',
	[suffix] [varchar](10) not null default '',
	[address_1] [varchar](50) not null default '',
	[address_2] [varchar](50) not null default '',
	[city] [varchar](50) not null default '',
	[state] [varchar](50) not null default '',
	[zip] [varchar](50) not null default '',
	[phone] [varchar](50) not null default '',
	[household_id] [varchar](50) not null default '',
	[email] [varchar](50) not null default '',
	[cq_1] [varchar](50) not null default '',
	[cq_2] [varchar](50) not null default '',
	[cq_3] [varchar](50) not null default '',
	[cq_4] [varchar](50) not null default '',
	[cq_5] [varchar](50) not null default '',
	[cq_6] [varchar](50) not null default '',
	[sequence_number] [varchar](10) not null default '',
	[purl] [varchar](50) not null default '',
	[mail_date_01_c] [varchar](50) not null default '',
	[mail_channel_01] [varchar](50) not null default '',
	[mail_date_02_c] [varchar](50) not null default '',
	[mail_channel_02] [varchar](50) not null default '',
	[mail_date_03_c] [varchar](50) not null default '',
	[mail_channel_03] [varchar](50) not null default '',
	[mail_date_04_c] [varchar](50) not null default '',
	[mail_channel_04] [varchar](50) not null default '',
	[mail_date_05_c] [varchar](50) not null default '',
	[mail_channel_05] [varchar](50) not null default '',
	[mail_date_06_c] [varchar](50) not null default '',
	[mail_channel_06] [varchar](50) not null default '',
	[response_load_date] [varchar](25) not null default '',
	[response_language] [varchar](50) not null default '',
	[response_channel] [varchar](50) not null default '',
	[q_01] tinyint not null default 0,
	[q_02] tinyint not null default 0,
	[q_03] tinyint not null default 0,
	[q_04] tinyint not null default 0,
	[q_05] tinyint not null default 0,
	[q_06] tinyint not null default 0,
	[q_07] tinyint not null default 0,
	[q_08] tinyint not null default 0,
	[q_09] tinyint not null default 0,
	[q_10] tinyint not null default 0,
	[q_11] tinyint not null default 0,
	[q_12] tinyint not null default 0,
	[q_13] tinyint not null default 0,
	[q_14] tinyint not null default 0,
	[q_15] tinyint not null default 0,
	[q_16] tinyint not null default 0,
	[q_17] tinyint not null default 0,
	[q_18] tinyint not null default 0,
	[q_19] tinyint not null default 0,
	[q_20] tinyint not null default 0,
	[q_21] tinyint not null default 0,
	[q_22] tinyint not null default 0,
	[q_23] tinyint not null default 0,
	[q_24] tinyint not null default 0,
	[q_25] tinyint not null default 0,
	[q_26] tinyint not null default 0,
	[q_27] tinyint not null default 0,
	[q_28] tinyint not null default 0,
	[q_29] tinyint not null default 0,
	[q_30] tinyint not null default 0,
	[q_31] tinyint not null default 0,
	[q_32] tinyint not null default 0,
	[q_33] tinyint not null default 0,
	[q_34] tinyint not null default 0,
	[q_35] tinyint not null default 0,
	[q_36] tinyint not null default 0,
	[q_37] tinyint not null default 0,
	[q_38] tinyint not null default 0,
	[q_39] tinyint not null default 0,
	[q_40] tinyint not null default 0,
	[q_41] tinyint not null default 0,
	[q_42] tinyint not null default 0,
	[q_43] tinyint not null default 0,
	[q_44] tinyint not null default 0,
	[q_45] tinyint not null default 0,
	[q_46] tinyint not null default 0,
	[q_47] tinyint not null default 0,
	[q_48] tinyint not null default 0,
	[q_49] tinyint not null default 0,
	[q_50] tinyint not null default 0,
	[q_51] tinyint not null default 0,
	[q_52] tinyint not null default 0,
	[q_53] tinyint not null default 0,
	[q_54] tinyint not null default 0,
	[q_55] tinyint not null default 0,
	[q_56] tinyint not null default 0,
	[q_57] tinyint not null default 0,
	[q_58] tinyint not null default 0,
	[q_59] tinyint not null default 0,
	[q_60] tinyint not null default 0,
	[q_61] tinyint not null default 0,
	[q_62] tinyint not null default 0,
	[q_63] tinyint not null default 0,
	[q_64] tinyint not null default 0,
	[q_65] tinyint not null default 0,
	[q_66] tinyint not null default 0,
	[q_67] tinyint not null default 0,
	[q_68] tinyint not null default 0,
	[q_69] tinyint not null default 0,
	[q_70] tinyint not null default 0,
	[q_71] tinyint not null default 0,
	[q_72] tinyint not null default 0,
	[q_73] tinyint not null default 0,
	[q_74] tinyint not null default 0,
	[q_75] tinyint not null default 0,
	[t_01] [varchar](1000) not null default '',
	[t_01_category] [varchar](1000) not null default '',
	[t_01_Questionable] [varchar](1000) not null default '',
	[t_02] [varchar](1000) not null default '',
	[t_02_category] [varchar](1000) not null default '',
	[t_02_Questionable] [varchar](1000) not null default '',
	[t_03] [varchar](1000) not null default '',
	[t_03_category] [varchar](1000) not null default '',
	[t_03_Questionable] [varchar](1000) not null default '',
	[t_04] [varchar](1000) not null default '',
	[t_04_category] [varchar](1000) not null default '',
	[t_04_Questionable] [varchar](1000) not null default '',
	[t_05] [varchar](1000) not null default '',
	[t_05_category] [varchar](1000) not null default '',
	[t_05_Questionable] [varchar](1000) not null default '',
	[t_06] [varchar](1000) not null default '',
	[t_06_category] [varchar](1000) not null default '',
	[t_06_Questionable] [varchar](1000) not null default '',
	[t_07] [varchar](1000) not null default '',
	[t_07_category] [varchar](1000) not null default '',
	[t_07_Questionable] [varchar](1000) not null default '',
	[t_08] [varchar](1000) not null default '',
	[t_08_category] [varchar](1000) not null default '',
	[t_08_Questionable] [varchar](1000) not null default '',
	[t_09] [varchar](1000) not null default '',
	[t_09_category] [varchar](1000) not null default '',
	[t_09_Questionable] [varchar](1000) not null default '',
	[t_10] [varchar](1000) not null default '',
	[t_10_category] [varchar](1000) not null default '',
	[t_10_Questionable] [varchar](1000) not null default '',
	[t_01_Image] [varchar](50) not null default '',
	[t_02_Image] [varchar](50) not null default '',
	[t_03_Image] [varchar](50) not null default '',
	[t_04_Image] [varchar](50) not null default '',
	[t_05_Image] [varchar](50) not null default '',
	[t_06_Image] [varchar](50) not null default '',
	[t_07_Image] [varchar](50) not null default '',
	[t_08_Image] [varchar](50) not null default '',
	[t_09_Image] [varchar](50) not null default '',
	[t_10_Image] [varchar](50) not null default '',
	[m_01a] [varchar](50) not null default '',
	[m_01b] [varchar](50) not null default '',
	[m_01c] [varchar](50) not null default '',
	[m_01d] [varchar](50) not null default '',
	[m_01e] [varchar](50) not null default '',
	[m_01f] [varchar](50) not null default '',
	[m_02a] [varchar](50) not null default '',
	[m_02b] [varchar](50) not null default '',
	[m_02c] [varchar](50) not null default '',
	[m_02d] [varchar](50) not null default '',
	[m_02e] [varchar](50) not null default '',
	[m_02f] [varchar](50) not null default '',
	[m_03a] [varchar](50) not null default '',
	[m_03b] [varchar](50) not null default '',
	[m_03c] [varchar](50) not null default '',
	[m_03d] [varchar](50) not null default '',
	[m_03e] [varchar](50) not null default '',
	[m_03f] [varchar](50) not null default '',
	[m_04a] [varchar](50) not null default '',
	[m_04b] [varchar](50) not null default '',
	[m_04c] [varchar](50) not null default '',
	[m_04d] [varchar](50) not null default '',
	[m_04e] [varchar](50) not null default '',
	[m_04f] [varchar](50) not null default '',
	[m_05a] [varchar](50) not null default '',
	[m_05b] [varchar](50) not null default '',
	[m_05c] [varchar](50) not null default '',
	[m_05d] [varchar](50) not null default '',
	[m_05e] [varchar](50) not null default '',
	[m_05f] [varchar](50) not null default '',
	[c_01] [varchar](50) not null default '',
	[c_02] [varchar](50) not null default '',
	[c_03] [varchar](50) not null default '',
	[c_04] [varchar](50) not null default '',
	[c_05] [varchar](50) not null default '',
	[c_06] [varchar](50) not null default '',
	[survey_image] [varchar](50) not null default '',
	[date_data_entered] datetime not null default getdate(),
	[data_enter_status] [varchar](50) not null default '',
	[response_coded_date] datetime not null default getdate(),
	[response_coded_status] [varchar](50) not null default '',
	[date_sent_to_seer] datetime not null default getdate(),
	[seer_status] [varchar](50) not null default '',
	[total_questions_answered] smallint default 0,
	[file_name] [varchar](75) not null default '',
	[right_file_name] [varchar](75) not null default ''
) ON [TRXGROUP]

GO

