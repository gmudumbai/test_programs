require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'
require 'date'

cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://10.92.21.1;databaseName=vwdb'
username: 'webuser'
password: 'N5p@dm1n'
driver: 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
autocommit: true
END_CFG

cfg = YAML::load(cfg_str)
p cfg

ActiveRecord::Base.establish_connection(cfg)

class TestInstance < ActiveRecord::Base
end
class Test < ActiveRecord::Base
end
i = 1
#time_interval_in_hours = '1'.to_i


tests =  Test.where(:client_id => 1234)

tests.each do |test_rec|
  test_instances = TestInstance.where(:test_id => test_rec.id).order(start_time: :desc)
  
  p test_instances
end