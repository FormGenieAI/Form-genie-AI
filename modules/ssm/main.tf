# ============================================================================
# SSM Parameters
# ============================================================================

resource "aws_ssm_parameter" "db_host" {
  name        = "${var.prefix}/DB_HOST"
  description = "birmigham database host"
  type        = "String"
  value       = var.db_host

  lifecycle {
    ignore_changes = [value]
  }

  tags = var.tags
}

resource "aws_ssm_parameter" "db_user" {
  name        = "${var.prefix}/DB_USER"
  description = "birmigham database user"
  type        = "String"
  value       = var.db_user

  lifecycle {
    ignore_changes = [value]
  }

  tags = var.tags
}

resource "aws_ssm_parameter" "db_password" {
  name        = "${var.prefix}/DB_PASSWORD"
  description = "birmigham database password"
  type        = "SecureString"
  value       = var.db_password

  lifecycle {
    ignore_changes = [value]
  }

  tags = var.tags
}

resource "aws_ssm_parameter" "db_name" {
  name        = "${var.prefix}/DB_NAME"
  description = "birmigham database name"
  type        = "String"
  value       = var.db_name

  lifecycle {
    ignore_changes = [value]
  }

  tags = var.tags
}