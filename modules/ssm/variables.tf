variable "prefix" {
  description = "SSM parameter prefix (e.g. /wordpress)"
  type        = string
}

variable "db_host" {
  description = "Database host value to store in SSM"
  type        = string
}

variable "db_user" {
  description = "Database username value to store in SSM"
  type        = string
}

variable "db_password" {
  description = "Database password value to store in SSM"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name value to store in SSM"
  type        = string
}

variable "tags" {
  description = "Tags to apply to parameters"
  type        = map(string)
  default     = {}
}