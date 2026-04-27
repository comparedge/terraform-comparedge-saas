# terraform-comparedge

Queries ComparEdge API at plan time. Returns cloud hosting providers filtered by budget and free tier availability. Zero provider lock-in — it's just an HTTP data source.

## Requirements

| Tool | Version |
|---|---|
| Terraform | >= 1.0 |
| hashicorp/http | >= 3.0 |

## Usage

```hcl
module "hosting_picker" {
  source = "path/to/terraform-comparedge"

  max_monthly_budget = 20
  require_free_tier  = false
}

output "options" {
  value = module.hosting_picker.budget_providers
}
```

## Inputs

| Name | Type | Default | Description |
|---|---|---|---|
| `max_monthly_budget` | number | 50 | Max monthly spend per provider in USD |
| `require_free_tier` | bool | false | Filter to providers with a free tier |

## Outputs

| Name | Description |
|---|---|
| `free_tier_providers` | Provider names with free tiers |
| `budget_providers` | Providers within budget with starting prices |
| `budget_providers_sorted` | Same list, sorted by price ascending |
| `total_providers_tracked` | Total providers in the ComparEdge DB |

## How it works

At `terraform plan` / `terraform apply`, the module fires one HTTP GET to:

```
https://comparedge-api.up.railway.app/api/v1/categories/cloud-hosting
```

No authentication. No state. No provider credentials to manage. The response is decoded with `jsondecode` and filtered with `for` expressions. Nothing is created or destroyed — it's a pure data layer.

Add it to automation pipelines to make infrastructure decisions based on current pricing without hardcoding provider lists.

## Extending

Add more categories in `data.tf`. The API exposes multiple categories:

```
https://comparedge-api.up.railway.app/api/v1/categories
```

Each category slug works as a drop-in replacement for `cloud-hosting`.

## License

MIT
