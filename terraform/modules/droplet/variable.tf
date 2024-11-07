variable "backups" {
  description = "(Optional) Boolean controlling if backups are made. Defaults to false."
  default     = false
}

variable "custom_image" {
  description = "Whether the image is custom or not (an official image)"
  default     = false
}

variable "droplet_count" {
  description = "The number of droplets / other resources to create"
  default     = 1
}

variable "enabled" {
  description = "The number of droplets / other resources to create"
  type        = bool
  default     = true
}

variable "droplet_name" {
  description = "The name of the droplet. If more than one droplet it is appended with the count, examples: stg-web, stg-web-01, stg-web-02"
}

variable "droplet_size" {
  description = "the size slug of a droplet size"
  default     = "s-1vcpu-1gb"
}

variable "image_id" {
  description = "The id of an image to use."
  default     = ""
}

variable "image_name" {
  description = "The image name or slug to lookup."
  default     = "ubuntu-22-04-x64"
}

variable "ipv6" {
  description = "(Optional) Boolean controlling if IPv6 is enabled. Defaults to false."
  default     = false
}

variable "monitoring" {
  description = "(Optional) Boolean controlling whether monitoring agent is installed. Defaults to false."
  default     = false
}

variable "number_format" {
  description = "The number format used to output."
  default     = "%02d"
}

variable "vpc_uuid" {
  description = "(Optional) Boolean controlling if private networks are enabled. Defaults to false."
  default     = null
}

variable "region" {
  description = "The Digitalocean datacenter to create resources in."
  default     = "ams3"
}

variable "resize_disk" {
  description = "(Optional) Boolean controlling whether to increase the disk size when resizing a Droplet. It defaults to true. When set to false, only the Droplet's RAM and CPU will be resized. Increasing a Droplet's disk size is a permanent change. Increasing only RAM and CPU is reversible."
  default     = true
}

variable "ssh_keys" {
  description = "(Optional) A list of SSH IDs or fingerprints to enable in the format [12345, 123456]. To retrieve this info, use a tool such as curl with the DigitalOcean API, to retrieve them."
  default     = []
}

variable "tags" {
  description = "(Optional) A list of the tags to label this Droplet. A tag resource must exist before it can be associated with a Droplet."
  default     = []
}

variable "user_data" {
  description = "(Optional) A string of the desired User Data for the Droplet."
  default     = "exit 0"
}

variable "inbound_rules" {
  description = "List of rules for inbound traffic"
  type = list(object({
    protocol                  = string
    port_range                = optional(string)
    source_addresses          = optional(list(string))
    source_droplet_ids        = optional(list(string))
    source_kubernetes_ids     = optional(list(string))
    source_load_balancer_uids = optional(list(string))
    source_tags               = optional(list(string))
  }))
}

variable "outbound_rules" {
  description = "List of rules for outbound traffic"
  type = list(object({
    protocol                       = string
    port_range                     = optional(string)
    destination_addresses          = optional(list(string))
    destination_droplet_ids        = optional(list(string))
    destination_kubernetes_ids     = optional(list(string))
    destination_load_balancer_uids = optional(list(string))
    destination_tags               = optional(list(string))
  }))
}