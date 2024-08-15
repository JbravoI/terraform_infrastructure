output "kubernetes_name" {
  value = azurerm_kubernetes_cluster.kube.name
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.kube.id
}

# output "service_principal_id" {
#   value = azurerm_kubernetes_cluster.kube.service_principal.id
# }
