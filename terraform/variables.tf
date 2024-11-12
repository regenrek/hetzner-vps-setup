variable "hcloud_api_token" {
  type        = string
  description = "Hetzner Cloud API token"
  default     = ""
}

variable "server_name" {
  type        = string
  description = "Server name"
  default     = "spiderman"
}

variable "server_type" {
  type        = string
  description = "Server type"
  default     = "cx42"
}

variable "server_location" {
  type        = string
  description = "Server location"
  default     = "fsn1"
}

variable "server_wg_privatekey" {
  type        = string
  description = "WireGuard private key"
  default     = ""
}

variable "firewall_name" {
  type        = string
  description = "Firewall name"
  default     = "spiderman-firewall"
}

variable "ssh_publickey" {
  type        = string
  description = "SSH public key"
}

variable "ssh_publickey_name" {
  type        = string
  description = "SSH public key name"
}

variable "server_architecture" {
  type        = string
  description = "Server architecture (arm or x86)"
  default     = "x86"
}

variable "service_label" {
  description = "Service label for the server"
  type        = string
  default     = "spiderman" # You can set a default value if desired
}

variable "server_wg_peers" {
  type = list(object({
    comment      = optional(string, "")
    publickey    = string
    presharedkey = string
  }))
  description = "WireGuard peers"
  default     = []
}
