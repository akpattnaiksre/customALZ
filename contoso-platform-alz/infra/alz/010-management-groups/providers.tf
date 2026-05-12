terraform {
  required_version = ">= 1.9.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.14"
    }
    # azapi is used by avm-ptn-alz to create MGs and policy resources via REST.
    # Declared here so the root module controls the version floor.
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.2"
    }
    # alz provider drives the architecture definition (MG hierarchy + archetypes).
    alz = {
      source  = "azure/alz"
      version = "~> 0.17"
    }
  }
}

provider "azurerm" {
  features {}
  # Explicit tenant_id prevents ARM_TENANT_ID env var from targeting the wrong tenant.
  # Management groups are tenant-scoped. Injected by ADO pipeline via WIF. (NN-4)
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "azapi" {
  # Explicit tenant_id mirrors azurerm to ensure both providers target the same tenant.
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "alz" {
  # Load ALZ built-in archetypes (root, platform, connectivity, management,
  # identity, landing_zones, corp, online, sandboxes, decommissioned) from the
  # official ALZ library, then overlay the Contoso architecture definition from
  # the local lib/ directory.
  library_references = [
    {
      path = "platform/alz"
      ref  = "2026.04.2"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
