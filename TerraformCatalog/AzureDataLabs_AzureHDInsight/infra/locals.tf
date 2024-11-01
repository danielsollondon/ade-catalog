locals {
  tags = {
    Owner       = "Azure Data Labs"
    Project     = "Azure Data Labs"
    Environment = "dev"
    Toolkit     = "Terraform"
    Template    = "data-analytics-hdi-spark"
    Name        = "${var.prefix}"
  }

  dns_zones = [
  ]

  safe_prefix  = replace(local.prefix, "-", "")
  safe_postfix = replace(local.postfix, "-", "")

  basename      = "${local.prefix}-${local.postfix}"
  safe_basename = "${local.safe_prefix}${local.safe_postfix}"

  # Configuration

  config = yamldecode(file("config-lab.yml"))

  resource_group_name = local.config.variables.enable_ade_deployment == "true" ? var.resource_group_name : length(module.resource_group) > 0 ? module.resource_group[0].name : ""
  location            = local.config.variables.location != null ? local.config.variables.location : var.location
  prefix              = local.config.variables.prefix != null ? local.config.variables.prefix : var.prefix
  postfix             = local.config.variables.postfix != null ? local.config.variables.postfix : var.postfix
  administrator_login = local.config.variables.administrator_login != null ? local.config.variables.administrator_login : var.administrator_login
  administrator_login_password = local.config.variables.administrator_login_password != null ? local.config.variables.administrator_login_password : var.administrator_login_password
  ambari_metastore_sku = local.config.variables.ambari_metastore_sku != null ? local.config.variables.ambari_metastore_sku : var.ambari_metastore_sku
  hive_metastore_sku = local.config.variables.hive_metastore_sku != null ? local.config.variables.hive_metastore_sku : var.hive_metastore_sku
  oozie_metastore_sku = local.config.variables.oozie_metastore_sku != null ? local.config.variables.oozie_metastore_sku : var.oozie_metastore_sku

  enable_private_endpoints = local.config.variables.enable_private_endpoints != null ? local.config.variables.enable_private_endpoints : var.enable_private_endpoints

  enable_ade_deployment = local.config.variables.enable_ade_deployment
}