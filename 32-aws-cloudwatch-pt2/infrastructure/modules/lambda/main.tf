data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/src/alert.py"
  output_path = "${path.module}/alert.zip"
}

resource "aws_lambda_function" "alerter_function" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "SystemStressAlerter"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "alert.lambda_handler"
  runtime          = "python3.13"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = var.eventbridge_rule_name
  target_id = "TriggerAlerterLambda"
  arn       = aws_lambda_function.alerter_function.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alerter_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.eventbridge_rule_arn
}
