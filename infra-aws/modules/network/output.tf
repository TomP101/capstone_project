output "subnet_ids" {
  description = "Lista subnetów (eu-north-1a i eu-north-1b) dla zasobów"
  value       = [
    aws_subnet.subnet_eu_north1a.id,
    aws_subnet.subnet_eu_north1b.id,
  ]
}

output "sg_ids" {
  description = "Lista Security Groups dla instancji i ALB"
  value       = [ aws_security_group.sg1.id ]
}

output "alb_listener_arn" {
  description = "ARN istniejącego listenera ALB (port 80)"
  value       = aws_lb_listener.listener_forward_all.arn
}

output "lb_arn" {
  description = "ARN ALB"
  value       = aws_lb.application-lb.arn
}

output "lb_dns_name" {
  description = "DNS name ALB"
  value       = aws_lb.application-lb.dns_name
}
