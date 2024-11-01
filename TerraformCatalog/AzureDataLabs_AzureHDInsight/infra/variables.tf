variable "location" {
  type        = string
  description = "Location of the resource group and modules"
  default     = "Central US"
}

variable "prefix" {
  type        = string
  description = "Prefix for module names"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
}

variable "gateway_username" {
  type        = string
  description = "The username used for the Ambari Portal"
  default     = "adminuser"
}

variable "gateway_password" {
  type        = string
  description = "The password used for the Ambari Portal"
  sensitive   = true
  default     = "This1sNotVerySecure!"
}

variable "ssh_username" {
  type        = string
  description = "The username used for the ssh"
  default     = locals.administrator_login
}

variable "ssh_password" {
  type        = string
  description = "The password used for the ssh"
  default     = locals.administrator_login_password
}

variable "roles_head_node_vm_size" {
  type        = string
  description = "The Size of the Virtual Machine which should be used as the Head Nodes"
  default     = "Standard_D3_V2"
}

variable "roles_worker_node_number_of_disks_per_node" {
  type        = number
  description = "The number of Data Disks which should be assigned to each Worker Node"
  default     = 1
}

variable "roles_worker_node_vm_size" {
  type        = string
  description = "The Size of the Virtual Machine which should be used as the Worker Nodes"
  default     = "Standard_DS13_V2"
}

variable "roles_worker_node_target_instance_count" {
  type        = number
  description = "The number of instances which should be run for the Worker Nodes"
  default     = 6
}

variable "roles_zookeeper_node_vm_size" {
  type        = string
  description = "The Size of the Virtual Machine which should be used as the Zookeeper Nodes"
  default     = "Standard_D3_V2"
}

variable "ambari_metastore_sku" {
  type        = string
  description = "SKU to be used for the Ambari metastore"
  default     = "S0"
}

variable "hive_metastore_sku" {
  type        = string
  description = "SKU to be used for the Hive metastore"
  default     = "S0"
}

variable "oozie_metastore_sku" {
  type        = string
  description = "SKU to be used for the Oozie metastore"
  default     = "S0"
}

variable "metastore_sku" {
  type        = map(any)
  description = "SKUs to be used for each metastore"
  default = {
    ambari = locals.ambari_metastore_sku
    hive   = locals.hive_metastore_sku
    oozie  = locals.oozie_metastore_sku
  }
}

variable "administrator_login" {
  type    = string
  default = "sqladminuser"
}

variable "administrator_login_password" {
  type    = string
  default = "ThisIsNotVerySecure!"
}

# Feature flags

variable "enable_private_endpoints" {
  type        = bool
  description = "Is secure enabled?"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "Variable for ADE based deployment"
}