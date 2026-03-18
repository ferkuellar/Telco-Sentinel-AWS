SELECT year, month, day, event_type, count(*) AS total_events
FROM novatel_data_dev_db.telco_telemetry_raw
GROUP BY year, month, day, event_type
ORDER BY year DESC, month DESC, day DESC, total_events DESC;