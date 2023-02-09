variable "resource_prefix" {
  description = "A prefix that will be prepended to all resource names"
  type        = string
}

variable "resource_location" {
  description = "The location where resources will be deployed"
  type        = string
}

variable "init_container_tag" {
  description = "The tag that will be applied to the init_container in ACR"
  type        = string
}

variable "nexus_admin_password" {
    description = "The password to be used for the admin user on the nexus repository"
    type        = string
    sensitive = true
}
