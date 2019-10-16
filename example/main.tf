locals {
  user     = "pi"
  pass     = "raspberry"
  timezone = "Asia/Tokyo"
}

module "master" {
  source   = "../"
  user     = local.user
  pass     = local.pass
  host     = "192.168.1.16"
  timezone = local.timezone
  pub_key  = var.pub_key
}

module "node1" {
  source   = "../"
  user     = local.user
  pass     = local.pass
  host     = "192.168.1.15"
  timezone = local.timezone
  pub_key  = var.pub_key
}
