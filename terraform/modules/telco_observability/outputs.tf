output "kinesis_stream_name" {
  value = aws_kinesis_stream.telemetry.name
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.telemetry.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.processor.function_name
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.noc.dashboard_name
}

output "critical_events_alarm_name" {
  value = aws_cloudwatch_metric_alarm.critical_events.alarm_name
}

output "lambda_errors_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_errors.alarm_name
}

output "metric_namespace" {
  value = var.metric_namespace
}