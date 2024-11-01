# Databricks workspace

module "databricks_workspace" {
  source = "git::https://github.com/Azure/azure-data-labs-modules.git//terraform/databricks/databricks-workspace/?ref=main"
  # Base config
  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
  module_enabled      = true
  # Vnet config
  virtual_network_id                                   = azurerm_virtual_network.virtual_network.id
  public_subnet_name                                   = azurerm_virtual_network.virtual_network.subnet.*.name[2]
  public_subnet_network_security_group_association_id  = module.network_security_group.id
  private_subnet_name                                  = azurerm_virtual_network.virtual_network.subnet.*.name[3]
  private_subnet_network_security_group_association_id = module.network_security_group.id
  backend_subnet_id                                    = var.enable_private_endpoints ? azurerm_virtual_network.virtual_network.subnet.*.id[0] : null
  backend_private_dns_zone_ids                         = var.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.azuredatabricks.net"].id] : null
  backend_dbfs_private_dns_zone_ids                    = var.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.dfs.core.windows.net"].id] : null
  # Module config
  is_private_endpoint           = var.enable_private_endpoints
  private_link_deployment_type  = "simplified"
  is_web_auth_workspace         = true
  public_network_access_enabled = var.public_network_enabled
  enable_ip_access_list         = var.enable_ip_access_list
  allow_ip_list                 = ["${data.http.ip.body}/32"]
  storage_account_name          = "${local.safe_basename}adbdbfs"
  storage_account_sku_name      = "Standard_LRS"
  # Tags
  tags = local.tags
}
