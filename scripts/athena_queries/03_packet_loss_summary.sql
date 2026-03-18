SELECT site,
       avg(packet_loss_pct) AS avg_packet_loss,
       max(packet_loss_pct) AS max_packet_loss
FROM novatel_data_dev_db.telco_telemetry_raw
GROUP BY site
ORDER BY avg_packet_loss DESC;