# ADR-009 - GuardDuty and Security Hub CSPM Baseline

## Status

Accepted

## Context

The project needs a realistic security posture baseline for an enterprise-style telecommunications platform.

## Decision

Enable GuardDuty and Security Hub CSPM in the lab region, and enable the AWS Foundational Security Best Practices standard.

## Alternatives Considered

- GuardDuty only
- Security Hub only
- defer posture services to later phases

## Consequences

### Positive

- unified findings view
- stronger baseline posture visibility
- measurable control coverage

### Negative

- initial findings may be noisy
- regional scope in MVP is narrower than enterprise target state

## Evidence

See detector ID, Security Hub enablement, and FSBP subscription evidence.
