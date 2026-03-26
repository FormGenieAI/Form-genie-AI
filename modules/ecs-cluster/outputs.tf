output "cluster_id" {
  description = "The ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "The ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_capacity_providers" {
  description = "Associated ECS cluster capacity providers"
  value       = var.enable_capacity_providers ? aws_ecs_cluster_capacity_providers.this[0].capacity_providers : []
}