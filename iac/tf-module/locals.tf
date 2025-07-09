locals {
  principals = [for principle in var.allowed_principles:
    {
      value = "arn:aws:iam::${principle.aws_account}:role/${principle.role}"
    }
  ]
}

locals {
  backend_ips = flatten([
    for port, ips in var.listeners : [
      for ip in ips : {
        port      = port
        target_id = ip
      }
    ]
  ])
}
