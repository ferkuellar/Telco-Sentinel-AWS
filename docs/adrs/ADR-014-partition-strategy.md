# ADR-014 - Partition Strategy for Telemetry Data

## Status

Accepted

## Context

Athena cost and performance depend heavily on scanned data volume.

## Decision

Partition the raw telemetry dataset by year, month, day, and event_type.

## Alternatives Considered

- no partitions
- time-only partitions
- over-partitioning by too many dimensions

## Consequences

### Positive

- lower scan cost
- faster operational queries
- natural mapping to telemetry troubleshooting

### Negative

- partition management overhead
