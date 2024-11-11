source "hcloud" "main" {
  token = var.hcloud_api_token

  image       = var.image
  server_name = "${var.server_name}-{{timestamp}}"
  server_type = var.server_type
  location    = var.location

  snapshot_name = "${var.server_name}-{{timestamp}}"
  snapshot_labels = {
    service = var.server_name
  }

  user_data_file = "./hetzner/seed/user-data"

  ssh_port                  = "22"
  ssh_username              = "root"
  ssh_timeout               = "30m"
  ssh_clear_authorized_keys = true
}