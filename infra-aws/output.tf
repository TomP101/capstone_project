output "aws_lb_arn" {
  value = module.network.lb_arn
}
output "aws_lb_pub_dns" {
  value = module.network.lb_dns_name
}
