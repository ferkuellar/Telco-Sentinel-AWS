# MSK Enterprise Roadmap

## When to move beyond Kinesis + Lambda

Move to Amazon MSK or MSK Serverless when the platform needs:

- Kafka-native producer and consumer compatibility
- multiple platform teams consuming the same event backbone
- connector ecosystem support
- more elaborate topic strategy and retention behavior
- broader event replay and event contract maturity

## Target State

- Amazon MSK or MSK Serverless
- topic-per-domain or topic-per-event-family
- schema governance
- stream processing with dedicated consumers
- optional connectors for sinks and analytics platforms

## Trade-off Summary

Kinesis + Lambda is excellent for a controlled MVP.
MSK becomes attractive when platform complexity and organizational scale increase.
