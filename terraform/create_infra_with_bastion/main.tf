provider "aws" {
  region = var.region
}
module "security" {
  source = "./modules/Security"
  vpc_id = module.networking.vpc_id
  region = var.region
}

#Create a complete VPC using module networking
module "networking" {
  source = "./modules/networking"
  cidr_block = var.cidr_block
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
  region = var.region
  public_subnet_ips = var.public_subnet_ips
  private_subnet_ips = var.private_subnet_ips
}


resource "aws_key_pair" "demo_keypair" {
  key_name = "demo_keypair"
  public_key = file(var.keypair_path)
}

# module "bastion-compute" {
#   source = "./modules/compute"
#   ec2_security_group_ids = [module.security.public_security_group_id]
#   key_name = aws_key_pair.demo_keypair.key_name
#   region = var.region
#   image_id = var.amis[var.region] 
#   subnet_id = module.networking.public_subnet_ids[0]
#   associate_public_ip_address = true
#   instance_name = var.instance_name[1]
# }

module "compute" {
  source = "./modules/compute"
  count = 3
  ec2_security_group_ids = [module.security.public_security_group_id]
  key_name = aws_key_pair.demo_keypair.key_name
  image_id = var.amis[var.region]
  subnet_id = module.networking.public_subnet_ids[0]
  instance_name = var.instance_name[0]
  associate_public_ip_address = true
  instance_type = var.instance_type
}