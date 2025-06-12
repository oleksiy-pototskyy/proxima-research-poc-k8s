output "security_group_eks_cluster" {
  value = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "eks_infrastructure_node_group" {
  value = aws_eks_node_group.infrastructure_node_group.resources[0].autoscaling_groups[0].name
}

output "eks_infrastructure_node_group_label" {
  value = aws_eks_node_group.infrastructure_node_group.node_group_name
}
