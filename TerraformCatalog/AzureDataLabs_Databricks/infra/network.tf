# Virtual network
# Use if NSGs are required for subnets
# cannot setup subnet delegations and connections to other services due to Terraform Limitations
module "network_security_group" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-group?ref=v1.5.0&depth=1"

  basename            = "nsg-${var.prefix}-${var.postfix}"
  location            = local.location
  resource_group_name = local.resource_group_name
}

module "network_security_rule_1" {
  source="git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-rule?ref=main&depth=1"
  name                       = "AllowHttpsInbound"
  priority                   = 120
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "Internet"
  destination_port_range     = 443
  destination_address_prefix = "*"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

module "network_security_rule_2" {
  source="git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-rule?ref=main&depth=1"
  name                       = "AllowGatewayManagerInbound"
  priority                   = 130
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "GatewayManager"
  destination_port_range     = 443
  destination_address_prefix = "*"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

module "network_security_rule_3" {
  source="git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-rule?ref=main&depth=1"
  name                       = "AllowAzureLoadBalancerInbound"
  priority                   = 140
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "AzureLoadBalancer"
  destination_port_range     = 443
  destination_address_prefix = "*"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_4" {
  name                       = "AllowBastionHostCommunication"
  priority                   = 150
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_port_ranges   = [8080, 5701]
  destination_address_prefix = "VirtualNetwork"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_5" {
  name                       = "AllowSshRdpOutbound"
  priority                   = 100
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  source_address_prefix      = "*"
  destination_port_ranges    = [22, 3389] # rdp [3389] must be open for the bastion to accept the nsg
  destination_address_prefix = "VirtualNetwork"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

module "network_security_rule_6" {
  source="git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-rule?ref=main&depth=1"
  name                       = "AllowAzureCloudOutbound"
  priority                   = 110
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  source_address_prefix      = "*"
  destination_port_range     = 443
  destination_address_prefix = "AzureCloud"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

resource "azurerm_network_security_rule" "network_security_rule_7" {
  name                       = "AllowBastionCommunication"
  priority                   = 120
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  source_address_prefix      = "VirtualNetwork"
  destination_port_ranges   = [8080, 5701]
  destination_address_prefix = "VirtualNetwork"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

module "network_security_rule_8" {
  source="git::https://github.com/Azure/azure-data-labs-modules.git//terraform/network-security-rule?ref=main&depth=1"
  name                       = "AllowHttpOutbound"
  priority                   = 130
  direction                  = "Outbound"
  access                     = "Allow"
  protocol                   = "*"
  source_port_range          = "*"
  source_address_prefix      = "*"
  destination_port_range     = 80
  destination_address_prefix = "Internet"
  resource_group_name        = local.resource_group_name
  network_security_group_name= module.network_security_group.name
}

resource "azurerm_virtual_network" "virtual_network"{
  name                = local.basename
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