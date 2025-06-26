module "s3_bucket" {
  source                    = "artifacts.merck.com/terraform-iac-shared__terraform-aws-modules/s3-bucket/aws"
  version                   = "~> 3.2"
  create_bucket             = true
  bucket                    = "${var.vendor}-${var.application_ci}-endptsvc-bucket"
  bucket_key_enabled        = true
  replication_configuration = {}
  force_destroy             = true
  s3_log_bucket             = "${var.vendor}-${var.application_ci}-endptsvc-bucket-logs"
  s3_log_force_destroy      = true
  default_tags              = var.default_tags 
  policy = jsonencode({
    Id = "BucketPolicy" 
    Statement = [
      {
        Action = "s3:PutObject"
        Effect = "allow"
        Principal = {
          AWS = [
            for principle in local.principals: principle.value
          ]
        }
        Resource = "${var.vendor}-${var.application_ci}-endptsvc-bucket"
        Sid      = "statement1"
      },
      {
        Action = "s3:PutObject"
        Effect = "allow"
        Principal = {
          service = "delivery.logs.amazonaws.com"
        }
        Resource = "${var.vendor}-${var.application_ci}-endptsvc-bucket"
        Sid      = "statement2"
        Condition = {
          "StringEquals" = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Action = "s3:GetBucketAcl"
        Effect = "allow"
        Principal = {
          service = "delivery.logs.amazonaws.com"
        }
        Resource = "${var.vendor}-${var.application_ci}-endptsvc-bucket"
        Sid      = "statement3"
      },
      {
        Action = "s3:GetBucketAcl"
        Effect = "allow"
        Principal = {
          service = "delivery.logs.amazonaws.com"
        }
        Resource = "${var.vendor}-${var.application_ci}-endptsvc-bucket"
        Sid      = "statement4"
        Condition = {
          "StringEquals" = {
            "aws:PrincipalOrgID" = ["o-j7csbuyn4x", "o-a3oon4kshs"]
          }
        }
      }
    ]
    Version = "2012-10-17"
  })
}