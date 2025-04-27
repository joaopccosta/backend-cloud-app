variable "environment" {
    type = string
    description = "Target environment"
}

variable "acm_domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route53 Hosted Zone ID for domain validation"
  type        = string
}

variable "backend_alb_dns_name" {
  description = "DNS name of the backend ALB"
  type        = string
  default = ""
}

variable "backend_alb_zone_id" {
  description = "Zone ID of the backend ALB"
  type        = string
  default = ""
}
