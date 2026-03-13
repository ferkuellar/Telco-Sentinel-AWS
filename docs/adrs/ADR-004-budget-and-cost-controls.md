# ADR-004 - Budget and Cost Governance

## Status

Accepted

## Context

The project should demonstrate cost awareness from the beginning, even before all cloud resources are deployed.

## Decision

Define budget thresholds and cost governance rules in Phase 1, and implement AWS Budgets and cost allocation visibility in later phases.

## Alternatives Considered

- no budget model during design
- only estimate costs informally
- wait until production-style phases

## Consequences

### Positive

- cost awareness early
- easier spend discipline
- cleaner maturity path

### Negative

- some controls are initially documentary rather than technical

## Evidence

See budget-strategy.md and governance-scorecard.md
