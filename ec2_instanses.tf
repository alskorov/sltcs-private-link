resource "aws_instance" "provider_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     =  aws_subnet.provider_private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.provider_instance_sg.id]
  key_name      = "pv-testing"
  associate_public_ip_address = false

  tags = {
    Name = "Provider-Instance"
  }

  user_data = <<-EOF
    #!/bin/bash

    # Create a directory to serve files
    sudo mkdir -p /var/www/html
    echo "Hello, World!" | sudo tee /var/www/html/index.html

    # Start a Python HTTP server on port 80
    sudo python3 -m http.server 80 --directory /var/www/html &
EOF
}

resource "aws_instance" "consumer_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.consumer_private_subnet.id
  vpc_security_group_ids = [aws_security_group.consumer_instance_sg.id]
  key_name      = "pv-testing"
  associate_public_ip_address = false

  tags = {
    Name = "Consumer-Instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    yum install -y telnet nc
  EOF

  depends_on = [
    aws_subnet.consumer_private_subnet,
    aws_security_group.consumer_instance_sg
  ]
}

resource "aws_instance" "bastion_host" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.consumer_public_subnet.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name      = "pv-testing"
  associate_public_ip_address = true

  tags = {
    Name = "Bastion-Host"
  }
}