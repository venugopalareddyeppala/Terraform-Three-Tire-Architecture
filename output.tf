#####################
### output for lb ###
#####################

output "aws_load_balancer_dns" {
  description = "DNS for application load balancer"
  value       = aws_lb.web_lb.dns_name

}