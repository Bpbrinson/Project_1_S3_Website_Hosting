variable "region" {
  description = "Primary AWS region for S3 and resources"
  type = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

variable "env" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type = string
  default = "dev"
}

variable "domain_name" {
  description = "Root domain name"
  default = "portfolio.brinovax.com"
  type = string
}

variable "hosted_zone_name" {
  description = "Hosted zone name"
  type = string
  default = "brinovax.com"
}

variable "tags" {
  description = "Tags for the S3 bucket"
  type = map(string)
  default = {}
}

variable "project_name" {
  description = "Project name for tagging and resource naming"
  type = string
  default = "s3-website-hosting-project"
}