/*
truncate table dd.factNewMemBranchExperienceReport
drop proc spPopulate_factNewMemBranchExperienceReport
SELECT * FROM dd.factNewMemBranchExperienceReport
ROLLBACK TRAN
*/
CREATE PROCEDURE [dbo].[spPopulate_factNewMemBranchExperienceReport] AS
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
			CASE WHEN bs.CurrentSurveyIndicator > 2 THEN 0
				ELSE bs.CurrentSurveyIndicator
			END CurrentSurveyIndicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association,
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName,
			bs.Branch,
			bs.Question,
			bs.ShortQuestion,
			'Q' + CASE WHEN bs.CategoryType = 'Key Indicators' THEN '01' 
					WHEN bs.CategoryType = 'Performance Measures' THEN '02'
					ELSE '03'
				  END
				+ CASE WHEN bs.[CategoryPosition] < 10  AND bs.Category <> 'Survey Responders' THEN '0'
					ELSE ''
				  END
				+ CAST(CASE WHEN bs.Category = 'Perceptions' THEN '9' 
						WHEN bs.Category = 'Survey Responders' then '11'
						ELSE bs.CategoryPosition
					   END AS varchar(2))
			    + CASE WHEN bs.[QuestionPosition] < 10 THEN '0'
					ELSE ''
				  END
				+ CAST(CASE WHEN bs.ShortQuestion = 'Y nutures potential all children' THEN '05'
						ELSE bs.QuestionPosition
					   END AS varchar(2)) AS QuestionCode,
			bs.QuestionPosition,
			bs.CategoryType,
			CASE WHEN bs.Category = 'Perceptions' THEN 'Support'
				ELSE bs.Category
			END Category, 
			bs.CategoryPosition, 
			bs.GrpDateName GivenSurveyCategory,
			bs.GivenSurveyDate,
			bs.SurveyYear,
			bs.SurveyYear CurrentSurveyYear, 
			bs.PreviousSurveyYear,
			bs.BranchCount,	
			CONVERT(INT, SUM(CASE WHEN bs.ResponseCode = '01' THEN bs.BranchPercentage
								ELSE 0
							END -
							CASE WHEN bs.ResponseCode = '02' THEN bs.BranchPercentage
								ELSE
							0 END)
					) AS BranchPercentage,
			CONVERT(INT, SUM(CASE WHEN bs.ResponseCode = '01' THEN bs.BranchPercentage
								ELSE 0
							END -
							CASE WHEN bs.ResponseCode = '02' THEN bs.BranchPercentage
								ELSE
							0 END)
					) AS CurrentPercentage,
			CONVERT(INT, SUM(CASE WHEN bs.ResponseCode = '01' THEN bs.PreviousBranchPercentage
								ELSE 0
							END -
							CASE WHEN bs.ResponseCode = '02' THEN bs.PreviousBranchPercentage
								ELSE
							0 END)
					) AS PreviousPercentage
			
	INTO	#NMBER

	FROM	(
			SELECT	distinct
					D.AssociationKey,
					D.BranchKey,
					db.batch_key,
					db.GivenDateKey,
					db.PrevGivenDateKey PreviousGivenDateKey,
					db.current_indicator, 
					LEFT(msr.GivenDateKey, 4) AS SurveyYear,
					LEFT(db.PrevGivenDateKey, 4) PreviousSurveyYear, 
					msr.Segment, 
					D.AssociationNumber, 
					D.AssociationName,
					D.AssociationNumber + ' - ' + D.AssociationName AS Association,
					D.OfficialBranchNumber, 
					D.OfficialBranchName,				
					dd.GetShortBranchName(D.OfficialBranchName) AS Branch, 
					CASE WHEN dc.Category = 'Net Promoter' THEN dc.Category 
						WHEN msr.Segment = 'Health Seeker' THEN msr.Segment
						ELSE dq.Question
					END AS Question, 
					'' AS QuestionLabel, 
					CASE WHEN dc.Category = 'Drivers Joining' THEN 'Reasons for Joining'
						WHEN msr.Segment = 'Health Seeker' THEN 'Health Seekers' 
						ELSE dc.Category
					END AS Category,         
					CASE WHEN dc.Category IN ('Health Seekers','Meeting Expectations', 'Net Promoter', 'Onboarding') THEN 'Key Indicators' 
						WHEN dc.Category IN ('Operational Excellence', 'Drivers Joining', 'Perceptions') THEN 'Performance Measures'
						ELSE dc.Category
					END AS CategoryType,
					CASE WHEN msr.Segment = 'Health Seeker' THEN 2
						ELSE dc.CategoryPosition
					END AS  CategoryPosition,
					CASE WHEN dc.Category = 'Net Promoter' or msr.Segment = 'Health Seeker' THEN 1
						ELSE dc.QuestionPosition
					END AS QuestionPosition,
					CASE WHEN dc.Category = 'Net Promoter' or msr.Segment = 'Health Seeker' THEN 1
						ELSE dq.QuestionNumber
					END AS QuestionNumber,
					CASE WHEN dc.Category = 'Net Promoter' THEN dc.Category 
						WHEN msr.Segment = 'Health Seeker' THEN msr.Segment
						ELSE dq.ShortQuestion
					END AS ShortQuestion,
					msr.SegmentHealthSeekerNo,
					msr.SegmentHealthSeekerYes,
					CASE WHEN dq.Question LIKE '%would you recommend%friends%' THEN
										  (CASE WHEN dr.ResponseCode in ('09','10') THEN '01'
					                            WHEN dr.ResponseCode in ('07','08') THEN '02'					
												ELSE '03'
											END)
						ELSE dr.ResponseCode
					END AS ResponseCode,
					CASE WHEN dq.Question LIKE '%would you recommend%friends%' THEN
										  (CASE WHEN dr.ResponseCode in ('09','10') then '9,10'
												WHEN dr.ResponseCode in ('07','08') then '7,8'
												ELSE '0-6'
											END)
						ELSE dr.ResponseText
					END AS ResponseText,
					REPLACE(B.report_date, '-', '') GivenSurveyDate,
					CASE WHEN left(right(db.GivenDateKey, 4), 2) IN ('01','02') then 'Feb - Jan '+ Left(db.GivenDateKey, 4)
						WHEN left(right(db.GivenDateKey, 4), 2) IN ('03','04') then 'Apr - Mar '+ Left(db.GivenDateKey, 4)
						WHEN left(right(db.GivenDateKey, 4), 2) IN ('05','06') then 'Jun - May '+ Left(db.GivenDateKey, 4) 
						WHEN left(right(db.GivenDateKey, 4), 2) IN ('07','08') then 'Aug - Jul '+ Left(db.GivenDateKey, 4) 
						WHEN left(right(db.GivenDateKey, 4), 2) IN ('09','10') then 'Oct - Sept '+ Left(db.GivenDateKey, 4) 
						WHEN left(right(db.GivenDateKey, 4), 2) IN ('11','12') then 'Dec - Nov '+ Left(db.GivenDateKey, 4) 
					END AS GrpDateName,
					CASE WHEN (dr.ResponseCode in ('01','-1') and dc.Category <> 'Net Promoter') THEN msr.BranchCount
					END BranchCount,
					ROUND(100*CASE WHEN (dr.ResponseCode IN ('01','-1') 
											AND dc.Category <> 'Net Promoter'
											AND dq.ShortQuestion not like 'Health Seeker%')
										OR (dr.ResponseCode in ('10','09','06','05','04','03','02','01')
											AND dc.Category = 'Net Promoter')
										OR msr.Segment = 'Health Seeker' THEN msr.BranchPercentage END, 0)
					AS BranchPercentage,
					ROUND(100*CASE WHEN (dr.ResponseCode IN ('01','-1') 
											AND dc.Category <> 'Net Promoter'
											AND dq.ShortQuestion not like 'Health Seeker%')
										OR (dr.ResponseCode in ('10','09','06','05','04','03','02','01')
											AND dc.Category = 'Net Promoter')
										OR msr.Segment = 'Health Seeker' THEN msr.PreviousBranchPercentage END, 0)
					AS PreviousBranchPercentage,
					RANK() OVER (PARTITION BY db.BranchKey ORDER BY db.GivenDateKey DESC) AS CurrentSurveyIndicator

			FROM	dbo.factBranchNewMemberExperienceReport AS msr 
					INNER JOIN dd.factNewMemDashboardBase db
						ON msr.BranchKey = db.BranchKey
							AND msr.batch_key = db.batch_key
							AND msr.GivenDateKey = db.GivenDateKey
					INNER JOIN dbo.dimBranch AS D
						ON msr.BranchKey = D.BranchKey
					INNER JOIN dbo.dimSurveyQuestion AS dq 
						ON msr.SurveyQuestionKey = dq.SurveyQuestionKey 
					INNER JOIN dbo.dimQuestionCategory AS dc 
						ON dq.SurveyQuestionKey = dc.SurveyQuestionKey 
							AND dc.CategoryType = 'Dashboard'
							--AND CategoryType = 'Reporting'
							AND dc.Category <> 'Survey Responders'
					INNER JOIN dbo.dimQuestionResponse AS dr 
						ON msr.QuestionResponseKey = dr.QuestionResponseKey 
							AND dr.ResponseCode <> '-1'
					INNER JOIN Seer_MDM.dbo.Batch B
						ON db.batch_key = B.batch_key
						
			WHERE	(dq.ShortQuestion not like 'Health Seeker%'
					OR msr.Segment = 'Health Seeker')
					AND msr.current_indicator = 1
			
			) bs
			
	WHERE	DATEADD(MM, 1, CONVERT(DATE, CONVERT(VARCHAR(20), bs.GivenDateKey))) < GETDATE()
			
	GROUP BY bs.AssociationKey,
			bs.BranchKey,
			bs.batch_key,
			bs.GivenDateKey,
			bs.PreviousGivenDateKey,
			bs.current_indicator,
			bs.CurrentSurveyIndicator,
			bs.AssociationNumber, 
			bs.AssociationName,
			bs.Association,
			bs.OfficialBranchNumber, 
			bs.OfficialBranchName,
			bs.Branch,
			bs.Question,
			bs.ShortQuestion,
			bs.QuestionPosition,
			bs.CategoryType,
			bs.Category, 
			bs.CategoryPosition, 
			bs.GrpDateName,
			bs.GivenSurveyDate,
			bs.SurveyYear,
			bs.PreviousSurveyYear,
			bs.BranchCount
	;
COMMIT TRAN

BEGIN TRAN

	MERGE	Seer_ODS.dd.factNewMemBranchExperienceReport AS target
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
					A.Question,
					A.ShortQuestion,
					A.QuestionCode,
					A.QuestionPosition,
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.CurrentSurveyYear,
					A.PreviousSurveyYear,
					A.BranchPercentage,
					A.CurrentPercentage,
					A.PreviousPercentage
					
			FROM	#NMBER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
				
			WHEN MATCHED AND (target.[GivenDateKey] <> source.[GivenDateKey]
								 OR target.[PreviousGivenDateKey] <> source.[PreviousGivenDateKey]
								 OR target.[CurrentSurveyIndicator] <> source.[CurrentSurveyIndicator]
								 OR target.[AssociationNumber] <> source.[AssociationNumber]
								 OR target.[AssociationName] <> source.[AssociationName]
								 OR target.[Association] <> source.[Association]
								 OR target.[OfficialBranchNumber] <> source.[OfficialBranchNumber]
								 OR target.[OfficialBranchName] <> source.[OfficialBranchName]
								 OR target.[Branch] <> source.[Branch]
								 OR target.[GivenSurveyDate] <> source.[GivenSurveyDate]
								 OR target.[SurveyYear] <> source.[SurveyYear]
								 OR target.[PreviousSurveyYear] <> source.[PreviousSurveyYear]
								 OR target.[ShortQuestion] <> source.[ShortQuestion]
								 OR target.[QuestionCode] <> source.[QuestionCode]
								 OR target.[QuestionPosition] <> source.[QuestionPosition]
								 OR target.[CategoryPosition] <> source.[CategoryPosition]
								 OR target.[GivenSurveyCategory] <> source.[GivenSurveyCategory]
								 OR target.[BranchPercentage] <> source.[BranchPercentage]
								 OR target.[CurrentPercentage] <> source.[CurrentPercentage]
								 OR target.[PreviousPercentage] <> source.[PreviousPercentage]
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
					[Question],
					[ShortQuestion],
					[QuestionCode],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[GivenSurveyCategory], 
					[GivenSurveyDate],
					[SurveyYear],
					[CurrentSurveyYear],
					[PreviousSurveyYear],
					[BranchPercentage],
					[CurrentPercentage],
					[PreviousPercentage]
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
					[Question],
					[ShortQuestion],
					[QuestionCode],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[GivenSurveyCategory], 
					[GivenSurveyDate],
					[SurveyYear],
					[CurrentSurveyYear],
					[PreviousSurveyYear],
					[BranchPercentage],
					[CurrentPercentage],
					[PreviousPercentage]
					)		
	;
COMMIT TRAN

BEGIN TRAN
	MERGE	Seer_ODS.dd.factNewMemBranchExperienceReport AS target
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
					A.Question,
					A.ShortQuestion,
					A.QuestionCode,
					A.QuestionPosition,
					A.CategoryType,
					A.Category, 
					A.CategoryPosition, 
					A.GivenSurveyCategory,
					A.GivenSurveyDate,
					A.SurveyYear,
					A.CurrentSurveyYear,
					A.PreviousSurveyYear,
					A.BranchPercentage,
					A.CurrentPercentage,
					A.PreviousPercentage
					
			FROM	#NMBER A

			) AS source
			
			ON target.AssociationKey = source.AssociationKey
				AND target.BranchKey = source.BranchKey
				AND target.batch_key = source.batch_key
				AND target.current_indicator = source.current_indicator
				AND target.Question = source.Question
				AND target.Category = source.Category
				AND target.CategoryType = source.CategoryType
						
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
					[Question],
					[ShortQuestion],
					[QuestionCode],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[GivenSurveyCategory], 
					[GivenSurveyDate],
					[SurveyYear],
					[CurrentSurveyYear],
					[PreviousSurveyYear],
					[BranchPercentage],
					[CurrentPercentage],
					[PreviousPercentage]
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
					[Question],
					[ShortQuestion],
					[QuestionCode],
					[QuestionPosition],
					[CategoryType],
					[Category], 
					[CategoryPosition], 
					[GivenSurveyCategory], 
					[GivenSurveyDate],
					[SurveyYear],
					[CurrentSurveyYear],
					[PreviousSurveyYear],
					[BranchPercentage],
					[CurrentPercentage],
					[PreviousPercentage]
					)
	;
COMMIT TRAN

BEGIN TRAN

	drOP TABLE #NMBER;
	
COMMIT TRAN
	
END








