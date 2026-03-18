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

  name_prefix = "novatel-net-${var.environment}"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.mandatory_tags
  }
}

module "network" {
  source = "../../modules/network"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  aws_region           = var.aws_region
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.mandatory_tags
}

module "security_baseline" {
  source = "../../modules/security_baseline"

  name_prefix = "novatel-sec-${var.environment}"
  aws_region  = var.aws_region
  tags        = local.mandatory_tags
}

module "telco_observability" {
  source = "../../modules/telco_observability"

  name_prefix      = "novatel-obsv-${var.environment}"
  aws_region       = var.aws_region
  tags             = local.mandatory_tags
  metric_namespace = var.metric_namespace
}