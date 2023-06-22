resource "aws_acm_certificate" "main" {
  provider          = aws.us-east-1
  domain_name       = "${local.naked_domain}"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_validation" {
  zone_id = "${local.hosted_zone_id}"
  name    = "${tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name}"
  type    = "${tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type}"
  records = ["${tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value}"]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "main" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [aws_route53_record.acm_validation.fqdn]
}
