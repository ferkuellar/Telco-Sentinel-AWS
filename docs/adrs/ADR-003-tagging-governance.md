# ADR-003 - Tagging Governance Baseline

## Status

Accepted

## Context

The project requires reliable tagging for cost allocation, operations, and governance.

## Decision

Adopt a mandatory tag baseline applied through Terraform default_tags and document enforcement expectations for all future modules.

## Alternatives Considered

- optional tagging
- service-by-service tagging
- manual tagging in console

## Consequences

### Positive

- better cost visibility
- easier filtering and automation
- more consistent inventory management

### Negative

- stricter discipline required
- occasional edge cases where resources support tags differently

## Evidence

See tagging-standard.md and terraform outputs
