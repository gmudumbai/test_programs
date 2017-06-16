require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'

write_cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://vwdbln.empirix.com;databaseName=vwdb_dr;applicationIntent=ReadWrite;multiSubnetFailover=true'
username: 'sa'
password: '123Empirix!'
driver: "com.microsoft.sqlserver.jdbc.SQLServerDriver"
END_CFG

$write_cfg = YAML::load(write_cfg_str)
p $write_cfg

ActiveRecord::Base.establish_connection($write_cfg)
p 'Established ReadWrite Connection'
p 'Connection string ----------------------------------------------'
p ActiveRecord::Base.connection
 
