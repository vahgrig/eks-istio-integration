
# Introduction
This project is designed to deploy infrastructure in AWS from scratch. It sets up an EKS cluster integrated with Istio for service mesh functionality. The infrastructure includes essential resources such as VPC, EKS Node Groups, and Helm releases for Istio and supporting components like cluster autoscaler and metrics server. This setup provides a scalable, secure, and production-ready environment on AWS.

In addition to the infrastructure setup, this repository also includes a Helm chart example for deploying an application. This can be used as a template or reference for deploying your own applications into the EKS cluster.

# Terraform infra
To use the terraform-module infra please see this example.

```hcl
module "infra" {
  source            = source = "../../modules/iac"
  project_name      = var.project_name
  vpc_cidr          = var.vpc_cidr
  node_group_confs  = var.node_group_confs

  ...
}
```

### Input Variables
The infra module requires the following input variables to customize the deployment according to your project requirements.

`project_name` (Required): The name of the project or application.<br/>
`eks_cluster_confs` (Required): The EKS cluster configuration.<br/>
`vpc_confs` (Required): The VPC configuration.<br/>
`node_group_confs` (Required): The EKS Node group configuration.<br/>


### Resources
The infra module deployes following resources.

###  Resources

| Name                                  | Type                              |
| ------------------------------------- | --------------------------------- |
| `module.eks` | [Module `eks/aws`](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)    |
| `module.vpc` | [Module `vpc/aws`](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)    |
| `resource.aws_ecr_repository` | recource    |
| `resource.kubernetes_manifest` | recource   |
| `helm_release.cluster_autoscaler`| `HELM`  |
| `helm_release.metric_server`| `HELM`  |
| `helm_release.istio_base`| `HELM`  |
| `helm_release.istiod`| `HELM`  |
| `helm_release.istio_ingress`| `HELM`  |
| `helm_release.gateway`| `HELM`  |

###  outputs

| Name                                  |
| ------------------------------------- |
| `cluster_name`                        |

