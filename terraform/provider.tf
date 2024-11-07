terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.28.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_project" "panda_team_task" {
  name        = "Panda-Team-Task"
  purpose     = "Operational / Developer tooling"
  resources = [
    module.droplet_master.droplet_urn,
    module.droplet_worker.droplet_urn
  ]
  is_default  = "true"
}