# IAM role for EKS cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = var.EKS_CLUSTER_ROLE_NAME

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "eks.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# EKS ckuster

resource "aws_eks_cluster" "eks_cluster" {
  name     = var.EKS_CLUSTER_NAME
  version  = var.EKS_CLUSTER_VERSION
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.EKS_CLUSTER_SUBNET_IDS
  }
}

# IAM role for EKS cluster nodes

resource "aws_iam_role" "eks_nodes_role" {
  name = var.EKS_NODES_ROLE_NAME
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  inline_policy {
    name = "S3-permissions"
    policy = jsonencode(
      {
        Statement = [
          {
            Action = [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject",
            ]
            Effect   = "Allow"
            Resource = "arn:aws:s3:::*/*"
            Sid      = "VisualEditor0"
          },
          {
            Action   = "s3:ListBucket"
            Effect   = "Allow"
            Resource = "arn:aws:s3:::*"
            Sid      = "VisualEditor1"
          },
        ]
        Version = "2012-10-17"
      }
    )
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

# EKS infrastructure node group

resource "aws_eks_node_group" "infrastructure_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.EKS_INFRASTRUCTURE_NODES_GROUP_NAME
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.EKS_INFRASTRUCTURE_NODES_SUBNET_IDS
  instance_types  = var.EKS_INFRASTRUCTURE_NODES_INSTANCE_TYPE
  disk_size       = var.EKS_INFRASTRUCTURE_NODES_DISK_SIZE

  remote_access {
    source_security_group_ids = [var.EKS_JUMP_HOST_SG_ID]
    ec2_ssh_key               = var.EKS_EC2_SSH_KEY
  }

  scaling_config {
    desired_size = var.EKS_INFRASTRUCTURE_NODES_SCALING_DESIRED_SIZE
    max_size     = var.EKS_INFRASTRUCTURE_NODES_SCALING_MAX_SIZE
    min_size     = var.EKS_INFRASTRUCTURE_NODES_SCALING_MIN_SIZE
  }
  update_config {
    max_unavailable = var.EKS_INFRASTRUCTURE_NODES_SCALING_MAX_UNAVIALABLE
  }
  depends_on = [
    aws_iam_role.eks_nodes_role
  ]
}

# EKS build node group

resource "aws_eks_node_group" "build_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.EKS_BUILD_NODES_GROUP_NAME
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.EKS_BUILD_NODES_SUBNET_IDS
  instance_types  = var.EKS_BUILD_NODES_INSTANCE_TYPE
  disk_size       = var.EKS_BUILD_NODES_DISK_SIZE

  remote_access {
    source_security_group_ids = [var.EKS_JUMP_HOST_SG_ID]
    ec2_ssh_key               = var.EKS_EC2_SSH_KEY
  }

  scaling_config {
    desired_size = var.EKS_BUILD_NODES_SCALING_DESIRED_SIZE
    max_size     = var.EKS_BUILD_NODES_SCALING_MAX_SIZE
    min_size     = var.EKS_BUILD_NODES_SCALING_MIN_SIZE
  }
  update_config {
    max_unavailable = var.EKS_BUILD_NODES_SCALING_MAX_UNAVIALABLE
  }
  depends_on = [
    aws_iam_role.eks_nodes_role
  ]
}

# EKS envs node group

resource "aws_eks_node_group" "envs_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.EKS_ENVS_NODES_GROUP_NAME
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.EKS_ENVS_NODES_SUBNET_IDS
  instance_types  = var.EKS_ENVS_NODES_INSTANCE_TYPE
  disk_size       = var.EKS_ENVS_NODES_DISK_SIZE

  remote_access {
    source_security_group_ids = [var.EKS_JUMP_HOST_SG_ID]
    ec2_ssh_key               = var.EKS_EC2_SSH_KEY
  }

  scaling_config {
    desired_size = var.EKS_ENVS_NODES_SCALING_DESIRED_SIZE
    max_size     = var.EKS_ENVS_NODES_SCALING_MAX_SIZE
    min_size     = var.EKS_ENVS_NODES_SCALING_MIN_SIZE
  }
  update_config {
    max_unavailable = var.EKS_ENVS_NODES_SCALING_MAX_UNAVIALABLE
  }
  depends_on = [
    aws_iam_role.eks_nodes_role
  ]
}
