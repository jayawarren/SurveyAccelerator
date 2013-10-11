USE [Seer_STG]
GO

/****** Object:  Index [MBR_INDEX_01]    Script Date: 08/15/2013 16:33:56 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Member]') AND name = N'MBR_INDEX_01')
DROP INDEX [MBR_INDEX_01] ON [dbo].[Member] WITH ( ONLINE = OFF )
GO
/****** Object:  Index [MBR_INDEX_02]    Script Date: 08/15/2013 16:34:07 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Member]') AND name = N'MBR_INDEX_02')
DROP INDEX [MBR_INDEX_02] ON [dbo].[Member] WITH ( ONLINE = OFF )
GO
/****** Object:  Index [MBR_INDEX_03]    Script Date: 08/15/2013 16:34:16 ******/
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Member]') AND name = N'MBR_INDEX_03')
DROP INDEX [MBR_INDEX_03] ON [dbo].[Member] WITH ( ONLINE = OFF )
GO

/****** Object:  Index [MBR_INDEX_01]    Script Date: 08/15/2013 16:33:57 ******/
CREATE NONCLUSTERED INDEX [MBR_INDEX_01] ON [dbo].[Member] 
(
	[Member_Key] ASC,
	[ProgramSiteLocation] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [NDXGROUP]
GO

/****** Object:  Index [MBR_INDEX_02]    Script Date: 08/15/2013 16:34:07 ******/
CREATE NONCLUSTERED INDEX [MBR_INDEX_02] ON [dbo].[Member] 
(
	[MemberCleansedID] ASC,
	[ProgramSiteLocation] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [NDXGROUP]
GO

/****** Object:  Index [MBR_INDEX_03]    Script Date: 08/15/2013 16:34:16 ******/
CREATE NONCLUSTERED INDEX [MBR_INDEX_03] ON [dbo].[Member] 
(
	[ProgramSiteLocation] ASC,
	[Member_Key] ASC,
	[MemberCleansedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [NDXGROUP]
GO


