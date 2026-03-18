CREATE EXTERNAL TABLE IF NOT EXISTS novatel_data_dev_db.telco_telemetry_raw (
  timestamp string,
  device_id string,
  site string,
  region string,
  severity string,
  latency_ms double,
  packet_loss_pct double,
  jitter_ms double,
  throughput_mbps double
)
PARTITIONED BY (
  year string,
  month string,
  day string,
  event_type string
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://REPLACE_RAW_BUCKET/telemetry/'
TBLPROPERTIES ('has_encrypted_data'='true');