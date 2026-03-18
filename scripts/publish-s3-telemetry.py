import json
import random
import sys
from datetime import datetime, timezone

import boto3

REGION = sys.argv[1] if len(sys.argv) > 1 else "us-east-1"
BUCKET = sys.argv[2] if len(sys.argv) > 2 else None
ITERATIONS = int(sys.argv[3]) if len(sys.argv) > 3 else 200

if not BUCKET:
    raise SystemExit("Usage: python publish-s3-telemetry.py <region> <bucket> [iterations]")

s3 = boto3.client("s3", region_name=REGION)

SITES = ["chihuahua-dc1", "juarez-edge1", "monterrey-core1"]
EVENT_TYPES = [
    "latency_high",
    "packet_loss_high",
    "jitter_high",
    "interface_down",
    "throughput_spike"
]
SEVERITIES = ["warning", "critical"]


def make_event():
    now = datetime.now(timezone.utc)
    event_type = random.choice(EVENT_TYPES)
    severity = random.choices(SEVERITIES, weights=[0.75, 0.25])[0]

    item = {
        "timestamp": now.isoformat(),
        "device_id": f"router-{random.randint(100,999)}",
        "site": random.choice(SITES),
        "region": REGION,
        "event_type": event_type,
        "severity": severity,
        "latency_ms": round(random.uniform(8, 180), 2),
        "packet_loss_pct": round(random.uniform(0, 8), 2),
        "jitter_ms": round(random.uniform(1, 60), 2),
        "throughput_mbps": round(random.uniform(20, 1500), 2),
    }

    if event_type == "interface_down":
        item["latency_ms"] = 0
        item["packet_loss_pct"] = 100
        item["throughput_mbps"] = 0

    return item, now


for i in range(ITERATIONS):
    event, now = make_event()
    key = (
        f"telemetry/"
        f"year={now:%Y}/month={now:%m}/day={now:%d}/"
        f"event_type={event['event_type']}/"
        f"event-{i:05d}.json"
    )
    s3.put_object(
        Bucket=BUCKET,
        Key=key,
        Body=json.dumps(event).encode("utf-8"),
        ContentType="application/json",
    )
    print(json.dumps({"bucket": BUCKET, "key": key, "event_type": event["event_type"]}))