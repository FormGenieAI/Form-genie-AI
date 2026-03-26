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

variable "ecr_repository_name" {
  description = "Name of the ECR repository for the application"
  type        = string
}

variable "ecr_image_retention_count" {
  description = "Number of images to retain in the ECR lifecycle policy"
  type        = number
  default     = 10
}

variable "ssm_prefix" {
  description = "Prefix used for SSM parameter paths"
  type        = string
}

variable "ssm_db_host" {
  description = "Database host value for SSM parameter"
  type        = string
}

variable "ssm_db_user" {
  description = "Database username value for SSM parameter"
  type        = string
}

variable "ssm_db_password" {
  description = "Database password value for SSM parameter"
  type        = string
  sensitive   = true
}

variable "ssm_db_name" {
  description = "Database name value for SSM parameter"
  type        = string
}