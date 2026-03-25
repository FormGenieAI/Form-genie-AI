# Terraform AWS Bastion Host Module

This module provisions a bastion host (EC2 instance) in a public subnet. The bastion host serves as a secure jump server to access resources, like databases or application instances, located in private subnets.

## Usage

```hcl
module "bastion" {
  source = "../modules/bastion"

  project_name     = "my-app"
  environment      = "dev"
  public_subnet_id = module.vpc.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_security_group_id
  key_name         = "my-ec2-keypair"
  
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
| public_subnet_id | The ID of the public subnet to launch the bastion host in. | `string` | n/a | yes |
| bastion_sg_id | The ID of the security group to associate with the bastion host. | `string` | n/a | yes |
| key_name | The name of the EC2 key pair to allow SSH access. | `string` | n/a | yes |
| common_tags | A map of common tags to apply to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_instance_id | The ID of the bastion EC2 instance. |
| bastion_public_ip | The public IP address of the bastion host. |