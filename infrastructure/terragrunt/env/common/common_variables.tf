variable "account_id" {
  description = "(Required) The account ID to perform actions on."
  type        = string
}

variable "env" {
  description = "(Required) The current running environment"
  type        = string
}

variable "region" {
  description = "(Required) The region to build infra in"
  type        = string
}

variable "product_name" {
  description = "(Required) The name of the product you are deploying."
  type        = string
}