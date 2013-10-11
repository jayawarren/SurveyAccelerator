USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factAssociationStaffExperienceReport]    Script Date: 07/29/2013 23:35:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[factAssociationStaffExperienceReport](
	[AssociationStaffExperienceReportKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[AssociationKey] [int] NULL DEFAULT 0,
	[OrganizationSurveyKey] [int] NULL DEFAULT 0,
	[QuestionResponseKey] [int] NULL DEFAULT 0,
	[SurveyQuestionKey] [int] NULL DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] NULL DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[AssociationCount] [int] NULL DEFAULT 0,
	[AssociationPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[NationalPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[PeerGroupPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[PreviousAssociationPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRangeU21] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange21to34] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange35to44] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange45to54] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRangeO55] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfServiceU1] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfService1] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfService2] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfService3to5] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfService6to10] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeLengthOfServiceO10] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeTypeHourly] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeTypeSalary] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeWorkFullTime] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeWorkPartTime] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentGenderMale] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentGenderFemale] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentDepartmentAdmin] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentDepartmentWellness] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentDepartmentMembership] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentDepartmentYouthPrograms] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentDepartmentOther] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeNPPromoter] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeNPDetractor] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentEmployeeNPNeither] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMemberNPPromoter] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMemberNPDetractor] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMemberNPNeither] [decimal](15, 5) NULL
) ON [TRXGROUP]

GO


