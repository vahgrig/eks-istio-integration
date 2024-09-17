

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_confs" {
  type = object({
    cidr               = string
    private_subnets    = list(string)
    public_subnets     = list(string)
    infra_subnets      = list(string)
    enable_nat_gateway = bool
    single_nat_gateway = bool
  })
  description = "VPC configuration"
}


variable "node_group_confs" {
  type = object({
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    capacity_type  = string
  })
  description = "EKS node group configuration"
}

variable "eks_cluster_confs" {
  type = object({
    version        = string
    private_access = bool
    public_access  = bool
  })
  description = "EKS cluster configuration"
}

variable "repositorys" {
  type        = list(string)
  description = "ECR repositorys"
  default = []
}

variable "namespaces" {
  type        = list(string)
  description = "EKS namespaces"
  default     = []
}


variable "tags" {
  type = map(any)
  default = {
    Terraform = "True"
  }
  description = "Tags for infrastructure resources."
}

variable "istio_mtls_enabled" {
  description = "Flag to enable or disable the PeerAuthentication resource"
  type        = bool
  default     = false
}