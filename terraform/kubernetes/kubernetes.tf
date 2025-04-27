resource "kubernetes_namespace" "environment" {
  metadata {
    name = var.environment
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = data.aws_iam_role.eks_node_role_arn.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes"
        ]
      }
    ])

    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.aws_username}"
        username = "admin"
        groups   = [
          "system:masters"
        ]
      }
    ])
  }

  force = true
}
