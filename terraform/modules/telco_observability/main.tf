data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = abspath("${path.module}/../../../scripts/lambda_src/lambda_function.py")
  output_path = abspath("${path.module}/lambda_function.zip")
}

resource "aws_kinesis_stream" "telemetry" {
  name             = "${var.name_prefix}-stream"
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-stream"
    Domain = "obsv"
  })
}

resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-lambda-role"
    Domain = "obsv"
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_extra" {
  name = "${var.name_prefix}-lambda-extra"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:PutMetricData"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:ListShards",
          "kinesis:SubscribeToShard"
        ],
        Resource = aws_kinesis_stream.telemetry.arn
      }
    ]
  })
}

resource "aws_lambda_function" "processor" {
  function_name    = "${var.name_prefix}-processor"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 60
  memory_size      = 256

  environment {
    variables = {
      METRIC_NAMESPACE = var.metric_namespace
    }
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-processor"
    Domain = "obsv"
  })
}

resource "aws_lambda_event_source_mapping" "kinesis_to_lambda" {
  event_source_arn  = aws_kinesis_stream.telemetry.arn
  function_name     = aws_lambda_function.processor.arn
  starting_position = "LATEST"
  batch_size        = 50
  enabled           = true
}

resource "aws_cloudwatch_dashboard" "noc" {
  dashboard_name = "${var.name_prefix}-noc-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric",
        x      = 0,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title   = "Kinesis Stream Throughput"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/Kinesis", "IncomingRecords", "StreamName", aws_kinesis_stream.telemetry.name],
            [".", "IncomingBytes", ".", "."]
          ]
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 0,
        width  = 12,
        height = 6,
        properties = {
          title   = "Lambda Processing"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            ["AWS/Lambda", "Invocations", "FunctionName", aws_lambda_function.processor.function_name],
            [".", "Errors", ".", "."],
            [".", "Duration", ".", "."]
          ]
        }
      },
      {
        type   = "metric",
        x      = 0,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title   = "Telco Custom Metrics"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            [var.metric_namespace, "ProcessedRecordCount"],
            [".", "CriticalEventCount"],
            [".", "AvgLatencyMs"],
            [".", "AvgPacketLossPct"]
          ]
        }
      },
      {
        type   = "metric",
        x      = 12,
        y      = 6,
        width  = 12,
        height = 6,
        properties = {
          title   = "Avg Jitter and Throughput"
          view    = "timeSeries"
          stacked = false
          region  = var.aws_region
          metrics = [
            [var.metric_namespace, "AvgJitterMs"],
            [".", "AvgThroughputMbps"]
          ]
        }
      }
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "critical_events" {
  alarm_name          = "${var.name_prefix}-critical-events"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CriticalEventCount"
  namespace           = var.metric_namespace
  period              = 60
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Alarm when critical telco events spike"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-critical-events-alarm"
    Domain = "obsv"
  })
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${var.name_prefix}-lambda-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0
  alarm_description   = "Alarm when Lambda processor errors occur"
  dimensions = {
    FunctionName = aws_lambda_function.processor.function_name
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-lambda-errors-alarm"
    Domain = "obsv"
  })
}