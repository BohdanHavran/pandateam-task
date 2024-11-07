// Lookup image to get id
data "digitalocean_image" "official" {
  count = var.custom_image == true ? 0 : 1
  slug  = var.image_name
}

data "digitalocean_image" "custom" {
  count = var.custom_image == true ? 1 : 0
  name  = var.image_name
}

// Create Droplets
resource "digitalocean_droplet" "droplet" {
  count = var.enabled == true ? 1 : 0

  image = coalesce(var.image_id, element(coalescelist(data.digitalocean_image.custom.*.image, data.digitalocean_image.official.*.image), 0))
  name  = var.droplet_name

  region = var.region
  # size   = coalesce(local.sizes[var.droplet_size], var.droplet_size)
  size   = var.droplet_size

  // Optional
  backups            = var.backups
  monitoring         = var.monitoring
  ipv6               = var.ipv6
  vpc_uuid           = var.vpc_uuid
  ssh_keys           = var.ssh_keys
  resize_disk        = var.resize_disk
  tags               = var.tags
  user_data          = var.user_data
}


resource "digitalocean_firewall" "droplet" {
  count = length(var.inbound_rules) > 0 || length(var.outbound_rules) > 0 ? 1 : 0

  name = var.droplet_name

  droplet_ids = [digitalocean_droplet.droplet.0.id]

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      protocol                  = inbound_rule.value["protocol"]
      port_range                = contains(keys(inbound_rule.value), "port_range") ? inbound_rule.value["port_range"] : null
      source_addresses          = contains(keys(inbound_rule.value), "source_addresses") && inbound_rule.value["source_addresses"] != null ? inbound_rule.value["source_addresses"] : []
      source_droplet_ids        = contains(keys(inbound_rule.value), "source_droplet_ids") && inbound_rule.value["source_droplet_ids"] != null ? inbound_rule.value["source_droplet_ids"] : []
      source_kubernetes_ids     = contains(keys(inbound_rule.value), "source_kubernetes_ids") && inbound_rule.value["source_kubernetes_ids"] != null ? inbound_rule.value["source_kubernetes_ids"] : []
      source_load_balancer_uids = contains(keys(inbound_rule.value), "source_load_balancer_uids") && inbound_rule.value["source_load_balancer_uids"] != null ? inbound_rule.value["source_load_balancer_uids"] : []
      source_tags               = contains(keys(inbound_rule.value), "source_tags") && inbound_rule.value["source_tags"] != null ? inbound_rule.value["source_tags"] : []
    }
  }

  dynamic "outbound_rule" {
    for_each = var.outbound_rules
    content {
      protocol                       = outbound_rule.value["protocol"]
      port_range                     = contains(keys(outbound_rule.value), "port_range") ? outbound_rule.value["port_range"] : null
      destination_addresses          = contains(keys(outbound_rule.value), "destination_addresses") && outbound_rule.value["destination_addresses"] != null ? outbound_rule.value["destination_addresses"] : []
      destination_droplet_ids        = contains(keys(outbound_rule.value), "destination_droplet_ids") && outbound_rule.value["destination_droplet_ids"] != null ? outbound_rule.value["destination_droplet_ids"] : []
      destination_kubernetes_ids     = contains(keys(outbound_rule.value), "destination_kubernetes_ids") && outbound_rule.value["destination_kubernetes_ids"] != null ? outbound_rule.value["destination_kubernetes_ids"] : []
      destination_load_balancer_uids = contains(keys(outbound_rule.value), "destination_load_balancer_uids") && outbound_rule.value["destination_load_balancer_uids"] != null ? outbound_rule.value["destination_load_balancer_uids"] : []
      destination_tags               = contains(keys(outbound_rule.value), "destination_tags") && outbound_rule.value["destination_tags"] != null ? outbound_rule.value["destination_tags"] : []
    }
  } 
}