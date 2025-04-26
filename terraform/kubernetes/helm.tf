

resource "helm_release" "backend" {
  name       = "backend"
  namespace  = var.environment

  chart      = "${path.module}/../../helm/backend"
  
  dependency_update = true

  values = [
    file("${path.module}/../../helm/backend/values.yaml")
  ]

  set {
    name  = "aws.accountId"
    value = data.aws_caller_identity.current.account_id
  }

  set {
    name  = "aws.irsa.roleName"
    value = data.aws_iam_role.backend_irsa_role.arn
  }

  set {
    name  = "environment"
    value = var.environment
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.acmCertificateArn"
    value = data.aws_acm_certificate.backend_cert.arn
  }

  set {
    name  = "ingress.host"
    value = var.acm_domain_name
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.1"

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.main.name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller-sa"
  }

  set {
    name  = "region"
    value = "eu-west-1"
  }

  set {
    name  = "vpcId"
    value = data.aws_eks_cluster.main.vpc_config[0].vpc_id
  }
}
