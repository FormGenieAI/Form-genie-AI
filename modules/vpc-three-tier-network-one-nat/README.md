# VPC Module

## Purpose
Creates a 3-tier VPC across 3 Availability Zones with:
- 3 public subnets
- 3 application subnets
- 3 database subnets
- 2 NAT Gateways
- 1 Internet Gateway
- route tables and associations

## Naming
Resources are named with:
<project_name>-<environment>-<resource>

Example:
birmingham-dev-vpc

## Architecture
- Public subnets route to the Internet Gateway
- Application subnets route to NAT Gateways
- Database subnets remain private with no default internet route

## Notes
- NAT Gateway 1 is in public subnet 1
- NAT Gateway 2 is in public subnet 2
- App subnet 3 routes to NAT Gateway 1 using modulo logic

## Inputs
- project_name
- environment
- vpc_cidr
- azs
- common_tags

## Outputs
- vpc_id
- public_subnets
- app_subnets
- db_subnets
- internet_gateway_id
- nat_gateway_ids