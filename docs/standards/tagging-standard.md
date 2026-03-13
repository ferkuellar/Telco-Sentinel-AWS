
# Tagging Standard

## Mandatory Tags

- Project
- Environment
- Owner
- Domain
- CostCenter
- DataClassification
- ManagedBy

## Mandatory Default Values for Phase 1

- Project = Telco-Sentinel-AWS
- Environment = dev
- Owner = Fernando
- Domain = shared
- CostCenter = ArchitectureLab
- DataClassification = Internal
- ManagedBy = Terraform

## Recommended Optional Tags

- Service
- Criticality
- ComplianceScope
- Lifecycle
- SupportGroup

## Tagging Rules

- all Terraform-managed resources must include mandatory tags
- tags are for cost, operations, automation, and governance
- tags must not contain secrets or sensitive information
- tag drift must be recorded and corrected
- cost allocation tags should be activated when the implementation phase begins
