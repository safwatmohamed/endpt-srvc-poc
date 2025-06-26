# Main

module "s3_bucket" {
  source  = "artifacts.merck.com/terraform-iac-shared__terraform-aws-modules/s3-bucket/aws"
  version = "~>3.2"

  bucket        = "my-globally-unique-bucket-name"
  s3_log_bucket = "my-globally-unique-log-bucket-name"
  default_tags  = var.default_tags
}