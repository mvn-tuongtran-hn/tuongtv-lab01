provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


#VPC ( 1 public subnet, 2 private subnet, 1 igw, 2 route table)

#VPC

resource "aws_vpc" "default" {
  cidr_block = var.cidr_block

  tags = {

    "Environment" = var.vpc_environment_tag
    "Name"        = var.vpc_name_tag
  }

  enable_dns_support   = true
  enable_dns_hostnames = true
}


# Private Subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones_private[count.index]

  tags = {
    name = var.private_name_tag[count.index]
  }
}


# Public Subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones_public[count.index]
  map_public_ip_on_launch = true

  tags = {
    name = var.public_name_tag[count.index]
  }
}

# Internet Gateway

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = var.ig_name_tag
  }
}

#Public Route Table and Association

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  tags = {
    name = var.rt_name_tag
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}




/*
resource "aws_route_table" "private"{
	count	= length(var.private_subnet_cidr_blocks)

	vpc_id	= aws_vpc.default.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route" "private" {
  	count	= length(var.private_subnet_cidr_blocks)

  	route_table_id         = aws_route_table.private[count.index].id
  	destination_cidr_block = "0.0.0.0/0"
}
*/







# Keypair
resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_host_key" {
  key_name   = var.bastion_key_name
  public_key = tls_private_key.public_key.public_key_openssh
}



resource "aws_key_pair" "ec2_key" {
  key_name   = var.ec2_key_name
  public_key = tls_private_key.public_key.public_key_openssh
}


# Bastion Host

resource "aws_instance" "bastion_host" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  key_name                    = aws_key_pair.bastion_host_key.key_name
  vpc_security_group_ids      = [aws_security_group.sg_bastion_host.id]
  subnet_id                   = var.public_subnet_cidr_blocks[0]
  associate_public_ip_address = true

  tags = {
    name = var.bastion_name_tag
  }
}


#  EC2 instance

resource "aws_instance" "ec2_private" {
  ami                         = var.ec2_ami
  instance_type               = var.ec2_type
  key_name                    = aws_key_pair.ec2_key.key_name
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.sg_ec2_private.id]
  subnet_id              = var.private_subnet_cidr_blocks[0]

  user_data = file("config.sh")

  tags = {
    name = var.web_name_tag
  }
}


