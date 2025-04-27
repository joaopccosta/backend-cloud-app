data "aws_eks_cluster" "main" {
  name = "${var.environment}-eks-cluster"
}

data "aws_eks_cluster_auth" "main" {
  name = "${var.environment}-eks-cluster"
}

data "aws_iam_role" "eks_node_role_arn" {
  name = "${var.environment}-eks-node-group-role"
}

data "aws_iam_role" "alb_controller_irsa" {
  name = "${var.environment}-aws-load-balancer-controller-role"
}

data "aws_acm_certificate" "backend_cert" {
  domain   = "${var.environment}-api.joaocosta.net"
  statuses = ["ISSUED"]
}

data "aws_iam_role" "backend_irsa_role" {
  name = "${var.environment}-backend-irsa-role"
}

data "aws_caller_identity" "current" {}
