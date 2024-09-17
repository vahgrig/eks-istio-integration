resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.value
    labels = {
      "istio-injection" = "enabled"
    }
  }
}