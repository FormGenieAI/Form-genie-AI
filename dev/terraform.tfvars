project_name = "birmigham"
environment  = "dev"
aws_region   = "eu-west-2"

vpc_cidr = "10.0.0.0/16"

azs = [
  "eu-west-2a",
  "eu-west-2b",
  "eu-west-2c"
]

tags = {
  Project     = "birmigham"
  Environment = "dev"
  ManagedBy   = "terraform"
}

app_port = 80
db_port  = 3306


bastion_key_name = "birmigham"

allowed_ingress_cidrs = [
  "0.0.0.0/0"
]

ecr_repository_name       = "birmingham-dev-app"
ecr_image_retention_count = 10

ssm_prefix = "/birmigham"

ssm_db_host     = "placeholder"
ssm_db_user     = "placeholder"
ssm_db_password = "placeholder"
ssm_db_name     = "placeholder"