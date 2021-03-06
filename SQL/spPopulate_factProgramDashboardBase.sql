/*
truncate table dd.factProgramDashboardBase
drop proc spPopulate_factProgramDashboardBase
SELECT * FROM dd.factProgramDashboardBase
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factProgramDashboardBase] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	
	SELECT	A.GroupingKey,
			A.ProgramKey,
			A.SurveyFormKey,
			A.AssociationKey,
			A.batch_key,
			A.GivenDateKey,
			A.PrevGivenDateKey,
			A.current_indicator,
			A.GroupingLabel,
			A.GroupingName,
			A.Program,	
			A.AssociationName,
			A.AssociationNumber,
			A.AssociationNameEx,
			A.SurveyYear,
			A.PrevYear,
			A.SurveyType,
			A.SurveysSent,
			A.SurveysReceived,
			A.ResponsePercentage
			
	INTO	#PDB
	
	FROM 	dd.vwProgramDashboardBase A		
	;
	 
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factProgramDashboardBase AS target
	USING	(
			SELECT	A.GroupingKey,
					A.ProgramKey,
					A.SurveyFormKey,
					A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.GroupingLabel,
					A.GroupingName,
					A.Program,	
					A.AssociationName,
					A.AssociationNumber,
					A.AssociationNameEx,
					A.SurveyYear,
					A.PrevYear,
					A.SurveyType,
					A.SurveysSent,
					A.SurveysReceived,
					A.ResponsePercentage
					
			FROM	#PDB A

			) AS source
			
			ON target.GroupingKey = source.GroupingKey
				AND target.ProgramKey = source.ProgramKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.AssociationKey = source.AssociationKey
				AND target.current_indicator = source.current_indicator
				AND target.GroupingLabel = source.GroupingLabel
				AND target.GroupingName = source.GroupingName
				AND target.Program = source.Program
			
			WHEN MATCHED AND (target.batch_key <> source.batch_key
								 OR target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[PrevGivenDateKey] <> source.[PrevGivenDateKey]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[AssociationNameEx] <> source.[AssociationNameEx]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[PrevYear] <> source.[PrevYear]
								 OR target.[SurveyType] <> source.[SurveyType]
								 OR target.[SurveysSent] <> source.[SurveysSent]
								 OR target.[SurveysReceived] <> source.[SurveysReceived]
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
			INSERT ([GroupingKey],
					[ProgramKey],
					[SurveyFormKey],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[GroupingLabel],
					[GroupingName],
					[Program],	
					[AssociationName],
					[AssociationNumber],
					[AssociationNameEx],
					[SurveyYear],
					[PrevYear],
					[SurveyType],
					[SurveysSent],
					[SurveysReceived],
					[ResponsePercentage]
					)
			VALUES ([GroupingKey],
					[ProgramKey],
					[SurveyFormKey],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[GroupingLabel],
					[GroupingName],
					[Program],	
					[AssociationName],
					[AssociationNumber],
					[AssociationNameEx],
					[SurveyYear],
					[PrevYear],
					[SurveyType],
					[SurveysSent],
					[SurveysReceived],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factProgramDashboardBase AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.GroupingKey,
					A.ProgramKey,
					A.SurveyFormKey,
					A.AssociationKey,
					A.batch_key,
					A.GivenDateKey,
					A.PrevGivenDateKey,
					A.current_indicator,
					A.GroupingLabel,
					A.GroupingName,
					A.Program,	
					A.AssociationName,
					A.AssociationNumber,
					A.AssociationNameEx,
					A.SurveyYear,
					A.PrevYear,
					A.SurveyType,
					A.SurveysSent,
					A.SurveysReceived,
					A.ResponsePercentage
					
			FROM	#PDB A

			) AS source
			
			ON target.GroupingKey = source.GroupingKey
				AND target.ProgramKey = source.ProgramKey
				AND target.SurveyFormKey = source.SurveyFormKey
				AND target.AssociationKey = source.AssociationKey
				AND target.current_indicator = source.current_indicator
				AND target.GroupingLabel = source.GroupingLabel
				AND target.GroupingName = source.GroupingName
				AND target.Program = source.Program
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[GroupingKey],
					[ProgramKey],
					[SurveyFormKey],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[GroupingLabel],
					[GroupingName],
					[Program],	
					[AssociationName],
					[AssociationNumber],
					[AssociationNameEx],
					[SurveyYear],
					[PrevYear],
					[SurveyType],
					[SurveysSent],
					[SurveysReceived],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[GroupingKey],
					[ProgramKey],
					[SurveyFormKey],
					[AssociationKey],
					[batch_key],
					[GivenDateKey],
					[PrevGivenDateKey],
					[current_indicator],
					[GroupingLabel],
					[GroupingName],
					[Program],	
					[AssociationName],
					[AssociationNumber],
					[AssociationNameEx],
					[SurveyYear],
					[PrevYear],
					[SurveyType],
					[SurveysSent],
					[SurveysReceived],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #PDB;
	
COMMIT TRAN
	
END








