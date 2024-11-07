resource "digitalocean_vpc" "default" {
  count       = var.enabled == true ? 1 : 0
  name        = var.name
  region      = var.region
  description = var.description
  ip_range    = var.ip_range
}