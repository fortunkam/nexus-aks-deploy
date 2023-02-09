#Azure Storage Account

resource "azurerm_storage_account" "nexus_storage" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  min_tls_version          = "TLS1_2"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Allow"
  }
}

# Azure File Share

resource "azurerm_storage_share" "nexus_storage_share" {
  name                 = local.storage_share_name
  storage_account_name = azurerm_storage_account.nexus_storage.name
  quota                = 1000
}