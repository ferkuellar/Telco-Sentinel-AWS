variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Telco-Sentinel-AWS"
}

variable "owner" {
  description = "Project owner"
  type        = string
  default     = "Fernando"
}

variable "cost_center" {
  description = "Cost center"
  type        = string
  default     = "ArchitectureLab"
}

variable "data_classification" {
  description = "Data classification"
  type        = string
  default     = "Internal"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}