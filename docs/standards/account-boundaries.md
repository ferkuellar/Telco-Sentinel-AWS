# Account Boundaries Standard

## Purpose

Define what belongs in each AWS account and what must not be mixed.

## Rules

### Management Account

- organization administration only
- no application workloads
- no experimentation

### Log Archive Account

- centralized log storage only
- no application runtime
- restricted write paths

### Audit Account

- read-only inspection and audit tooling
- no application deployment

### Shared Services Account

- CI/CD runners
- artifact storage
- shared automation
- future identity integrations

### Observability Account

- dashboards
- monitoring aggregation
- operational analytics

### Workload Accounts

- application and data plane resources
- isolated by environment

### Sandbox Account

- isolated experiments only
- lower trust boundary
- tighter budget controls
