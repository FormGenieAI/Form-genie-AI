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

variable "vpc_cidr" {
  description = "CIDR block for the VPC, for example 10.0.0.0/16"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }

  validation {
    condition     = tonumber(split("/", var.vpc_cidr)[1]) <= 24
    error_message = "vpc_cidr must be large enough to create the required subnets, such as /16."
  }
}

variable "azs" {
  description = "List of exactly 3 availability zones"
  type        = list(string)

  validation {
    condition     = length(var.azs) == 3
    error_message = "azs must contain exactly 3 availability zones."
  }

  validation {
    condition = alltrue([
      for az in var.azs : can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", az))
    ])
    error_message = "Each availability zone must be in a valid format like eu-west-1a."
  }
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}