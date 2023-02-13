resource "helm_release" "nexus" {
  name              = "nexus"
  chart             = "../helm/nexus-repository"
  timeout           = local.nexus_readiness_timeout
  wait              = true
  wait_for_jobs     = true
  dependency_update = true

  set {
    name  = "initJob.repository"
    value = "${azurerm_container_registry.acr.login_server}/nexus-initializer"
  }
  set {
    name  = "initJob.tag"
    value = var.init_container_tag
  }
  set {
    name  = "storage.accountName"
    value = azurerm_storage_account.nexus_storage.name
  }
  set_sensitive {
    name  = "storage.primaryKey"
    value = azurerm_storage_account.nexus_storage.primary_access_key
  }
  set {
    name  = "storage.shareName"
    value = local.storage_share_name
  }
  set {
    name  = "storage.resourceGroupName"
    value = azurerm_resource_group.resource_group.name
  }
  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.nexus.hostName"
    value = local.nexus_uri
  }

  set {
    name  = "ingress.nexus.ingressClassName"
    value = local.nexus_ingress_class_name
  }

  set {
    name  = "ingress.nexus.certClusterIssuerSuffix"
    value = "-staging"
  }

  set_sensitive {
    name  = "nexus.admin.password"
    value = var.nexus_admin_password
  }

  set {
    name  = "nexus.serviceUri"
    value = "https://${local.nexus_uri}"
  }

  set {
    name  = "imageCredentials.registry"
    value = azurerm_container_registry.acr.login_server
  }

  set {
    name  = "imageCredentials.username"
    value = azurerm_container_registry.acr.admin_username
  }

  set_sensitive {
    name  = "imageCredentials.password"
    value = azurerm_container_registry.acr.admin_password
  }

  set {
    name  = "nexus-ingress.controller.ingressClassResource.name"
    value = local.nexus_ingress_class_name
  }
  set {
    name  = "nexus-ingress.controller.ingressClassResource.controllerValue"
    value = "k8s.io/${local.nexus_ingress_class_name}"
  }
  set {
    name  = "nexus-ingress.controller.service.loadBalancerIP"
    value = azurerm_public_ip.nexus_ingress.ip_address
  }
  set {
    name  = "nexus-ingress.controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-dns-label-name"
    value = azurerm_public_ip.nexus_ingress.domain_name_label
  }
  set {
    name  = "nexus-ingress.controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = azurerm_resource_group.resource_group.name
  }

  depends_on = [
    azurerm_role_assignment.aks_ip_contributor_role,
    null_resource.push_nexus_initializer
  ]
}