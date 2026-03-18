# Delivery Pipeline Architecture

## Objective

Provide a controlled and auditable CI/CD pipeline for Terraform-based infrastructure delivery.

## Components

- GitHub repository
- GitHub Actions workflow
- Terraform CLI
- AWS environment
- Artifact storage for tfplan

## Diagram

```mermaid
flowchart LR
    DEV[Developer] --> PR[Pull Request]
    PR --> CI[GitHub Actions CI]
    CI --> FMT[terraform fmt]
    CI --> VAL[terraform validate]
    CI --> PLAN[terraform plan]
    PLAN --> ART[tfplan artifact]
    ART --> REVIEW[Manual Review]
    REVIEW --> APPLY[Manual Apply]
```
