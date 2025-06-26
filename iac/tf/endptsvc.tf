resource "aws_vpc_endpoint_service" "endptsvc" {  
  acceptance_required        = false
  network_load_balancer_arns = [module.alb.arn]
  tags = {
    "Name": "${var.vendor}-${var.application_ci}-endptsvc"
  }
}

resource "aws_vpc_endpoint_service_allowed_principal" "this" {
  for_each = { for idx, val in local.principals : idx => val }
  vpc_endpoint_service_id = aws_vpc_endpoint_service.endptsvc.id
  principal_arn           = each.value.value  
}