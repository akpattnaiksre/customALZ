# Consumed by stacks 020-policies and 030-rbac to scope policy assignments
# and role assignments to the correct management group resource IDs.
# (spec-001 §3 — Stack Interfaces)
#
# VERIFY: Confirm the output key from the avm-ptn-alz module.
# Run: terraform init && terraform output
# Common names across module versions:
#   module.alz_management_groups.management_group_resource_ids
#   module.alz_management_groups.management_groups
# Adjust the value reference below after first `terraform init`.
output "management_group_resource_ids" {
  description = "Map of management group stable keys to their Azure resource IDs. Consumed by stacks 020-policies and 030-rbac."
  # sensitive = false intentional: MG resource IDs are not secrets.
  # They are path-like strings (/providers/Microsoft.Management/managementGroups/<name>)
  # and are required in plaintext by downstream stacks. (NN-3 does not apply here)
  value = module.alz_management_groups.management_group_resource_ids
}
