terraform {
  required_providers {

    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://${var.proxmox_host_ip}:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "k3s_node" {
  count  = length(var.vm_name)
  vmid   = 200 + count.index
  name   = var.vm_name[count.index]
  agent  = 1
  cores  = var.cpu_cores
  memory = var.ram_size
  boot   = "order=scsi0"
  tags   = "K3s"

  target_node      = var.proxmox_node
  clone            = var.vm_template
  scsihw           = "virtio-scsi-single"
  vm_state         = "running"
  automatic_reboot = true

  cicustom   = "vendor=local:snippets/ubuntu.yaml"
  ciupgrade  = true
  ciuser     = "ansibleuser"
  cipassword = var.cloud_init_password

  os_type   = "cloud-init"
  ipconfig0 = "ip=${var.ip_addresses[count.index]}/24,gw=${var.gateway}"
  sshkeys   = file("~/.ssh/id_rsa_proxmox.pub")

  serial {
    id = 0
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  disks {
    scsi {
      scsi0 {
        disk {
          storage = var.storage
          size    = var.disk_size
        }
      }
    }
    ide {
      ide1 {
        cloudinit {
          storage = var.storage
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [network, disk]
  }
}