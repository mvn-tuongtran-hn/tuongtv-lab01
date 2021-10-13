variable "access_key" {
  description = "Access key to AWS console"

}
variable "secret_key" {
  description = "Secret key to AWS console"

}

variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "Region of the VPC"
}

variable "vpc_name_tag" {
  default     = "terra-vpc"
  type        = string
  description = "Name of the VPC"
}

variable "vpc_environment_tag" {
  default     = "Development"
  type        = string
  description = "Development of the VPC"
}

variable "private_name_tag" {
  default     = ["private_sn_1", "private_sn_2"]
  type        = list(any)
  description = "Name of the private subnet"
}

variable "public_name_tag" {
  default     = ["public_sn"]
  type        = list(any)
  description = "Name of the public subnet"
}

variable "ig_name_tag" {
  default     = "ig-terra-vpc"
  type        = string
  description = "Internet gateway of the VPC"
}

variable "rt_name_tag" {
  default     = "rt-terra-vpc"
  type        = string
  description = "Route table of the VPC"
}

variable "web_name_tag" {
  default     = "Web Server"
  type        = string
  description = "Name of Web Server"
}

variable "bastion_name_tag" {
  default     = "Bastion"
  type        = string
  description = "Name of the bastion host"
}

variable "bastion_sg_tag" {
  default     = "sg-bastion-host"
  type        = string
  description = "Name of the security group bastion host"
}

variable "ec2_sg_tag" {
  default     = "sg-ec2-private"
  type        = string
  description = "Name of the security group EC2"
}

variable "rds_sg_tag" {
  default     = "sg-rds-private"
  type        = string
  description = "Name of the security group RDS"
}

variable "alb_sg_tag" {
  default     = "sg-alb"
  type        = string
  description = "Name of the security group ALB"
}

variable "ingress_from_port_ssh" {
  default     = 22
  type        = number
  description = "ingress from port ssh"
}

variable "ingress_to_port_ssh" {
  default     = 22
  type        = number
  description = "ingress to port ssh"
}

variable "ingress_from_port_https" {
  default     = 443
  type        = number
  description = "ingress from port https"
}

variable "ingress_to_port_https" {
  default     = 443
  type        = string
  description = "ingress to port https"
}

variable "ingress_from_port_http" {
  default     = 80
  type        = string
  description = "ingress to port http"
}

variable "ingress_to_port_http" {
  default     = 80
  type        = string
  description = "ingress to port http"
}

variable "protocol" {
  default     = 80
  description = "Protocol for security group"
}

variable "IpAddress" {
  default     = "72.137.76.221/32"
  description = "ip address of your choice"
}

variable "bastion_key_name" {
  default     = "tuongtv-bastion"
  description = "Name of key pair"
}

variable "ec2_key_name" {
  default     = "tuongtv-web"
  description = "Name of key pair"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "ec2_ami" {
  default     = "ami-082105f875acab993"
  description = "ami of EC2"
}

variable "ec2_type" {
  default     = "t2.micro"
  description = "Type of EC2"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24"]
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list(any)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones_private" {
  default     = ["ap-southeast-1b", "ap-southeast-1c"]
  type        = list(any)
  description = "List of availability zones private"
}

variable "availability_zones_public" {
  default     = ["ap-southeast-1a"]
  type        = list(any)
  description = "List of availability zones public"
}

variable "username" {
  default = "admin"
  type    = string

}

variable "password" {
  default = "tuongtv08"
  type    = string
}