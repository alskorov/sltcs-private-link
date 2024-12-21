
output "provider_instance_private_ip" {
  value = aws_instance.provider_instance.private_ip
}


output "service_name" {
  value = aws_vpc_endpoint_service.provider_service.service_name
}