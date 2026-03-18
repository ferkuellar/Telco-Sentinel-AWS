import base64
import json
import os
from collections import Counter
from statistics import mean
from datetime import datetime, timezone

import boto3

cloudwatch = boto3.client("cloudwatch")

NAMESPACE = os.getenv("METRIC_NAMESPACE", "Telco/Observability")


def safe_float(value, default=0.0):
    try:
        return float(value)
    except Exception:
        return default


def publish_metric(name, value, dimensions):
    cloudwatch.put_metric_data(
        Namespace=NAMESPACE,
        MetricData=[
            {
                "MetricName": name,
                "Dimensions": dimensions,
                "Timestamp": datetime.now(timezone.utc),
                "Value": value,
                "Unit": "Count" if name.endswith("Count") else "None",
            }
        ],
    )


def lambda_handler(event, context):
    decoded_records = []
    event_counter = Counter()
    latency_values = []
    packet_loss_values = []
    jitter_values = []
    throughput_values = []

    for record in event.get("Records", []):
        payload = base64.b64decode(record["kinesis"]["data"]).decode("utf-8")
        item = json.loads(payload)
        decoded_records.append(item)

        event_type = item.get("event_type", "unknown")
        severity = item.get("severity", "unknown")
        site = item.get("site", "unknown")
        region = item.get("region", "unknown")

        event_counter[(event_type, severity, site, region)] += 1

        latency_values.append(safe_float(item.get("latency_ms", 0)))
        packet_loss_values.append(safe_float(item.get("packet_loss_pct", 0)))
        jitter_values.append(safe_float(item.get("jitter_ms", 0)))
        throughput_values.append(safe_float(item.get("throughput_mbps", 0)))

        print(json.dumps({
            "processed_at": datetime.now(timezone.utc).isoformat(),
            "device_id": item.get("device_id"),
            "site": site,
            "region": region,
            "event_type": event_type,
            "severity": severity,
            "latency_ms": item.get("latency_ms"),
            "packet_loss_pct": item.get("packet_loss_pct"),
            "jitter_ms": item.get("jitter_ms"),
            "throughput_mbps": item.get("throughput_mbps"),
        }))

    total_records = len(decoded_records)

    if total_records > 0:
        publish_metric("ProcessedRecordCount", total_records, [])

        publish_metric("AvgLatencyMs", mean(latency_values), [])
        publish_metric("AvgPacketLossPct", mean(packet_loss_values), [])
        publish_metric("AvgJitterMs", mean(jitter_values), [])
        publish_metric("AvgThroughputMbps", mean(throughput_values), [])

        critical_count = sum(
            1 for item in decoded_records if item.get("severity") == "critical"
        )
        publish_metric("CriticalEventCount", critical_count, [])

        for (event_type, severity, site, region), count in event_counter.items():
            publish_metric(
                "EventTypeCount",
                count,
                [
                    {"Name": "EventType", "Value": event_type},
                    {"Name": "Severity", "Value": severity},
                    {"Name": "Site", "Value": site},
                    {"Name": "Region", "Value": region},
                ],
            )

    return {
        "statusCode": 200,
        "processed_records": total_records
    }