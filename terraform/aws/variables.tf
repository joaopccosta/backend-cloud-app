variable "environment" {
    type = string
    description = "Target environment"
}

variable "backend_port" {
    type = number
    default = 8080
    description = "The port on which the backend is listening to traffic"
}
variable "dynamodb_users_table_name" {
    type = string
    description = "Name of the dynamodb table for mapping usernames to birth dates"
    default = "users"
}

variable "acm_domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "route53_zone_id" {
  description = "The Route53 Hosted Zone ID for domain validation"
  type        = string
}
