module "eks" {
  source                              = "./modules/eks"
  EKS_VPC_ID                          = var.PREPROD_VPC_ID
  EKS_INFRASTRUCTURE_NODES_SUBNET_IDS = var.PRIVATE_SUBNETS_IDS
  EKS_BUILD_NODES_SUBNET_IDS          = var.PRIVATE_SUBNETS_IDS
  EKS_ENVS_NODES_SUBNET_IDS           = var.PRIVATE_SUBNETS_IDS
  EKS_CLUSTER_SUBNET_IDS              = var.PRIVATE_SUBNETS_IDS
  EKS_JUMP_HOST_SG_ID                 = var.JUMP_HOST_SG_ID
}

module "route53" {
  source = "./modules/route53"
}

module "environments" {
  source                     = "./modules/environments"
  ENVS_DB_SUBNETS_IDS        = var.DB_SUBNETS_IDS
  ENVS_PRIVATE_SUBNETS_IDS   = var.PRIVATE_SUBNETS_IDS
  ENVS_JUMP_HOST_SG_ID       = var.JUMP_HOST_SG_ID
  ENVS_EKS_SG_ID             = module.eks.security_group_eks_cluster
  ENVS_VPC_ID                = var.PREPROD_VPC_ID
}

output "eks_module" {
  value = module.eks
}

output "route53_module" {
  value = module.route53
}

