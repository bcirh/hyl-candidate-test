terraform {
  backend "azurerm" {
    subscription_id      = var.subscription_id
    resource_group_name  = "hylastix-tf-remote-backend"
    storage_account_name = "hylastixftremotebackend"
    container_name       = "hylastixftremotebackend" #one container per subscription 
    key                  = "hylastix.tfstate"
  }
}