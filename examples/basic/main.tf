terraform {
  required_version = ">= 1.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}

# ---------------------------------------------------------------
# Example: find cloud hosting providers under $20/mo
# Run: terraform init && terraform apply
# ---------------------------------------------------------------

module "hosting" {
  source = "../.."

  max_monthly_budget = 20
  require_free_tier  = false
}

output "free_options" {
  description = "Providers with a free tier"
  value       = module.hosting.free_tier_providers
}

output "budget_options" {
  description = "Providers with plans under $20/mo"
  value       = module.hosting.budget_providers
}

output "total" {
  description = "Total providers tracked"
  value       = module.hosting.total_providers_tracked
}
