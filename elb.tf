# Target group

resource "aws_lb_target_group" "my-target-group" {

  name        = "tuongtv-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.default.id

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}


resource "aws_lb" "my-aws-alb" {

  load_balancer_type = "application"
  name               = "tuongtv-alb"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups    = ["${aws_security_group.my-alb-sg.id}"]

  subnets = var.public_subnet_cidr_blocks

  tags = {
    Name = "tuongtv-alb"
  }

}

resource "aws_lb_listener" "my-alb-listner" {
  load_balancer_arn = aws_lb.my-aws-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-target-group.arn
  }
}









