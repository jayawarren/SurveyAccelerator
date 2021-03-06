/*
truncate table dd.factMemExAssociationSegment
drop proc spPopulate_factMemExAssociationSegment
SELECT * FROM dd.factMemExAssociationSegment
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExAssociationSegment] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	bs.AssociationKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.current_indicator,
			bs.SurveyYear, 
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association, 
			bs.Segment, 
			SUM(bs.AssociationCount) AS AssociationCount, 
			bs.Question, 
			bs.QuestionLabel, 	
			bs.CategoryType,
			bs.Category, 
			bs.CategoryPosition, 
			bs.QuestionPosition,
			bs.ResponseCode, 
			bs.ResponseText,	
			SUM(bs.AssociationPercentage) AS AssociationPercentage,
			CASE WHEN SUM(bs.PreviousAssociationPercentage) is null then 99999
				ELSE SUM(bs.PreviousAssociationPercentage)
			END AS PrevAssociationPercentage
			
	INTO	#MEAS

	FROM	(
			SELECT	distinct
					D.AssociationKey,
					DB.batch_key,
					MSR.GivenDateKey,
					DB.current_indicator, 
					LEFT(MSR.GivenDateKey, 4) AS SurveyYear, 
					MSR.Segment, 
					D.AssociationNumber, 
					D.AssociationName, 
					D.AssociationNumber + ' - ' + D.AssociationName AS Association,
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
					MSR.AssociationCount,
					MSR.AssociationPercentage,
					MSR.PreviousAssociationPercentage

			FROM	dbo.factAssociationMemberSatisfactionReport AS MSR 
					INNER JOIN dd.factMemExDashboardBase db
						ON MSR.AssociationKey = DB.AssociationKey
							AND msr.GivenDateKey = db.GivenDateKey
					INNER JOIN dbo.dimAssociation AS D
						ON MSR.AssociationKey = D.AssociationKey
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
			
			) bs
			
	GROUP BY bs.AssociationKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.current_indicator, 	
			bs.AssociationNumber, 
			bs.AssociationName, 
			bs.Association,
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

	MERGE	Seer_ODS.dd.factMemExAssociationSegment AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.SurveyYear, 
					A.AssociationNumber, 
					A.AssociationName,
					A.Association,
					A.Segment, 
					A.AssociationCount, 
					A.Question, 
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.QuestionPosition,
					A.ResponseCode, 
					A.ResponseText,	
					A.AssociationPercentage,
					A.PrevAssociationPercentage
					
			FROM	#MEAS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Segment = source.Segment
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[AssociationCount] <> source.[AssociationCount]
								 OR target.[QuestionLabel] <> source.[QuestionLabel]
								 OR target.[CategoryType] <> source.[CategoryType]
								 OR target.[Category] <> source.[Category]
								 OR target.[CategoryPosition] <> source.[CategoryPosition]
								 OR target.[QuestionPosition] <> source.[QuestionPosition]
								 OR target.[ResponseCode] <> source.[ResponseCode]
								 OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								 OR target.[PrevAssociationPercentage] <> source.[PrevAssociationPercentage]
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
					[GivenDateKey],
					[batch_key],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[Segment], 
					[AssociationCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[AssociationPercentage],
					[PrevAssociationPercentage]
					)
			VALUES ([AssociationKey],
					[GivenDateKey],
					[batch_key],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[Segment], 
					[AssociationCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[AssociationPercentage],
					[PrevAssociationPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExAssociationSegment AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.SurveyYear, 
					A.AssociationNumber, 
					A.AssociationName, 
					A.Association,
					A.Segment, 
					A.AssociationCount, 
					A.Question, 
					A.QuestionLabel, 	
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.QuestionPosition,
					A.ResponseCode, 
					A.ResponseText,	
					A.AssociationPercentage,
					A.PrevAssociationPercentage
					
			FROM	#MEAS A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
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
					[GivenDateKey],
					[batch_key],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[Segment], 
					[AssociationCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[AssociationPercentage],
					[PrevAssociationPercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[GivenDateKey],
					[batch_key],
					[current_indicator],
					[SurveyYear], 
					[AssociationNumber], 
					[AssociationName], 
					[Association], 
					[Segment], 
					[AssociationCount], 
					[Question], 
					[QuestionLabel], 	
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[QuestionPosition],
					[ResponseCode], 
					[ResponseText],	
					[AssociationPercentage],
					[PrevAssociationPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEAS;
	
COMMIT TRAN
	
END








