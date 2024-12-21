variable "region" {
  type    = string
  default = "us-east-2"
}

variable "provider_vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "consumer_vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "private_subnet_cidrs_provider" {
  type    = list(string)
  default = ["10.0.1.0/24","10.0.3.0/24"]
}

variable "instance_ami" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-036841078a4b68e14"  
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}


variable "consumer_availability_zones" {
  default = ["us-east-2a", "us-east-2b"] 
}

variable "private_subnet_cidrs_consumer" {
  type    = list(string)
  default = [
    "10.1.4.0/24"#private
  ] 
}

variable "public_subnet_cidrs_consumer" {
  type    = list(string)
  default = [
    "10.1.1.0/24"#public
  ] 
}