output "distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution for Route53 alias records."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "oac_id" {
  description = "Origin Access Control ID."
  value       = aws_cloudfront_origin_access_control.this.id
}