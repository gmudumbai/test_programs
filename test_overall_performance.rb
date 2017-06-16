require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'
require 'json'

cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://10.92.21.1;databaseName=vwdb1'
username: 'webuser'
password: 'N5p@dm1n'
driver: 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
autocommit: true
END_CFG

cfg = YAML::load(cfg_str)
p cfg

ActiveRecord::Base.establish_connection(cfg)

group_sql = <<-EOS
DECLARE
    @hours TINYINT,
    @minute_interval TINYINT,
    @start SMALLDATETIME;

SELECT
    @hours = 24,
    @minute_interval = 10,
    @start = GETUTCDATE();

WITH x AS
(
SELECT TOP (@hours * (60 / @minute_interval)) n = ROW_NUMBER() OVER (ORDER BY column_id) FROM msdb.sys.columns),
intervals(boundary) AS
( SELECT CONVERT(SMALLDATETIME, DATEADD(MINUTE, (-n * @minute_interval), @start)) FROM x )
SELECT
  interval = DATEDIFF(second,{d '1970-01-01'},i.boundary),
  total_calls = COUNT(d.id),
  total_passed = COUNT(CASE d.failed WHEN 0 THEN 1 END),
  total_failed = COUNT(CASE d.failed WHEN 1 THEN 1 END),
  total_alerts = COUNT(d.total_alerts)
FROM
    intervals AS i
LEFT OUTER JOIN
    dbo.test_instances AS d
    ON d.start_time >= i.boundary
    AND d.start_time < DATEADD(MINUTE, @minute_interval, i.boundary)
GROUP BY i.boundary
ORDER BY i.boundary desc;
    EOS

x = ActiveRecord::Base.connection.select_all(group_sql)
#p x
  
p x.to_hash

