bastion-host module
This module is used to create a bastion host in a public subnet with SSH access via key pair and Systems Manager.

The module is intended to use as module dependency.

Important note!

Create EC2 key pair outside Terraform via AWS Console or CLI, then reference it by name.

Version
1.0.0

Table of Contents
bastion-host module
Version
Table of Contents
Created Resources
Inputs
Outputs
Prerequisites
Providers
Deployment
Terraform Lifecycle Rules
Created Resources
Name	Type
"${var.env}-${var.project}-bastion"	AWS EC2 Instance
"${var.env}-${var.project}-bastion-sg"	AWS Security Group
"${var.env}-${var.project}-bastion-role"	AWS IAM Role
"${var.env}-${var.project}-bastion-profile"	AWS IAM Instance Profile
"${var.env}-${var.project}-bastion-eip"	AWS Elastic IP (optional)
Inputs
Name	Description	Type	Default	Required
env	Environment name	string	-	Y
project	Project name	string	-	Y
vpc_id	VPC ID where bastion host will be deployed	string	-	Y
ami_id	AMI ID for the bastion host	string	-	Y
public_subnet_id	Public subnet ID for bastion host placement	string	-	Y
allowed_cidr_blocks	List of CIDR blocks allowed to SSH	list(string)	-	Y
key_pair_name	Name of existing EC2 key pair	string	null	N
instance_type	EC2 instance type for bastion host	string	t3.micro	N
create_elastic_ip	Whether to create and attach an Elastic IP	bool	true	N
kms_key_id	KMS key ID for encryption	string	null	N
Outputs
Name	Description
bastion_instance_id	ID of the bastion host instance
bastion_public_ip	Public IP address of the bastion host
bastion_elastic_ip	Elastic IP address of the bastion host
bastion_private_ip	Private IP address of the bastion host
bastion_security_group_id	ID of the bastion host security group
Prerequisites
Terraform version: >= 1.9.0

Providers
Name	Version
aws	>= 5.59.0
Deployment
To run this code you need to execute:

terraform init
terraform plan
terraform apply