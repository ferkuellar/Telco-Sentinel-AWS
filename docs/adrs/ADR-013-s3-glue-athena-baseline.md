# ADR-013 - S3 + Glue + Athena Baseline

## Status

Accepted

## Context

The platform needs a practical historical analytics layer for telecommunications telemetry.

## Decision

Use Amazon S3 for storage, AWS Glue Data Catalog for metadata, and Amazon Athena for serverless querying.

## Alternatives Considered

- warehouse-first approach
- self-managed query engine
- no historical query layer

## Consequences

### Positive

- fast implementation
- low operational friction
- native integration across AWS analytics services

### Negative

- raw JSON query efficiency is limited compared to optimized columnar formats
- partition hygiene becomes important
