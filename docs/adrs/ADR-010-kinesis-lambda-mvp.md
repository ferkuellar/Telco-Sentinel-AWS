# ADR-010 - Kinesis and Lambda for the MVP

## Status

Accepted

## Context

The project needs a working real-time telemetry pipeline without excessive operational complexity.

## Decision

Use Amazon Kinesis Data Streams as the event backbone and AWS Lambda as the processor for the MVP observability phase.

## Alternatives Considered

- Amazon MSK immediately
- EC2-based Kafka
- batch-only processing

## Consequences

### Positive

- fast time to value
- lower operational burden
- native AWS integrations for metrics and monitoring

### Negative

- less Kafka portability
- less flexible event platform than an enterprise Kafka backbone
