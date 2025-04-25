variable "environment" {
    type = string
    description = "Target environment"
}

variable "aws_username" {
    type = string
    description = "AWS username managing EKS"
}

variable "eks_node_role_arn" {
  type = string
  description = "The IAM role ARN for the EKS worker nodes"
}

variable "backend_irsa_role_arn" {
  type        = string
  description = "Backend IRSA role ARN for Kubernetes ServiceAccount"
}
