variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "Primary AWS region"
  type        = string
}

variable "trail_name" {
  description = "CloudTrail name"
  type        = string
  default     = null
}

variable "cloudtrail_s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

variable "cloudtrail_log_group_retention_in_days" {
  description = "Retention for CloudTrail CloudWatch log group"
  type        = number
  default     = 90
}

variable "enable_multi_region_trail" {
  description = "Enable multi-region CloudTrail"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Enable CloudTrail log file validation"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service events in CloudTrail"
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_inspector" {
  description = "Enable Amazon Inspector v2"
  type        = bool
  default     = true
}

variable "inspector_resource_types" {
  description = "Inspector v2 resource types to enable"
  type        = list(string)
  default     = ["ECR"]
}

variable "enable_securityhub" {
  description = "Enable Security Hub"
  type        = bool
  default     = true
}

variable "enable_config" {
  description = "Enable AWS Config baseline"
  type        = bool
  default     = true
}

variable "config_s3_bucket_name" {
  description = "S3 bucket name for AWS Config delivery"
  type        = string
  default     = null
}

variable "config_snapshot_delivery_frequency" {
  description = "AWS Config snapshot delivery frequency"
  type        = string
  default     = "TwentyFour_Hours"
}

variable "enable_config_managed_rules" {
  description = "Enable a small starter set of AWS Config managed rules"
  type        = bool
  default     = true
}

variable "enable_notifications" {
  description = "Enable SNS topic and EventBridge notifications"
  type        = bool
  default     = false
}

variable "notification_emails" {
  description = "List of email addresses for security notifications"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}