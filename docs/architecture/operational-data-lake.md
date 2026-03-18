# Operational Data Lake

## Objective

Store, catalog, and query telecommunications telemetry data for historical operations analysis.

## Core Components

- Amazon S3 raw zone
- Amazon S3 curated zone
- AWS Glue Data Catalog
- Amazon Athena
- S3 Athena query results bucket

## Diagram

```mermaid
flowchart LR
    KDS[Kinesis Data Stream] --> LMB[Lambda Processor]
    LMB --> S3RAW[S3 Raw Zone]
    S3RAW --> GLUE[AWS Glue Data Catalog]
    GLUE --> ATHENA[Amazon Athena]
    ATHENA --> S3RES[S3 Athena Results]
    ATHENA --> OPS[Operational Queries / KPIs]
    S3RAW --> CURATED[S3 Curated Zone]
```
