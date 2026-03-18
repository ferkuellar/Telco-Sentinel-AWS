# Lake Formation Roadmap

## Why Lake Formation

Future enterprise governance will require finer-grained permissions on S3-backed data and Data Catalog resources.

## Target State

- register S3 locations with Lake Formation
- move from broad S3/IAM-only access to finer permissions
- govern database, table, and column access
- support multi-team analytics securely

## Current State

The MVP uses S3 + Glue + Athena without Lake Formation enforcement.
