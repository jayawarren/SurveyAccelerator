/*
truncate table dd.factNewMemBranchSurveyResponders
drop proc spPopulate_factNewMemBranchSurveyResponders
SELECT * FROM dd.factNewMemBranchSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemBranchSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			A.GivenDateKey,
			A.current_indicator,
			A.CurrentSurveyIndicator,
			A.AssociationNumber,
			A.AssociationName,
			A.Association,
			A.OfficialBranchNumber,
			A.OfficialBranchName,
			A.Branch,
			A.GivenSurveyCategory,
			A.GivenSurveyDate,
			A.SurveyYear,
			A.Members,
			A.SurveysMailed,
			A.ResponsePercentage
			
	INTO	#NMBSR
			
	FROM	[dd].[vwNewMemBranchSurveyResponders] A
			
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), A.GivenDateKey))) < GETDATE() 
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemBranchSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[GivenSurveyDate] <> source.[GivenSurveyDate]				 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[Association] <> source.[Association]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[Members] <> source.[Members]
								 OR target.[SurveysMailed] <> source.[SurveysMailed]
								 OR target.[ResponsePercentage] <> source.[ResponsePercentage]
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
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
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
	MERGE	Seer_ODS.dd.factNewMemBranchSurveyResponders AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.GivenDateKey,
					A.current_indicator,
					A.CurrentSurveyIndicator,
					A.AssociationNumber,
					A.AssociationName,
					A.Association,
					A.OfficialBranchNumber,
					A.OfficialBranchName,
					A.Branch,
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.Members,
					A.SurveysMailed,
					A.ResponsePercentage
					
			FROM	#NMBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
						
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
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
					[GivenSurveyCategory],
					[GivenSurveyDate],
					[SurveyYear],
					[Members],
					[SurveysMailed],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[GivenDateKey],
					[current_indicator],
					[CurrentSurveyIndicator],
					[AssociationNumber],
					[AssociationName],
					[Association],
					[OfficialBranchNumber],
					[OfficialBranchName],
					[Branch],
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

	DROP TABLE #NMBSR;
	
COMMIT TRAN
	
END








