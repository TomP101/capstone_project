output "subnet_id" {
  description = "The ID of the subnet"
  value       = aws_subnet.subnet_eu_north1a.id
}

output "sg_ids" {
  description = "The IDs of the security groups"
  value       = [aws_security_group.sg1.id]
}

output "tg_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tg_ec2.arn
}
output "lb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.application-lb.id
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.application-lb.dns_name
}
