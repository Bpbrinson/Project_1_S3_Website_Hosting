variable "project_name" {
  description = "Project name used for tagging and resource naming."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or prod."
  type        = string
}

variable "s3_origin_domain_name" {
  description = "Regional domain name of the private S3 bucket origin."
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for the CloudFront distribution. Leave blank to use the default CloudFront domain."
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for the custom domain. Required if domain_name is set."
  type        = string
  default     = ""

  validation {
    condition     = var.domain_name == "" || var.acm_certificate_arn != ""
    error_message = "acm_certificate_arn must be provided when domain_name is set."
  }
}

variable "default_root_object" {
  description = "Default object returned when the root URL is requested."
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "enable_spa_routing" {
  description = "Whether to rewrite 403 and 404 responses to /index.html for SPA routing."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}