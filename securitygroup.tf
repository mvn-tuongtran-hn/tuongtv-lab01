#Bastion Host Security Group

resource "aws_security_group" "sg_bastion_host" {
  name    = "sg_bastion_host"
  vpc_id  = aws_vpc.default.id

  ingress {
    from_port   = var.ingress_from_port_ssh
    to_port     = var.ingress_to_port_ssh
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    name = var.bastion_sg_tag
  }
}

#EC2 security Group

resource "aws_security_group" "sg_ec2_private" {
  name   = "sg_ec2_private"
  vpc_id = aws_vpc.default.id

  ingress {
    from_port   = var.ingress_from_port_ssh
    to_port     = var.ingress_to_port_ssh
    protocol    = var.protocol
    cidr_blocks = ["10.0.0.0/16"]


  }
  ingress {
    from_port   = var.ingress_from_port_https
    to_port     = var.ingress_to_port_https
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.ec2_sg_tag
  }
}

resource "aws_security_group" "sg_rds_private" {
  name   = "var.rds_sg_private"
  vpc_id = aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = var.protocol
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_ec2_private.id]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = var.rds_sg_tag
  }
}

# ALB Security Group

resource "aws_security_group" "my-alb-sg" {
  name   = "my-alb-sg"
  vpc_id = aws_vpc.default.id

  ingress {
    from_port   = var.ingress_from_port_ssh
    to_port     = var.ingress_to_port_ssh
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = var.ingress_from_port_http
    to_port     = var.ingress_to_port_http
    protocol    = var.protocol
    cidr_blocks = ["0.0.0.0/0"]


  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    name = var.alb_sg_tag
  }
}