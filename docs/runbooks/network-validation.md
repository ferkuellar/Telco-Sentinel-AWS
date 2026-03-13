# Runbook - Network Validation

## Purpose

Validate that the Phase 2 network baseline deployed correctly.

## Preconditions

- AWS credentials configured
- Terraform apply completed successfully
- Region confirmed

## Steps

1. Confirm VPC exists
2. Confirm subnets exist in two AZs
3. Confirm IGW attached
4. Confirm NAT Gateway is available
5. Confirm public and private route tables exist
6. Confirm subnet associations
7. Confirm security groups exist
8. Confirm Flow Logs are enabled
9. Export CLI outputs into evidence folder

## Validation

- VPC status visible
- subnets correctly tagged
- default routes present
- NAT state is available
- flow logs active

## Evidence

- aws ec2 describe-vpcs
- aws ec2 describe-subnets
- aws ec2 describe-route-tables
- aws ec2 describe-nat-gateways
- aws ec2 describe-security-groups
- aws ec2 describe-flow-logs
