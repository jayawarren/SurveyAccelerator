USE [Seer_ODS]
GO

/****** Object:  Table [dbo].[factAssociationMemberSatisfactionReport]    Script Date: 07/29/2013 06:45:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[factAssociationMemberSatisfactionReport](
	[AssociationMemberSatisfactionReportKey] [bigint] IDENTITY(1, 1) NOT NULL PRIMARY KEY,
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
	[Segment] [varchar](50) NULL DEFAULT 0,
	[AssociationCount] [int] NULL DEFAULT 0,
	[AssociationPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[NationalPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[PeerGroupPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[PreviousAssociationPercentage] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRangeU25] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange25to34] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange35to49] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRange50to64] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentAgeRangeO64] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse7Week] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse5Week] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse3Week] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse1Week] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse3Month] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUse1Month] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentFrequencyOfUseU1Month] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentGenderMale] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentGenderFemale] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentHealthSeekerYes] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentHealthSeekerNo] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentIntentToRenewDefinitely] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentIntentToRenewProbably] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentIntentToRenewMaybe] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentIntentToRenewProbablyNot] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentIntentToRenewDefinitelyNot] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembershipU1] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembership1] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembership2] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembership3to5] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembership6to10] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLengthOfMembershipO10] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLoyaltyVery] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLoyaltySomewhat] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLoyaltyNotVery] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentLoyaltyNot] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMembershipAdult] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMembershipFamily] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentMembershipSenior] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentNPPromoter] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentNPDetractor] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentNPNeither] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentChildrenYes] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentChildrenNo] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentTimeOfDayEarlyAM] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentTimeOfDayMidAM] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentTimeOfDayLunch] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentTimeOfDayMidPM] [decimal](15, 5) NULL DEFAULT 0,
	[SegmentTimeOfDayPM] [decimal](15, 5) NULL DEFAULT 0
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO


