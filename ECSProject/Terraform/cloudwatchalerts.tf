# CloudWatch Alerts for API Gateway (SNS Notification)

resource "aws_sns_topic" "cloudwatchalerts_apigw" {
  name = "cloudwatchalerts-apigw-alerts"
}

resource "aws_cloudwatch_metric_alarm" "cloudwatchalerts_apigw_request_count" {
  alarm_name          = "cloudwatchalerts-apigw-high-request-count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Count"
  namespace           = "AWS/ApiGateway"
  period              = 300 # 5 minutes
  statistic           = "Sum"
  threshold           = var.cloudwatchalerts_threshold # Parameterized threshold
  alarm_description   = "Alarm when API Gateway request count exceeds threshold"
  dimensions = {
    ApiName = aws_apigatewayv2_api.http_api.name # Use the actual API Gateway resource from apigateway.tf
  }
  alarm_actions = [aws_sns_topic.cloudwatchalerts_apigw.arn]
}

resource "aws_sns_topic_subscription" "cloudwatchalerts_email" {
  topic_arn = aws_sns_topic.cloudwatchalerts_apigw.arn
  protocol  = "email"
  endpoint  = var.cloudwatchalerts_email # Parameterized email address
}

output "cloudwatchalerts_apigw_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cloudwatchalerts_apigw_request_count.arn
  description = "ARN of the API Gateway request count alarm."
}

output "cloudwatchalerts_apigw_sns_topic_arn" {
  value = aws_sns_topic.cloudwatchalerts_apigw.arn
  description = "SNS topic ARN for API Gateway CloudWatch alerts."
}
