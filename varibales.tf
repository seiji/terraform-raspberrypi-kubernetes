variable "host" {
  default = "raspberrypi.local"
}

variable "user" {}
variable "pass" {}
variable "timezone" {}

variable "pub_key" {}

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
}
