data "aws_availability_zones" "available" {
  state = "available"
  exclude_names = [ "eu-central-1c" ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.4"

  name = "${local.name}-${var.vpc_name}"
  cidr =  var.vpc_cidr_block
  azs                 = data.aws_availability_zones.available.names
  private_subnets     = var.vpc_private_subnets
  public_subnets      = var.vpc_public_subnets


  create_database_subnet_group = true
  create_database_subnet_route_table = true
  database_subnets    = var.vpc_database_subnets
  
  #create_database_nat_gateway_route  = true
  #create_database_internet_gateway_route =  true

  # NAT Gateways for outbound Comminication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  #VPC DNS parameters
  enable_dns_hostnames =true
  enable_dns_support = true

  public_subnet_tags ={
   Type = "public-subnets"
   "kubernetes.io/role/elb" = 1
   "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  private_subnet_tags = {
    Type = "private-subnets"
   "kubernetes.io/role/internal-elb" = 1
   "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

  tags = local.common_tags
  vpc_tags = local.common_tags


  
}