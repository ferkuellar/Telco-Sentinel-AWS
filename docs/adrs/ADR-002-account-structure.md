# ADR-002 - Multi-Account Target Structure

## Status

Accepted

## Context

The project must reflect enterprise governance patterns suitable for a telecommunications platform, while the initial implementation may begin in a limited environment.

## Decision

Adopt a target AWS multi-account structure with dedicated governance, security, observability, workload, and sandbox boundaries.

## Alternatives Considered

- single account for everything
- separate only dev and prod
- document nothing and improvise later

## Consequences

### Positive

- clearer trust boundaries
- better scaling path
- easier cost and control segmentation

### Negative

- more up-front design work
- staged implementation complexity

## Evidence

See account-model.md and logical-architecture.md
