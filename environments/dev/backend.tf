terraform {
  backend "s3" {
    bucket       = "project-1-s3-website-hosting-tf-state-bucket"
    key          = "project1/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
