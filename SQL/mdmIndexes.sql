DROP INDEX [Member Response Data].MRD_INDEX_01
go
DROP INDEX [Member Response Data].MRD_INDEX_02
go
DROP INDEX [Member].MRD_INDEX_03
go
CREATE INDEX MRD_INDEX_01 ON dbo.[Member Response Data](Member_Key, Q_27, Q_28) ON NDXGROUP
go
CREATE INDEX MRD_INDEX_02 ON dbo.[Member Response Data](SeerKey, Q_27, Q_28) ON NDXGROUP
go
CREATE INDEX MBR_INDEX_03 ON dbo.[Member](Member_Key, MemberCleansedID) ON NDXGROUP
go
