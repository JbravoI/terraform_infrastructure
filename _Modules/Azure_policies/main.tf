

resource "azurerm_subscription_policy_assignment" "azurepolicy" {
  for_each = { for policy in var.policies : policy.name => policy }

  name                 = each.value.name
  subscription_id      = "/subscriptions/${var.subscription_id}"
  policy_definition_id = each.value.policy_definition_id
  description          = each.value.description
  display_name         = each.value.display_name
#   parameters           = each.value.parameters
}


# resource "azurerm_subscription_policy_assignment" "auditvms" {
#   name = "audit-vm-manageddisks"
#   subscription_id = var.subscription_id
#   policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
#   description = "Shows all virtual machines not using managed disks"
#   display_name = "Audit VMs without managed disks assignment"
#   }