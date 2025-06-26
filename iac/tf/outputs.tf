output "id" {
  value = aws_vpc_endpoint_service.endptsvc.id
}

output "service_name" {
  value = aws_vpc_endpoint_service.endptsvc.service_name
}

output "private_dns_name" {
  value = aws_vpc_endpoint_service.endptsvc.private_dns_name
}