resource "aws_instance" "provider_instance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id     =  aws_subnet.provider_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.provider_instance_sg.id]
  key_name      = "pv-testing"
  associate_public_ip_address = false

  tags = {
    Name = "Provider-Instance"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx

    # Create a new user with /bin/bash as the default shell
    sudo useradd -m -s /bin/bash testuser
    echo 'testuser:testuser' | sudo chpasswd

    # Grant sudo privileges
    sudo usermod -aG wheel testuser

    # Allow password-based authentication
    sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

    # Restart SSH service
    sudo systemctl restart sshd
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