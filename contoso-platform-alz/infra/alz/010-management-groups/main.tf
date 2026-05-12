locals {
  # Stack tag merged into common_tags so every resource carries all five
  # mandatory keys: env, owner, cost_centre, stack, created_by. (EW-3)
  # MG-level tags are enforced via Azure Policy in stack 020-policies;
  # the module does not expose a top-level tags variable.
  common_tags = merge(var.tags, {
    stack = "010-management-groups"
  })
}

# Retrieves the tenant ID at runtime — used as parent_resource_id for the
# Contoso root MG. Avoids hardcoding the tenant GUID. (NN-3)
data "azapi_client_config" "current" {}

# AVM pattern module for the Contoso ALZ management group hierarchy.
# NN-1: AVM only — no direct azurerm_management_group or azapi_resource blocks
# in this root module.
# Version pinned exactly per EW-3; never use ~> on AVM modules.
#
# The MG hierarchy is declared in lib/contoso.alz_architecture_definition.json
# and loaded by the alz provider via library_references in providers.tf.
# Hierarchy (from Constitution AP-1 / spec-001 §2.2):
#   Tenant Root
#   └── contoso
#       ├── platform
#       │   ├── connectivity
#       │   ├── management
#       │   └── identity
#       ├── landingzones
#       │   ├── corp
#       │   └── online
#       ├── sandboxes
#       └── decommissioned
module "alz_management_groups" {
  source  = "Azure/avm-ptn-alz/azurerm"
  version = "0.11.1"

  # "contoso" matches the `name` field in lib/contoso.alz_architecture_definition.json.
  architecture_name = "contoso"

  # Tenant root group ID — just the GUID, no resource path prefix.
  # The module creates the `contoso` MG as a direct child of the tenant root.
  parent_resource_id = data.azapi_client_config.current.tenant_id

  # Primary region for policy managed identities (Constitution AP-1, AP-2).
  location = var.location
}

