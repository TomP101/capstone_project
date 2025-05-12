output "subnet_ids" {
  description = "List of subnets (eu-north-1a and eu-north-1b)"
  value       = [
    aws_subnet.subnet_eu_north1a.id,
    aws_subnet.subnet_eu_north1b.id,
  ]
}

output "sg_ids" {
  description = "Security Group IDs for instances and ALB"
  value       = [ aws_security_group.sg1.id ]
}

output "tg_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.tg_ec2.arn
}

output "alb_listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.listener_forward_all.arn
}
