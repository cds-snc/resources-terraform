terraform {
  source = "../../../aws//app"
}

dependencies {
  paths = ["../hosted-zone"]
}

inputs = {
  domain_name    = "learning-resources.cdssandbox.xyz"
  #  app_hosted_zone_id = dependency.hosted_zone.outputs.app_zone_id
  #  app_domain_name    = "app.learning-resources.cdssandbox.xyz"
  zone_name    = "learning-resources.cdssandbox.xyz"
  fr_zone_name = ""
}

include {
  path = find_in_parent_folders()
}