[Interface]
PrivateKey = ${peer_private_key}
Address = ${peer_address}
DNS = ${dns_servers}

[Peer]
PublicKey = ${server_public_key}
PresharedKey = ${preshared_key}
AllowedIPs = ${allowed_ips}
Endpoint = ${server_endpoint}
PersistentKeepalive = 25 