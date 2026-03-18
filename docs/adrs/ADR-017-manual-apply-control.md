# ADR-017 - Manual Apply Control

## Decision

Keep Terraform apply as a manual step during the MVP phase.

## Rationale

- prevents unintended infrastructure changes
- enforces review discipline
- aligns with enterprise gated deployment patterns

## Trade-offs

- slower delivery
- requires operator intervention
