variable "environment" {
    type = string
    description = "Target environment"
}

variable "aws_username" {
    type = string
    description = "AWS username managing EKS"
}

variable "acm_domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

