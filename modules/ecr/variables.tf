variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "image_retention_count" {
  description = "Number of images to keep in ECR"
  type        = number
  default     = 10
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}