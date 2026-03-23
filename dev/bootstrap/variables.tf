variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
}

variable "terraform_state_bucket_name" {
  description = "S3 bucket name for Terraform remote state"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}