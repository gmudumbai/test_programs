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

class Notification < ActiveRecord::Base
  self.table_name = 'notifications'
  
  serialize :users, Array
  serialize :schedules, Array
end

class TriggeredAlert < ActiveRecord::Base
  serialize :notifications_sent, Array
  serialize :notifications_attempted, Array
  serialize :notifications_limit_reached, Array
  serialize :notifications_outside_schedule, Array
end



=begin
NotificationPlan.all.each do |nplan|
  p nplan.id
  
  TriggeredAlert.where(:notification_plan_id => nplan.id).each do |ta|
    ta.notifications_sent = [{'id' => notification.id, 'name' => notification.name}]
    ta.save!
  end
  
  TriggeredAlert.where(:notification_plan_id => nplan.id).update_all(:notifications_sent => [{'id' => 21, 'name' => 'blah blah'}].to_yaml)
end



alerts = [1216280]

alerts.each do |id|
  begin
    alert = TriggeredAlert.find(id)
    puts 'Updating triggered alert table for alert id ' + alert.id.to_s
    if alert.notification_sent
      notification_index = alert.notifications_attempted.find_index {|x| x['id'] == 31}
      p notification_index
      notification = alert.notifications_attempted.delete_at(notification_index) unless notification_index.nil?
      p notification
      alert.notifications_outside_schedule << notification unless notification.nil?
      p alert.notifications_outside_schedule
      alert.alert_status = 'Alert triggered outside of notification schedule' if (alert.notifications_attempted.empty? && alert.notifications_sent.empty?)
      alert.save!
      
      p alert
    end
  rescue ActiveRecord::RecordNotFound
    puts "TriggeredAlert with id #{id} does not exist!"
  end
end
=end

ta = TriggeredAlert.find(1216332)
ta.notifications_outside_schedule << {'id' => 31, 'name' => 'blah'}
ta.save!