output "cloudtrail_arn" {
  value       = aws_cloudtrail.this.arn
  description = "ARN of CloudTrail"
}

output "cloudtrail_s3_bucket_name" {
  value       = aws_s3_bucket.cloudtrail.bucket
  description = "CloudTrail S3 bucket name"
}

output "cloudtrail_log_group_name" {
  value       = aws_cloudwatch_log_group.cloudtrail.name
  description = "CloudTrail CloudWatch log group name"
}

output "guardduty_detector_id" {
  value       = var.enable_guardduty ? aws_guardduty_detector.this[0].id : null
  description = "GuardDuty detector ID"
}

output "securityhub_enabled" {
  value       = var.enable_securityhub
  description = "Whether Security Hub is enabled"
}

output "sns_topic_arn" {
  value       = var.enable_notifications ? aws_sns_topic.security_alerts[0].arn : null
  description = "SNS topic ARN for security alerts"
}

output "config_bucket_name" {
  value       = var.enable_config ? aws_s3_bucket.config[0].bucket : null
  description = "AWS Config S3 bucket name"
}