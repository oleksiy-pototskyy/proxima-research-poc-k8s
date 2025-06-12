variable "EKS_VPC_ID" {}

variable "EKS_CLUSTER_ROLE_NAME" {
  default = "eks-cluster-role"
}

variable "EKS_CLUSTER_NAME" {
  default = "rocket"
}

variable "EKS_CLUSTER_VERSION" {
  default = "1.21"
}

variable "EKS_CLUSTER_SUBNET_IDS" {
  type = list(string)
}

variable "EKS_NODES_ROLE_NAME" {
  default = "eks-node-group-role"
}

variable "EKS_INFRASTRUCTURE_NODES_GROUP_NAME" {
  default = "infrastructure-node-group"
}

variable "EKS_INFRASTRUCTURE_NODES_SUBNET_IDS" {}

variable "EKS_INFRASTRUCTURE_NODES_INSTANCE_TYPE" {
  type    = list(string)
  default = ["t3a.large"]
}

variable "EKS_INFRASTRUCTURE_NODES_DISK_SIZE" {
  default = 20
}

variable "EKS_INFRASTRUCTURE_NODES_SCALING_DESIRED_SIZE" {
  default = 1
}

variable "EKS_INFRASTRUCTURE_NODES_SCALING_MIN_SIZE" {
  default = 1
}

variable "EKS_INFRASTRUCTURE_NODES_SCALING_MAX_SIZE" {
  default = 5
}

variable "EKS_INFRASTRUCTURE_NODES_SCALING_MAX_UNAVIALABLE" {
  default = 1
}

variable "EKS_BUILD_NODES_GROUP_NAME" {
  default = "build-node-group"
}

variable "EKS_BUILD_NODES_SUBNET_IDS" {}

variable "EKS_BUILD_NODES_INSTANCE_TYPE" {
  type    = list(string)
  default = ["c5a.2xlarge"]
}

variable "EKS_BUILD_NODES_DISK_SIZE" {
  default = 40
}

variable "EKS_BUILD_NODES_SCALING_DESIRED_SIZE" {
  default = 1
}

variable "EKS_BUILD_NODES_SCALING_MIN_SIZE" {
  default = 1
}

variable "EKS_BUILD_NODES_SCALING_MAX_SIZE" {
  default = 8
}

variable "EKS_BUILD_NODES_SCALING_MAX_UNAVIALABLE" {
  default = 1
}


variable "EKS_ENVS_NODES_GROUP_NAME" {
  default = "deploy-node-group"
}

variable "EKS_ENVS_NODES_SUBNET_IDS" {}

variable "EKS_ENVS_NODES_INSTANCE_TYPE" {
  type    = list(string)
  default = ["t3a.micro"]
}

variable "EKS_ENVS_NODES_DISK_SIZE" {
  default = 80
}

variable "EKS_ENVS_NODES_SCALING_DESIRED_SIZE" {
  default = 1
}

variable "EKS_ENVS_NODES_SCALING_MIN_SIZE" {
  default = 1
}

variable "EKS_ENVS_NODES_SCALING_MAX_SIZE" {
  default = 5
}

variable "EKS_ENVS_NODES_SCALING_MAX_UNAVIALABLE" {
  default = 1
}

variable "EKS_JUMP_HOST_SG_ID" {}

variable "EKS_EC2_SSH_KEY" {
  default = "default-key"
}
