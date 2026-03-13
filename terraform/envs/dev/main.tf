terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  mandatory_tags = {
    Project            = var.project_name
    Environment        = var.environment
    Owner              = var.owner
    Domain             = "shared"
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
    ManagedBy          = "Terraform"
  }

  account_model = {
    management     = "Management Account"
    log_archive    = "Log Archive Account"
    audit          = "Audit Account"
    shared         = "Shared Services Account"
    observability  = "Observability Account"
    telco_dev      = "Telco Platform Dev"
    telco_prod     = "Telco Platform Prod"
    sandbox        = "Experimentation Account"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.mandatory_tags
  }
}