require 'yaml'
require 'rubygems'
require 'json'
require "march_hare"

conn = MarchHare.connect(:host => "10.88.2.212", :user => "bugsadmin", :password => "123Empirix!")

$channel_core_webapp = conn.create_channel
$queue_core_webapp = $channel_core_webapp.queue('vwcore_test')

$channel_core_jcc = conn.create_channel
$queue_core_jcc = $channel_core_jcc.queue('vwcore_test2')

$channel_webapp = conn.create_channel
$queue_webapp = $channel_webapp.queue('vwwebapp_test')

begin
  puts " [*] Waiting for messages on queue #{$queue_core_webapp.name}. To exit press CTRL+C"
  $queue_core_webapp.subscribe do |delivery_info, properties, body|
    core_str = JSON.parse(body)
    puts "Message on webapp_queue: #{core_str}"

    send core_str['method'].to_sym, core_str['params'], core_str['id']
  end

  puts " [*] Waiting for messages on queue #{$queue_core_jcc.name}. To exit press CTRL+C"
  $queue_core_jcc.subscribe do |delivery_info, properties, body|
    core_str = JSON.parse(body)
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

  message.to_json
end
  

def get_test_results(params, request_id)
  retrieval_timestamp = ''.to_i.zero? ? Time.now.utc : Time.at(''.to_i).utc
  duration_in_secs = '86400'.to_i
  
  f = File.open('test_results_big.json', 'r')
  result = f.read
  result = {'result' => 'none'} if result.empty?
  
  to_webapp = create_json_rpc_message('returned_results', result, request_id)
  p Time.now
  p 'After serializing to json'
 
  $channel_webapp.default_exchange.publish(to_webapp, :routing_key => $queue_webapp.name)
  p Time.now
  p 'After publishing'
end

get_test_results('',1)


