# output "ip_public_bastion" {
#   value = module.bastion-compute.ip_public_instance
# }

# output "ip_private_bastion" {
#   value = module.bastion-compute.ip_private_instance
# }

output "ip_private_instance" {
  value = [for node in module.compute : node.ip_private_instance]
  description = "Private IP addresses of all nodes"
}


output "ip_public_instance" {
  value = [for node in module.compute : node.ip_public_instance]
  description = "Public IP addresses of all nodes"
}