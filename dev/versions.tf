terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.12"
    }
  }

  backend "s3" {
    bucket       = "birmigham-terraform-state-eu-west-2"
    key          = "dev/core/baseinfra/terraform.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}