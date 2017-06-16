require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'
require 'multi_json'
require 'jrjackson'
require 'march_hare'

cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://10.88.3.100;databaseName=vwdb1'
username: 'webuser'
password: 'N5p@dm1n'
driver: 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
autocommit: true
END_CFG

cfg = YAML::load(cfg_str)
p cfg

ActiveRecord::Base.establish_connection(cfg)

class Test < ActiveRecord::Base
  has_many :test_instances
  has_many :schedules
end

class Schedule < ActiveRecord::Base
   belongs_to :test
end

class TestInstance < ActiveRecord::Base
   belongs_to :test
end

class TestInputParam < ActiveRecord::Base
   belongs_to :test
end



conn = MarchHare.connect(:host => "10.88.2.211", :user => "bugsadmin", :password => "123Empirix!")

$channel_core_webapp = conn.create_channel
$queue_core_webapp = $channel_core_webapp.queue('vwcore_test')

$channel_core_jcc = conn.create_channel
$queue_core_jcc = $channel_core_jcc.queue('vwcore_test2')

$channel_webapp = conn.create_channel
$queue_webapp = $channel_webapp.queue('vwwebapp_test')

begin
  puts " [*] Waiting for messages on queue #{$queue_core_webapp.name}. To exit press CTRL+C"
  $queue_core_webapp.subscribe do |metadata, body|
    puts body
    core_str = MultiJson.load(body)
    puts "Message on webapp_queue: #{core_str}"

    send core_str['method'].to_sym, core_str['params'], core_str['id']
  end

  puts " [*] Waiting for messages on queue #{$queue_core_jcc.name}. To exit press CTRL+C"
  $queue_core_jcc.subscribe do |metadata, body|
    puts body
    core_str = MultiJson.load(body)
    puts "Message on jcc_queue: #{core_str}"

    send core_str['method'].to_sym, core_str['params'], core_str['id']
  end
rescue Interrupt => _
  conn.close
end

def create_json_rpc_message(method_name, params, unique_id)
  message = Hash.new

  message['jsonrpc']  = '2.0'
  message['method'] = method_name
  message['params'] = params
  message['id'] = unique_id.to_s

  MultiJson.dump(message)
  #message.to_json
end
  

def get_test_results(params, request_id)
  retrieval_timestamp = ''.to_i.zero? ? Time.now.utc : Time.at(''.to_i).utc
  duration_in_secs = '86400'.to_i
  result = []
  p 'Start: ' + Time.now.to_s
  
  test_ids = '102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201'.split(',').map { |x| x.to_i }
  #test_ids = '102'.split(',').map { |x| x.to_i } 
  ts = TestInstance.where(:start_time => (retrieval_timestamp - duration_in_secs)..retrieval_timestamp, :test_id => test_ids)
  ts = ts.select("test_instance_id, DATEDIFF(second,{d '1970-01-01'},start_time) as test_time,
                            CAST(~failed AS INT) as instance_result, call_recording_url, total_alerts, notification_status")
  p 'After getting results: ' + Time.now.to_s 
  result = ts.map(&:serializable_hash)
  p 'After converting to serializable hash: ' + Time.now.to_s  
  
  
  result = {'result' => 'none'} if result.empty?
  
  to_webapp = create_json_rpc_message('returned_results', result, request_id)
  p 'After serializing to json: ' + Time.now.to_s 
    
  $channel_webapp.default_exchange.publish(to_webapp, :routing_key => $queue_webapp.name, :immediate => true)
  p 'After publishing: ' + Time.now.to_s
end

def get_test_results2(params, request_id)
  retrieval_timestamp = ''.to_i.zero? ? Time.now.utc : Time.at(''.to_i).utc
  duration_in_secs = '86400'.to_i
  result = []
  p 'Start: ' + Time.now.to_s
  
  test_ids = '102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201'.split(',').map { |x| x.to_i }
  #test_ids = '102'.split(',').map { |x| x.to_i } 
  
  Test.where(:id => test_ids.first(50)).each do |test|
    test_results_hash = {}
    test_results_hash['test_id'] = test.id
    test_results_hash['test_name'] = test.name
    #test_results_hash['test_tags'] = test.tags.pluck(:name)
    test_results_hash['alert_status'] = (test.alert_disabled ? 0 : 1)
    #test_results_hash['script_name'] = test.script.name
    test_results_hash['subscription_start_date'] = test.subscription_start_date.to_i
    test_results_hash['subscription_end_date'] = test.subscription_end_date.to_i

    test_results_hash['schedules'] = []
    test.schedules.each do |schedule|
      temp_hash = {}
      temp_hash['frequency'] = schedule.frequency_in_minutes
      temp_hash['schedule_table'] = JSON.parse(schedule.schedule_table_as_json)

      test_results_hash['schedules'] << temp_hash unless temp_hash.empty?
    end

    test_results_hash['schedule_info'] = []  #TODO schedule info

    ts = test.test_instances.where(:start_time => (retrieval_timestamp - duration_in_secs)..retrieval_timestamp)
    ts = ts.select("test_instance_id, DATEDIFF(second,{d '1970-01-01'},start_time) as test_time,
                              CAST(~failed AS INT) as instance_result, call_recording_url, total_alerts,
                              alert_level, notification_status")
    #p 'After getting results: ' + Time.now.to_s
    test_results_hash['test_instances'] = ts.to_a.map(&:serializable_hash)
    #p 'After converting to serializable hash: ' + Time.now.to_s

    result << test_results_hash unless test_results_hash.empty?
  end
  p 'After serialized results: ' + Time.now.to_s
  result = {'result' => 'none'} if result.empty?
  
  to_webapp = create_json_rpc_message('returned_results', result, request_id)
  p 'After serializing to json: ' + Time.now.to_s
 
  $channel_webapp.default_exchange.publish(to_webapp, :routing_key => $queue_webapp.name, :immediate => true)
  p 'After publishing: ' + Time.now.to_s
end




#puts "\n\nFIRST METHOD!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#get_test_results('',1)

#puts "\n\n\nSECOND METHOD!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#get_test_results2('',2)