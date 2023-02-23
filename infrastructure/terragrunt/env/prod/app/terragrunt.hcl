terraform {
  source = "git::https://github.com/cds-snc/resources-terraform//infrastructure/terragrunt/aws/app?ref=v${get_env("INFRASTRUCTURE_VERSION")}"
}

#dependencies {
#  paths = ["../hosted-zone"]
#}

inputs = {
  domain_name      = "resources.alpha.canada.ca"
  fr_domain_name   = "ressources.alpha.canada.ca"
  zone_name        = "resources.alpha.canada.ca"
  fr_zone_name     = "ressources.alpha.canada.ca"
  legacy_zone_name = ""
}

include {
  path = find_in_parent_folders()
}