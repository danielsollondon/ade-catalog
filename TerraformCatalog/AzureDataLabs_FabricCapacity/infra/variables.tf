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

variable "sku" {
  type        = string
  description = "SKU for the fabric capacity"
  default     = "F2"
}

variable "admin_email" {
  type        = string
  description = "Admin email for the fabric capacity"
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