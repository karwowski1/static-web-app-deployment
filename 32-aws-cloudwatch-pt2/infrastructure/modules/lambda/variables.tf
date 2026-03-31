variable "slack_webhook_url" {
  description = "URL address of the Slack webhook to send notifications to"
  type        = string
}

variable "eventbridge_rule_name" {
  description = "Name of the EventBridge rule capturing alarms"
  type        = string
}

variable "eventbridge_rule_arn" {
  description = "ARN of the EventBridge rule capturing alarms"
  type        = string
}
