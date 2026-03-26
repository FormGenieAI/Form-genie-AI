resource "aws_ecs_cluster" "this" {
  name = var.name

  dynamic "setting" {
    for_each = var.cluster_settings
    content {
      name  = setting.value.name
      value = setting.value.value
    }
  }

  configuration {
    execute_command_configuration {
      logging = var.execute_command_logging

      dynamic "log_configuration" {
        for_each = var.execute_command_logging == "OVERRIDE" ? [1] : []
        content {
          cloud_watch_log_group_name     = var.execute_command_log_group_name
          cloud_watch_encryption_enabled = var.execute_command_cloudwatch_encryption_enabled
        }
      }
    }
  }

  dynamic "service_connect_defaults" {
    for_each = var.service_connect_defaults != null ? [var.service_connect_defaults] : []
    content {
      namespace = service_connect_defaults.value.namespace
    }
  }

  tags = merge(
    var.tags,
    {
      Name        = var.name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  count = var.enable_capacity_providers ? 1 : 0

  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy
    content {
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
      weight            = default_capacity_provider_strategy.value.weight
      base              = try(default_capacity_provider_strategy.value.base, null)
    }
  }
}