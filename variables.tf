variable "max_monthly_budget" {
  description = "Maximum monthly budget per service in USD"
  type        = number
  default     = 50
}

variable "require_free_tier" {
  description = "Only include providers with a free tier"
  type        = bool
  default     = false
}
