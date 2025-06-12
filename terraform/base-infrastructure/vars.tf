variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PREPROD_VPC_ID" {}

variable "PRIVATE_SUBNETS_IDS" {
  type = list(string)
}

variable "PUBLIC_SUBNETS_IDS" {
  type = list(string)
}

variable "DB_SUBNETS_IDS" {
  type = list(string)
}

variable "JUMP_HOST_SG_ID" {}
