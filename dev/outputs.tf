output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "app_subnets" {
  description = "Application subnet IDs"
  value       = module.vpc.app_subnets
}

output "db_subnets" {
  description = "Database subnet IDs"
  value       = module.vpc.db_subnets
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}



output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = module.security_groups.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "ECS security group ID"
  value       = module.security_groups.ecs_security_group_id
}

output "db_security_group_id" {
  description = "DB security group ID"
  value       = module.security_groups.db_security_group_id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.security_groups.bastion_security_group_id
}

output "bastion_instance_id" {
  description = "Bastion instance ID"
  value       = module.bastion.bastion_instance_id
}

output "bastion_public_ip" {
  description = "Bastion public Elastic IP"
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Bastion private IP"
  value       = module.bastion.bastion_private_ip
}

output "security_cloudtrail_arn" {
  value = module.security.cloudtrail_arn
}

output "security_guardduty_detector_id" {
  value = module.security.guardduty_detector_id
}

output "security_sns_topic_arn" {
  value = module.security.sns_topic_arn
}

output "ecs_cluster_id" {
  description = "ECS cluster ID"
  value       = module.ecs_cluster.cluster_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs_cluster.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs_cluster.cluster_arn
}

output "ecs_cluster_capacity_providers" {
  description = "ECS cluster capacity providers"
  value       = module.ecs_cluster.cluster_capacity_providers
}

output "ssm_db_parameters" {
  value = {
    host     = module.ssm_parameters.db_host_parameter_name
    user     = module.ssm_parameters.db_user_parameter_name
    password = module.ssm_parameters.db_password_parameter_name
    db_name  = module.ssm_parameters.db_name_parameter_name
  }
}