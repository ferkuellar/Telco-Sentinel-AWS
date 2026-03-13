# Runbook - Security Baseline Validation

## Purpose

Validate the audit and security posture baseline deployed in Phase 3.

## Preconditions

- Terraform apply completed successfully
- AWS CLI configured
- Correct region selected

## Steps

1. Confirm CloudTrail exists and is logging
2. Confirm the trail is multi-Region
3. Confirm log file validation is enabled
4. Confirm CloudWatch Logs integration exists
5. Confirm S3 log bucket is encrypted and blocked from public access
6. Confirm AWS Config recorder exists and is enabled
7. Confirm delivery channel exists
8. Confirm GuardDuty detector is enabled
9. Confirm Security Hub CSPM is enabled
10. Confirm FSBP standard is subscribed

## Validation Commands

- aws cloudtrail describe-trails
- aws cloudtrail get-trail-status
- aws configservice describe-configuration-recorders
- aws configservice describe-delivery-channels
- aws guardduty list-detectors
- aws securityhub get-enabled-standards
