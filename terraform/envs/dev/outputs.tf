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

output "kms_key_arn" {
  value = module.security_baseline.kms_key_arn
}

output "trail_bucket_name" {
  value = module.security_baseline.trail_bucket_name
}

output "config_bucket_name" {
  value = module.security_baseline.config_bucket_name
}

output "cloudtrail_name" {
  value = module.security_baseline.cloudtrail_name
}

output "cloudtrail_arn" {
  value = module.security_baseline.cloudtrail_arn
}

output "cloudwatch_log_group_name" {
  value = module.security_baseline.cloudwatch_log_group_name
}

output "config_recorder_name" {
  value = module.security_baseline.config_recorder_name
}

output "guardduty_detector_id" {
  value = module.security_baseline.guardduty_detector_id
}

output "securityhub_enabled" {
  value = module.security_baseline.securityhub_enabled
}

output "fsbp_enabled" {
  value = module.security_baseline.fsbp_enabled
}