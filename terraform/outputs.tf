output "wg_server_ipv4_address" {
  value       = hcloud_server.hetzner_server.ipv4_address
  description = "IPv4 address"
}

output "wg_server_ipv6_address" {
  value       = hcloud_server.hetzner_server.ipv6_address
  description = "IPv6 address"
}

output "wireguard_peer_configs" {
  description = "WireGuard configuration for each peer"
  value = {
    for idx, peer in var.server_wg_peers : "peer_${idx}" => templatefile("${path.module}/templates/wireguard-peer.tpl", {
      peer_private_key  = peer.privatekey
      peer_address      = "10.0.0.${idx + 2}/32"
      dns_servers       = "1.1.1.1, 1.0.0.1"
      server_public_key = var.server_wg_publickey
      preshared_key    = peer.presharedkey
      allowed_ips      = "0.0.0.0/0, ::/0"
      server_endpoint  = "${hcloud_server.vpn_server.ipv4_address}:51820"
    })
  }
  sensitive = true
} 