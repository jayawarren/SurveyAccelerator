DROP INDEX [Member Response Data].MRD_INDEX_01
go
DROP INDEX [Member Response Data].MRD_INDEX_02
go
DROP INDEX [Member].MBR_INDEX_01
go
DROP INDEX [Member].MBR_INDEX_02
go
DROP INDEX [Member].MBR_INDEX_03
go
DROP INDEX [Member_MAP].MMP_INDEX_01
go
DROP INDEX [Member_MAP].MMP_INDEX_02
go
DROP INDEX [Member_MAP].MMP_INDEX_03
go
DROP INDEX [Survey_Question].SVQ_INDEX_01
go
DROP INDEX [Survey_Response].SVR_INDEX_01
go
DROP INDEX [Survey_Response].SVR_INDEX_02
go
DROP INDEX [Survey_Segment].SSG_INDEX_01
go
DROP INDEX [Question].QST_INDEX_01
go
DROP INDEX [Organization].ORG_INDEX_01
go
DROP INDEX [Organization].ORG_INDEX_02
go
DROP INDEX [Survey_Segment].SSG_INDEX_01
go
DROP INDEX [Batch].BCH_INDEX_01
go
DROP INDEX [Batch_Map].BMP_INDEX_01
go
DROP INDEX [Program_Group].PGP_INDEX_01
go
DROP INDEX [Member_Program_Group_Map].MPGM_INDEX_01
go
DROP INDEX [Member_Program_Group_Map].MPGM_INDEX_02
go
DROP INDEX [Member_Program_Group_Map].MPGM_INDEX_03
go
CREATE INDEX MRD_INDEX_01 ON dbo.[Member Response Data](Member_Key, Q_27, Q_28) ON NDXGROUP
go
CREATE INDEX MRD_INDEX_02 ON dbo.[Member Response Data](SeerKey, Q_27, Q_28) ON NDXGROUP
go
CREATE INDEX MBR_INDEX_01 ON dbo.[Member](member_key, is_health_seeker, change_datetime, next_change_datetime, current_indicator) ON NDXGROUP
go
CREATE INDEX MBR_INDEX_02 ON dbo.[Member](member_key, member_cleansed_id) ON NDXGROUP
go
CREATE INDEX MBR_INDEX_03 ON dbo.[Member](program_site_location) ON NDXGROUP
go
CREATE INDEX MMP_INDEX_01 ON dbo.[Member_Map](seer_key, member_key, current_indicator) ON NDXGROUP
go
CREATE INDEX MMP_INDEX_02 ON dbo.[Member_Map](member_key, organization_key, program_group_key) ON NDXGROUP
go
CREATE INDEX MMP_INDEX_03 ON dbo.[Member_Map](organization_key) ON NDXGROUP
go
CREATE INDEX BMP_INDEX_01 on dbo.[Batch_Map]([module], [aggregate_type], [organization_key], [survey_form_key], [batch_key], [date_given_key], [previous_year_date_given_key], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX SVQ_INDEX_01 ON dbo.[Survey_Question](question_key, survey_form_key, survey_question_key) ON NDXGROUP
go
CREATE INDEX SVR_INDEX_01 ON dbo.[Survey_Response](survey_question_key, response_code, response_text) ON NDXGROUP
go
CREATE INDEX SVR_INDEX_02 ON dbo.[Survey_Response](survey_question_key, survey_form_key, survey_response_key, exclude_from_report_calculation) ON NDXGROUP
go
CREATE INDEX QST_INDEX_01 ON dbo.[Question](question, question_key) ON NDXGROUP
go
CREATE INDEX ORG_INDEX_01 ON dbo.[Organization](association_number, official_branch_number, current_indicator, organization_key) ON NDXGROUP
go
CREATE INDEX ORG_INDEX_02 ON dbo.[Organization]([organization_key], [association_name], [association_number], [official_branch_number], [current_indicator]) ON NDXGROUP
go
CREATE INDEX SSG_INDEX_01 ON dbo.[Survey_Segment](member_key) ON NDXGROUP
go
CREATE INDEX BCH_INDEX_01 ON dbo.[Batch](batch_number, form_code, date_given_key) ON NDXGROUP
go
CREATE INDEX PGP_INDEX_01 ON dbo.[Program_Group](program_site_location, program_group_key) ON NDXGROUP
go
CREATE INDEX MPGM_INDEX_01 ON dbo.[Member_Program_Group_Map]([program_group_key], [member_key], [organization_key]) ON NDXGROUP
go
CREATE INDEX MPGM_INDEX_02 ON dbo.[Member_Program_Group_Map]([survey_form_key], [program_group_key], [member_key], [organization_key]) ON NDXGROUP
go
CREATE INDEX MPGM_INDEX_03 ON dbo.[Member_Program_Group_Map]([program_category], [program_group_key], [organization_key], [survey_form_key]) ON NDXGROUP
go

