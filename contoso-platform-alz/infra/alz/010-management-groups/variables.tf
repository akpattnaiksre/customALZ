variable "subscription_id" {
  description = "Subscription ID used to authenticate the azurerm and azapi providers. Management groups are tenant-scoped; any subscription in the tenant is valid. Injected by the ADO pipeline via WIF. (NN-4)"
  type        = string

  validation {
    condition     = length(var.subscription_id) > 0
    error_message = "subscription_id must be a non-empty string (GUID)."
  }
}

variable "tenant_id" {
  description = "Entra ID tenant ID. Explicit provider config prevents ARM_TENANT_ID env var from targeting the wrong tenant. Injected by the ADO pipeline alongside subscription_id."
  type        = string

  validation {
    condition     = length(var.tenant_id) > 0
    error_message = "tenant_id must be a non-empty GUID."
  }
}

variable "location" {
  description = "Primary Azure region for policy managed identities created by this stack. Constitution AP-1/AP-2 mandates UK South as the primary region."
  type        = string
  default     = "uksouth"

  validation {
    condition     = contains(["uksouth", "ukwest"], var.location)
    error_message = "location must be uksouth (primary) or ukwest (DR). Constitution AP-2."
  }
}

variable "tags" {
  description = "Mandatory tag set applied to all resources. All five keys are required by the Constitution (EW-3). MG-level tags are enforced via Azure Policy in stack 020-policies."
  type = object({
    env         = string
    owner       = string
    cost_centre = string
    created_by  = string
  })
  default = {
    env         = "mgmt"
    owner       = "platform-team"
    cost_centre = "CC-1234"
    created_by  = "terraform"
  }
}
