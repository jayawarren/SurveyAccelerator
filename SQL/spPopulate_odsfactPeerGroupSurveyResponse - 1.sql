/*
truncate table Seer_ODS.dbo.factPeerGroupSurveyResponse
drop procedure spPopulate_odsfactPeerGroupSurveyResponse
SELECT * FROM Seer_ODS.dbo.factPeerGroupSurveyResponse
*/
CREATE PROCEDURE spPopulate_odsfactPeerGroupSurveyResponse AS
BEGIN

DECLARE @change_datetime datetime
DECLARE @next_change_datetime datetime
SET @change_datetime = getdate()
SET @next_change_datetime = dateadd(SS, -1, @change_datetime)

BEGIN TRAN
SELECT	A.SurveyFormKey,
		A.QuestionKey,
		A.ResponseKey,
		A.ResponseKey PeerGroupResponseKey,
		A.OrganizationKey,
		A.Year,
		A.PeerGroup,
		A.SurveyType,
		1 current_indicator,
		A.ResponseCount,
		ResponsePercentage = dbo.RoundToZero(CASE WHEN COALESCE(C.PercentageDenominator,'Survey') = 'Survey' THEN CONVERT(DECIMAL(19,6), A.ResponseCount)/CONVERT(DECIMAL(19,6), B.SurveyCount) 
													ELSE
														CASE WHEN COALESCE(D.ExcludeFromReportCalculation,'N') = 'Y' THEN CONVERT(DECIMAL(19,6), A.ResponseCount)/CONVERT(DECIMAL(19,6), B.SurveyCount)
															ELSE CONVERT(DECIMAL(19,6), A.ResponseCount)/CONVERT(DECIMAL(19,6), B.QuestionCount)
														END
													END, 5)

INTO	#PSR

FROM	(
		SELECT	bsr.OrganizationSurveyKey SurveyFormKey,
				dq.QuestionKey,
				dr.ResponseKey, 
				db.OrganizationKey,
				ds.SurveyType, 
				CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)) Year, 
				CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
					ELSE COALESCE(db.PeerGroup,'Unknown')
				END PeerGroup,
				SUM(ResponseCount) ResponseCount
				
		FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
				INNER JOIN dimBranch db
					ON bsr.BranchKey = db.BranchKey
				INNER JOIN dimSurveyForm ds
					ON bsr.OrganizationSurveyKey = ds.SurveyFormKey
				INNER JOIN dimSurveyQuestion dq
					ON bsr.OrganizationSurveyKey = dq.SurveyFormKey
						AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
				INNER JOIN dimQuestionResponse dr
					ON bsr.SurveyQuestionKey = dr.SurveyQuestionKey
						AND bsr.QuestionResponseKey = dr.QuestionResponseKey

		--SurveyFormKey Filter for performance				
		WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
				AND bsr.current_indicator = 1
					
		GROUP BY bsr.OrganizationSurveyKey,
				dq.QuestionKey,
				dr.ResponseKey, 
				db.OrganizationKey,
				ds.SurveyType, 
				CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)), 
				CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
					ELSE COALESCE(db.PeerGroup,'Unknown')
				END
		) A
		INNER JOIN
		(
		SELECT	PSR.SurveyFormKey,
				PSR.QuestionKey,
				PSR.OrganizationKey,
				PSR.Year,
				PSR.SurveyType,
				PSR.PeerGroup,
				SUM(CASE WHEN COALESCE(DQR.ExcludeFromReportCalculation,'N') = 'Y' THEN 0
							ELSE
					PSR.ResponseCount END) AS QuestionCount,
				SUM(PSR.ResponseCount) AS SurveyCount

		FROM	(
				SELECT	bsr.OrganizationSurveyKey SurveyFormKey,
						dr.ResponseKey, 
						dq.QuestionKey,
						db.OrganizationKey,
						ds.SurveyType, 
						CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)) Year, 
						CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
							ELSE COALESCE(db.PeerGroup,'Unknown')
						END PeerGroup,
						SUM(ResponseCount) ResponseCount
						
				FROM	Seer_ODS.dbo.factBranchSurveyResponse bsr
						INNER JOIN dimBranch db
							ON bsr.BranchKey = db.BranchKey
						INNER JOIN dimSurveyForm ds
							ON bsr.OrganizationSurveyKey = ds.SurveyFormKey
						INNER JOIN dimSurveyQuestion dq
							ON bsr.OrganizationSurveyKey = dq.SurveyFormKey
								AND bsr.SurveyQuestionKey = dq.SurveyQuestionKey
						INNER JOIN dimQuestionResponse dr
							ON bsr.SurveyQuestionKey = dr.SurveyQuestionKey
								AND bsr.QuestionResponseKey = dr.QuestionResponseKey

				--SurveyFormKey Filter for performance				
				WHERE	bsr.OrganizationSurveyKey IN (SELECT SurveyFormKey FROM dimSurveyForm)
						AND bsr.current_indicator = 1
							
				GROUP BY bsr.OrganizationSurveyKey,
						dr.ResponseKey, 
						dq.QuestionKey,
						db.OrganizationKey,
						ds.SurveyType, 
						CONVERT(INT, LEFT(CONVERT(VARCHAR(20), bsr.GivenDateKey), 4)), 
						CASE WHEN LEN(COALESCE(db.PeerGroup,'Unknown')) = 0 THEN 'Unknown'
							ELSE COALESCE(db.PeerGroup,'Unknown')
						END
				
				) PSR
				INNER JOIN
				(
				SELECT	DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey, 
						DSF.SurveyType,
						MAX(DQR.ExcludeFromReportCalculation) AS ExcludeFromReportCalculation
						
				FROM	dimSurveyForm DSF
						INNER JOIN dimSurveyQuestion DSQ
							ON DSF.SurveyFormKey = DSQ.SurveyFormKey
						INNER JOIN dimQuestionResponse DQR
							ON DSQ.SurveyQuestionKey = DQR.SurveyQuestionKey
							
				GROUP BY DSF.SurveyFormKey,
						DSQ.QuestionKey,
						DQR.ResponseKey,
						DSF.SurveyType
				) DQR
					ON PSR.SurveyFormKey = DQR.SurveyFormKey
					AND PSR.QuestionKey = DQR.QuestionKey
					AND PSR.ResponseKey = DQR.ResponseKey
					
		GROUP BY PSR.SurveyFormKey,
				PSR.QuestionKey,
				PSR.OrganizationKey,
				PSR.Year,
				PSR.SurveyType,
				PSR.PeerGroup
		) B
			ON A.SurveyFormKey = B.SurveyFormKey
				AND A.QuestionKey = B.QuestionKey
				AND A.OrganizationKey = B.OrganizationKey
				AND A.Year = B.Year
				AND A.PeerGroup = B.PeerGroup
		INNER JOIN dimSurveyQuestion C
			ON A.SurveyFormKey = C.SurveyFormKey
				AND A.QuestionKey = C.QuestionKey
		INNER JOIN dimQuestionResponse D
			ON C.SurveyQuestionKey = D.SurveyQuestionKey
				AND A.ResponseKey = D.ResponseKey
				
--SurveyFormKey Filter for performance				
WHERE	A.SurveyFormKey IN (SELECT SurveyFormKey FROM dimSurveyForm);

COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factPeerGroupSurveyResponse]') AND name = N'PSR_INDEX_01')
	DROP INDEX [PSR_INDEX_01] ON [dbo].[factPeerGroupSurveyResponse] WITH ( ONLINE = OFF );

	CREATE INDEX PSR_INDEX_01 ON [dbo].[factPeerGroupSurveyResponse] ([SurveyFormKey], [QuestionKey], [ResponseKey], [PeerGroupResponseKey], [OrganizationKey], [Year], [SurveyType]) ON NDXGROUP;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factPeerGroupSurveyResponse AS target
	USING	(
			SELECT	A.SurveyFormKey,
					A.QuestionKey,
					A.ResponseKey,
					A.PeerGroupResponseKey,
					A.OrganizationKey,
					A.Year,
					A.PeerGroup,
					A.SurveyType,
					A.current_indicator,
					A.ResponseCount,
					A.ResponsePercentage
														
			FROM	#PSR A

			) AS source
			
			ON target.SurveyFormKey = source.SurveyFormKey
				AND target.QuestionKey = source.QuestionKey
				AND target.ResponseKey = source.ResponseKey
				AND target.PeerGroupResponseKey = source.PeerGroupResponseKey
				AND target.OrganizationKey = source.OrganizationKey
				AND target.current_indicator = source.current_indicator
				AND target.Year = source.Year
				AND target.PeerGroup = source.PeerGroup
				AND target.SurveyType = source.SurveyType
			
			WHEN MATCHED AND (target.[ResponseCount] <> source.[ResponseCount]
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
			INSERT ([SurveyFormKey],
					[QuestionKey],
					[ResponseKey],
					[PeerGroupResponseKey],
					[OrganizationKey],
					[PeerGroup],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([SurveyFormKey],
					[QuestionKey],
					[ResponseKey],
					[PeerGroupResponseKey],
					[OrganizationKey],
					[PeerGroup],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dbo.factPeerGroupSurveyResponse AS target
	USING	(
			SELECT	@change_datetime change_datetime,
					DATEADD(YY, 100, @change_datetime) next_change_datetime,
					A.SurveyFormKey,
					A.QuestionKey,
					A.ResponseKey,
					A.PeerGroupResponseKey,
					A.OrganizationKey,
					A.current_indicator,
					A.Year,
					A.PeerGroup,
					A.SurveyType,
					A.ResponseCount,
					A.ResponsePercentage
											
			FROM	#PSR A

			) AS source
			
			ON target.SurveyFormKey = source.SurveyFormKey
				AND target.QuestionKey = source.QuestionKey
				AND target.ResponseKey = source.ResponseKey
				AND target.PeerGroupResponseKey = source.PeerGroupResponseKey
				AND target.OrganizationKey = source.OrganizationKey
				AND target.current_indicator = source.current_indicator
				AND target.Year = source.Year
				AND target.PeerGroup = source.PeerGroup
				AND target.SurveyType = source.SurveyType
						
	WHEN NOT MATCHED BY target AND
		(1 = 1
		)
		THEN 
			INSERT ([change_datetime],
					[next_change_datetime],
					[SurveyFormKey],
					[QuestionKey],
					[ResponseKey],
					[PeerGroupResponseKey],
					[OrganizationKey],
					[PeerGroup],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage]
					)
			VALUES ([change_datetime],
					[next_change_datetime],
					[SurveyFormKey],
					[QuestionKey],
					[ResponseKey],
					[PeerGroupResponseKey],
					[OrganizationKey],
					[PeerGroup],
					[Year],
					[SurveyType],
					[ResponseCount],
					[ResponsePercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN
	IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[factPeerGroupSurveyResponse]') AND name = N'PSR_INDEX_01')
	DROP INDEX [PSR_INDEX_01] ON [dbo].[factPeerGroupSurveyResponse] WITH ( ONLINE = OFF );

	DROP TABLE #PSR;
COMMIT TRAN

END