variable "resoure_group_name" {
  description = "Name of the resource group"
}

variable "location" {
  description = "Location of the resource"
}

variable "application_name" {
  description = "Name of the application"
}

variable "admin_username" {
  default = ""
}

variable "admin_password" {
  default = ""
}

variable "computer_name" {
  default = ""
}

variable "SUBSCRIPTION_ID" {
  description = "Environment Vars"
}

variable "TENANT_ID" {
  description = "Environment Vars"
}

variable "CLIENT_ID" {
  description = "Environment Vars"
}

variable "CLIENT_SECRET" {
  description = "Environment Vars"
}