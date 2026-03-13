
# Naming Standard

## Objective

Define deterministic and auditable resource naming.

## General Pattern

`<company>`-`<domain>`-`<env>`-`<resource>`-`<region>`

## Examples

- novatel-gov-dev-s3logs-use1
- novatel-sec-dev-kms-use1
- novatel-obsv-dev-dashboard-use1
- novatel-net-dev-vpc-use1
- novatel-telco-prod-stream-use1

## Domain Values

- gov
- sec
- net
- obsv
- data
- telco
- shared

## Environment Values

- dev
- prod

## Rules

- lowercase only
- hyphen-separated
- no spaces
- no vague abbreviations
- include environment
- include domain
- preserve naming stability for evidence consistency
