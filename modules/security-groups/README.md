# Terraform AWS Security Groups Module

This module creates a set of security groups for a standard three-tier web application architecture.

It provisions the following security groups with pre-configured rules:
- **ALB Security Group**: For an Application Load Balancer, allowing HTTP/HTTPS traffic from specified CIDRs.
- **ECS Security Group**: For ECS tasks (or other application servers), allowing traffic from the ALB on the application port.
- **DB Security Group**: For a database, allowing traffic from the ECS security group on the database port.
- **Bastion Security Group**: For a bastion host, allowing SSH access from specified CIDRs.

It also adds a rule to the DB security group to allow access from the bastion host for management and troubleshooting.

## Usage

```hcl
module "security_groups" {
  source = "../modules/security-groups"

  project_name          = "my-app"
  environment           = "dev"
  vpc_id                = module.vpc.vpc_id
  app_port              = 8080
  db_port               = 5432
  allowed_ingress_cidrs = ["0.0.0.0/0"]
  bastion_allowed_cidrs = ["203.0.113.5/32"]
  
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
| vpc_id | The ID of the VPC where the security groups will be created. | `string` | n/a | yes |
| app_port | The port your application runs on (e.g., 8080). | `number` | n/a | yes |
| db_port | The port your database listens on (e.g., 5432 for PostgreSQL). | `number` | n/a | yes |
| allowed_ingress_cidrs | A list of CIDR blocks allowed to access the ALB on HTTP/HTTPS. | `list(string)` | n/a | yes |
| bastion_allowed_cidrs | A list of CIDR blocks allowed to SSH into the bastion host. | `list(string)` | n/a | yes |
| common_tags | A map of common tags to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_security_group_id | The ID of the ALB security group. |
| ecs_security_group_id | The ID of the ECS security group. |
| db_security_group_id | The ID of the Database security group. |
| bastion_security_group_id | The ID of the Bastion security group. |