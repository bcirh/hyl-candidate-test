terraform {
  backend "azurerm" {
    subscription_id      = "32a2a8a0-04fb-4892-8b1a-30ac436c03de"
    resource_group_name  = "hylastix-tf-remote-backend"
    storage_account_name = "hylastixftremotebackend"
    container_name       = "hylastixftremotebackend" #one container per subscription 
    key                  = "hylastix.tfstate"
  }
}