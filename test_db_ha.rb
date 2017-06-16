require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'

read_cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://vwdbln.empirix.com;databaseName=vwdb_dr;applicationIntent=ReadOnly;multiSubnetFailover=true'
username: 'sa'
password: '123Empirix!'
driver: "com.microsoft.sqlserver.jdbc.SQLServerDriver"
END_CFG

$read_cfg = YAML::load(read_cfg_str)
p $read_cfg

class ReadBaseClass < ActiveRecord::Base
  self.abstract_class = true
  establish_connection $read_cfg
  puts "established read connection"
end

class ReadHaTest < ReadBaseClass
  self.table_name = 'ha_tests'
end

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
p ActiveRecord::Base.connection

class HaTest < ActiveRecord::Base
  self.table_name = 'ha_tests'
  
  def did_lose_sqlserver_connection(connection)
    puts "CONNECTION LOST: #{connection.class.name}"
    puts Time.now
    puts "Now do something!!!!"
  end
  
  def did_retry_sqlserver_connection(connection, count)
    puts "CONNECTION RETRY: #{connection.class.name} retry ##{count}."
    puts "Retrying..."
    puts Time.now
  end
end 

=begin
i = 0
#(0..10).each do
loop do
  begin
    p i
    x = HaTest.create(:user_name => "blah#{i}", :activity => "add_row#{i}")
    #y = ReadHaTest.where(:user_name => "blah#{i}").order(created_at: :desc).first
    
    p x#,y
    i = i + 1
  rescue ActiveRecord::JDBCError
    ActiveRecord::Base.establish_connection($write_cfg)
  end
end
=end