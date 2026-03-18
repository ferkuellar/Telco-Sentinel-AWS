output "raw_bucket_name" {
  value = aws_s3_bucket.raw.bucket
}

output "curated_bucket_name" {
  value = aws_s3_bucket.curated.bucket
}

output "athena_results_bucket_name" {
  value = aws_s3_bucket.athena_results.bucket
}

output "glue_database_name" {
  value = aws_glue_catalog_database.telco.name
}

output "athena_workgroup_name" {
  value = aws_athena_workgroup.telco.name
}