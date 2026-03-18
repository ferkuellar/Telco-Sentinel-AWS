# Runbook - Observability Validation

## Purpose

Validate the real-time telco observability baseline in Phase 4.

## Preconditions

- Terraform apply completed successfully
- Stream and Lambda created
- AWS CLI configured
- Python and boto3 available locally

## Steps

1. Confirm the Kinesis stream exists
2. Confirm the Lambda processor exists
3. Confirm event source mapping is enabled
4. Generate sample telemetry events
5. Validate Lambda invocation activity
6. Validate Lambda logs
7. Validate custom metrics appear in CloudWatch
8. Validate dashboard renders data
9. Validate alarms exist

## Validation Commands

- aws kinesis describe-stream-summary
- aws lambda get-function
- aws lambda list-event-source-mappings
- aws cloudwatch list-metrics
- aws cloudwatch describe-alarms
- aws logs describe-log-groups
