# Telco Observability Architecture

## Objective

Provide a real-time observability baseline for simulated telecommunications telemetry.

## MVP Pattern

- Telemetry producer in Python
- Amazon Kinesis Data Stream
- AWS Lambda processor
- CloudWatch Logs
- CloudWatch custom metrics
- CloudWatch NOC dashboard
- CloudWatch alarms

## Diagram

```mermaid
flowchart LR
    PROD[Telemetry Producer<br/>Python simulator] --> KDS[Kinesis Data Stream]
    KDS --> LMB[Lambda Processor]
    LMB --> CWM[CloudWatch Custom Metrics]
    LMB --> CWL[CloudWatch Logs]
    CWM --> DSH[NOC Dashboard]
    CWM --> ALM[CloudWatch Alarms]
```
