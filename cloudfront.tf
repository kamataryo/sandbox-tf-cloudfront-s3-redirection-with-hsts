resource "aws_cloudfront_response_headers_policy" "policy" {
  name = "hsts-preload"

  security_headers_config {
      strict_transport_security {
        access_control_max_age_sec = 63072000
        include_subdomains         = true
        override                   = true
        preload                    = true
      }
  }
}

resource "aws_cloudfront_distribution" "main" {

  http_version    = "http2"
  is_ipv6_enabled = true
  enabled         = true
  comment         = "[SANDBOX] CDN for Redirection with HSTS"
  aliases         = ["${local.naked_domain}"]

  origin {
    origin_id           = aws_s3_bucket.main.id
    domain_name         = "${aws_s3_bucket.main.id}.${aws_s3_bucket_website_configuration.main.website_domain}"
    connection_attempts = 3
    connection_timeout  = 10

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = [ "GET", "HEAD", "OPTIONS" ]
    cached_methods   = [ "GET", "HEAD" ]
    target_origin_id = aws_s3_bucket.main.id

    forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }
    }

    response_headers_policy_id = aws_cloudfront_response_headers_policy.policy.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl     = 0
    default_ttl = 300
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.main.arn
    ssl_support_method  = "sni-only"
  }
}

output "redirection" {
  value = "https://${local.naked_domain} will redirect to https://www.${local.naked_domain}"
}
