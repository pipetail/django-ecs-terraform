output "prod_endpoint" {
  value = "https://${aws_route53_record.www.name}"
}

output "staging_endpoint" {
  value = "https://${aws_route53_record.staging.name}"
}
