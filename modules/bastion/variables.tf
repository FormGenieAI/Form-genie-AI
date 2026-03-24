variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}