import json
import random
import sys
import time
from datetime import datetime, timezone

import boto3

STREAM_NAME = sys.argv[1] if len(sys.argv) > 1 else "novatel-obsv-dev-stream"
REGION = sys.argv[2] if len(sys.argv) > 2 else "us-east-1"
ITERATIONS = int(sys.argv[3]) if len(sys.argv) > 3 else 100
SLEEP_SECONDS = float(sys.argv[4]) if len(sys.argv) > 4 else 0.2

kinesis = boto3.client("kinesis", region_name=REGION)

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
    event_type = random.choice(EVENT_TYPES)
    severity = random.choices(SEVERITIES, weights=[0.75, 0.25])[0]

    base = {
        "timestamp": datetime.now(timezone.utc).isoformat(),
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
        base["latency_ms"] = 0
        base["packet_loss_pct"] = 100
        base["throughput_mbps"] = 0

    return base


for _ in range(ITERATIONS):
    event = make_event()
    response = kinesis.put_record(
        StreamName=STREAM_NAME,
        Data=json.dumps(event),
        PartitionKey=event["site"]
    )
    print(json.dumps({
        "sequence_number": response["SequenceNumber"],
        "event": event
    }))
    time.sleep(SLEEP_SECONDS)