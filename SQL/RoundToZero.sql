USE [Seer_ODS]
GO

/****** Object:  UserDefinedFunction [dbo].[RoundToZero]    Script Date: 07/21/2013 21:11:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[RoundToZero](@Val DECIMAL(32,16), @Digits INT)
RETURNS DECIMAL(32,16)
AS
BEGIN
    RETURN CASE WHEN ABS(@Val - ROUND(@Val, @Digits, 1)) * POWER(10, @Digits+1) = 5
                THEN ROUND(@Val, @Digits, 1)
                ELSE ROUND(@Val, @Digits)
                END
END


GO


