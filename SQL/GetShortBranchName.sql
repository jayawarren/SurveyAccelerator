USE [Seer_ODS]
GO
/****** Object:  UserDefinedFunction [dd].[GetShortBranchName]    Script Date: 08/01/2013 16:04:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- select dd.GetDimensionColorAndDirection(50, 0, -3, 3, 5)
-- =============================================
CREATE FUNCTION [dd].[GetShortBranchName]
(	
	@OfficialBranchName varchar(255)
)
RETURNS varchar(100)
AS
BEGIN
	DECLARE @ResultVar varchar(100)
	
	
	SELECT @ResultVar = 
	 CASE 
	    WHEN @OfficialBranchName = 'YMCA of the Upper Main Line'
	        THEN 'Upper Main Line YGV' 
	   
	    WHEN @OfficialBranchName = 'Upper Main Line Branch YMCA'
	     THEN 'Upper Main Line Berwyn' 
	     
	    WHEN @OfficialBranchName = 'YMCA of Metuchen'
	     THEN 'Metuchen Association Office'
	     
	    WHEN @OfficialBranchName = 'Metuchen Branch YMCA'
	     THEN 'Metuchen Branch'
	     ELSE
		LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@OfficialBranchName, 'YMCA at the', ''), 'Family', ''), 'Legacy Survey - ', ''), 'YMCA of the', ''), 'YMCA at ', ''), 'YMCAs of', ''), 'YMCA of ', ''), 'YMCA', ''), 'Branch', '')))
      END
	RETURN @ResultVar
END






