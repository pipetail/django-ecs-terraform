data "aws_route53_zone" "primary" {
  name         = "django-ecs.pipetail.io."
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "prod.django-ecs.pipetail.io"
  type    = "A"

  alias {
    name                   = aws_lb.production.dns_name
    zone_id                = aws_lb.production.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "staging" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "staging.django-ecs.pipetail.io"
  type    = "A"

  alias {
    name                   = aws_lb.production.dns_name
    zone_id                = aws_lb.production.zone_id
    evaluate_target_health = false
  }
}
