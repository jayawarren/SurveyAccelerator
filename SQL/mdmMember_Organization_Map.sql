USE [Seer_MDM]
GO

/****** Object:  Table [dbo].[Member_Organization_Map]    Script Date: 08/11/2013 11:50:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Member_Organization_Map](
	[member_organization_map_key] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[member_key] [int] DEFAULT 0,
	[organization_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1
) ON [TRXGROUP]

GO

SET ANSI_PADDING OFF
GO

