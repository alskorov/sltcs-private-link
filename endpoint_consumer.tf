

resource "aws_vpc_endpoint" "consumer_endpoint" {
  vpc_id              = aws_vpc.consumer_vpc.id
  vpc_endpoint_type   = "Interface"
  service_name        = aws_vpc_endpoint_service.provider_service.service_name
  subnet_ids          = [aws_subnet.consumer_private_subnet.id]
  security_group_ids  = [aws_security_group.endpoint_sg.id]
  
  tags = {
    Name = "Consumer-VPC-Endpoint"
  }

  depends_on = [
    aws_vpc_endpoint_service.provider_service,
    aws_lb.nlb  
  ]

   lifecycle {
    create_before_destroy = true
  }
}




