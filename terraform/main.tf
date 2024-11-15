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
  with_selector     = "service=${var.service_label}"
  with_architecture = var.server_architecture
  most_recent       = true
}

resource "hcloud_firewall" "serv_firewall" {
  name   = var.firewall_name
  labels = { service = var.service_label }

  # Allow ICMP for basic connectivity testing
  rule {
    description = "ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }

  # Allow SSH from anywhere
  rule {
    description = "SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "122"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }

  # Allow Coolify UI and API ports
  rule {
    description = "Coolify UI"
    direction   = "in"
    protocol    = "tcp"
    port        = "6001"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }

  rule {
    description = "Coolify API"
    direction   = "in"
    protocol    = "tcp"
    port        = "6002"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }

  rule {
    description = "Coolify Apps"
    direction   = "in"
    protocol    = "tcp"
    port        = "8000"
    source_ips  = ["0.0.0.0/0", "::0/0"]
  }

  # Keep your existing WireGuard rules
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
  public_key = var.ssh_publickey
  name       = var.ssh_publickey_name
}

resource "hcloud_server" "hetznerserver" {
  image       = data.hcloud_image.serv_image.id
  name        = var.server_name
  server_type = var.server_type
  location    = var.server_location
  labels      = { service = var.service_label }
  user_data = templatefile("${path.module}/templates/cloud-init.yaml.tftpl", {
    server_wg_privatekey = var.server_wg_privatekey
    server_wg_peers      = var.server_wg_peers
    ssh_publickey        = var.ssh_publickey
  })
}
