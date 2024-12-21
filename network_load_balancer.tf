resource "aws_lb" "nlb" {
  name               = "provider-nlb"
  load_balancer_type = "network"
  internal           = true
  subnets            = [
    aws_subnet.provider_private_subnet_1.id, 
    aws_subnet.provider_private_subnet_2.id
  ]
  security_groups = [aws_security_group.nlb_sg.id]

  tags = {
    Name = "Provider-NLB"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "provider-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.provider_vpc.id

  tags = {
    Name = "Provider-Target-Group"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
  
  depends_on = [
    aws_lb_target_group.tg,
    aws_lb.nlb
  ]
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.provider_instance.id
  port             = 80                               
}

resource "aws_lb_target_group" "ssh_tg" {
  name     = "provider-ssh-tg"
  port     = 22
  protocol = "TCP"
  vpc_id   = aws_vpc.provider_vpc.id

  tags = {
    Name = "Provider-SSH-Target-Group"
  }
}

resource "aws_lb_listener" "ssh_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 22
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "ssh_tg_attachment" {
  target_group_arn = aws_lb_target_group.ssh_tg.arn
  target_id        = aws_instance.provider_instance.id
  port             = 22
}

