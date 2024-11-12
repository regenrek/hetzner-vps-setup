variable "hcloud_api_token" {
  type        = string
  description = "Hetzner Cloud API token"
  default     = "xxxx"
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

variable "server_wg_peers" {
  description = "List of WireGuard peer configurations"
  type = list(object({
    publickey    = string
    privatekey   = string
    presharedkey = string
  }))
}

variable "firewall_name" {
  type        = string
  description = "Firewall name"
  default     = "spiderman-firewall"
}

variable "create_firewall" {
  description = "Whether to create the firewall"
  type        = bool
  default     = true
}

variable "create_ssh_key" {
  description = "Whether to create a new SSH key"
  type        = bool
  default     = true
}

variable "existing_ssh_keys" {
  description = "List of existing SSH key IDs to use when create_ssh_key is false"
  type        = list(string)
  default     = []
}

variable "ssh_publickey" {
  type        = string
  description = "SSH public key"
}

variable "ssh_publickey_name" {
  type        = string
  description = "SSH public key name"
}

variable "users" {
  description = "List of users to create on the instances"
  type = list(object({
    name                = string
    sudo                = bool
    shell              = string
    groups             = list(string)
    ssh_authorized_keys = list(string)
  }))
}

variable "server_architecture" {
  type        = string
  description = "Server architecture (arm or x86)"
  default     = "x86"
}

variable "server_image_selector" {
  type        = string
  description = "Label selector for the server image"
  default     = "service=spiderman"
}
