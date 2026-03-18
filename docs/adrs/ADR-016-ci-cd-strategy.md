

# ADR-016 - CI/CD Strategy for Terraform Delivery

## Decision

Use GitHub Actions to validate Terraform code, generate execution plans, and provide artifacts for review.

## Rationale

- low operational overhead
- tight integration with repository workflow
- strong audit trail

## Trade-offs

- limited enterprise features vs full CI/CD platforms
