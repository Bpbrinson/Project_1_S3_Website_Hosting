variable "project_name" {
  description = "Name of the project using this S3 bucket."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev or prod."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
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
  description = "Whether to upload local website files into the bucket."
  type        = bool
  default     = false
}

variable "website_directory" {
  description = "Local directory containing website files to upload."
  type        = string
  default     = ""
}

variable "s3_attach_policy" {
  description = "Whether to attach a bucket policy."
  type        = bool
  default     = false
}

variable "policy_statements" {
  description = "List of IAM policy statements to apply to the bucket policy."
  type = list(object({
    sid       = string
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = optional(object({
      type        = string
      identifiers = list(string)
    }))
    condition = optional(object({
      test     = string
      variable = string
      values   = list(string)
    }))
  }))
  default = []
}