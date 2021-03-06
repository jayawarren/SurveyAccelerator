/*
truncate table dd.factNewMemBranchSegment
drop proc spPopulate_factNewMemBranchSegment
SELECT * FROM dd.factNewMemBranchSegment
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemBranchSegment] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	bs.AssociationKey,
			bs.BranchKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.PreviousGivenDateKey,
			bs.current_indicator,
			bs.current_indicator CurrentSurveyIndicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName,
			bs.Branch,
			bs.Segment, 
			bs.Question, 
			bs.QuestionPosition,
			bs.QuestionLabel, 	
			bs.CategoryType,
			CASE WHEN bs.Category = 'Perceptions' THEN 'Support'
				ELSE bs.Category
			END Category, 
			bs.CategoryPosition, 
			bs.ResponseCode, 
			bs.ResponseText,
			bs.GivenSurveyDate,
			bs.SurveyYear, 	
			SUM(bs.BranchCount) AS BranchCount, 
			COALESCE(SUM(bs.BranchPercentage), 99999) AS BranchPercentage,
			COALESCE(SUM(bs.PreviousBranchPercentage), 99999) AS PreviousPercentage,
			SUM(bs.SegmentHealthSeekerYes) AS SegmentHealthSeekerYes,
			SUM(bs.SegmentHealthSeekerNo) AS SegmentHealthSeekerNo
			
	INTO	#NMBS

	FROM	(
			SELECT	distinct
					D.AssociationKey,
					D.BranchKey,
					DB.batch_key,
					DB.GivenDateKey,
					DB.PrevGivenDateKey PreviousGivenDateKey,
					DB.current_indicator, 
					LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
					MSR.Segment, 
					D.AssociationNumber, 
					D.AssociationName,
					D.AssociationNumber + ' - ' + D.AssociationName AS Association,
					D.OfficialBranchNumber, 
					D.OfficialBranchName,				
					dd.GetShortBranchName(D.OfficialBranchName) AS Branch, 
					DQ.Question, 
					'' AS QuestionLabel, 
					CASE WHEN DC.Category = 'Drivers Joining' THEN 'Reasons for Joining' 
						ELSE DC.Category
					END AS Category,         
					CASE WHEN DC.Category IN ('Health Seekers','Meeting Expectations', 'Net Promoter', 'Onboarding') THEN 'Key Indicators' 
						WHEN DC.Category IN ('Operational Excellence', 'Drivers Joining', 'Perceptions') THEN 'Performance Measures'
						ELSE DC.Category
					END AS CategoryType,
					DC.CategoryPosition, 
					QuestionPosition,
					MSR.SegmentHealthSeekerNo,
					MSR.SegmentHealthSeekerYes,
					DR.ResponseCode, 
					DR.ResponseText,
					REPLACE(B.report_date, '-', '') GivenSurveyDate,
					CASE WHEN left(right(DB.GivenDateKey, 4), 2) IN ('01','02') then 'Feb - Jan '+ Left(DB.GivenDateKey, 4)
						WHEN left(right(DB.GivenDateKey, 4), 2) IN ('03','04') then 'Apr - Mar '+ Left(DB.GivenDateKey, 4)
						WHEN left(right(DB.GivenDateKey, 4), 2) IN ('05','06') then 'Jun - May '+ Left(DB.GivenDateKey, 4) 
						WHEN left(right(DB.GivenDateKey, 4), 2) IN ('07','08') then 'Aug - Jul '+ Left(DB.GivenDateKey, 4) 
						WHEN left(right(DB.GivenDateKey, 4), 2) IN ('09','10') then 'Oct - Sept '+ Left(DB.GivenDateKey, 4) 
						WHEN left(right(DB.GivenDateKey, 4), 2) IN ('11','12') then 'Dec - Nov '+ Left(DB.GivenDateKey, 4) 
					END AS GrpDateName,
					MSR.BranchCount,
					ROUND(100*MSR.BranchPercentage, 0) BranchPercentage,
					ROUND(100*MSR.PreviousBranchPercentage, 0) PreviousBranchPercentage

			FROM	dbo.factBranchNewMemberExperienceReport AS MSR 
					INNER JOIN dd.factNewMemDashboardBase db
						ON MSR.BranchKey = DB.BranchKey
							AND msr.GivenDateKey = db.GivenDateKey
					INNER JOIN dbo.dimBranch AS D
						ON MSR.BranchKey = D.BranchKey
					INNER JOIN dbo.dimSurveyQuestion AS DQ 
						ON MSR.SurveyQuestionKey = DQ.SurveyQuestionKey 
					INNER JOIN dbo.dimQuestionCategory AS DC 
						ON DQ.SurveyQuestionKey = DC.SurveyQuestionKey 
							--AND CategoryType = 'Dashboard'
							AND CategoryType = 'Reporting'
							AND Category = 'Survey Responders'
					INNER JOIN dbo.dimQuestionResponse AS DR 
						ON MSR.QuestionResponseKey = DR.QuestionResponseKey 
							AND DR.ResponseCode <> '-1'
					INNER JOIN Seer_MDM.dbo.Batch B
						ON db.batch_key = B.batch_key
			
			) bs
			
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), bs.GivenDateKey))) < GETDATE()
			
	GROUP BY bs.AssociationKey,
			bs.BranchKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.PreviousGivenDateKey,
			bs.current_indicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName,
			bs.Branch,
			bs.Segment, 
			bs.Question, 
			bs.QuestionPosition,
			bs.QuestionLabel, 	
			bs.CategoryType,
			bs.Category, 
			bs.CategoryPosition, 
			bs.ResponseCode, 
			bs.ResponseText,
			bs.GivenSurveyDate,
			bs.SurveyYear
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemBranchSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association, 
					A.OfficialBranchNumber, 
					A.OfficialBranchName,
					A.Branch,
					A.Segment, 
					A.Question, 
					A.QuestionPosition,
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.ResponseCode, 
					A.ResponseText,
					A.GivenSurveyDate,
					A.SurveyYear, 	
					A.BranchCount, 
					A.BranchPercentage,
					A.PreviousPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo
					
			FROM	#NMBS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[PreviousGivenDateKey] <> source.[PreviousGivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[Association] <> source.[Association]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[GivenSurveyDate] <> source.[GivenSurveyDate]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[QuestionLabel] <> source.[QuestionLabel]
								 OR target.[CategoryType] <> source.[CategoryType]
								 OR target.[Category] <> source.[Category]
								 OR target.[CategoryPosition] <> source.[CategoryPosition]
								 OR target.[QuestionPosition] <> source.[QuestionPosition]
								 OR target.[ResponseCode] <> source.[ResponseCode]
								 OR target.[BranchCount] <> source.[BranchCount]
								 OR target.[BranchPercentage] <> source.[BranchPercentage]
								 OR target.[PreviousPercentage] <> source.[PreviousPercentage]
								 OR target.[SegmentHealthSeekerYes] <> source.[SegmentHealthSeekerYes]
								 OR target.[SegmentHealthSeekerNo] <> source.[SegmentHealthSeekerNo]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = @next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Segment], 
					[Question], 
					[QuestionPosition],
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[ResponseCode], 
					[ResponseText],
					[GivenSurveyDate],
					[SurveyYear], 	
					[BranchCount], 
					[BranchPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Segment], 
					[Question], 
					[QuestionPosition],
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[ResponseCode], 
					[ResponseText],
					[GivenSurveyDate],
					[SurveyYear], 	
					[BranchCount], 
					[BranchPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemBranchSegment AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association, 
					A.OfficialBranchNumber, 
					A.OfficialBranchName,
					A.Branch,
					A.Segment, 
					A.Question, 
					A.QuestionPosition,
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.ResponseCode, 
					A.ResponseText,
					A.GivenSurveyDate,
					A.SurveyYear, 	
					A.BranchCount, 
					A.BranchPercentage,
					A.PreviousPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo
					
			FROM	#NMBS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Segment], 
					[Question], 
					[QuestionPosition],
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[ResponseCode], 
					[ResponseText],
					[GivenSurveyDate],
					[SurveyYear], 	
					[BranchCount], 
					[BranchPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName],
					[Branch],
					[Segment], 
					[Question], 
					[QuestionPosition],
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[ResponseCode], 
					[ResponseText],
					[GivenSurveyDate],
					[SurveyYear], 	
					[BranchCount], 
					[BranchPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMBS;
	
COMMIT TRAN
	
END








