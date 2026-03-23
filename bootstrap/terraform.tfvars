aws_region                  = "eu-west-2"
project_name                = "birmigham"
environment                 = "shared"
terraform_state_bucket_name = "birmingham-terraform-state-eu-west-2"
terraform_lock_table_name   = "birmingham-terraform-locks"

tags = {
  Project     = "birmingham"
  Environment = "shared"
  ManagedBy   = "terraform"
}