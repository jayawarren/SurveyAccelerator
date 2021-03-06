/*
truncate table dd.factMemExBranchSegment
drop proc spPopulate_factMemExBranchSegment
SELECT * FROM dd.factMemExBranchSegment
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchSegment] AS
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
			bs.change_datetime,
			bs.next_change_datetime,
			bs.current_indicator,
			bs.SurveyYear, 
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName, 
			bs.Segment, 
			SUM(bs.BranchCount) AS BranchCount, 
			bs.Question, 
			bs.QuestionLabel, 	
			bs.CategoryType,
			bs.Category, 
			bs.CategoryPosition, 
			bs.QuestionPosition,
			bs.ResponseCode, 
			bs.ResponseText,	
			SUM(bs.BranchPercentage) AS BranchPercentage,
			CASE WHEN SUM(bs.PreviousBranchPercentage) is null then 99999
				ELSE SUM(bs.PreviousBranchPercentage)
			END AS PrevBranchPercentage
			
	INTO	#MEBS

	FROM	(
			SELECT	distinct
					D.AssociationKey,
					D.BranchKey,
					DB.batch_key,
					MSR.GivenDateKey,
					B.change_datetime,
					B.next_change_datetime,
					DB.current_indicator, 
					LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
					MSR.Segment, 
					D.AssociationNumber, 
					D.AssociationName, 
					D.AssociationNumber + ' - ' + D.AssociationName AS Association,
					D.OfficialBranchNumber, 				
					dd.GetShortBranchName(D.OfficialBranchName) AS OfficialBranchName, 
					DQ.Question, 
					'' AS QuestionLabel, 
					DC.Category,         
					'Reporting' AS CategoryType,
					DC.CategoryPosition, 
					CASE 
						WHEN Question like 'data source%' then 0
						ELSE QuestionPosition
					END AS QuestionPosition,
					--DR.ResponseCode, 
					--DR.ResponseText,
					CASE WHEN ResponseText like '%Adult%' then '61' 
						WHEN ResponseText like '%Family%' then '62'
						WHEN ResponseText like '%Senior%' then '63'
						ELSE ResponseCode
					END AS ResponseCode,		
					CASE
						WHEN ResponseText like '%Adult%' then 'Adult' 
						WHEN ResponseText like '%Family%' then 'Family' 
						WHEN ResponseText like '%Senior%' then 'Senior' 
						ELSE ResponseText
					END AS ResponseText,
					MSR.BranchCount,
					MSR.BranchPercentage,
					MSR.PreviousBranchPercentage

			FROM	dbo.factBranchMemberSatisfactionReport AS MSR 
					INNER JOIN dd.factMemExDashboardBase db
						ON MSR.BranchKey = DB.BranchKey
							AND msr.GivenDateKey = db.GivenDateKey
					INNER JOIN dbo.dimBranch AS D
						ON MSR.BranchKey = D.BranchKey
					INNER JOIN dbo.dimSurveyQuestion AS DQ 
						ON MSR.SurveyQuestionKey = DQ.SurveyQuestionKey 
					INNER JOIN dbo.dimQuestionCategory AS DC 
						ON DQ.SurveyQuestionKey = DC.SurveyQuestionKey 
							--AND CategoryType = 'Dashboard'
							--AND CategoryType = 'Reporting'
							AND Category = 'Survey Responders'
					INNER JOIN dbo.dimQuestionResponse AS DR 
						ON MSR.QuestionResponseKey = DR.QuestionResponseKey 
							AND DR.ResponseCode <> '-1'
					INNER JOIN Seer_MDM.dbo.Batch_Map B
						ON MSR.batch_key = B.batch_key
							AND MSR.BranchKey = B.organization_key
						
			WHERE	B.module = 'Member'
					AND B.aggregate_type = 'Branch'
					AND MSR.current_indicator = 1
					AND db.current_indicator = 1
			
			) bs
			
	GROUP BY bs.AssociationKey,
			bs.BranchKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.change_datetime,
			bs.next_change_datetime,
			bs.current_indicator, 	
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName, 
			bs.SurveyYear, 
			bs.Segment, 
			bs.Question, 
			bs.QuestionLabel, 	
			bs.CategoryType,
			bs.Category, 
			bs.CategoryPosition, 
			bs.QuestionPosition,
			bs.ResponseCode, 
			bs.ResponseText
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.SurveyYear, 
					A.AssociationNumber, 
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber, 
					A.OfficialBranchName, 
					A.Segment, 
					A.BranchCount, 
					A.Question, 
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.QuestionPosition,
					A.ResponseCode, 
					A.ResponseText,	
					A.BranchPercentage,
					A.PrevBranchPercentage
					
			FROM	#MEBS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[GivenDateKey] <> source.[GivenDateKey]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[BranchCount] <> source.[BranchCount]
								OR target.[QuestionLabel] <> source.[QuestionLabel]
								OR target.[CategoryType] <> source.[CategoryType]
								OR target.[Category] <> source.[Category]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[ResponseCode] <> source.[ResponseCode]
								OR target.[BranchPercentage] <> source.[BranchPercentage]
								OR target.[PrevBranchPercentage] <> source.[PrevBranchPercentage]
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
					[BranchKey],
					[GivenDateKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName], 
					[Segment], 
					[BranchCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[BranchPercentage],
					[PrevBranchPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[GivenDateKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName], 
					[Segment], 
					[BranchCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[BranchPercentage],
					[PrevBranchPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.SurveyYear, 
					A.AssociationNumber, 
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber, 
					A.OfficialBranchName, 
					A.Segment, 
					A.BranchCount, 
					A.Question, 
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.QuestionPosition,
					A.ResponseCode, 
					A.ResponseText,	
					A.BranchPercentage,
					A.PrevBranchPercentage
					
			FROM	#MEBS A

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
			INSERT ([AssociationKey],
					[BranchKey],
					[GivenDateKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName], 
					[Segment], 
					[BranchCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[BranchPercentage],
					[PrevBranchPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[GivenDateKey],
					[batch_key],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[OfficialBranchNumber], 
					[OfficialBranchName], 
					[Segment], 
					[BranchCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[BranchPercentage],
					[PrevBranchPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBS;
	
COMMIT TRAN
	
END








