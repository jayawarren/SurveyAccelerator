USE [Seer_ODS]
GO
/****** Object:  UserDefinedFunction [dd].[ufnGetUsergroupAssociations]    Script Date: 09/02/2013 15:45:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dd].[ufnGetUsergroupAssociations](@originalinput AS varchar(8000) )
RETURNS
      @Result TABLE(String varchar(100))
AS
BEGIN
	IF (PATINDEX('%SEER Admins%', @originalinput)>0)
	BEGIN	
		INSERT INTO @Result	
		SELECT distinct AssociationNameEx from [dd].[vwAssociations]
	END
	ELSE
	BEGIN
	  DECLARE @input varchar(8000)	
	  SET @input = REPLACE(@originalinput, ', ', '@@space')
	
      DECLARE @str VARCHAR(100)
      DECLARE @ind Int
      IF(@input is not null)
      BEGIN
            SET @ind = CharIndex(',',@input)
            WHILE @ind > 0
            BEGIN
                  SET @str = SUBSTRING(@input,1,@ind-1)
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)
                  INSERT INTO @Result values (Replace(@str, '@@space', ', '))
                  SET @ind = CharIndex(',',@input)
            END
            SET @str = @input
            INSERT INTO @Result values (@str)
      END
    END
    RETURN
END



