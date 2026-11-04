output "alb_dns_name" {
  value = aws_lb.Clude_lb.dns_name 
}
output "bucket_name" {
  value = aws_s3_bucket.Clude_s3.id
}