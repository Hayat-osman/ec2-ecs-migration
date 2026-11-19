# Route53 Record (optional - for easy cutover to ALB later)
resource "aws_route53_record" "app" {
  count   = var.domain_name != "" && var.route53_zone_id != "" ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  records = [aws_eip.app.public_ip]
  ttl     = 300 # 5 minutes TTL for easy cutover
}
