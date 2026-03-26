variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod"
  type        = string
}

variable "ssm_parameter_arns" {
  description = "List of SSM parameter ARNs that ECS is allowed to read"
  type        = list(string)
  default     = []
}

variable "kms_key_arns" {
  description = "Optional list of KMS key ARNs for decrypting SecureString parameters encrypted with customer-managed keys"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}