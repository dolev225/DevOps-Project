output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "application_url" {
  description = "URL to test the load balancer"
  value       = "http://${aws_lb.this.dns_name}"
}

