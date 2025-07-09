module "alb" {
  source             = "artifacts.merck.com/terraform-iac-shared__terraform-aws-modules/alb/aws"
  name               = "${var.vendor}-${var.application_ci}-endptsvc-nlb"
  vpc_id             = var.vpc_id
  load_balancer_type = "network"
  internal           = true
  security_groups    = [var.security_group_id]
  subnets            = var.subnets_id
  default_tags       = var.default_tags

  listeners = {
    for port, ips in var.listeners : "${port}" => {
      port     = port
      protocol = "TCP"
      forward  = {
        target_group_key = "${var.vendor}-${var.application_ci}-nlb-tg-${port}"
      }
    }
  }

  target_groups = {
    for port, ips in var.listeners : "${var.vendor}-${var.application_ci}-nlb-tg-${port}" => {
      name              = "${var.vendor}-${var.application_ci}-nlb-tg-${port}"
      port              = port
      protocol          = "TCP"
      availability_zone = "all"
      create_attachment = false 
      target_type       = "ip"
      health_check = {
        internal            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        port                = port
        protocol            = "TCP"
      }
    }
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = length(local.backend_ips)
  target_group_arn = module.alb.target_groups["${var.vendor}-${var.application_ci}-nlb-tg-${local.backend_ips[count.index].port}"].arn
  target_id        = local.backend_ips[count.index].target_id
  port             = local.backend_ips[count.index].port
  availability_zone = "all"
}
