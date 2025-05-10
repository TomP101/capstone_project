output "cluster_id" {
  description = "ECS cluster ARN"
  value       = module.compute.cluster_id
}

output "asg_name" {
  description = "Name of the ECS AutoScalingGroup"
  value       = module.compute.asg_name
}
