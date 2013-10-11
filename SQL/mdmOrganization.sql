drop table Organization
go
CREATE TABLE [Organization](
	[organization_key] [int] NOT NULL IDENTITY(1, 1) PRIMARY KEY,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[organization_name] [varchar](100) DEFAULT '',
	[organization_number] [varchar](10) DEFAULT '',
	[association_name] [varchar](100) DEFAULT '',
	[association_number] [varchar](10) DEFAULT '',
	[official_branch_name] [varchar](100) DEFAULT '',
	[short_branch_name] [varchar](50) DEFAULT '',
	[official_branch_number] [varchar](10) DEFAULT '',
	[local_branch_number] [varchar](10) DEFAULT '',
	[branch_address_1] [varchar](100) DEFAULT '',
	[branch_address_2] [varchar](100) DEFAULT '',
	[branch_city] [varchar](100) DEFAULT '',
	[branch_state] [varchar](25) DEFAULT '',
	[branch_postal] [varchar](20) DEFAULT '',
	[branch_country] [varchar](25) DEFAULT '',
	[branch_address_line_quality] [varchar](20) DEFAULT '',
	[branch_address_csz_quality] [varchar](20) DEFAULT '',
	[signature_name] [varchar](100) DEFAULT '',
	[signature_title] [varchar](75) DEFAULT '',
	[call_name] [varchar](100) DEFAULT '',
	[call_branch_association] [varchar](50) DEFAULT '',
	[call_phone] [varchar](50) DEFAULT '',
	[member_count] [int] DEFAULT 0,
	[unit_count] [int] DEFAULT 0,
	[phone_number] [varchar](20) DEFAULT '',
	[msa_on_file] [varchar](5) DEFAULT '',
	[source_id] [varchar](50) DEFAULT '',
	[sub_source_id] [varchar](50) DEFAULT '',
	[peer_group] [varchar](50) DEFAULT '',
	[active_flag] [varchar](5) DEFAULT '',
	[custom_question_1] [varchar](255) DEFAULT '',
	[custom_question_2] [varchar](255) DEFAULT '',
	[custom_question_3] [varchar](255) DEFAULT ''
) ON DIMGROUP


