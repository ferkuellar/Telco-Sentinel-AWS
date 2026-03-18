# Partition Strategy

## Objective

Reduce Athena scan volume and improve query efficiency.

## Partition Keys

- year
- month
- day
- event_type

## Rationale

Time-based partitioning is a natural fit for telemetry and operational log data.
Adding event_type supports common troubleshooting and trend queries.

## Example Prefix

```telemetry/year=2026/month=03/day=17/event_type=latency_high/
telemetry/year=2026/month=03/day=17/event_type=latency_high/
```
