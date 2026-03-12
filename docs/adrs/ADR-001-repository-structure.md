# ADR-001 - Repository Structure and Evidence Layout

## Status

Accepted

## Context

The project needs a repeatable structure that supports architecture documentation, Terraform delivery, and evidence-based execution by phase.

## Decision

Adopt a repository model with:

- docs/
- terraform/
- scripts/
- evidence/
- .github/

Each phase will have a dedicated evidence area.

## Alternatives Considered

- Flat repository with minimal folders
- Docs outside the repository
- Single evidence folder without phase separation

## Consequences

### Positive

- easier auditability
- cleaner project navigation
- scalable for future phases

### Negative

- more up-front setup
- stricter discipline required

## Evidence

See phase-0 outputs and screenshots.
