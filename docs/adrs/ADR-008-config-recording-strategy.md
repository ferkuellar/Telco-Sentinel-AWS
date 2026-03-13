# ADR-008 - AWS Config Recording Strategy

## Status

Accepted

## Context

Security posture controls depend on reliable configuration recording and resource visibility.

## Decision

Enable AWS Config to record all supported resource types and include global resource types for the lab account.

## Alternatives Considered

- selective resource recording
- no Config in MVP
- manual posture checks only

## Consequences

### Positive

- stronger compliance visibility
- better support for Security Hub control evaluation

### Negative

- additional cost
- more findings to triage

## Evidence

See Config recorder status, delivery channel, and Security Hub findings.
