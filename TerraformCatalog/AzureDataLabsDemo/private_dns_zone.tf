# Private DNS zones

module "private_dns_zones" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/private-dns-zone"

  rg_name = var.enable_private_endpoints ? local.shared_network_rg : null

  vnet_id   = var.enable_private_endpoints ? module.virtual_network[0].id : null
  dns_zones = local.dns_zones

  count = var.enable_private_endpoints ? 1 : 0

  tags = local.tags
}