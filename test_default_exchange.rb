#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"
require 'json'

#conn = Bunny.new("amqp://user:pwd@server:5672")
conn = Bunny.new("amqp://bugsadmin:123Empirix!@10.88.2.212:5672")
#conn = Bunny.new("amqp://guest:guest@localhost:5672")
conn.start

ch = conn.create_channel
q  = ch.queue("bunny.examples.hello_world", :auto_delete => true)

q.subscribe do |delivery_info, properties, payload|
  puts "Received #{Marshal.load(payload)}"
  p payload.size
end

#f = File.open('test_results_big.json', 'r')
result = ("a" * 931055)
result = {'result' => 'none'} if result.empty?

to_webapp = Marshal.dump(result)
p Time.now
p 'After marshalling'
p to_webapp.size
  
q.publish(to_webapp, :routing_key => q.name)

p Time.now
p 'After publishing'

sleep 1.0
conn.close