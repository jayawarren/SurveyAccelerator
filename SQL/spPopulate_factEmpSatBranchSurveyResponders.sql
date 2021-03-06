/*
truncate table dd.factEmpSatBranchSurveyResponders
drop proc spPopulate_factEmpSatBranchSurveyResponders
SELECT * FROM dd.factEmpSatBranchSurveyResponders
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factEmpSatBranchSurveyResponders] AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
	SELECT	A.AssociationKey,
			A.BranchKey,
			A.batch_key,
			A.current_indicator,
			A.Association,
			A.Branch,
			A.Sent,
			A.Received,
			A.ResponseCount,
			A.Question,
			A.QuestionPosition,
			A.Response,
			A.ResponsePosition,
			A.CurrentResponsePercentage,
			CASE WHEN A.PreviousResponsePercentage IS NULL THEN 99999
				ELSE A.PreviousResponsePercentage
			END PreviousResponsePercentage,
			A.CurrentSurveyPercentage
			
	INTO	#ESBSR
			
	FROM	dd.vwEmpSatBranchSurveyResponders A
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factEmpSatBranchSurveyResponders AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.Sent,
					A.Received,
					A.ResponseCount,
					A.Question,
					A.QuestionPosition,
					A.Response,
					A.ResponsePosition,
					A.CurrentResponsePercentage,
					A.PreviousResponsePercentage,
					A.CurrentSurveyPercentage
					
			FROM	#ESBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Response = source.Response
				
			WHEN MATCHED AND (target.[Association] <> source.[Association]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[Sent] <> source.[Sent]
								 OR target.[Received] <> source.[Received]
								 OR target.[ResponseCount] <> source.[ResponseCount]
								 OR target.[QuestionPosition] <> source.[QuestionPosition]
								 OR target.[ResponsePosition] <> source.[ResponsePosition]
								 OR target.[CurrentResponsePercentage] <> source.[CurrentResponsePercentage]
								 OR target.[PreviousResponsePercentage] <> source.[PreviousResponsePercentage]
								 OR target.[CurrentSurveyPercentage] <> source.[CurrentSurveyPercentage]
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
					[current_indicator],
					[Association],
					[Branch],
					[Sent],
					[Received],
					[ResponseCount],
					[Question],
					[QuestionPosition],
					[Response],
					[ResponsePosition],
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CurrentSurveyPercentage]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Sent],
					[Received],
					[ResponseCount],
					[Question],
					[QuestionPosition],
					[Response],
					[ResponsePosition],
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CurrentSurveyPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factEmpSatBranchSurveyResponders AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.Association,
					A.Branch,
					A.Sent,
					A.Received,
					A.ResponseCount,
					A.Question,
					A.QuestionPosition,
					A.Response,
					A.ResponsePosition,
					A.CurrentResponsePercentage,
					A.PreviousResponsePercentage,
					A.CurrentSurveyPercentage
					
			FROM	#ESBSR A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Response = source.Response
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Sent],
					[Received],
					[ResponseCount],
					[Question],
					[QuestionPosition],
					[Response],
					[ResponsePosition],
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CurrentSurveyPercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[Association],
					[Branch],
					[Sent],
					[Received],
					[ResponseCount],
					[Question],
					[QuestionPosition],
					[Response],
					[ResponsePosition],
					[CurrentResponsePercentage],
					[PreviousResponsePercentage],
					[CurrentSurveyPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #ESBSR;
	
COMMIT TRAN
	
END








