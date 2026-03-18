# ADR-015 - Lake Formation as the Governance Roadmap

## Status

Accepted

## Context

The MVP emphasizes speed and simplicity, but enterprise data governance requires finer controls.

## Decision

Document AWS Lake Formation as the future-state governance layer for S3 locations and Glue metadata resources.

## Alternatives Considered

- IAM and bucket policies only forever
- immediate Lake Formation adoption in MVP
- no data governance roadmap

## Consequences

### Positive

- clear enterprise path
- stronger future least-privilege model
- supports multi-team analytics governance

### Negative

- governance migration work will be needed later
