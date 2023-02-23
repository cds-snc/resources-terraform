terraform {
  source = "../../../aws//app"
}

#dependencies {
#  paths = ["../hosted-zone"]
#}

inputs = {
  domain_name      = "resources.cdssandbox.xyz"
  zone_name        = "resources.cdssandbox.xyz"
  fr_zone_name     = "ressources.cdssandbox.xyz"
  legacy_zone_name = "learning-resources.cdssandbox.xyz"
}

include {
  path = find_in_parent_folders()
}