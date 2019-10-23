variable "host" {
  default = "raspberrypi.local"
}

variable "user" {}
variable "pass" {}

variable "pub_key" {}
variable "hostname" {}

variable "static_ip_address" {}
variable "static_routers" {}
variable "static_domain_name_servers" {}

variable "timezone" {}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}
