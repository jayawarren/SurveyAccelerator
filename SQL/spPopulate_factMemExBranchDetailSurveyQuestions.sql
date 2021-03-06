/*
truncate table dd.factMemExBranchDetailSurveyQuestions
drop proc spPopulate_factMemExBranchDetailSurveyQuestions
SELECT * FROM dd.factMemExBranchDetailSurveyQuestions
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factMemExBranchDetailSurveyQuestions] AS
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
			A.AssociationName,
			A.Branch,
			CASE WHEN A.Category = 'Perception' THEN 'Support'
				ELSE A.Category
			END Category,
			CASE WHEN A.ReportType = 'wellbeing' AND A.Question NOT LIKE '%: %' THEN A.Category + ': ' + A.Question
				ELSE A.Question
			END Question,
			A.ResponseText,	 
			COALESCE(A.PeerGroup, '') PeerGroup,
			A.BranchPercentage,
			A.AssociationPercentage,
			A.NationalPercentage,
			A.PeerPercentage,
			A.PreviousBranchPercentage,
			A.CategoryPosition,
			A.QuestionPosition,
			A.ResponseCode,
			A.QuestionNumber,	
			A.txtBranchPercentage,
			A.txtAssociationPercentage,
			A.txtNationalPercentage,
			A.txtPeerPercentage,
			A.txtPreviousBranchPercentage,
			A.ReportType
			
	INTO	#MEBDSQ

	FROM	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.Category,
					A.Question,
					A.ResponseText,	 
					A.PeerGroup,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerPercentage,
					A.PreviousBranchPercentage,
					A.CategoryPosition,
					A.QuestionPosition,
					A.ResponseCode,
					A.QuestionNumber,	
					A.txtBranchPercentage,
					A.txtAssociationPercentage,
					A.txtNationalPercentage,
					A.txtPeerPercentage,
					A.txtPreviousBranchPercentage,
					A.ReportType
					
			FROM	[dd].[vwMemExBranchDetailSurveyQuestions] A
			
			UNION ALL
			
			SELECT	B.AssociationKey,
					B.BranchKey,
					B.batch_key,
					B.current_indicator,
					B.AssociationName,
					B.Branch,
					B.Category,
					B.Question,
					B.ResponseText,	 
					B.PeerGroup,
					B.BranchPercentage,
					B.AssociationPercentage,
					B.NationalPercentage,
					B.PeerPercentage,
					B.PreviousBranchPercentage,
					B.CategoryPosition,
					B.QuestionPosition,
					B.ResponseCode,
					B.QuestionNumber,	
					B.txtBranchPercentage,
					B.txtAssociationPercentage,
					B.txtNationalPercentage,
					B.txtPeerPercentage,
					B.txtPreviousBranchPercentage,
					B.ReportType
					
			FROM	[dd].[vwMemExBranchDetailSurveyQuestions_WellBeing] B
			
			) A
			
	WHERE	A.BranchKey IS NOT NULL
			AND A.Question NOT LIKE 'custom%'
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factMemExBranchDetailSurveyQuestions AS target
	USING	(
			SELECT	A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.Category,
					A.Question,
					A.ResponseText,	 
					A.PeerGroup,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerPercentage,
					A.PreviousBranchPercentage,
					A.CategoryPosition,
					A.QuestionPosition,
					A.ResponseCode,
					A.QuestionNumber,	
					A.txtBranchPercentage,
					A.txtAssociationPercentage,
					A.txtNationalPercentage,
					A.txtPeerPercentage,
					A.txtPreviousBranchPercentage,
					A.ReportType
					
			FROM	#MEBDSQ A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Category = source.Category
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				AND target.[ResponseCode] = source.[ResponseCode]			
				AND target.ReportType = source.ReportType
				
			WHEN MATCHED AND (target.[PeerGroup] <> source.[PeerGroup]
								OR target.[BranchPercentage] <> source.[BranchPercentage]
								OR target.[AssociationPercentage] <> source.[AssociationPercentage]
								OR target.[NationalPercentage] <> source.[NationalPercentage]
								OR target.[PeerPercentage] <> source.[PeerPercentage]
								OR target.[PreviousBranchPercentage] <> source.[PreviousBranchPercentage]
								OR target.[CategoryPosition] <> source.[CategoryPosition]
								OR target.[QuestionPosition] <> source.[QuestionPosition]
								OR target.[QuestionNumber] <> source.[QuestionNumber]
								OR target.[txtBranchPercentage] <> source.[txtBranchPercentage]
								OR target.[txtAssociationPercentage] <> source.[txtAssociationPercentage]
								OR target.[txtNationalPercentage] <> source.[txtNationalPercentage]
								OR target.[txtPeerPercentage] <> source.[txtPeerPercentage]
								OR target.[txtPreviousBranchPercentage] <> source.[txtPreviousBranchPercentage]
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
					[AssociationName],
					[Branch],
					[Category],
					[Question],
					[ResponseText],	 
					[PeerGroup],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerPercentage],
					[PreviousBranchPercentage],
					[CategoryPosition],
					[QuestionPosition],
					[ResponseCode],
					[QuestionNumber],	
					[txtBranchPercentage],
					[txtAssociationPercentage],
					[txtNationalPercentage],
					[txtPeerPercentage],
					[txtPreviousBranchPercentage],
					[ReportType]
					)
			VALUES ([AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[Category],
					[Question],
					[ResponseText],	 
					[PeerGroup],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerPercentage],
					[PreviousBranchPercentage],
					[CategoryPosition],
					[QuestionPosition],
					[ResponseCode],
					[QuestionNumber],	
					[txtBranchPercentage],
					[txtAssociationPercentage],
					[txtNationalPercentage],
					[txtPeerPercentage],
					[txtPreviousBranchPercentage],
					[ReportType]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factMemExBranchDetailSurveyQuestions AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.AssociationKey,
					A.BranchKey,
					A.batch_key,
					A.current_indicator,
					A.AssociationName,
					A.Branch,
					A.Category,
					A.Question,
					A.ResponseText,	 
					A.PeerGroup,
					A.BranchPercentage,
					A.AssociationPercentage,
					A.NationalPercentage,
					A.PeerPercentage,
					A.PreviousBranchPercentage,
					A.CategoryPosition,
					A.QuestionPosition,
					A.ResponseCode,
					A.QuestionNumber,	
					A.txtBranchPercentage,
					A.txtAssociationPercentage,
					A.txtNationalPercentage,
					A.txtPeerPercentage,
					A.txtPreviousBranchPercentage,
					A.ReportType
					
			FROM	#MEBDSQ A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Category = source.Category
				AND target.Question = source.Question
				AND target.ResponseText = source.ResponseText
				AND target.ResponseCode = source.ResponseCode
				AND target.ReportType = source.ReportType
						
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
					[AssociationName],
					[Branch],
					[Category],
					[Question],
					[ResponseText],	 
					[PeerGroup],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerPercentage],
					[PreviousBranchPercentage],
					[CategoryPosition],
					[QuestionPosition],
					[ResponseCode],
					[QuestionNumber],	
					[txtBranchPercentage],
					[txtAssociationPercentage],
					[txtNationalPercentage],
					[txtPeerPercentage],
					[txtPreviousBranchPercentage],
					[ReportType]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[AssociationKey],
					[BranchKey],
					[batch_key],
					[current_indicator],
					[AssociationName],
					[Branch],
					[Category],
					[Question],
					[ResponseText],	 
					[PeerGroup],
					[BranchPercentage],
					[AssociationPercentage],
					[NationalPercentage],
					[PeerPercentage],
					[PreviousBranchPercentage],
					[CategoryPosition],
					[QuestionPosition],
					[ResponseCode],
					[QuestionNumber],	
					[txtBranchPercentage],
					[txtAssociationPercentage],
					[txtNationalPercentage],
					[txtPeerPercentage],
					[txtPreviousBranchPercentage],
					[ReportType]
					)
	;
COMMIT TRAN

BEGIN TRAN

	DROP TABLE #MEBDSQ;
	
COMMIT TRAN
	
END








