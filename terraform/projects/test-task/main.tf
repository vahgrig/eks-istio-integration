module "lab" {
  source = "../../modules/iac/"


  project_name = "project" #replace 


  region = "us-west-1"

  eks_cluster_confs = {
    version        = "1.29"
    private_access = true
    public_access  = true

  }

  vpc_confs = {
    cidr               = "10.10.0.0/16"
    private_subnets    = ["10.10.1.0/24", "10.10.2.0/24"]
    public_subnets     = ["10.10.101.0/24", "10.10.102.0/24"]
    infra_subnets      = ["10.10.201.0/24", "10.10.202.0/24"]
    enable_nat_gateway = true
    single_nat_gateway = true

  }

  node_group_confs = {
    min_size       = 1
    max_size       = 10
    desired_size   = 1
    instance_types = ["t3.small"]
    capacity_type  = "SPOT"
  }

  repositorys = ["test-repo"]
  namespaces = ["test-ns"]
  istio_mtls_enabled = true
}

terraform {
  backend "s3" {
    bucket = "vahagn-task"
    key    = "task"
    region = "us-west-1"
  }

}