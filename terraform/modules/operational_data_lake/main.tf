data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "raw" {
  bucket = "${var.name_prefix}-raw-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-raw"
    Domain = "data"
    Zone   = "raw"
  })
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.name_prefix}-curated-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-curated"
    Domain = "data"
    Zone   = "curated"
  })
}

resource "aws_s3_bucket" "athena_results" {
  bucket = "${var.name_prefix}-athena-results-${data.aws_caller_identity.current.account_id}"

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-athena-results"
    Domain = "data"
    Zone   = "results"
  })
}

resource "aws_s3_bucket_public_access_block" "raw" {
  bucket = aws_s3_bucket.raw.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "curated" {
  bucket = aws_s3_bucket.curated.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "athena_results" {
  bucket = aws_s3_bucket.athena_results.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_versioning" "curated" {
  bucket = aws_s3_bucket.curated.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw" {
  bucket = aws_s3_bucket.raw.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "curated" {
  bucket = aws_s3_bucket.curated.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results" {
  bucket = aws_s3_bucket.athena_results.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "raw" {
  bucket = aws_s3_bucket.raw.id

  rule {
    id     = "raw-transition-and-expire"
    status = "Enabled"

    filter {
      prefix = "telemetry/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "curated" {
  bucket = aws_s3_bucket.curated.id

  rule {
    id     = "curated-transition"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_glue_catalog_database" "telco" {
  name = replace("${var.name_prefix}_db", "-", "_")
}

resource "aws_athena_workgroup" "telco" {
  name = "${var.name_prefix}-wg"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results.bucket}/query-results/"
    }
  }

  tags = merge(var.tags, {
    Name   = "${var.name_prefix}-wg"
    Domain = "data"
  })
}