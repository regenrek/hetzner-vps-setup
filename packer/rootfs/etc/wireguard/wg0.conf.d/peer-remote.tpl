# ${WG_PEER_COMMENT}
[Interface]
PrivateKey = ${WG_PEER_PRIVATE_KEY}
Address = 10.100.${WG_PEER_IPV4_SUFFIX}/32, fd10:100::${WG_PEER_IPV6_SUFFIX}/128

[Peer]
PublicKey = ${WG_OWN_PUBLIC_KEY}
PresharedKey = ${WG_PEER_PRESHARED_KEY}
AllowedIPs = 10.100.0.0/16, fd10:100::/112
Endpoint = ${WG_PEER_ENDPOINT}
