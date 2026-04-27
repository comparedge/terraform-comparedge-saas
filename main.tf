terraform {
  required_version = ">= 1.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0"
    }
  }
}

data "http" "comparedge_hosting" {
  url = "https://comparedge-api.up.railway.app/api/v1/categories/cloud-hosting"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  hosting_data = jsondecode(data.http.comparedge_hosting.response_body)
  products     = try(local.hosting_data.products, [])

  # Providers that advertise a free tier
  free_tier_providers = [
    for p in local.products : p.name
    if try(p.pricing.free, false) == true
  ]

  # Providers that have at least one paid plan within var.max_monthly_budget
  budget_providers = [
    for p in local.products : {
      name = p.name
      slug = p.slug
      starting_price = try(
        min([
          for plan in try(p.pricing.plans, []) : plan.price
          if try(plan.price, 0) > 0
        ]...),
        null
      )
    }
    if try(
      length([
        for plan in try(p.pricing.plans, []) : plan.price
        if try(plan.price, 0) > 0 && try(plan.price, 999) <= var.max_monthly_budget
      ]),
      0
    ) > 0
  ]

  # Sorted by starting_price ascending (nulls last)
  budget_providers_sorted = sort([
    for p in local.budget_providers :
    format("%08.2f|%s|%s", coalesce(p.starting_price, 999), p.slug, p.name)
  ])
}
