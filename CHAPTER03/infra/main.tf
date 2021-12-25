resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_prefix}-RG"
  location = var.node_location

  tags = {
    environment = "Test"
  }
}

resource "azurerm_virtual_network" "test_vnet" {
  name                = "${var.resource_prefix}-vnet"
  location            = var.node_location
  address_space       = var.node_address_space
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "test_subnet" {
  name                 = "${var.resource_prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.test_vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.node_address_prefixes
}

resource "azurerm_network_interface" "test_nic" {
  count               = var.node_count
  name                = "${var.resource_prefix}-${format("%02d", count.index + 1)}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.test_pip.*.id, count.index)
  }
}

resource "azurerm_public_ip" "test_pip" {
  count               = var.node_count
  name                = "${var.resource_prefix}-${format("%02d", count.index + 1)}-PublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = var.Environment == "Test" ? "Static" : "Dynamic"
}

resource "azurerm_storage_account" "test_stor" {
  name                     = "teststor"
  location                 = var.node_location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "vm" {
  count                         = var.node_count
  name                          = "${var.resource_prefix}-${format("%02d", count.index + 1)}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  vm_size                       = "Standard_DS1_v2"
  network_interface_ids         = [element(azurerm_network_interface.test_nic.*.id, count.index)]
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "my-osdisk-${count.index + 1}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "linuxhost"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Test"
  }
}

