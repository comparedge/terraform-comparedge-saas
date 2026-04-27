output "free_tier_providers" {
  description = "Cloud hosting providers with free tiers"
  value       = local.free_tier_providers
}

output "budget_providers" {
  description = "Providers within budget, sorted by starting price"
  value       = local.budget_providers
}

output "total_providers_tracked" {
  description = "Total cloud hosting providers in ComparEdge database"
  value       = length(local.products)
}

output "budget_providers_sorted" {
  description = "Provider slugs sorted by starting price ascending"
  value       = local.budget_providers_sorted
}
