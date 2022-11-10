variable "contentful_cda_access_token" {
  type      = string
  sensitive = true
}

variable "gh_access_token" {
  type      = string
  sensitive = true
}

variable "domain_name" {
  type = string
}

variable "fr_domain_name" {
  type = string
}

variable "google_analytics_id" {
  type      = string
  sensitive = true
}

variable "google_tag_manager_id" {
  type      = string
  sensitive = true
}

variable "sentry_dsn" {
  type      = string
  sensitive = true
}

#variable "env" {
#  type      = string
#  sensitive = true
#}