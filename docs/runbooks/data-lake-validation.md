# Runbook - Data Lake Validation

## Purpose

Validate the operational data lake deployed in Phase 5.

## Preconditions

- Terraform apply completed successfully
- AWS CLI configured
- Athena permissions available
- Sample telemetry published to S3

## Steps

1. Confirm S3 raw, curated, and Athena results buckets exist
2. Confirm public access is blocked
3. Confirm encryption is enabled
4. Confirm lifecycle rules exist
5. Confirm Glue database exists
6. Confirm Athena workgroup exists
7. Publish sample telemetry to raw zone
8. Create external table in Athena
9. Repair or add partitions
10. Run validation queries
11. Capture evidence

## Validation Commands

- aws s3api list-buckets
- aws s3api get-bucket-encryption
- aws s3api get-bucket-lifecycle-configuration
- aws glue get-database
- aws athena get-work-group
