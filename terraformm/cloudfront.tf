resource "aws_cloudfront_distribution" "ec2_cdn" {

  enabled = true

  origin {
    domain_name = aws_instance.suman.public_dns
    origin_id   = "ec2-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {

    target_origin_id = "ec2-origin"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]

    cached_methods = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}