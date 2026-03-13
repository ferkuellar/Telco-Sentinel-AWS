
# Subnet Segmentation

## Public Tier
Public subnets are intended for internet-facing components such as future load balancers, NAT placement, or tightly controlled bastion-style access if ever required.

## Private Tier
Private subnets are intended for application components, telemetry processors, data collectors, and internal services that should not receive direct inbound internet traffic.

## Security Principles
- private subnets have no direct route to the Internet Gateway
- outbound internet access from private tier uses NAT
- baseline security groups are role-oriented
- network telemetry is captured using VPC Flow Logs
