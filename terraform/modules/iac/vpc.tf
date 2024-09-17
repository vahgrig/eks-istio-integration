data "aws_availability_zones" "available" {
  state = "available"
}



module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_confs.cidr

  azs = data.aws_availability_zones.available.names

  public_subnets     = var.vpc_confs.public_subnets
  private_subnets    = var.vpc_confs.private_subnets
  intra_subnets      = var.vpc_confs.infra_subnets
  enable_nat_gateway = var.vpc_confs.enable_nat_gateway
  single_nat_gateway = var.vpc_confs.single_nat_gateway

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                            = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                   = 1
  }
  tags = merge(
    { Environment = "${var.project_name}" },
    var.tags
  )
}