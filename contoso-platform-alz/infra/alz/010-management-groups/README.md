# 010 — Management Groups

Deploys the CAF-aligned Management Group hierarchy for Contoso Ltd via the
`Azure/avm-ptn-alz/azurerm` AVM pattern module (v0.11.1).

## Hierarchy

```
Tenant Root Group
└── contoso          (Contoso)
    ├── platform     (Platform)
    │   ├── connectivity
    │   ├── management
    │   └── identity
    ├── landingzones (Landing Zones)
    │   ├── corp
    │   └── online
    ├── sandboxes
    └── decommissioned
```

## Inputs

| Name | Description | Required |
|---|---|---|
| `subscription_id` | Any subscription in the tenant for provider auth | Yes |
| `root_management_group_id` | Tenant ID (= tenant root MG ID) | Yes |
| `tags` | Mandatory tag set (env, owner, cost_centre, created_by) | No (has defaults) |

## Outputs

| Name | Description | Consumed by |
|---|---|---|
| `management_group_resource_ids` | Map of MG key → resource ID | 020-policies, 030-rbac |

## Backend

State: `satfstatecontosoalz / tfstate / 010-management-groups.tfstate`

## Local validation

```bash
terraform init
terraform fmt -check -recursive
terraform validate
tflint --chdir=.
checkov -d . --framework terraform --compact
terraform plan -out=010.plan
```

## Deployment

All applies run from Azure DevOps via Workload Identity Federation. No local
`terraform apply` against production or staging. (Constitution NN-4)
