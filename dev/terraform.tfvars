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