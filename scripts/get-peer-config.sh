#!/bin/bash
peer_number="$1"
if [ -z "$peer_number" ]; then
    echo "Usage: $0 <peer_number>"
    exit 1
fi

cd terraform/
terraform output -raw "wireguard_peer_configs.peer_${peer_number}" > "wg-peer-${peer_number}.conf"
echo "Configuration saved to wg-peer-${peer_number}.conf" 