region = "ap-southeast-1"
availability_zone_1 = "ap-southeast-1a"
availability_zone_2 = "ap-southeast-1b"
cidr_block = "10.10.0.0/16"
public_subnet_ips = [ "10.10.1.0/24", "10.10.2.0/24" ]
private_subnet_ips = [ "10.10.3.0/24", "10.10.4.0/24" ]
keypair_path = "./keypair/keyssh.pub"
instance_type = "t2.medium"
instance_name = ["Demo private instance" , "Demo public instance"]

