output "ecs_cluster_id" {
  description = "ID klastra ECS"
  value       = aws_ecs_cluster.main.id
}

output "ecs_security_group_id" {
  description = "SG używana przez instancje w klastrze"
  value       = aws_security_group.ecs_sg.id
}

output "private_subnet_ids" {
  description = "List of private subnets for ECS tasks"
  value       = aws_subnet.private[*].id
}