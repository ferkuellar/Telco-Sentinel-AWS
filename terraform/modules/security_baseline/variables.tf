variable "name_prefix" {
  description = "Prefix for resource names"
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

variable "manage_aws_config" {
  description = "Create and manage AWS Config resources. Set to false if a recorder already exists in the account/region."
  type        = bool
  default     = false
}

variable "manage_securityhub_account" {
  description = "Create the Security Hub account resource. Set to false if Security Hub is already enabled and import is not planned."
  type        = bool
  default     = false
}
