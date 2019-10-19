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
  hostname = "raspi01"
}

module "worker1" {
  source   = "../"
  user     = local.user
  pass     = local.pass
  host     = "192.168.1.15"
  timezone = local.timezone
  pub_key  = var.pub_key
  hostname = "raspi02"
}

module "worker2" {
  source   = "../"
  user     = local.user
  pass     = local.pass
  host     = "192.168.1.17"
  timezone = local.timezone
  pub_key  = var.pub_key
  hostname = "raspi03"
}
