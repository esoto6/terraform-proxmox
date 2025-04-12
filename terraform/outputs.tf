output "vm_ids" {
  description = "IDs of all created VMs"
  value       = [for i in proxmox_vm_qemu.k3s_node : i.id]
}

output "vm_ips" {
  description = "IP addresses of all created VMs"
  value       = [for i in proxmox_vm_qemu.k3s_node : i.default_ipv4_address]
}

output "k3s_master_ip" {
  description = "IP address of the K3s master node"
  value       = proxmox_vm_qemu.k3s_node[0].default_ipv4_address
}

output "k3s_worker_ips" {
  description = "IP addresses of K3s worker nodes"
  value       = slice([for i in proxmox_vm_qemu.k3s_node : i.default_ipv4_address], 1, length(proxmox_vm_qemu.k3s_node))
}
