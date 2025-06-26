# Variables

variable "default_tags" {
  description = "A map of default tags to be applied on each resource. You can get required tags [here](https://cloud.merck.com/documentation/compliance/tagging-standards/index.html)"
  type        = map(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "deployment_role" {
  description = "Terraform Deployment Role"
  type        = string
}

variable "account_no" {
  description = "AWS account number to deploy to"
  type        = string
}