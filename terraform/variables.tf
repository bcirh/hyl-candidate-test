##AUTH###
variable "client_id" {
  description = "Azure Client ID (will be overriden in runtime)"
  default     = "##{appId}##"
}

variable "client_secret" {
  description = "Azure Client Secret (will be overriden in runtime)"
  default     = "##{secret}##"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  default     = "32a2a8a0-04fb-4892-8b1a-30ac436c03de"
}

variable "tenant_id" {
  description = "Azure Tenant ID (will be overriden in runtime)"
  default     = "##{tenantID}##"
}
##/AUTH###

variable "location" {
  description = "Azure Location"
  default     = "West Europe"
}

variable "project_name" {
  description = "Name of the Project"
  default     = "Hylastix Test"
}

variable "environment" {
  description = "Environment"
  default     = "dev"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Size of the VM."
}

variable "ip_restrictions" {
  type = list(any)
  default = [
    {
      name                       = "allowSshHttpHttps"
      priority                   = "200"
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_ranges         = [22,80,443]
      destination_port_range    = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

variable "ssh_public_key" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "tags" {
  type    = map(string)
  default = {}
}

locals {
  tags = merge(
    var.tags,
    {
      project : var.project_name
      environment : var.environment
      provisioner : "terraform"
    },
  )
}
