data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  cloudwatch_logs_service_principal = "logs.${var.aws_region}.amazonaws.com"
  cloudwatch_log_group_name         = "/aws/cloudtrail/${var.name_prefix}"
  cloudwatch_log_group_arn          = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:${local.cloudwatch_log_group_name}"
}

resource "aws_kms_key" "trail" {
  description             = "KMS key for CloudTrail, CloudWatch Logs, and AWS Config delivery"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableRootPermissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogsUseOfTheKey"
        Effect = "Allow"
        Principal = {
          Service = local.cloudwatch_logs_service_principal
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowCloudTrailUseOfTheKey"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowConfigUseOfTheKey"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-trail-kms"
    Domain = "sec"
  })
}

resource "aws_kms_alias" "trail" {
  name          = "alias/${var.name_prefix}-trail-kms"
  target_key_id = aws_kms_key.trail.key_id
}

resource "aws_s3_bucket" "trail_logs" {
  bucket = "${var.name_prefix}-trail-logs-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-trail-logs"
    Domain = "sec"
  })
}

resource "aws_s3_bucket_versioning" "trail_logs" {
  bucket = aws_s3_bucket.trail_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "trail_logs" {
  bucket = aws_s3_bucket.trail_logs.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.trail.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "trail_logs" {
  bucket = aws_s3_bucket.trail_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudwatch_log_group" "trail" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 30
  kms_key_id        = aws_kms_key.trail.arn

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-cloudtrail-lg"
    Domain = "sec"
  })
}

resource "aws_iam_role" "cloudtrail_to_cw" {
  name = "${var.name_prefix}-cloudtrail-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-cloudtrail-cw-role"
    Domain = "sec"
  })
}

resource "aws_iam_role_policy" "cloudtrail_to_cw" {
  name = "${var.name_prefix}-cloudtrail-cw-policy"
  role = aws_iam_role.cloudtrail_to_cw.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.trail.arn}:*"
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "trail_logs" {
  bucket = aws_s3_bucket.trail_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = aws_s3_bucket.trail_logs.arn
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = { Service = "cloudtrail.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.trail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.name_prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.trail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.trail.arn

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.trail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_to_cw.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.trail_logs,
    aws_iam_role_policy.cloudtrail_to_cw
  ]

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-trail"
    Domain = "sec"
  })
}

resource "aws_iam_role" "config" {
  count = var.manage_aws_config ? 1 : 0

  name = "${var.name_prefix}-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-config-role"
    Domain = "sec"
  })
}

resource "aws_s3_bucket" "config" {
  count = var.manage_aws_config ? 1 : 0

  bucket = "${var.name_prefix}-config-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-config"
    Domain = "sec"
  })
}

resource "aws_s3_bucket_public_access_block" "config" {
  count = var.manage_aws_config ? 1 : 0

  bucket = aws_s3_bucket.config[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  count = var.manage_aws_config ? 1 : 0

  bucket = aws_s3_bucket.config[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.trail.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_iam_role_policy" "config_inline" {
  count = var.manage_aws_config ? 1 : 0

  name = "${var.name_prefix}-config-inline"
  role = aws_iam_role.config[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ConfigBucketAccess"
        Effect = "Allow"
        Action = [
          "s3:GetBucketAcl",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.config[0].arn
        ]
      },
      {
        Sid    = "ConfigBucketWrite"
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.config[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "ConfigKmsUsage"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = [
          aws_kms_key.trail.arn
        ]
      },
      {
        Sid    = "ConfigDescribePermissions"
        Effect = "Allow"
        Action = [
          "config:Put*",
          "config:Get*",
          "config:Describe*",
          "config:StartConfigurationRecorder",
          "config:StopConfigurationRecorder"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_config_configuration_recorder" "main" {
  count = var.manage_aws_config ? 1 : 0

  name     = "${var.name_prefix}-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_s3_bucket_policy" "config" {
  count = var.manage_aws_config ? 1 : 0

  bucket = aws_s3_bucket.config[0].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSConfigBucketPermissionsCheck",
        Effect    = "Allow",
        Principal = { Service = "config.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = aws_s3_bucket.config[0].arn
      },
      {
        Sid       = "AWSConfigBucketDelivery",
        Effect    = "Allow",
        Principal = { Service = "config.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.config[0].arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/Config/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_config_delivery_channel" "main" {
  count = var.manage_aws_config ? 1 : 0

  name           = "${var.name_prefix}-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config[0].bucket

  depends_on = [
    aws_config_configuration_recorder.main,
    aws_s3_bucket_policy.config
  ]
}

resource "aws_config_configuration_recorder_status" "main" {
  count = var.manage_aws_config ? 1 : 0

  name       = aws_config_configuration_recorder.main[0].name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.main]
}

resource "aws_guardduty_detector" "main" {
  enable = true

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-guardduty"
    Domain = "sec"
  })
}

resource "aws_securityhub_account" "main" {
  count = var.manage_securityhub_account ? 1 : 0
}

resource "aws_securityhub_standards_subscription" "fsbp" {
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/aws-foundational-security-best-practices/v/1.0.0"
  
}
