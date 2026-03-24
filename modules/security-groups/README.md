# Security Groups Module

## Purpose
Creates security groups for:
- Application Load Balancer
- ECS tasks
- Database

## Traffic Flow
- Internet can access ALB on ports 80 and 443
- ECS accepts traffic only from the ALB security group on the application port
- Database accepts traffic only from the ECS security group on the database port

## Naming
Resources are named with:
<project_name>-<environment>-<resource>

Example:
birmingham-dev-alb-sg

## Inputs
- project_name
- environment
- vpc_id
- app_port
- db_port
- allowed_ingress_cidrs
- common_tags

## Outputs
- alb_security_group_id
- ecs_security_group_id
- db_security_group_id