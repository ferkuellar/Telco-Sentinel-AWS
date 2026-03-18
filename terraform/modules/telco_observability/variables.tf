variable "name_prefix" {
  description = "Prefix for naming"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "metric_namespace" {
  description = "CloudWatch custom metric namespace"
  type        = string
  default     = "Telco/Observability"
}