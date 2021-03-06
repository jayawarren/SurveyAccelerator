/*
truncate table dd.factNewMemAssociationSegment
drop proc spPopulate_factNewMemAssociationSegment
SELECT * FROM dd.factNewMemAssociationSegment
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemAssociationSegment] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	bs.AssociationKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.PreviousGivenDateKey,
			bs.change_datetime,
			bs.next_change_datetime,
			bs.current_indicator,
			bs.current_indicator CurrentSurveyIndicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
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
			SUM(bs.AssociationCount) AS AssociationCount, 
			COALESCE(SUM(bs.AssociationPercentage), 99999) AS AssociationPercentage,
			COALESCE(SUM(bs.PreviousAssociationPercentage), 99999) AS PreviousPercentage,
			SUM(bs.SegmentHealthSeekerYes) AS SegmentHealthSeekerYes,
			SUM(bs.SegmentHealthSeekerNo) AS SegmentHealthSeekerNo
			
	INTO	#NMAS

	FROM	(
			SELECT	distinct
					D.AssociationKey,
					DB.batch_key,
					DB.GivenDateKey,
					DB.PrevGivenDateKey PreviousGivenDateKey,
					E.change_datetime,
					E.next_change_datetime,
					DB.current_indicator, 
					LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
					MSR.Segment, 
					D.AssociationNumber, 
					D.AssociationName,
					D.AssociationNumber + ' - ' + D.AssociationName AS Association,
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
					MSR.AssociationCount,
					ROUND(100*MSR.AssociationPercentage, 0) AssociationPercentage,
					ROUND(100*MSR.PreviousAssociationPercentage, 0) PreviousAssociationPercentage

			FROM	dbo.factAssociationNewMemberExperienceReport AS MSR 
					INNER JOIN dd.factNewMemDashboardBase db
						ON MSR.AssociationKey = DB.AssociationKey
							AND msr.GivenDateKey = db.GivenDateKey
					INNER JOIN dbo.dimAssociation AS D
						ON MSR.AssociationKey = D.AssociationKey
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
					INNER JOIN Seer_MDM.dbo.Batch_Map E
						ON db.batch_key = E.batch_key
							AND db.BranchKey = E.organization_key
						
			WHERE	MSR.current_indicator = 1
					AND E.module = 'New Member'
					AND E.aggregate_type = 'Association'
			
			) bs
			
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), bs.GivenDateKey))) < GETDATE()
			
	GROUP BY bs.AssociationKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.PreviousGivenDateKey,
			bs.change_datetime,
			bs.next_change_datetime,
			bs.current_indicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
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

	MERGE	Seer_ODS.dd.factNewMemAssociationSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association, 
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
					A.AssociationCount, 
					A.AssociationPercentage,
					A.PreviousPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo
					
			FROM	#NMAS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				AND target.[GivenDateKey] = source.[GivenDateKey]
				AND COALESCE(target.[PreviousGivenDateKey], '19000101') = COALESCE(source.[PreviousGivenDateKey], '19000101')
								
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[Association] <> source.[Association]
								OR target.[GivenSurveyDate] <> source.[GivenSurveyDate]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[QuestionLabel] <> source.[QuestionLabel]
								OR target.[CategoryType] <> source.[CategoryType]
								OR target.[Category] <> source.[Category]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[ResponseCode] <> source.[ResponseCode]
								OR target.[AssociationCount] <> source.[AssociationCount]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[PreviousPercentage] <> source.[PreviousPercentage]
								OR target.[SegmentHealthSeekerYes] <> source.[SegmentHealthSeekerYes]
								OR target.[SegmentHealthSeekerNo] <> source.[SegmentHealthSeekerNo]
								)
		THEN
			UPDATE	
			SET		[current_indicator]	 = 	0,
					[next_change_datetime] = source.next_change_datetime
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
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
					[AssociationCount], 
					[AssociationPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
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
					[AssociationCount], 
					[AssociationPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemAssociationSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.PreviousGivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber, 
					A.AssociationName,
					A.Association, 
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
					A.AssociationCount, 
					A.AssociationPercentage,
					A.PreviousPercentage,
					A.SegmentHealthSeekerYes,
					A.SegmentHealthSeekerNo
					
			FROM	#NMAS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				AND target.[GivenDateKey] = source.[GivenDateKey]
				AND COALESCE(target.[PreviousGivenDateKey], '19000101') = COALESCE(source.[PreviousGivenDateKey], '19000101')
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
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
					[AssociationCount], 
					[AssociationPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PreviousGivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber], 
					[AssociationName],
					[Association], 
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
					[AssociationCount], 
					[AssociationPercentage],
					[PreviousPercentage],
					[SegmentHealthSeekerYes],
					[SegmentHealthSeekerNo]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMAS;
	
COMMIT TRAN
	
END








