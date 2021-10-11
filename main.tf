provider "aws"{
	region	="${var.region}"
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
}


#VPC ( 1 public subnet, 2 private subnet, 1 igw, 2 route table)

#VPC

resource "aws_vpc" "default"{
	cidr_block = var.cidr_block
	
	tags = {
    "Environment" = var.environment_tag
    "Name" = var.name_tag
  }
	enable_dns_support = true
	enable_dns_hostnames = true
}

# Internet Gateway

resource "aws_internet_gateway" "default"{
	vpc_id = aws_vpc.default.id
}



# Private Subnet

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
}


# Public Subnet

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
}



resource "aws_route_table" "private"{
	count = length(var.private_subnet_cidr_blocks)

	vpc_id = aws_vpc.default.id
}

/*resource "aws_route" "private" {
  	count = length(var.private_subnet_cidr_blocks)

  	route_table_id         = aws_route_table.private[count.index].id
  	destination_cidr_block = "0.0.0.0/0"
}*/


#Public Route Table and Association

resource "aws_route_table" "public" {
	vpc_id = aws_vpc.default.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


#Bastion Host Security Group

resource "aws_security_group" "bastion_host"{
	
	vpc_id	= aws_vpc.default.id
	ingress {
		from_port = var.ingressfromport
		to_port   = var.ingresstoport
		protocol  = var.protocol
    // replace with your IP address, or CIDR block
  		cidr_blocks = [var.IpAddress]
	}

	egress {
		from_port = var.egressfromport
		to_port   = var.egresstoport
		protocol  = "var.protocol"
	}
}

# Keypair
resource "tls_private_key" "public_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "bastion_host_key" {
  key_name   = var.key_name
  public_key = tls_private_key.public_key.public_key_openssh
}


# Bastion host EC2 instance

resource "aws_instance" "bastion_host" {
	ami           = var.ec2_ami
	instance_type = var.ec2_type
  	key_name      = aws_key_pair.bastion_host_key.key_name
 	vpc_security_group_ids      = [aws_security_group.bastion_host.id]
 	subnet_id                   = element(aws_subnet.public.*.id, 1)
  	associate_public_ip_address = true
  	
  	provisioner "remote-exec" {
		inline = [
			"sudo su-",
			"yum -y update",
			"amazon-linux-extras -y install nginx1",
			"systemctl start nginx.service",
			"systemctl enable nginx.service",
			"amazon-linux-extras -y install php8",
			"yum install -y php-mbstring php-devel php-xml",
			"systemctl start php-fpm.service",
			"systemctl enable php-fpm.service",
			"systemctl restart nginx.service",
			"systemctl restart php-fpm.service",
			"sudo service nginx start"
]
}
}

