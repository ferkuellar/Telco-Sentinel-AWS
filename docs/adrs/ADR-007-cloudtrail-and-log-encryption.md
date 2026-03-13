# ADR-007 - CloudTrail with KMS Encryption and CloudWatch Integration

## Status
Accepted

## Context
The platform requires auditable API and console activity with secure storage and near-real-time visibility.

## Decision
Enable a multi-Region CloudTrail with management events, log file validation, CloudWatch Logs integration, and KMS encryption for storage resources.

## Alternatives Considered
- single-region trail only
- S3-only logging without CloudWatch integration
- no KMS encryption

## Consequences
### Positive
- stronger audit coverage
- better log integrity posture
- faster troubleshooting visibility

### Negative
- more components to manage
- higher cost than minimal logging

## Evidence
See CloudTrail outputs, screenshots, and Security Hub control posture.
---
