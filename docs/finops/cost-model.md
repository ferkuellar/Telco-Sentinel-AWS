# Cost Model - Telco Sentinel AWS

## Overview

This project uses a consumption-based cost model aligned with AWS pricing.

## Major Cost Drivers

### 1. Kinesis Data Streams

- cost per shard/hour
- PUT payload units

### 2. Lambda

- invocation count
- execution duration

### 3. S3

- storage (GB/month)
- PUT/GET requests

### 4. CloudWatch

- metrics
- logs ingestion

### 5. NAT Gateway

- hourly + data processing

## Estimated Monthly Cost (Lab)

| Component       | Estimated Cost |
| --------------- | -------------- |
| Kinesis         | $10            |
| Lambda          | $5             |
| S3              | $3             |
| CloudWatch      | $5             |
| NAT Gateway     | $30            |
| **Total** | **~$53** |

## Observations

NAT Gateway dominates cost in small environments.
