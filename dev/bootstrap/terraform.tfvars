aws_region                  = "eu-west-2"
project_name                = "birmigham"
environment                 = "shared"
terraform_state_bucket_name = "birmigham-terraform-state-eu-west-2"

tags = {
  Project     = "birmigham"
  Environment = "shared"
  ManagedBy   = "terraform"
}