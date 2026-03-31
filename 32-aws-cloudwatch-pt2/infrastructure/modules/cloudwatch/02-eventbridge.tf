resource "aws_cloudwatch_event_rule" "system_stress_rule" {
  name        = "Capture-SystemStress-Alarms"
  description = "Capture SystemStress alarms which are in ALARM state"


  event_pattern = jsonencode({
    source      = ["aws.cloudwatch"]
    detail-type = ["CloudWatch Alarm State Change"]
    detail = {
      state = {
        value = ["ALARM"]
      }
      alarmName = [{ "prefix" : "SystemStress-" }]
    }
  })
}

