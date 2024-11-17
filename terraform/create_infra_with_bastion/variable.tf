variable "region" {
  type = string
  default = "ap-southeast-1"
}
#parameters for networking module
variable "availability_zone_1" {
  type = string
  nullable = false
}
variable "availability_zone_2" {
  type = string
  nullable = false
}
variable "cidr_block" {
  type = string
  nullable = false
}
variable "public_subnet_ips" {
  type = list(string)
  nullable = false
  
}
variable "private_subnet_ips" {
  type = list(string)
  nullable = false
}

variable "instance_name" {
  type =  list(string)
  nullable = false
}

#parameter for compute module
variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to launch. Example: t3.micro"
  default = "t3.micro"
}
variable "amis" {
  type = map(any)
  default = {
    "ap-southeast-1" : "ami-03fa85deedfcac80b"
  }
}
variable "keypair_path" {
  type = string
  default = "./keypair/keyssh.pub"
}
