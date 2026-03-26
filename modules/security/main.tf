locals {
  name_prefix               = "${var.project_name}-${var.environment}"
  trail_name                = coalesce(var.trail_name, "${local.name_prefix}-cloudtrail")
  cloudtrail_bucket_name    = var.cloudtrail_s3_bucket_name
  config_bucket_name        = coalesce(var.config_s3_bucket_name, "${local.name_prefix}-config")
  cloudtrail_log_group_name = "/aws/cloudtrail/${local.name_prefix}"
  sns_topic_name            = "${local.name_prefix}-alerts"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# ============================================================================
# CloudTrail S3 Bucket
# ============================================================================

resource "aws_s3_bucket" "cloudtrail" {
  bucket = local.cloudtrail_bucket_name

  tags = merge(var.tags, {
    Name = local.cloudtrail_bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_lifecycle" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "cloudtrail-retention"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }
  }
}

data "aws_iam_policy_document" "cloudtrail_bucket" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_bucket.json
}

# ============================================================================
# CloudWatch Log Group for CloudTrail
# ============================================================================

resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = local.cloudtrail_log_group_name
  retention_in_days = var.cloudtrail_log_group_retention_in_days

  tags = var.tags
}

data "aws_iam_policy_document" "cloudtrail_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudtrail_to_cloudwatch" {
  name               = "${local.name_prefix}-cloudtrail-to-cw-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "cloudtrail_to_cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.cloudtrail.arn}:*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail_to_cloudwatch" {
  name   = "${local.name_prefix}-cloudtrail-to-cw-policy"
  role   = aws_iam_role.cloudtrail_to_cloudwatch.id
  policy = data.aws_iam_policy_document.cloudtrail_to_cloudwatch.json
}

# ============================================================================
# CloudTrail
# ============================================================================

resource "aws_cloudtrail" "this" {
  name                          = local.trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.enable_multi_region_trail
  enable_log_file_validation    = var.enable_log_file_validation

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cloudwatch.arn

  depends_on = [
    aws_s3_bucket_policy.cloudtrail,
    aws_iam_role_policy.cloudtrail_to_cloudwatch
  ]

  tags = var.tags
}

# ============================================================================
# GuardDuty
# ============================================================================

resource "aws_guardduty_detector" "this" {
  count  = var.enable_guardduty ? 1 : 0
  enable = true

  tags = var.tags
}

# ============================================================================
# Inspector
# ============================================================================

resource "aws_inspector2_enabler" "this" {
  count           = var.enable_inspector ? 1 : 0
  account_ids     = [data.aws_caller_identity.current.account_id]
  resource_types  = var.inspector_resource_types
}

# ============================================================================
# Security Hub
# ============================================================================

resource "aws_securityhub_account" "this" {
  count = var.enable_securityhub ? 1 : 0
}

# ============================================================================
# AWS Config
# ============================================================================

resource "aws_s3_bucket" "config" {
  count  = var.enable_config ? 1 : 0
  bucket = local.config_bucket_name

  tags = merge(var.tags, {
    Name = local.config_bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "config" {
  count  = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "config" {
  count  = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count  = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "config_lifecycle" {
  count  = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config[0].id

  rule {
    id     = "config-retention"
    status = "Enabled"

    filter {}

    expiration {
      days = 365
    }
  }
}

data "aws_iam_policy_document" "config_bucket" {
  count = var.enable_config ? 1 : 0

  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl", "s3:ListBucket"]
    resources = [aws_s3_bucket.config[0].arn]
  }

  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.config[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "config" {
  count  = var.enable_config ? 1 : 0
  bucket = aws_s3_bucket.config[0].id
  policy = data.aws_iam_policy_document.config_bucket[0].json
}

data "aws_iam_policy_document" "config_assume_role" {
  count = var.enable_config ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "config" {
  count              = var.enable_config ? 1 : 0
  name               = "${local.name_prefix}-config-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role[0].json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "config_managed" {
  count      = var.enable_config ? 1 : 0
  role       = aws_iam_role.config[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "this" {
  count    = var.enable_config ? 1 : 0
  name     = "${local.name_prefix}-config-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  count          = var.enable_config ? 1 : 0
  name           = "${local.name_prefix}-config-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config[0].bucket
  snapshot_delivery_properties {
    delivery_frequency = var.config_snapshot_delivery_frequency
  }

  depends_on = [
    aws_config_configuration_recorder.this,
    aws_s3_bucket_policy.config
  ]
}

resource "aws_config_configuration_recorder_status" "this" {
  count      = var.enable_config ? 1 : 0
  name       = aws_config_configuration_recorder.this[0].name
  is_enabled = true

  depends_on = [
    aws_config_delivery_channel.this
  ]
}

resource "aws_config_config_rule" "s3_bucket_server_side_encryption_enabled" {
  count = var.enable_config && var.enable_config_managed_rules ? 1 : 0
  name  = "${local.name_prefix}-s3-bucket-sse-enabled"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder_status.this]
}

resource "aws_config_config_rule" "encrypted_volumes" {
  count = var.enable_config && var.enable_config_managed_rules ? 1 : 0
  name  = "${local.name_prefix}-encrypted-volumes"

  source {
    owner             = "AWS"
    source_identifier = "ENCRYPTED_VOLUMES"
  }

  depends_on = [aws_config_configuration_recorder_status.this]
}

resource "aws_config_config_rule" "root_account_mfa_enabled" {
  count = var.enable_config && var.enable_config_managed_rules ? 1 : 0
  name  = "${local.name_prefix}-root-account-mfa-enabled"

  source {
    owner             = "AWS"
    source_identifier = "ROOT_ACCOUNT_MFA_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder_status.this]
}

# ============================================================================
# SNS Topic for Notifications
# ============================================================================

resource "aws_sns_topic" "security_alerts" {
  count = var.enable_notifications ? 1 : 0
  name  = local.sns_topic_name

  tags = merge(var.tags, {
    Name = local.sns_topic_name
  })
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = var.enable_notifications ? 1 : 0

  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.security_alerts[0].arn]
  }
}

resource "aws_sns_topic_policy" "security_alerts" {
  count  = var.enable_notifications ? 1 : 0
  arn    = aws_sns_topic.security_alerts[0].arn
  policy = data.aws_iam_policy_document.sns_topic_policy[0].json
}