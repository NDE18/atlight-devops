output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

data "aws_instances" "nodes" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [aws_eks_node_group.main.node_group_name]
  }
}

output "node_ips" {
  value = data.aws_instances.eks_nodes.private_ips
}