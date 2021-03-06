/*
truncate table dd.factNewMemAssociationSurveyResponders
drop proc spPopulate_factNewMemAssociationSurveyResponders
SELECT * FROM dd.factNewMemAssociationSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemAssociationSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	distinct
			A.AssociationKey,
			A.batch_key,
			A.GivenDateKey,
			B.change_datetime,
			B.next_change_datetime,
			A.current_indicator,
			A.CurrentSurveyIndicator,
			A.AssociationNumber,
			A.AssociationName,
			A.Association,
			A.GivenSurveyCategory,
			A.GivenSurveyDate,
			A.SurveyYear,
			A.Members,
			A.SurveysMailed,
			A.ResponsePercentage
			
	INTO	#NMASR
	
	FROM	dd.vwNewMemAssociationSurveyResponders A
			INNER JOIN Seer_MDM.dbo.Batch_Map B
				ON A.batch_key = B.batch_key
					AND A.AssociationKey = B.organization_key
						
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), A.GivenDateKey))) < GETDATE()
			AND B.module = 'New Member'
			AND B.aggregate_type = 'Association'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemAssociationSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMASR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.GivenDateKey = source.GivenDateKey
				AND target.GivenSurveyDate = source.GivenSurveyDate
				
			WHEN MATCHED AND (target.[change_datetime] <> source.[change_datetime]
								OR target.[next_change_datetime] <> source.[next_change_datetime]
								OR target.[AssociationName] <> source.[AssociationName]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[Association] <> source.[Association]
								OR target.[GivenSurveyCategory] <> source.[GivenSurveyCategory]
								OR target.[AssociationNumber] <> source.[AssociationNumber]
								OR target.[SurveyYear] <> source.[SurveyYear]
								OR target.[Members] <> source.[Members]
								OR target.[SurveysMailed] <> source.[SurveysMailed]
								OR target.[ResponsePercentage] <> source.[ResponsePercentage]
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
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemAssociationSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.change_datetime,
					A.next_change_datetime,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMASR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.GivenDateKey = source.GivenDateKey
				AND target.GivenSurveyDate = source.GivenSurveyDate
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([AssociationKey],
					[batch_key],
					[GivenDateKey],
					[change_datetime],
					[next_change_datetime],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #NMASR;
	
COMMIT TRAN
	
END








