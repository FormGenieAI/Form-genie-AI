locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_iam_policy_document" "ecs_tasks_assume_role" {
  statement {
    sid = "AllowECSTasksToAssumeRole"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.name_prefix}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-task-execution-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_managed_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ecs_ssm_access" {
  count = length(var.ssm_parameter_arns) > 0 ? 1 : 0

  statement {
    sid = "AllowReadSpecificSSMParameters"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = var.ssm_parameter_arns
  }

  dynamic "statement" {
    for_each = length(var.kms_key_arns) > 0 ? [1] : []
    content {
      sid = "AllowDecryptKMSForSecureString"

      actions = [
        "kms:Decrypt"
      ]

      resources = var.kms_key_arns
    }
  }
}

resource "aws_iam_policy" "ecs_ssm_access" {
  count = length(var.ssm_parameter_arns) > 0 ? 1 : 0

  name   = "${local.name_prefix}-ecs-ssm-access"
  policy = data.aws_iam_policy_document.ecs_ssm_access[0].json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-ssm-access"
  })
}

resource "aws_iam_role_policy_attachment" "ecs_ssm_access" {
  count = length(var.ssm_parameter_arns) > 0 ? 1 : 0

  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_ssm_access[0].arn
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.name_prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role.json

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-ecs-task-role"
  })
}