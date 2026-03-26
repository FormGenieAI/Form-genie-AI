variable "name" {
  description = "Name of the ECS cluster"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "name must be between 1 and 255 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "name must contain only alphanumeric characters, hyphens, and underscores"
  }
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = length(var.environment) > 0 && length(var.environment) <= 50
    error_message = "environment must be between 1 and 50 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.environment))
    error_message = "environment must contain only alphanumeric characters and hyphens"
  }
}

variable "cluster_settings" {
  description = "List of ECS cluster settings"
  type = list(object({
    name  = string
    value = string
  }))

  default = [
    {
      name  = "containerInsights"
      value = "enabled"
    }
  ]
}

variable "execute_command_logging" {
  description = "Logging configuration for ECS Exec"
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["NONE", "DEFAULT", "OVERRIDE"], var.execute_command_logging)
    error_message = "execute_command_logging must be one of: NONE, DEFAULT, OVERRIDE"
  }
}

variable "execute_command_log_group_name" {
  description = "CloudWatch log group name for ECS Exec when logging is OVERRIDE"
  type        = string
  default     = null

  validation {
    condition = (
      var.execute_command_logging != "OVERRIDE" ||
      (var.execute_command_log_group_name != null && trimspace(var.execute_command_log_group_name) != "")
    )
    error_message = "execute_command_log_group_name must be provided when execute_command_logging is OVERRIDE."
  }
}

variable "execute_command_cloudwatch_encryption_enabled" {
  description = "Enable CloudWatch encryption for ECS Exec logs"
  type        = bool
  default     = true
}

variable "service_connect_defaults" {
  description = "Optional Service Connect defaults"
  type = object({
    namespace = string
  })
  default = null
}

variable "enable_capacity_providers" {
  description = "Whether to associate capacity providers with the cluster"
  type        = bool
  default     = true
}

variable "capacity_providers" {
  description = "Capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy"
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = optional(number)
  }))

  default = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  ]
}

variable "tags" {
  description = "Tags to apply to ECS resources"
  type        = map(string)
  default     = {}
}