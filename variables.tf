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

variable "name_tag"{
	default	="Webserver"
	type		=string
	description 	="Name of the VPC"
}

variable "environment_tag"{
	default	="Development"
	type 		=string
	description 	="Development of the VPC"
}

variable "ingressfromport" {
  	description = "ingress from port"
}

variable "ingresstoport" {
  	description = "ingress to port"
}

variable "IpAddress" {
  	description = "ip address of your choice"
}

variable "egressfromport" {
  	description = "egress from port"
}

variable "egresstoport" {
  	description = "egress to port"
}

variable "protocol" {
  	description = "protocol for security group"
}

variable "key_name" {
  	description = "name of key pair"
}
	
variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}

variable "ec2_ami" {
  description = "ami of EC2"
}

variable "ec2_type" {
  description = "type of EC2"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
  type        = list
  description = "List of availability zones"
}

variable "username"{
  default     ="admin"
  type        =string

}

variable "password"{
  default     ="tuongtv08"
  type        = string
}