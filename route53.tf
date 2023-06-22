resource "aws_route53_record" "main" {
  zone_id = "${local.hosted_zone_id}"
  name    = "${local.naked_domain}"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.main.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.main.hosted_zone_id}"
    evaluate_target_health = true
  }
}
