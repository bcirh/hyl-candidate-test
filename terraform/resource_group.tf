resource "azurerm_resource_group" "hylastix_min_rg" {
  name     = "hylastix-minimal-${var.environment}"
  location = var.location

  tags = local.tags
}