security module

This module enables a foundational AWS security and audit baseline for an environment.

It is designed to provision core monitoring, logging, compliance, and alerting services such as:

AWS CloudTrail
CloudWatch Logs for CloudTrail
S3 bucket for CloudTrail logs
AWS Config
Amazon SNS notifications
Optional GuardDuty
Optional Amazon Inspector
Optional Security Hub

This module is intended to be reused from a root Terraform project.

Version

1.0.0

What this module creates

Depending on the enabled options, this module can create:

CloudTrail trail
S3 bucket for CloudTrail logs
CloudWatch log group for CloudTrail
IAM role and policy for CloudTrail → CloudWatch Logs
GuardDuty detector
Amazon Inspector v2 enabler
Security Hub account enablement
AWS Config recorder and delivery channel
S3 bucket for AWS Config snapshots
Optional AWS Config managed rules
SNS topic for security notifications
SNS email subscriptions
EventBridge rules and targets for findings notifications
Features
Centralized CloudTrail logging to S3 and CloudWatch Logs
Configurable CloudWatch Logs retention
Optional multi-region CloudTrail
Optional GuardDuty enablement
Optional Inspector enablement
Optional Security Hub enablement
Optional AWS Config baseline
Optional SNS email notifications
Reusable across environments using consistent naming and tags
Inputs
Name	Description	Type	Default	Required
project_name	Project name used for naming resources	string	n/a	yes
environment	Environment name such as dev, stage, prod	string	n/a	yes
aws_region	Primary AWS region	string	n/a	yes
trail_name	Custom CloudTrail trail name	string	null	no
cloudtrail_s3_bucket_name	S3 bucket name for CloudTrail logs	string	n/a	yes
cloudtrail_log_group_retention_in_days	CloudWatch Logs retention for CloudTrail logs	number	90	no
enable_multi_region_trail	Whether CloudTrail should be multi-region	bool	true	no
enable_log_file_validation	Whether to enable CloudTrail log file validation	bool	true	no
include_global_service_events	Whether to include global service events in CloudTrail	bool	true	no
enable_guardduty	Enable GuardDuty	bool	true	no
enable_inspector	Enable Amazon Inspector v2	bool	true	no
inspector_resource_types	Resource types for Inspector v2	list(string)	["ECR"]	no
enable_securityhub	Enable Security Hub	bool	true	no
enable_config	Enable AWS Config baseline	bool	true	no
config_s3_bucket_name	S3 bucket name for AWS Config delivery	string	null	no
config_snapshot_delivery_frequency	AWS Config snapshot delivery frequency	string	"TwentyFour_Hours"	no
enable_config_managed_rules	Enable starter AWS Config managed rules	bool	true	no
enable_notifications	Enable SNS topic and notifications	bool	false	no
notification_emails	List of email addresses subscribed to SNS alerts	list(string)	[]	no
tags	Common tags to apply to resources	map(string)	{}	no
Outputs
Name	Description
cloudtrail_arn	ARN of the CloudTrail trail
cloudtrail_s3_bucket_name	Name of the CloudTrail S3 bucket
cloudtrail_log_group_name	Name of the CloudTrail CloudWatch log group
guardduty_detector_id	GuardDuty detector ID, or null if disabled
securityhub_enabled	Whether Security Hub is enabled
sns_topic_arn	ARN of the SNS topic for security alerts, or null if disabled
config_bucket_name	Name of the AWS Config S3 bucket, or null if disabled
Prerequisites
Terraform >= 1.0.0
AWS Provider compatible with the resources used in this module
Valid AWS credentials with permissions to create:
CloudTrail
S3
CloudWatch Logs
IAM roles and policies
SNS
EventBridge
AWS Config
Optional GuardDuty, Inspector, and Security Hub
Notes
1. Service availability

Some AWS accounts may not support certain services such as:

GuardDuty
Inspector
Security Hub

If your account returns subscription or access errors, disable those services using:

enable_guardduty  = false
enable_inspector  = false
enable_securityhub = false
2. SNS email subscription confirmation

When enable_notifications = true, AWS sends a confirmation email to each address in notification_emails.

Each recipient must confirm the subscription, otherwise alerts will not be delivered.