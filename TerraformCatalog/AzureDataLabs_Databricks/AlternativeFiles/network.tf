# Virtual network
# Use if NSGs are required for subnets
# cannot setup subnet delegations and connections to other services due to Terraform Limitations
module "network_security_group" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-group?ref=v1.5.0&depth=1"

  basename            = "nsg-${var.prefix}-${var.postfix}"
  location            = local.location
  resource_group_name = local.resource_group_name
}

module "virtual_network" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/virtual-network?ref=v1.5.0&depth=1"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "snet-${var.prefix}-${var.postfix}-default"
    address_prefix = "10.0.1.0/24"
    security_group = module.network_security_group.id
  }

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.0.10.0/27"
    security_group = module.network_security_group.id
  }

  subnet {
    name           = "snet-${var.prefix}-${var.postfix}-adb-public"
    address_prefix = "10.0.2.0/24"
    security_group = module.network_security_group.id
  }

  subnet {
    name           = "snet-${var.prefix}-${var.postfix}-adb-private"
    address_prefix = "10.0.3.0/24"
    security_group = module.network_security_group.id
  }

  tags = local.tags
}

