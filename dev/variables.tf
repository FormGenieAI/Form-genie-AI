variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of exactly 3 availability zones"
  type        = list(string)
}

variable "app_port" {
  description = "Application port exposed by ECS"
  type        = number
  default     = 80
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "bastion_key_name" {
  description = "Existing EC2 key pair name for bastion"
  type        = string
}


variable "allowed_ingress_cidrs" {
  description = "CIDR blocks allowed to access the ALB"
  type        = list(string)
}