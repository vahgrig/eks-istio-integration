resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = "9.29.3"


  set {
    name  = "autoDiscovery.enabled"
    value = "true"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = "${var.project_name}-cluster"
  }

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "awsRegion"
    value = "us-west-1"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "sslCertPath"
    value = "/etc/ssl/certs/ca-bundle.crt"
  }
  set {
    name  = "extraArgs.scale-down-delay-after-add"
    value = "2m"
  }
  set {
    name  = "extraArgs.scale-down-unneeded-time"
    value = "2m"
  }
}
 