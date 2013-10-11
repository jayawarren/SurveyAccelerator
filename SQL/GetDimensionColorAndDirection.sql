USE [Seer_ODS]
GO

/****** Object:  UserDefinedFunction [dd].[GetDimensionColorAndDirection]    Script Date: 08/04/2013 18:03:17 ******/
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
CREATE FUNCTION [dd].[GetDimensionColorAndDirection]
(	
	@ColorTestValue float,
	@DirectionTestValue float,
	@LowerLimit float,
	@UpperLimit float,
	@Buckets int
)
RETURNS varchar(10)
AS
BEGIN
	DECLARE @ResultVar varchar(10)
	
	SELECT @ResultVar = 
		--first set the color
		
		case
			when @Buckets = 5 then 
				case					
					when 0 < @ColorTestValue and @ColorTestValue < 20 then '1br'
					when 20 <= @ColorTestValue and @ColorTestValue < 45 then '2lr'
					when 45 <= @ColorTestValue and @ColorTestValue < 55 then '3yy'
					when 55 <= @ColorTestValue and @ColorTestValue < 80 then '4lg'
					when 80 <= @ColorTestValue then '5bg'
				end 
			else --only three buckets
				case
					when @ColorTestValue < @LowerLimit then '1br'
					when @ColorTestValue > @UpperLimit then '5bg'
					else '3yy'
				end 
		end
		--now set the direction
		+
		
		case						
			when @DirectionTestValue < @LowerLimit then 'dn'
			when @DirectionTestValue > @UpperLimit then 'up'
			else 'sq'
		end
		
	RETURN ISNULL(@ResultVar, '0na')
END

GO


