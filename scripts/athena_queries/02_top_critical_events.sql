SELECT event_type, site, count(*) AS total_critical
FROM novatel_data_dev_db.telco_telemetry_raw
WHERE severity = 'critical'
GROUP BY event_type, site
ORDER BY total_critical DESC
LIMIT 20;