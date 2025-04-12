variable "proxmox_host_ip" {
  description = "Proxmox Host URL"
  type        = string
}

variable "proxmox_password" {
  description = "Proxmox root password"
  type        = string
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox node where VM will be created"
  type        = string
  default     = "proxmox-node"
}

variable "vm_name" {
  description = "Name of the Kubernetes master node"
  type        = list(string)
  default     = ["k3s-master", "k3s-worker-1", "k3s-worker-2"]
}

variable "vm_template" {
  description = "Proxmox VM template to clone"
  type        = string
  default     = "ubuntu-template"
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "ram_size" {
  description = "Amount of RAM in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "Size of the VM disk in GB"
  type        = string
  default     = "10G"
}

variable "storage" {
  description = "Proxmox storage type"
  type        = string
  default     = "local-lvm"
}

variable "ip_addresses" {
  type    = list(string)
  default = ["192.168.1.2", "192.168.1.3", "192.168.1.4"]
}

variable "gateway" {
  type    = string
  default = "192.168.1.1"
}

variable "cloud_init_password" {
  type      = string
  sensitive = true
}