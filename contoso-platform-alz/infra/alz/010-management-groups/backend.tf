terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-prod-uks-001"
    storage_account_name = "satfstatecontalz001"
    container_name       = "tfstate"
    # Isolated key per stack — changing this key severs state continuity.
    # Never share this key with another stack. (TerraShark: blast-radius)
    key = "010-management-groups.tfstate"
  }
}
