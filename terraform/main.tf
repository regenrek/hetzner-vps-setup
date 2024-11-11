terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_api_token
}

data "hcloud_image" "serv_image" {
  with_selector     = var.server_image_selector
  with_architecture = var.server_architecture
  most_recent       = true
}

resource "hcloud_firewall" "serv_firewall" {
  count  = var.create_firewall ? 1 : 0
  name   = var.firewall_name
  labels = { service = "wireguard" }
  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }
  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "122"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }
  rule {
    description = "WireGuard"
    direction   = "in"
    protocol    = "udp"
    port        = "51820"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }
  rule {
    description = "WireGuard (alt)"
    direction   = "in"
    protocol    = "udp"
    port        = "53"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }
}

resource "hcloud_ssh_key" "serv_ssh_key" {
  count      = var.create_ssh_key ? 1 : 0
  public_key = var.ssh_publickey
  name       = var.ssh_publickey_name
}

resource "hcloud_server" "hetzner_server" {
  image        = data.hcloud_image.serv_image.id
  name         = var.server_name
  server_type  = var.server_type
  location     = var.server_location
  labels       = { service = "wireguard" }
  firewall_ids = var.create_firewall ? [hcloud_firewall.serv_firewall[0].id] : []
  ssh_keys = var.create_ssh_key ? [hcloud_ssh_key.serv_ssh_key[0].id] : var.existing_ssh_keys
  user_data    = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    users                   = var.users
    wg_server_wg_privatekey = var.server_wg_privatekey
    wg_server_wg_peers      = var.server_wg_peers
  })
}