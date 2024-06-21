
resource "aws_route53_record" "route53_record_blue" {
  count   = length(var.availability_zones)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"

  weighted_routing_policy {
    weight = var.weighted_routing_policy_blue
  }
  records = ["www.testing123.com"]

  alias {
    name                   = aws_alb.alb_blue[count.index].dns_name
    zone_id                = aws_alb.alb_blue[count.index].zone_id
    evaluate_target_health = true
  }
}


# Rout53 record for Green environment 
resource "aws_route53_record" "route53_record_green" {
  count   = length(var.availability_zones)
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"

  weighted_routing_policy {
    weight = var.weighted_routing_policy_green
  }

  records = ["www.testing123.com"]

  alias {
    name                   = aws_alb.alb_green[count.index].dns_name
    zone_id                = aws_alb.alb_green[count.index].zone_id
    evaluate_target_health = true
  }
}