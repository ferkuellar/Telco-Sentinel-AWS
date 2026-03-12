# Tagging Standard

## Mandatory Tags

- Project = Telco-Sentinel-AWS
- Environment = dev
- Owner = Fernando
- Domain = shared
- CostCenter = ArchitectureLab
- DataClassification = Internal
- ManagedBy = Terraform

## Optional Tags

- Service
- Criticality
- ComplianceScope
- Lifecycle

## Rules

- all Terraform-managed resources must include mandatory tags
- tags must be documented in plan reviews
- tag drift must be recorded as a governance issue
