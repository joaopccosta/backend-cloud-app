data "aws_eks_cluster" "main" {
  name = "${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "main" {
  name = "${var.environment}-eks-cluster"
}
