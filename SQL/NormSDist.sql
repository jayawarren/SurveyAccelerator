USE [Seer_ODS]
GO

/****** Object:  UserDefinedFunction [dbo].[NormSDist]    Script Date: 07/27/2013 16:57:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[NormSDist]
(
    @x float
)
    RETURNS FLOAT
AS
BEGIN 
	declare @result float
    declare @L float
    declare @K float
    declare @dCND float
    declare @pi float
    declare @a1 float
    declare @a2 float
    declare @a3 float
    declare @a4 float
    declare @a5 float

    select @L = 0.0
    select @K = 0.0
    select @dCND = 0.0

    select @a1 = 0.31938153
    select @a2 = -0.356563782
    select @a3 = 1.781477937
    select @a4 = -1.821255978
    select @a5 = 1.330274429
    select @pi = 3.1415926535897932384626433832795

    select @L = Abs(@x)

   if @L >= 30
    begin
        if sign(@x) = 1
            select @result = 1
        else
            select @result = 0
    end
    else
    begin
    -- perform calculation
        select @K = 1.0 / (1.0 + 0.2316419 * @L)
        select @dCND = 1.0 - 1.0 / Sqrt(2 * @pi) * Exp(-@L * @L / 2.0) *
          (@a1 * @K + @a2 * @K * @K + @a3 * POWER(@K, 3.0) + @a4 * POWER(@K, 4.0) + @a5 * POWER (@K, 5.0))
        if (@x < 0)
            select @result = 1.0 - @dCND
        else
        SELECT @result = @dCND
		
	end
		RETURN @result
END

GO


