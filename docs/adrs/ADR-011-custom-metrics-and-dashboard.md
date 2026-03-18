# ADR-011 - CloudWatch Custom Metrics and NOC Dashboard

## Status

Accepted

## Context

The platform needs visible operational KPIs for network-like telemetry.

## Decision

Publish custom metrics from Lambda to CloudWatch and use a CloudWatch dashboard for the initial NOC view.

## Alternatives Considered

- logs only
- external dashboard tools first
- no custom metrics

## Consequences

### Positive

- immediate visibility
- simple AWS-native implementation
- low friction for evidence capture

### Negative

- dashboard sophistication is limited compared to a mature observability stack
