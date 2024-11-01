# Resource group

module "resource_group" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/resource-group"

  basename = local.resource_group_name
  location = local.location

  count = local.enable_ade_deployment ? 0 : 1

  tags = local.tags
}