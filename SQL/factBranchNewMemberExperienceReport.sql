USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[FactBranchNewMemberExperienceReport]    Script Date: 07/31/2013 11:39:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[factBranchNewMemberExperienceReport](
	[BranchNewMemberExperiendReportKey] [int] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	[BranchKey] [int] DEFAULT 0,
	[OrganizationSurveyKey] [int] DEFAULT 0,
	[QuestionResponseKey] [int] DEFAULT 0,
	[SurveyQuestionKey] [int] DEFAULT 0,
	[batch_key] [int] DEFAULT 0,
	[GivenDateKey] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[Segment] [varchar](50) DEFAULT '',
	[BranchCount] [int] DEFAULT 0,
	[BranchPercentage] [decimal](15, 5) DEFAULT 0,
	[AssociationPercentage] [decimal](15, 5) DEFAULT 0,
	[NationalPercentage] [decimal](15, 5) DEFAULT 0,
	[PeerGroupPercentage] [decimal](15, 5) DEFAULT 0,
	[PreviousBranchPercentage] [decimal](15, 5) DEFAULT 0,
	[SegmentHealthSeekerYes] [decimal](15, 5) DEFAULT 0,
	[SegmentHealthSeekerNo] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse7Week] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse5Week] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse3Week] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse1Week] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse3Month] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUse1Month] [decimal](15, 5) DEFAULT 0,
	[SegmentFrequencyOfUseU1Month] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembershipU1] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembership1] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembership2] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembership3to5] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembership6to10] [decimal](15, 5) DEFAULT 0,
	[SegmentLengthOfMembershipO10] [decimal](15, 5) DEFAULT 0,
	[SegmentNPPromoter] [decimal](15, 5) DEFAULT 0,
	[SegmentNPDetractor] [decimal](15, 5) DEFAULT 0,
	[SegmentNPNeither] [decimal](15, 5) DEFAULT 0,
	[SegmentTimeOfDayEarlyAM] [decimal](15, 5) DEFAULT 0,
	[SegmentTimeOfDayMidAM] [decimal](15, 5) DEFAULT 0,
	[SegmentTimeOfDayLunch] [decimal](15, 5) DEFAULT 0,
	[SegmentTimeOfDayMidPM] [decimal](15, 5) DEFAULT 0,
	[SegmentTimeOfDayPM] [decimal](15, 5) DEFAULT 0,
	[SegmentActivitiesGroup] [decimal](15, 5) DEFAULT 0,
	[SegmentActivitiesIndividual] [decimal](15, 5) DEFAULT 0,
	[SegmentActivitiesBoth] [decimal](15, 5) DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


