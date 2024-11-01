# Virtual network

module "virtual_network" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/virtual-network"

  basename      = local.basename
  rg_name       = var.resource_group_name
  location      = var.location
  address_space = ["10.0.0.0/16"]

  count = var.enable_private_endpoints ? 1 : 0

  tags = local.tags
}

# Subnets

module "subnet_default" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/subnet"

  name                                      = "snet-${var.prefix}-${var.postfix}-default"
  rg_name                                   = var.resource_group_name
  vnet_name                                 = var.enable_private_endpoints ? module.virtual_network[0].name : null
  address_prefixes                          = ["10.0.1.0/24"]
  private_endpoint_network_policies_enabled = true

  count = var.enable_private_endpoints ? 1 : 0
}