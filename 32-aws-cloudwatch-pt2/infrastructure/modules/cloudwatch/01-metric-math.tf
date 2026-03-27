locals {
  instances = {
    "web-1"    = var.web_instance_id
    "api-1"    = var.api_instance_id
    "worker-1" = var.worker_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "system_stress_alarm" {
  for_each            = local.instances
  alarm_name          = "SystemStress-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 3
  alarm_description   = "Advanced alarm for ${each.key}. Triggers if equal to or more than 3 stress conditions are met."

  metric_query {
    id          = "e1"
    expression  = "IF(m1 > 80, 1, 0) + IF(m2 > 20, 1, 0) + IF(m3 > 85, 1, 0) + IF(m4 > 524288000, 1, 0)"
    label       = "System Stress Score"
    return_data = true
  }

  metric_query {
    id = "m1"
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      period      = 60
      stat        = "Average"
      dimensions = {
        InstanceId = each.value
      }
    }
  }

  metric_query {
    id = "m2"
    metric {
      metric_name = "cpu_usage_iowait"
      namespace   = "CWAgent"
      period      = 60
      stat        = "Average"
      dimensions = {
        InstanceId = each.value
      }
    }
  }

  metric_query {
    id = "m3"
    metric {
      metric_name = "disk_used_percent"
      namespace   = "CWAgent"
      period      = 60
      stat        = "Average"
      dimensions = {
        InstanceId = each.value
      }
    }
  }

  metric_query {
    id = "m4"
    metric {
      metric_name = "bytes_sent"
      namespace   = "CWAgent"
      period      = 60
      stat        = "Average"
      dimensions = {
        InstanceId = each.value
      }
    }
  }
}
