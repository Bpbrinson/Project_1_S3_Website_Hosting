#######################################################
# Locals / naming
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

  website_files = var.upload_files ? fileset(var.website_directory, "**") : []
}

#######################################################
# S3 bucket
#######################################################

resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "bucket_name" {
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
  tags   = local.common_tags
  force_destroy = true
}

#######################################################
# Ownership controls
#######################################################

resource "aws_s3_bucket_ownership_controls" "bucket_owner" {
  bucket = aws_s3_bucket.bucket_name.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#######################################################
# Public access block
#######################################################

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
  bucket = aws_s3_bucket.bucket_name.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

#######################################################
# Versioning
#######################################################

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket_name.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

#######################################################
# Server-side encryption
#######################################################

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket_name.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#######################################################
# Optional website file uploads
#######################################################

resource "aws_s3_object" "website_files" {
  for_each = var.upload_files ? {
    for file in local.website_files : file => file
  } : {}

  bucket = aws_s3_bucket.bucket_name.id
  key    = each.value
  source = "${var.website_directory}/${each.value}"
  etag   = filemd5("${var.website_directory}/${each.value}")

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      json = "application/json"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
      svg  = "image/svg+xml"
      ico  = "image/x-icon"
      txt  = "text/plain"
      webp = "image/webp"
    },
    lower(element(reverse(split(".", each.value)), 0)),
    "application/octet-stream"
  )

  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_owner
  ]
}

#######################################################
# Optional bucket policy
# Used when another module (like CloudFront) needs access
#######################################################

data "aws_iam_policy_document" "iam_s3_policy" {
  count = var.s3_attach_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals != null ? [statement.value.principals] : []
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition != null ? [statement.value.condition] : []
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.s3_attach_policy ? 1 : 0
  bucket = aws_s3_bucket.bucket_name.id
  policy = data.aws_iam_policy_document.iam_s3_policy[0].json
}