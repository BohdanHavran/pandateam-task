resource "digitalocean_ssh_key" "ssh_key" {
  name       = "User ssh key"
  public_key = file("./id_rsa.pub")
}

module "droplet_master" {
  source             = "./modules/droplet"
  enabled            = true
  droplet_name       = "master"
  droplet_size       = "s-2vcpu-2gb-intel"
  region             = "fra1"
  custom_image       = false
  image_name         = "ubuntu-22-04-x64"
  vpc_uuid           = module.vpc.vpc_id
  ssh_keys           = [digitalocean_ssh_key.ssh_key.fingerprint]
  tags               = ["master"]

  inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["91.201.234.74"]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]

  outbound_rules = [
    {
      protocol              = "tcp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}

module "droplet_worker" {
  source             = "./modules/droplet"
  enabled            = true
  droplet_name       = "worker"
  droplet_size       = "s-2vcpu-2gb-intel"
  region             = "fra1"
  custom_image       = false
  image_name         = "ubuntu-22-04-x64"
  vpc_uuid           = module.vpc.vpc_id
  ssh_keys           = [digitalocean_ssh_key.ssh_key.fingerprint]
  tags               = ["worker"]

  inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = ["91.201.234.74", module.droplet_master.public_ip]
    },
    {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]

  outbound_rules = [
    {
      protocol              = "tcp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "udp"
      port_range            = "all"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    }
  ]
}