variable "hcloud_api_token" {
  type        = string
  description = "Hetzner Cloud API token"
  default     = "xxxx"
}

variable "server_type" {
  type        = string
  description = "Hetzner Cloud server type"
  default     = "cax11"
}

variable "location" {
  type        = string
  description = "Hetzner Cloud datacenter location"
  default     = "fsn1"
}

variable "image" {
  type        = string
  description = "Base image to use"
  default     = "ubuntu-24.04"
}

variable "server_name" {
  type        = string
  description = "Server name prefix"
  default     = "wireguard"
}