resource "aws_vpc_endpoint_service" "provider_service" {
  acceptance_required = false
  network_load_balancer_arns = [aws_lb.nlb.arn]
  
  
  tags = {
    Name = "Provider-Endpoint-Service"
  }

  depends_on = [
    aws_lb.nlb
  ]

  lifecycle {
    create_before_destroy = true
  }
}



