# Account Model

## Objective

Define the target AWS multi-account structure for the Telco-Sentinel-AWS platform.

## Target Organizational Structure

- Management OU
- Security OU
- Infrastructure OU
- Workloads OU
- Sandbox OU

## Proposed Accounts

### Management Account

Used for top-level billing, organization administration, and governance visibility.

### Log Archive Account

Dedicated to centralized security and operational log retention.

### Audit Account

Used for security review, read-only audit tooling, and governance inspection.

### Shared Services Account

Hosts shared CI/CD, shared DNS, artifact repositories, and cross-cutting services.

### Observability Account

Hosts centralized dashboards, metrics aggregation, analytics integrations, and NOC-facing tooling.

### Telco Platform Dev

Development environment for the telecommunications workload.

### Telco Platform Prod

Production environment for the telecommunications workload.

### Experimentation Account

Used for sandbox work, prototyping, and isolated experiments.

## Notes

This account model is documented in Phase 1 and may be implemented incrementally in later phases.
