output "droplet_master" {
  value = module.droplet_master.public_ip
}

output "droplet_worker" {
  value = module.droplet_worker.public_ip
}