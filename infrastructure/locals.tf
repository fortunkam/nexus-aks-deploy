locals {
  resource_group_name               = "${var.resource_prefix}-rg"
  storage_account_name              = "${var.resource_prefix}store"
  storage_share_name                = "nexusdata"
  acr_name                          = "${var.resource_prefix}acr"
  aks_name                          = "${var.resource_prefix}-aks"
  aks_kubernetes_version            = "1.24.6"
  aks_default_nodepool_vm_sku       = "Standard_D8s_v5"
  aks_node_resource_group_name      = "${var.resource_prefix}-aks-resource"
  nexus_public_ip_name              = "${var.resource_prefix}-nexus-ip"
  nexus_public_ip_domain_name_label = "${var.resource_prefix}-nexus-ip-ingress"
  nexus_ingress_class_name          = "${var.resource_prefix}-nexus"

  nexus_uri               = "${azurerm_public_ip.nexus_ingress.domain_name_label}.${azurerm_resource_group.resource_group.location}.cloudapp.azure.com"
  nexus_readiness_timeout = 900
}   