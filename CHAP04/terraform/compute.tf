resource "azurerm_network_interface" "nic" {
  name                = "orion-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "orionipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_public_ip" "pip" {
  name                = "orion-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "oriondevops"
}

resource "azurerm_storage_account" "stor" {
  name                     = "orionstor"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



## GET THE CUSTOM IMAGE CREATED BY PACKER
data "azurerm_image" "customngnix" {
  name                = "linuxWeb-0.0.1"
  resource_group_name = "rg_images"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "orionvm"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_DS2_v2"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  ## USE THE CUSTOM IMAGE
  storage_image_reference {
    id = data.azurerm_image.customngnix.id
  }


  storage_os_disk {
    name              = "orion-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.stor.primary_blob_endpoint
  }
}
