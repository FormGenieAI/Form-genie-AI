# Terraform AWS VPC Three-Tier Network Module

This module provisions a new VPC with a three-tier network architecture suitable for a highly available web application.

It creates the following resources:
- A VPC with a user-defined CIDR block.
- Public, Application, and Database subnets across three specified Availability Zones.
- An Internet Gateway to provide internet access to the VPC.
- A single NAT Gateway (in the first public subnet) and associated Elastic IP to allow outbound internet access for resources in the private subnets.
- Route tables and associations to control traffic flow between subnets and the internet.

## Usage

```hcl
module "vpc" {
  source = "../modules/vpc-three-tier-network-one-nat"

  project_name = "my-app"
  environment  = "dev"
  vpc_cidr     = "10.0.0.0/16"
  azs          = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  
  common_tags = {
    Owner       = "DevTeam"
    Project     = "WebApp"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Project name used for naming resources. | `string` | n/a | yes |
| environment | Environment name such as dev, staging, or prod. | `string` | n/a | yes |
| vpc_cidr | CIDR block for the VPC, for example 10.0.0.0/16. Must be /24 or larger. | `string` | n/a | yes |
| azs | A list of exactly 3 availability zones to deploy resources into. | `list(string)` | n/a | yes |
| common_tags | A map of common tags to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the created VPC. |
| vpc_cidr_block | The CIDR block of the VPC. |
| public_subnets | A list of IDs for the public subnets. |
| app_subnets | A list of IDs for the application subnets. |
| db_subnets | A list of IDs for the database subnets. |