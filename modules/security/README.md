# Terraform AWS Security Baseline Module

This module helps establish a foundational security posture in an AWS account by configuring various native AWS security services.

It can enable and configure:
- **AWS CloudTrail**: Creates a multi-region trail with log file validation, sending logs to a designated S3 bucket and CloudWatch Logs.
- **Amazon GuardDuty**: Enables threat detection service.
- **Amazon Inspector v2**: Enables vulnerability management service for specified resource types.
- **AWS Security Hub**: Provides a comprehensive view of your security state in AWS.
- **AWS Config**: Creates a configuration recorder and delivery channel to assess, audit, and evaluate the configurations of your AWS resources. It can also enable a starter set of managed rules.
- **SNS Notifications**: Creates an SNS topic and uses EventBridge to send findings from various security services to a list of email subscribers.

## Usage

```hcl
module "security" {
  source = "../modules/security"

  project_name = "my-app"
  environment  = "dev"
  aws_region   = "eu-west-1"

  cloudtrail_s3_bucket_name = "my-app-dev-cloudtrail-logs"
  config_s3_bucket_name     = "my-app-dev-config-logs"

  cloudtrail_log_group_retention_in_days = 30

  enable_guardduty = true
  enable_inspector = true
  enable_securityhub = true

  enable_config               = true
  enable_config_managed_rules = true

  enable_notifications = true
  notification_emails  = ["security-alerts@example.com"]

  tags = {
    Owner       = "SecurityTeam"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project name. | `string` | n/a | yes |
| environment | Environment name. | `string` | n/a | yes |
| aws_region | Primary AWS region. | `string` | n/a | yes |
| trail_name | CloudTrail name. If null, a name is generated. | `string` | `null` | no |
| cloudtrail_s3_bucket_name | S3 bucket name for CloudTrail logs. | `string` | n/a | yes |
| cloudtrail_log_group_retention_in_days | Retention for CloudTrail CloudWatch log group. | `number` | `90` | no |
| enable_multi_region_trail | Enable multi-region CloudTrail. | `bool` | `true` | no |
| enable_log_file_validation | Enable CloudTrail log file validation. | `bool` | `true` | no |
| include_global_service_events | Include global service events in CloudTrail. | `bool` | `true` | no |
| enable_guardduty | Enable GuardDuty. | `bool` | `true` | no |
| enable_inspector | Enable Amazon Inspector v2. | `bool` | `true` | no |
| inspector_resource_types | Inspector v2 resource types to enable. | `list(string)` | `["ECR"]` | no |
| enable_securityhub | Enable Security Hub. | `bool` | `true` | no |
| enable_config | Enable AWS Config baseline. | `bool` | `true` | no |
| config_s3_bucket_name | S3 bucket name for AWS Config delivery. If null, a new bucket is created. | `string` | `null` | no |
| config_snapshot_delivery_frequency | AWS Config snapshot delivery frequency. | `string` | `"TwentyFour_Hours"` | no |
| enable_config_managed_rules | Enable a small starter set of AWS Config managed rules. | `bool` | `true` | no |
| enable_notifications | Enable SNS topic and EventBridge notifications. | `bool` | `false` | no |
| notification_emails | List of email addresses for security notifications. | `list(string)` | `[]` | no |
| tags | Common tags. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| notification_sns_topic_arn | The ARN of the SNS topic for security notifications. |