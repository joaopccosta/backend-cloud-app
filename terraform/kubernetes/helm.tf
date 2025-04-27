

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

resource "helm_release" "kube_state_metrics" {
  name       = "kube-state-metrics"
  namespace  = "kube-system"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = "5.16.0"
  dependency_update = true

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }
}

resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  namespace  = "kube-system"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.69.1"
  dependency_update = true

  set {
    name  = "mode"
    value = "deployment"
  }
  set {
    name  = "config.receivers.prometheus.config.scrape_configs[0].job_name"
    value = "backend"
  }
  set {
    name  = "config.receivers.prometheus.config.scrape_configs[0].static_configs[0].targets[0]"
    value = "backend.${var.environment}.svc.cluster.local:80"
  }
  set {
    name  = "config.receivers.prometheus.config.scrape_configs[1].job_name"
    value = "kube-state-metrics"
  }
  set {
    name  = "config.receivers.prometheus.config.scrape_configs[1].static_configs[0].targets[0]"
    value = "kube-state-metrics.kube-system.svc.cluster.local:8080"
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.12.0"

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
