resource "aws_vpc" "provider_vpc" {
  cidr_block           = var.provider_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Provider-VPC"
  }
}

resource "aws_subnet" "provider_private_subnet_1" {
  vpc_id                  = aws_vpc.provider_vpc.id
  cidr_block              = var.private_subnet_cidrs_provider[0] # First CIDR block
  availability_zone       = var.provider_availability_zones[0] 
  
  map_public_ip_on_launch = false

  tags = {
    Name = "Provider-Private-Subnet-1"
  }
}

resource "aws_subnet" "provider_private_subnet_2" {
  vpc_id                  = aws_vpc.provider_vpc.id
  cidr_block              = var.private_subnet_cidrs_provider[1] # Second CIDR block
  availability_zone       = var.provider_availability_zones[1] 
  map_public_ip_on_launch = false

  tags = {
    Name = "Provider-Private-Subnet-2"
  }
}

resource "aws_route_table" "provider_private_rt" {
  vpc_id = aws_vpc.provider_vpc.id

  tags = {
    Name = "Provider-Private-RT"
  }
}

resource "aws_route_table" "provider_private_rt_2" {
  vpc_id = aws_vpc.provider_vpc.id

  tags = {
    Name = "Provider-Private-RT2"
  }
}

resource "aws_route_table_association" "provider_private_rta_1" {
  subnet_id      = aws_subnet.provider_private_subnet_1.id
  route_table_id = aws_route_table.provider_private_rt.id
}

resource "aws_route_table_association" "provider_private_rta_2" {
  subnet_id      = aws_subnet.provider_private_subnet_2.id
  route_table_id = aws_route_table.provider_private_rt_2.id
}
