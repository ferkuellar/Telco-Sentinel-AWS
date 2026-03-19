variable "monthly_limit" {
  description = "Monthly budget limit"
  type        = string
  default     = "50"
}

variable "alert_email" {
  description = "Email for budget alerts"
  type        = string
}