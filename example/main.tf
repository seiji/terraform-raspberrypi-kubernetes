locals {
  user                       = "pi"
  pass                       = "raspberry"
  timezone                   = "Asia/Tokyo"
  static_routers             = "192.168.1.1"
  static_domain_name_servers = "192.168.1.1"
}

module "master" {
  source                     = "../"
  user                       = local.user
  pass                       = local.pass
  host                       = "192.168.1.16"
  timezone                   = local.timezone
  pub_key                    = var.pub_key
  hostname                   = "raspi01"
  static_ip_address          = "192.168.1.16/24"
  static_routers             = local.static_routers
  static_domain_name_servers = local.static_domain_name_servers
}

module "worker1" {
  source                     = "../"
  user                       = local.user
  pass                       = local.pass
  host                       = "192.168.1.15"
  timezone                   = local.timezone
  pub_key                    = var.pub_key
  hostname                   = "raspi02"
  static_ip_address          = "192.168.1.15/24"
  static_routers             = local.static_routers
  static_domain_name_servers = local.static_domain_name_servers
}

module "worker2" {
  source                     = "../"
  user                       = local.user
  pass                       = local.pass
  host                       = "192.168.1.17"
  timezone                   = local.timezone
  pub_key                    = var.pub_key
  hostname                   = "raspi03"
  static_ip_address          = "192.168.1.17/24"
  static_routers             = local.static_routers
  static_domain_name_servers = local.static_domain_name_servers
}
