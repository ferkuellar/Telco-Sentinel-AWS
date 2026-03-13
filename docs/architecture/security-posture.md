# Security Posture Architecture

## Objective

Define the baseline audit and security posture services for Telco-Sentinel-AWS.

## Services Included

- AWS CloudTrail
- AWS Config
- AWS KMS
- Amazon S3 for security logs
- Amazon CloudWatch Logs
- Amazon GuardDuty
- AWS Security Hub CSPM
- AWS Foundational Security Best Practices standard

## Diagram

```mermaid
flowchart TD
    A[AWS Account / Region] --> B[CloudTrail Multi-Region]
    A --> C[AWS Config]
    A --> D[GuardDuty]
    A --> E[Security Hub CSPM]

    B --> F[S3 Log Bucket]
    B --> G[CloudWatch Logs]
    B --> H[KMS Key]

    C --> I[Config Recorder]
    C --> J[Config Delivery Channel]
    J --> F

    D --> E
    B --> E
    C --> E

    E --> K[FSBP Controls]
    E --> L[Findings]
    E --> M[Security Score]
```
