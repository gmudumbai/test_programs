require 'active_support/time'

test_start_time = '2015-07-11 15:29:59.000'
call_start_time = DateTime.strptime(test_start_time, '%Y-%m-%d %H:%M:%S.%L').to_i * 1000

schedule_hash = {'timezone' => 'Asia/Calcutta', 'schedules' => [{'days_of_week' => 'MON,TUE,THU,FRI', 'start_time' => '00:00', 'end_time' => '23:59'}, {'days_of_week' => 'MON,WED,FRI', 'start_time' => '11:00', 'end_time' => '20:59'}]}

def within_notification_schedule?(call_start_time, days_of_week, start_time, end_time, timezone)
  all_days_of_week = %w(SUN MON TUE WED THU FRI SAT)
  days_array = days_of_week.split(',')
  call_start_time_in_sched_tz = Time.at(call_start_time.to_i/1000).to_datetime.in_time_zone(timezone)
  puts "Call start time in notification schedule timezone: #{call_start_time_in_sched_tz}"

  days_array.include?(all_days_of_week[call_start_time_in_sched_tz.wday]) && 
    (start_time..end_time).include?(call_start_time_in_sched_tz.strftime("%H:%M"))
end
 
timezone = schedule_hash['timezone']
time_within_schedule = false
 
schedule_hash['schedules'].each do |schedule|
  time_within_schedule = within_notification_schedule?(call_start_time, schedule['days_of_week'], schedule['start_time'], schedule['end_time'], timezone)
  puts "Call within schedule #{schedule}: #{time_within_schedule}"
  break if time_within_schedule
end

p time_within_schedule
 
=begin
specified_warning_notify_count
specified_critical_notify_count

warning_notification_plan_id
critical_notification_plan_id

notify_warning_good_state
notify_critical_good_state

running_critical_notify_count
running_warning_notify_count

running_notify_critical_good_state
running_notify_warning_good_state
=end 