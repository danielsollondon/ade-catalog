# Bastion

module "bastion" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/bastion-host?ref=v1.5.0&depth=1"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = var.enable_jumphost ? azurerm_virtual_network.virtual_network.subnet.*.id[1] : null

  module_enabled = var.enable_jumphost

  tags = local.tags
}

# Virtual machine

module "virtual_machine_jumphost" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/virtual-machine?ref=v1.5.0&depth=1"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = var.enable_private_endpoints ? azurerm_virtual_network.virtual_network.subnet.*.id[0] : null
  jumphost_username   = var.jumphost_username
  jumphost_password   = var.jumphost_password

  module_enabled = var.enable_jumphost

  tags = local.tags
}
