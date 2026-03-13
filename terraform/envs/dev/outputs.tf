output "phase" {
  value = "phase-2"
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "internet_gateway_id" {
  value = module.network.internet_gateway_id
}

output "nat_gateway_id" {
  value = module.network.nat_gateway_id
}

output "public_route_table_id" {
  value = module.network.public_route_table_id
}

output "private_route_table_id" {
  value = module.network.private_route_table_id
}

output "public_security_group_id" {
  value = module.network.public_security_group_id
}

output "private_security_group_id" {
  value = module.network.private_security_group_id
}

output "flow_log_id" {
  value = module.network.flow_log_id
}

output "flow_log_group_name" {
  value = module.network.flow_log_group_name
}