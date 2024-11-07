output "public_ip" {
  value = digitalocean_droplet.droplet[0].ipv4_address
}

output "droplet_urn" {
  value = digitalocean_droplet.droplet[0].urn
}