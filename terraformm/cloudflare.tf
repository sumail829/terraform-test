resource "cloudflare_dns_record" "api_dns_record" {
  zone_id = "12bff830f7c794620444ce897cc736d1"
  name = "samir-api.deepak-shahi.com.np"
  ttl = 1
  type = "A"
  content = "${aws_instance.suman.public_ip}"
  proxied = true
}
resource "cloudflare_dns_record" "frontend_dns_record" {
  zone_id = "12bff830f7c794620444ce897cc736d1"
  name = "samir.deepak-shahi.com.np"
  ttl = 1
  type = "A"
  content = "${aws_instance.suman.public_ip}"
  proxied = true
}