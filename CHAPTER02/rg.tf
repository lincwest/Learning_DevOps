resource "azurerm_resource_group" "rg" {
  name     = "bookRg"
  location = var.location
  tags = {
    environment = "Terraform Azure"
  }
}

