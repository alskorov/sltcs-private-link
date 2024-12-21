resource "aws_security_group" "provider_instance_sg" {
  name        = "provider-instance-sg"
  description = "SG for the provider EC2 instance"
  vpc_id      = aws_vpc.provider_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
    description     = "Allow HTTP from NLB"
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
    description     = "Allow SSH from NLB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "consumer_instance_sg" {
  name        = "consumer-instance-sg"
  description = "SG for consumer EC2 instance"
  vpc_id      = aws_vpc.consumer_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.provider_vpc_cidr]
  }
}

resource "aws_security_group" "endpoint_sg" {
  name        = "endpoint_sg"
  description = "Allow inbound traffic to the endpoint"
  vpc_id      = aws_vpc.consumer_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.consumer_vpc_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.consumer_vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EndpointSG"
  }
}


resource "aws_security_group" "nlb_sg" {
  name        = "nlb-sg"
  description = "Security group for Network Load Balancer"
  vpc_id      = aws_vpc.provider_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.consumer_vpc.cidr_block]
    description = "Allow HTTP from consumer subnet"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.consumer_vpc.cidr_block]
    description = "Allow SSH from consumer VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NLB-Security-Group"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  vpc_id      = aws_vpc.consumer_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["87.70.172.247/32"] # Your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}