resource "aws_vpc" "consumer_vpc" {
  cidr_block           = var.consumer_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Consumer-VPC"
  }
}


# Subnet in us-east-2b
resource "aws_subnet" "consumer_private_subnet" {
  vpc_id                  = aws_vpc.consumer_vpc.id
  cidr_block              = var.private_subnet_cidrs_consumer[0]
  #availability_zone       = var.consumer_availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "Consumer-Private-Subnet"
  }
}


resource "aws_route_table" "consumer_private_rt" {
  vpc_id = aws_vpc.consumer_vpc.id
  tags = {
    Name = "Consumer-Private-RT"
  }
}

# resource "aws_route" "consumer_to_provider" {
#   route_table_id         = aws_route_table.consumer_private_rt.id
#   destination_cidr_block = "10.0.0.0/16" # Provider VPC CIDR
#   network_interface_id   = "eni-0b99998f566836c29" # Replace with the ENI ID of your VPC Endpoint
# }


resource "aws_route_table_association" "consumer_private_rta" {
  subnet_id      = aws_subnet.consumer_private_subnet.id
  route_table_id = aws_route_table.consumer_private_rt.id
}

resource "aws_subnet" "consumer_public_subnet" {
  vpc_id                  = aws_vpc.consumer_vpc.id
  cidr_block              = var.public_subnet_cidrs_consumer[0] 
  map_public_ip_on_launch = true

  tags = {
    Name = "Consumer-Public-Subnet"
  }
}


resource "aws_internet_gateway" "consumer_igw" {
  vpc_id = aws_vpc.consumer_vpc.id

  tags = {
    Name = "Consumer-Internet-Gateway"
  }
}

resource "aws_internet_gateway" "provider_igw" {
  vpc_id = aws_vpc.provider_vpc.id

  tags = {
    Name = "Provider-Internet-Gateway"
  }
}

resource "aws_route_table" "consumer_public_rt" {
  vpc_id = aws_vpc.consumer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.consumer_igw.id
  }

  tags = {
    Name = "Consumer-Public-RT"
  }
}

resource "aws_route_table_association" "consumer_public_rta" {
  subnet_id      = aws_subnet.consumer_public_subnet.id
  route_table_id = aws_route_table.consumer_public_rt.id
}

resource "aws_route_table" "provider_public_rt" {
  vpc_id = aws_vpc.provider_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.provider_igw.id
  }

  tags = {
    Name = "Provider-Public-RT"
  }
}

resource "aws_route_table_association" "provider_public_rta_1" {
  subnet_id      = aws_subnet.provider_private_subnet_1.id
  route_table_id = aws_route_table.provider_public_rt.id
}