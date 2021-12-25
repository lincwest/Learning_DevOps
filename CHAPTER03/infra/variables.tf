variable "admin_username" {
  description = "Admin username"
}

variable "admin_password" {
  description = "Admin password"
}

variable "node_location" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "node_address_space" {
  description = "Address range of the node"
}

variable "node_address_prefixes" {
  description = "Address prefixes of the node"
}
#variable for Environment
variable "Environment" {
  type = string
}
variable "node_count" {
  type = number
}
