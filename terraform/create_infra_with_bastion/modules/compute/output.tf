# output "instance_ip_addr_public" {
#   value = aws_eip.demo-eip.public_ip
# }
output "ip_public_instance" {
  value = aws_instance.demo-instance.public_ip
}

output "ip_private_instance" {
  value = aws_instance.demo-instance.private_ip
}

