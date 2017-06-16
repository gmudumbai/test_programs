require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'

cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://vwdbln.empirix.com;databaseName=vwdb_dr;applicationIntent=ReadWrite;multiSubnetFailover=true'
port: 1433
username: 'sa'
password: '123Empirix!'
driver: "com.microsoft.sqlserver.jdbc.SQLServerDriver"
autocommit: true
pool: 240
END_CFG

cfg = YAML::load(cfg_str)
p cfg

ActiveRecord::Base.establish_connection(cfg)

admin_dashboard = <<EOS
If(OBJECT_ID('tempdb..#admin_dashboard') Is Not Null)
BEGIN
    Drop Table #admin_dashboard
END

CREATE TABLE #admin_dashboard(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[interval] [int] NULL,	
	[pass] [int] NULL,
	[fail] [int] NULL,
	[alerts] [int] NULL
);


CREATE TABLE #all_test_instances_72(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [int] NULL,
	[pass] [int] NULL,
	[fail] [int] NULL,
	[alerts] [int] NULL
);
CREATE TABLE #all_test_instances_24(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [int] NULL,
	[pass] [int] NULL,
	[fail] [int] NULL,
	[alerts] [int] NULL
);
CREATE TABLE #all_test_instances_1(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[client_id] [int] NULL,
	[pass] [int] NULL,
	[fail] [int] NULL,
	[alerts] [int] NULL
);


EXEC sp_MSforeachtable 
@command1 = '
INSERT INTO #all_test_instances_72
SELECT client_id,
    SUM(CASE WHEN failed = 0 THEN 1 ELSE 0 END) AS pass,
    SUM(CASE WHEN failed = 1 THEN 1 ELSE 0 END) AS fail,
    SUM(total_alerts) AS alerts
  FROM ?
  WHERE start_time >= DATEADD(hh, -72, CURRENT_TIMESTAMP)
    AND end_time IS NOT NULL
  GROUP BY client_id
PRINT ''DONE ?''',
@whereand='AND O.name LIKE ''%test_instances_%'''


INSERT INTO #admin_dashboard
SELECT 72, SUM(pass) AS pass, SUM(fail) AS fail, SUM(alerts) AS alerts
FROM #all_test_instances_72


EXEC sp_MSforeachtable 
@command1 = '
INSERT INTO #all_test_instances_24
SELECT client_id,
    SUM(CASE WHEN failed = 0 THEN 1 ELSE 0 END) AS pass,
    SUM(CASE WHEN failed = 1 THEN 1 ELSE 0 END) AS fail,
    SUM(total_alerts) AS alerts
  FROM ?
  WHERE start_time >= DATEADD(hh, -24, CURRENT_TIMESTAMP)
    AND end_time IS NOT NULL
  GROUP BY client_id
PRINT ''DONE ?''',
@whereand='AND O.name LIKE ''%test_instances_%'''


INSERT INTO #admin_dashboard
SELECT 24, SUM(pass) AS pass, SUM(fail) AS fail, SUM(alerts) AS alerts
FROM #all_test_instances_24



EXEC sp_MSforeachtable 
@command1 = '
INSERT INTO #all_test_instances_1
SELECT client_id,
    SUM(CASE WHEN failed = 0 THEN 1 ELSE 0 END) AS pass,
    SUM(CASE WHEN failed = 1 THEN 1 ELSE 0 END) AS fail,
    SUM(total_alerts) AS alerts
  FROM ?
  WHERE start_time >= DATEADD(hh, -1, CURRENT_TIMESTAMP)
    AND end_time IS NOT NULL
  GROUP BY client_id
PRINT ''DONE ?''',
@whereand='AND O.name LIKE ''%test_instances_%'''


INSERT INTO #admin_dashboard
SELECT 1, SUM(pass) AS pass, SUM(fail) AS fail, SUM(alerts) AS alerts
FROM #all_test_instances_1

If(OBJECT_ID('tempdb..#all_test_instances_72') Is Not Null)
Begin
    Drop Table #all_test_instances_72
End
If(OBJECT_ID('tempdb..#all_test_instances_24') Is Not Null)
Begin
    Drop Table #all_test_instances_24
End
If(OBJECT_ID('tempdb..#all_test_instances_1') Is Not Null)
Begin
    Drop Table #all_test_instances_1
End

SELECT * FROM #admin_dashboard

EOS

p ActiveRecord::Base.connection.select_all(admin_dashboard).to_hash