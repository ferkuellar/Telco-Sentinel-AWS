# Naming Standard

## Objective

Define consistent resource naming across the project.

## Pattern

`<company>`-`<domain>`-`<env>`-`<resource>`-`<region>`

## Examples

- novatel-gov-dev-s3logs-use1
- novatel-net-dev-vpc-use1
- novatel-obsv-dev-kinesis-use1
- novatel-sec-dev-kms-use1

## Rules

- lowercase only
- use hyphens as separators
- avoid ambiguous abbreviations
- include environment
- include domain when relevant
- keep names deterministic for evidence traceability
