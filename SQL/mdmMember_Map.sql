drop table Member_Map
GO
CREATE TABLE [Member_Map](
	[member_map_key] [int] IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	[member_key] [int] DEFAULT 0,
	[matching_member_key] [int] DEFAULT 0,
	[seer_key] [int] DEFAULT 0,
	[organization_key] [int] DEFAULT 0,
	[create_datetime] [datetime] DEFAULT GETDATE(),
	[change_datetime] [datetime] DEFAULT GETDATE(),
	[next_change_datetime] [datetime] DEFAULT DATEADD(YY, 100, GETDATE()),
	[current_indicator] [bit] DEFAULT 1,
	[member_cleansed_id] [varchar] (50) DEFAULT '',
	[confidence_percentage] decimal (20, 5) DEFAULT 0
) ON TRXGROUP
GO


