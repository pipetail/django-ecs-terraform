output "url_endpoint" {
  value = "https://${aws_route53_record.staging.name}"
}
