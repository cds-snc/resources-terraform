resource "aws_route53_zone" "learning_resources" {
  name = var.zone_name
}

resource "aws_route53_zone" "fr_learning_resources" {
  name  = var.fr_zone_name
}
