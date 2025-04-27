resource "aws_route53_record" "backend" {
  zone_id = var.route53_zone_id
  name    = var.acm_domain_name
  type    = "A"

  alias {
    name                   = var.backend_alb_dns_name
    zone_id                = var.backend_alb_zone_id
    evaluate_target_health = true
  }
}
