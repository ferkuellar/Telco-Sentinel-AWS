output "kms_key_arn" {
  value = aws_kms_key.trail.arn
}

output "trail_bucket_name" {
  value = aws_s3_bucket.trail_logs.bucket
}

output "config_bucket_name" {
  value = try(aws_s3_bucket.config[0].bucket, null)
}

output "cloudtrail_name" {
  value = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  value = aws_cloudtrail.main.arn
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.trail.name
}

output "config_recorder_name" {
  value = try(aws_config_configuration_recorder.main[0].name, null)
}

output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "securityhub_enabled" {
  value = true
}

output "fsbp_enabled" {
  value = true
}
