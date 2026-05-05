output "s3_bucket_name" {
  description = "S3 bucket name."
  value       = module.s3_static_site.bucket_name
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN."
  value       = module.s3_static_site.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID."
  value       = module.cloudfront_static_site.distribution_id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN."
  value       = module.cloudfront_static_site.distribution_arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name."
  value       = module.cloudfront_static_site.distribution_domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID."
  value       = module.cloudfront_static_site.hosted_zone_id
}