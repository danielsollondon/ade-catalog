# Fabric Capacity
data "azurerm_resource_group" "existing_rg" {
  name = local.resource_group_name
}

module "fabric_capacity" {
  source            = "github.com/Azure/azure-data-labs-modules/terraform/fabric/fabric-capacity"

  basename          = local.safe_basename
  resource_group_id = azurerm_resource_group.existing_rg.id
  location          = local.location

  sku               = var.sku
  admin_email       = var.admin_email

  tags = local.tags
}
