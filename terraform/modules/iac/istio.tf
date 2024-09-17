resource "helm_release" "istio_base" {
  name             = "istio-base"
  chart            = "./../istio-helm-charts/base" 
  namespace        = "istio-system"
  create_namespace = true
  depends_on = [
    module.eks
  ]

}

resource "helm_release" "istiod" {
  name      = "istiod"
  namespace = "istio-system"
  chart     = "./../istio-helm-charts/istio-discovery"

  set {
    name  = "global.hub"
    value = "docker.io/istio"
  }

  set {
    name  = "global.tag"
    value = "1.17.1"
  }
  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  name      = "istio-ingress"
  namespace = "istio-system"
  chart     = "./../istio-helm-charts/istio-ingress" 

  set {
    name  = "global.hub"
    value = "docker.io/istio"
  }

  set {
    name  = "global.tag"
    value = "1.17.1"
  }

  set {
    name  = "gateways.istio-ingressgateway.serviceAnnotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-proxy-protocol\""
    value = "*"
  }

  set {
    name  = "gateways.istio-ingressgateway.serviceAnnotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-connection-idle-timeout\""
    value = "60"
  }

  set {
    name  = "gateways.istio-ingressgateway.serviceAnnotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled\""
    value = "true"
  }

  set {
    name  = "gateways.istio-ingressgateway.serviceAnnotations.\"service\\.beta\\.kubernetes\\.io/aws-load-balancer-type\""
    value = "nlb"
  }

  depends_on = [
    helm_release.istiod
  ]
}

resource "helm_release" "gateway" {
  name      = "istiod"
  namespace = "istio-system"
  chart     = "./../istio-helm-charts/istio-discovery"
  depends_on = [
    helm_release.istio_ingress
  ]
}

resource "kubernetes_manifest" "peer_authentication" {
  count = var.istio_mtls_enabled ? 1 : 0
  manifest = {
    apiVersion = "security.istio.io/v1"
    kind       = "PeerAuthentication"
    metadata = {
      name      = "default"
      namespace = "istio-system"
    }
    spec = {
      mtls = {
        mode = "STRICT"
      }
    }
  }
}
