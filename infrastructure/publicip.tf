resource "azurerm_public_ip" "nexus_ingress" {
  name                = local.nexus_public_ip_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = local.nexus_public_ip_domain_name_label

  lifecycle {
    ignore_changes = [tags]
  }

}