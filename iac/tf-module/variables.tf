variable "region" {
  type    = string
  description = ""
}

variable "allowed_principles" {
  type = list(object({
    aws_account = number
    role        = string
  }))
  description = "The ARNs of one or more principals allowed to discover the endpoint service."
}

variable "listeners" {
  description = "Map of listeners with their corresponding backend IPs"
  type        = map(list(string))
}

variable "port" {
  type    = number
  description = ""
}

variable "application_ci" {
  type    = string
  description = ""
}

variable "vendor" {
  type    = string
  description = ""
}

variable "vpc_id" {
  type    = string
  default = "vpc-0a811bddb05e042a6"
  description = ""
}

variable "security_group_id" {
  type    = string
  default = "sg-00fe059c2edb62f3e"
  description = ""
}

variable "subnets_id" {
  type    = list(string)
  default = ["subnet-04c44114a21ca5288", "subnet-0332cc87c7367a71a"]
  description = ""
}

variable "default_tags" {
  description = "A map of default tags to be applied on each resource. You can get required tags [here](https://cloud.merck.com/documentation/compliance/tagging-standards/index.html)"
  type        = map(string)
}