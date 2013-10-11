USE [Seer_ODS]
GO

/****** Object:  View [dbo].[dimOpenEndResponse]    Script Date: 07/01/2013 01:07:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER view [dbo].[dimOpenEndResponse] as
select	A.open_ends_key as OpenEndResponseKey,
		A.open_response as OpenEndResponse
		
from	dbo.Open_Ends A

where	LEN(A.open_response) > 0
		and A.current_indicator = 1



   
GO


