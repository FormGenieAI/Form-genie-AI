variable "project_name" {
  description = "Project name used for naming resources"
  type        = string

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 255
    error_message = "project_name must be between 1 and 255 characters."
  }
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod"
  type        = string

  validation {
    condition     = length(var.environment) > 0 && length(var.environment) <= 50
    error_message = "environment must be between 1 and 50 characters."
  }
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application port exposed by ECS service"
  type        = number
  default     = 80

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "app_port must be between 1 and 65535."
  }
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306

  validation {
    condition     = var.db_port > 0 && var.db_port <= 65535
    error_message = "db_port must be between 1 and 65535."
  }
}

variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed to access the ALB on HTTP/HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}