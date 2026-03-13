# ADR-005 - Network Segmentation Baseline

## Status
Accepted

## Context
The project needs a reusable secure network foundation for a telecommunications-oriented AWS platform.

## Decision
Use a two-AZ VPC with separate public and private subnets, dedicated route tables, and VPC Flow Logs enabled.

## Alternatives Considered
- single subnet flat network
- public-only architecture
- one-AZ lab design

## Consequences
### Positive
- better isolation
- clearer future expansion path
- supports resilient workload placement

### Negative
- more components to manage
- NAT introduces cost

## Evidence
See Terraform outputs and phase-2 screenshots.