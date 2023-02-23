resource "aws_route53_zone" "en_learning_resources" {
  name = var.zone_name
}

resource "aws_route53_zone" "fr_learning_resources" {
  name = var.fr_zone_name
}

resource "aws_route53_zone" "legacy_learning_resources" {
  # Only exists in staging account
  count = var.env == "staging" ? 1 : 0
  name  = var.legacy_zone_name
}