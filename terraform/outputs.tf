output "wg_server_ipv4_address" {
  value       = hcloud_server.hetznerserver.ipv4_address
  description = "IPv4 address"
}

output "wg_server_ipv6_address" {
  value       = hcloud_server.hetznerserver.ipv6_address
  description = "IPv6 address"
}
