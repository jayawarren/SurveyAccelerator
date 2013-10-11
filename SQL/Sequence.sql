CREATE TABLE dbo.Sequence
(
sequence_key int not null identity(1, 1) PRIMARY KEY,
audit_key int not null default 0,
create_datetime datetime default getdate(),
current_indicator bit default 1,
sequence_id varchar(50) default '',
begin_datetime datetime default getdate(),
end_datetime datetime default dateadd(YY, 100, getdate()),
runtime_minutes AS (CONVERT(DECIMAL(10, 2), DATEDIFF(SS, begin_datetime, CASE WHEN end_datetime = DATEADD(YY, 100, begin_datetime) THEN GETDATE() ELSE end_datetime END), 0)/60),
status_indicator bit default 1,
sequence_status varchar(25) default '',
sequence_name varchar(75) default '',
task_description varchar(255) default ''
)
ON DIMGROUP