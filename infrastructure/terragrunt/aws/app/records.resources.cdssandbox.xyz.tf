resource "aws_route53_record" "NS-resources-cdssandbox-xyz" {
  count = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.en_learning_resources.zone_id
  name    = "resources.cdssandbox.xyz."
  type    = "NS"
  ttl     = "172800"
  records = ["ns-1202.awsdns-22.org.", "ns-2023.awsdns-60.co.uk.", "ns-693.awsdns-22.net.", "ns-173.awsdns-21.com."]
}

resource "aws_route53_record" "SOA-resources-cdssandbox-xyz" {
  count = var.env == "staging" ? 1 : 0
  zone_id = aws_route53_zone.en_learning_resources.zone_id
  name    = "resources.cdssandbox.xyz."
  type    = "SOA"
  ttl     = "900"
  records = ["ns-1202.awsdns-22.org. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
}
