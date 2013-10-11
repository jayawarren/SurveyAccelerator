DROP INDEX [Close_Ends].CED_INDEX_01
go
DROP INDEX [Open_Ends].OED_INDEX_01
go
DROP INDEX [Top_Box].TBX_INDEX_01
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_01
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_02
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_03
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_04
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_05
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_06
go
DROP INDEX [factMemberSurveyResponse].MSR_INDEX_07
go
DROP INDEX [factBranchSurveyResponse].BSR_INDEX_01
go
DROP INDEX [factBranchSurveyResponse].BSR_INDEX_02
go
DROP INDEX [factBranchSurveyResponse].BSR_INDEX_03
go
DROP INDEX [factAssociationSurveyResponse].ASR_INDEX_01
go
DROP INDEX [factAssociationSurveyResponse].ASR_INDEX_02
go
DROP INDEX [factAssociationSurveyResponse].ASR_INDEX_03
go
DROP INDEX [factAssociationSurveyResponse].ASR_INDEX_04
go
DROP INDEX [factOrganizationSurveyResponse].OSR_INDEX_01
go
DROP INDEX [factOrganizationSurveyResponse].OSR_INDEX_02
go
DROP INDEX [factPeerGroupSurveyResponse].PSR_INDEX_01
go
DROP INDEX [factPeerGroupSurveyResponse].PSR_INDEX_02
go
DROP INDEX [factBranchNewMemberExperienceReport].BNMER_INDEX_01
go
DROP INDEX [factBranchMemberSatisfactionReport].BMSR_INDEX_01
go
DROP INDEX [factBranchMemberSatisfactionReport].BMSR_INDEX_02
go
DROP INDEX [factBranchMemberSatisfactionReport].BMSR_INDEX_03
go
DROP INDEX [factBranchStaffExperienceReport].BSER_INDEX_01
go
DROP INDEX [factBranchStaffExperienceReport].BSER_INDEX_02
go
DROP INDEX [factProgramSiteLocationSurveyResponse].PSLSR_INDEX_01
go
DROP INDEX [factProgramSiteLocationSurveyResponse].PSLSR_INDEX_02
go
DROP INDEX [factProgramGroupSurveyResponse].PGSR_INDEX_01
go
DROP INDEX [Observation_Data].OSV_INDEX_01
GO
DROP INDEX [Observation_Data].OSV_INDEX_02
GO
DROP INDEX [Observation_Data].OSV_INDEX_03
GO
DROP INDEX [dd].[factProgramDashboardBase].FPDB_INDEX_01
GO
DROP INDEX [dbo].[factProgramGroupProgramReport].PGPR_INDEX_01
GO
DROP INDEX [dbo].[factAssociationProgramReport].APR_INDEX_01
GO
CREATE INDEX CED_INDEX_01 ON Seer_ODS.dbo.[Close_Ends]([batch_number], [form_code], [official_association_number], [official_branch_number], [question], [response], [member_key], [module], [current_indicator]) ON NDXGROUP
go
CREATE INDEX TBX_INDEX_01 ON Seer_ODS.dbo.[Top_Box](official_association_number, official_branch_number, aggregate_type, form_code, module, current_indicator) ON NDXGROUP
go
CREATE INDEX OED_INDEX_01 ON Seer_ODS.dbo.[Open_Ends]([batch_number], [form_code], [official_association_number], [official_branch_number], [open_question], [closed_response], [member_key], [module], [current_indicator]) ON NDXGROUP
go
CREATE INDEX MSR_INDEX_01 ON [dbo].[factMemberSurveyResponse] ([BranchKey],[OrganizationSurveyKey],[SurveyQuestionKey], [GivenDateKey], [QuestionResponseKey],[ResponseCount]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_02 ON [dbo].[factMemberSurveyResponse] ([current_indicator],[ProgramSiteLocationKey], [MemberKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_03 ON [dbo].[factMemberSurveyResponse] ([OrganizationSurveyKey], [MemberKey], [BranchKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_04 ON [dbo].[factMemberSurveyResponse] ([current_indicator], [MemberKey], [BranchKey], [OrganizationSurveyKey], [GivenDateKey]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_05 ON [dbo].[factMemberSurveyResponse] ([ProgramSiteLocationKey], [MemberKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_06 ON [dbo].[factMemberSurveyResponse] ([OpenEndResponseKey], [BranchKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey], [ResponseCount], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX MSR_INDEX_07 ON [dbo].[factMemberSurveyResponse] ([OpenEndResponseKey], [ProgramSiteLocationKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey], [ResponseCount], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX BSR_INDEX_01 ON [dbo].[factBranchSurveyResponse] ([BranchKey],[OrganizationSurveyKey],[SurveyQuestionKey], [GivenDateKey], [QuestionResponseKey], [current_indicator], [ResponseCount]) ON NDXGROUP
GO
CREATE INDEX BSR_INDEX_02 ON [dbo].[factBranchSurveyResponse] ([BranchResponseKey]) ON NDXGROUP
GO
CREATE INDEX BSR_INDEX_03 ON [dbo].[factBranchSurveyResponse] ([OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [BranchKey], [GivenDateKey], [ResponseCount]) ON NDXGROUP
GO
CREATE INDEX ASR_INDEX_01 ON [dbo].[factAssociationSurveyResponse] ([AssociationKey],[SurveyFormKey],[SurveyQuestionKey], [GivenDateKey], [QuestionResponseKey],[ResponseCount], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX ASR_INDEX_02 ON [dbo].[factAssociationSurveyResponse] ([AssociationKey],[SurveyFormKey],[SurveyQuestionKey],[QuestionResponseKey],[GivenDateKey],[ResponsePercentage]) ON NDXGROUP
GO
CREATE INDEX ASR_INDEX_03 ON [dbo].[factAssociationSurveyResponse] ([current_indicator], [AssociationKey], [SurveyFormKey], [SurveyQuestionKey], [QuestionResponseKey], [GivenDateKey], [ResponseCount], [ResponsePercentage]) ON NDXGROUP
GO
CREATE INDEX ASR_INDEX_04 ON [dbo].[factAssociationSurveyResponse] ([SurveyQuestionKey], [AssociationKey], [SurveyFormKey], [QuestionResponseKey], [GivenDateKey], [ResponsePercentage]) ON NDXGROUP
GO
CREATE INDEX OSR_INDEX_01 ON [dbo].[factOrganizationSurveyResponse] ([SurveyFormKey], [QuestionKey], [ResponseKey], [OrganizationResponseKey], [OrganizationKey], [current_indicator], [Year], [SurveyType]) ON NDXGROUP;
GO
CREATE INDEX OSR_INDEX_02 ON [dbo].[factOrganizationSurveyResponse] ([ResponseKey], [QuestionKey], [OrganizationKey], [SurveyType], [ResponsePercentage]) ON NDXGROUP;
GO
CREATE INDEX PSR_INDEX_01 ON [dbo].[factPeerGroupSurveyResponse] ([SurveyFormKey], [QuestionKey], [ResponseKey], [PeerGroupResponseKey], [OrganizationKey], [Year], [SurveyType]) ON NDXGROUP;
GO
CREATE INDEX PSR_INDEX_02 ON [dbo].[factPeerGroupSurveyResponse] ([SurveyFormKey],[QuestionKey],[ResponseKey],[OrganizationKey],[PeerGroup],[Year], [ResponsePercentage]) ON NDXGROUP;
GO
CREATE INDEX BNMER_INDEX_01 ON [dbo].[factBranchNewMemberExperienceReport]([GivenDateKey], [BranchKey], [OrganizationSurveyKey]) ON NDXGROUP
GO
CREATE INDEX BMSR_INDEX_01 ON [dbo].[factBranchMemberSatisfactionReport]([BranchKey], [GivenDateKey]) ON NDXGROUP
GO
CREATE INDEX BMSR_INDEX_02 ON [dbo].[factBranchMemberSatisfactionReport]([SurveyQuestionKey], [BranchKey], [GivenDateKey], [QuestionResponseKey], [BranchPercentage], [PreviousBranchPercentage]) ON NDXGROUP
GO
CREATE INDEX BMSR_INDEX_03 ON [dbo].[factBranchMemberSatisfactionReport]([Segment], [BranchKey], [QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [BranchPercentage], [AssociationPercentage], [NationalPercentage], [PreviousBranchPercentage]) ON NDXGROUP
GO
CREATE INDEX BSER_INDEX_01 ON [dbo].[factBranchStaffExperienceReport] ([GivenDateKey], [BranchKey], [QuestionResponseKey], [SurveyQuestionKey], [batch_key], [AssociationPercentage], [NationalPercentage], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX BSER_INDEX_02 ON [dbo].[factBranchStaffExperienceReport] ([SurveyQuestionKey], [BranchKey], [QuestionResponseKey], [batch_key], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX PSLSR_INDEX_01 ON [dbo].[factProgramSiteLocationSurveyResponse] ([ProgramSiteLocationKey], [OrganizationSurveyKey], [AssociationKey], [QuestionResponseKey], [SurveyQuestionKey], [batch_key], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX PSLSR_INDEX_02 ON [dbo].[factProgramSiteLocationSurveyResponse] ([OrganizationSurveyKey], [ProgramSiteLocationKey], [AssociationKey], [QuestionResponseKey], [SurveyQuestionKey], [batch_key], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX PGSR_INDEX_01 ON [dbo].[factProgramGroupSurveyResponse] ([ProgramGroupKey], [AssociationKey], [OrganizationSurveyKey], [SurveyQuestionKey], [QuestionResponseKey], [batch_key], [GivenDateKey], [current_indicator]) ON NDXGROUP
GO
CREATE INDEX OSV_INDEX_01 ON [dbo].[Observation_Data] ([status], [channel], [form_code], [batch_number], [official_association_number], [official_branch_number]) ON NDXGROUP;
GO
CREATE INDEX OSV_INDEX_02 ON [dbo].[Observation_Data] ([status], [member_key], [form_code], [batch_number], [official_association_number]) ON NDXGROUP;
GO
CREATE INDEX OSV_INDEX_03 ON [dbo].[Observation_Data] ([form_code], [batch_number], [official_association_number], [member_key], [status]) ON NDXGROUP;
GO
CREATE INDEX FPDB_INDEX_01 ON [dd].[factProgramDashboardBase] ([SurveyFormKey], [AssociationKey], [current_indicator]) ON NDXGROUP;
GO
CREATE INDEX PGPR_INDEX_01 ON [dbo].[factProgramGroupProgramReport]([QuestionResponseKey], [SurveyQuestionKey], [GivenDateKey], [ProgramGroupKey], [ProgramGroupCount], [ProgramGroupPercentage], [PreviousProgramGroupPercentage]) ON NDXGROUP;
GO
CREATE INDEX APR_INDEX_01 ON [dbo].[factAssociationProgramReport]([QuestionResponseKey], [SurveyQuestionKey], [AssociationKey], [SurveyFormKey], [GivenDateKey], [AssociationPercentage], [NationalPercentage], [PreviousAssociationPercentage]) ON NDXGROUP;
GO