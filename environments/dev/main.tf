#######################################################
# Terraform / Provider Configuration
#######################################################

provider "aws" {
  region = var.aws_region
}

#######################################################
# Locals
#######################################################

locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

#######################################################
# S3 Module
#######################################################

module "s3_static_site" {
  source = "../../modules/s3-static-site"

  project_name       = var.project_name
  environment        = var.environment
  bucket_name        = var.bucket_name
  versioning_enabled = var.versioning_enabled
  upload_files       = var.upload_files
  website_directory  = var.website_directory
  tags               = local.common_tags
}

#######################################################
# CloudFront Module
#######################################################

module "cloudfront_static_site" {
  source = "../../modules/cloudfront-static-site"

  project_name          = var.project_name
  environment           = var.environment
  s3_origin_domain_name = module.s3_static_site.bucket_regional_domain_name
  domain_name           = var.domain_name
  acm_certificate_arn   = var.acm_certificate_arn
  default_root_object   = var.default_root_object
  price_class           = var.price_class
  enable_spa_routing    = var.enable_spa_routing
  tags                  = local.common_tags
}

#######################################################
# S3 Bucket Policy for CloudFront OAC Access
#######################################################

data "aws_iam_policy_document" "cloudfront_access" {
  statement {
    sid    = "AllowCloudFrontReadAccess"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${module.s3_static_site.bucket_arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfront_static_site.distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = module.s3_static_site.bucket_id
  policy = data.aws_iam_policy_document.cloudfront_access.json
}

#######################################################
# Optional Route53 Record
#######################################################

resource "aws_route53_record" "site_alias" {
  count   = var.create_route53_record ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront_static_site.distribution_domain_name
    zone_id                = module.cloudfront_static_site.hosted_zone_id
    evaluate_target_health = false
  }
}