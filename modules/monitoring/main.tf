###############################################################
# SNS Topic — Alarm Notifications
###############################################################

resource "aws_sns_topic" "alerts" {

  provider = aws.virginia

  name = "${replace(var.project_name, " ", "-")}-${var.environment}-alerts"

  tags = merge(var.tags, {
    Name = "${replace(var.project_name, " ", "-")}-${var.environment}-alerts"
  })
}

resource "aws_sns_topic_subscription" "email" {

  provider = aws.virginia

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

###############################################################
# CloudFront — Error Rate Alarms
#
# CloudFront publishes these metrics only to us-east-1.
###############################################################

resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx_error_rate" {

  provider = aws.virginia

  alarm_name        = "${replace(var.project_name, " ", "-")}-${var.environment}-cloudfront-5xx-error-rate"
  alarm_description = "Triggers when CloudFront's 5xx error rate exceeds the configured threshold."

  namespace   = "AWS/CloudFront"
  metric_name = "5xxErrorRate"
  statistic   = "Average"

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
  }

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.error_rate_threshold
  evaluation_periods  = 2
  period              = 300
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "cloudfront_4xx_error_rate" {

  provider = aws.virginia

  alarm_name        = "${replace(var.project_name, " ", "-")}-${var.environment}-cloudfront-4xx-error-rate"
  alarm_description = "Triggers when CloudFront's 4xx error rate exceeds the configured threshold."

  namespace   = "AWS/CloudFront"
  metric_name = "4xxErrorRate"
  statistic   = "Average"

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
  }

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.error_rate_threshold
  evaluation_periods  = 2
  period              = 300
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = var.tags
}

###############################################################
# WAF — Blocked Requests Alarm
#
# WAFv2 metrics for a CLOUDFRONT-scoped Web ACL are also only
# published to us-east-1.
###############################################################

resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests" {

  provider = aws.virginia

  alarm_name        = "${replace(var.project_name, " ", "-")}-${var.environment}-waf-blocked-requests"
  alarm_description = "Triggers when WAF blocks an unusually high number of requests — possible attack in progress."

  namespace   = "AWS/WAFV2"
  metric_name = "BlockedRequests"
  statistic   = "Sum"

  dimensions = {
    WebACL = var.waf_metric_name
    Rule   = "ALL"
  }

  comparison_operator = "GreaterThanThreshold"
  threshold           = var.waf_blocked_requests_threshold
  evaluation_periods  = 1
  period              = 300
  treat_missing_data  = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]

  tags = var.tags
}
