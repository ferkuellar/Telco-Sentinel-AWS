# ADR-006 - NAT Strategy for MVP vs Target State

## Status

Accepted

## Context

Private subnets require outbound internet access for updates, package retrieval, or managed service communication patterns.

## Decision

Use a single NAT Gateway in the MVP for cost control, while documenting the enterprise target state as one NAT per AZ or regional NAT depending on the future architecture choice.

## Alternatives Considered

- one NAT per AZ immediately
- no NAT and no outbound internet path
- NAT instances

## Consequences

### Positive

- lower initial lab cost
- simpler MVP deployment

### Negative

- reduced AZ independence in the MVP
- enterprise hardening required later

## Evidence

See network-flow.md, route tables, and Terraform plan.
