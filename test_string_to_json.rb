require 'json'

test_details = <<-EOS
{
  "TotalTestRuns":100,
  "Details":[
    {
      "TestRunTime":"03/01/2014 10:10 AM",
      "Metrics":[
        {
          "Name":"PESQ",
          "Value":4.5,
          "Description":"Voice Quality Metric",
          "Unit":"PESQ",
          "Category":"VQ"
        },
        {
          "Name":"Test Duration",
          "Value":10,
          "Description":"Duration of the test",
          "Unit":"Seconds",
          "Category":"Other"
        }
      ],
      "CallRecordingURL":"http://vw.com/12830192890183.wav",
      "AlertInfo":[
        {
          "Name":"Alert Name",
          "Level":"Critical",
          "Description":"This is a test alert",
          "Time":"03/03/2013 10:15 AM",
          "NotificationPlan":{
            "Name":"Notification Plan Name",
            "Type":"Email",
            "Description":"This is a Test Notification Plan",
            "To":[
              "xyz@empirix.com",
              "abc@empirix.com"
            ]
          }
        }
      ]
    }
  ],
  "TestInfo":{
    "Name":"Demo Test",
    "Scripts":"IVRNavigation.sbx",
    "InputParams":{
      "phone_num":"1-800-229-2993",
      "account num":129938291
    },
    "SubscriptionStartDate":"1/1/2012 10:00 PM",
    "SubscriptionEndDate":"1/1/2015 10:00 PM",
    "ScheduleInfo":"Runs every 10 mins WeekDays"
  }
}
EOS
p JSON.parse(test_details).to_json