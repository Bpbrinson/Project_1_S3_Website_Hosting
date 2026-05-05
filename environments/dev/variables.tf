variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for tagging and naming."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
}

variable "versioning_enabled" {
  description = "Enable versioning on the S3 bucket."
  type        = bool
  default     = true
}

variable "upload_files" {
  description = "Whether to upload local website files to the bucket."
  type        = bool
  default     = false
}

variable "website_directory" {
  description = "Path to the local website files."
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Custom domain name for the site. Leave blank to use CloudFront default domain."
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for CloudFront. Required if domain_name is set."
  type        = string
  default     = ""

  validation {
    condition     = var.domain_name == "" || var.acm_certificate_arn != ""
    error_message = "acm_certificate_arn must be provided when domain_name is set."
  }
}

variable "default_root_object" {
  description = "Default root object for CloudFront."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "enable_spa_routing" {
  description = "Enable SPA routing by redirecting 403/404 to index.html."
  type        = bool
  default     = false
}

variable "create_route53_record" {
  description = "Whether to create a Route53 alias record for the custom domain."
  type        = bool
  default     = false
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for the domain."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}