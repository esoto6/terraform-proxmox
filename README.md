# terraform-proxmox

Project used to manage the creation of virtual machines on my proxmox host. 


## Proxmox Notes:

### Create cloud-init template

Instructions on creating a template can be found in the documentation located [here](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started#creating-a-cloud-init-template).


### SSH key for Proxmox


On your local machine create the private / public key for SSH
```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_proxmox -N ""
```

Utilizing this key create a ~/.ssh/config file.

```sh
Host master
	Hostname 192.x.x.x
	User ansibleuser
	IdentityFile ~/.ssh/id_rsa_proxmox
Host worker1
	Hostname 192.x.x.x
	User ansibleuser
	IdentityFile ~/.ssh/id_rsa_proxmox
Host worker2
	Hostname 192.x.x.x
	User ansibleuser
	IdentityFile ~/.ssh/id_rsa_proxmox
```

Once you initialize in a later step you can now use simple commands like

```sh
ssh master
```

### Create a script snippet to be used for the cloud-init

>[!IMPORTANT]
> Creating a snippet is very important in this step as the template will not work with out having `qemu-guest-agent`
>

### Create ubuntu.yaml

```sh
cd /var/lib/vz/snippets
touch ubuntu.yaml
```

## ubuntu.yml contents
Update content with either vim or nano with the below content.

```sh
#cloud-config
runcmd:
  - apt update
  - apt install -y qemu-guest-agent
  - systemctl start qemu-guest-agent
  - systemctl enable ssh
  - reboot
```

## Terraform Notes:

### Configure Variables

1. Create file `terraform.tfvars`

```
proxmox_host_ip        = "192.168.1.5"
proxmox_password       = "password"
proxmox_node           = "yourNode"
cloud_init_password    = "initPassword"
vm_name = ["k3s-master", "k3s-worker-1", "k3s-worker-2"]
vm_template = "ubuntu-template"
cpu_cores = 1
ram_size = 2048
disk_size = "25G"
ip_addresses = ["192.x.x.x", "192.x.x.x", "192.x.x.x"]
gateway = "192.x.x.x"
```

### Initialize, Plan and Apply



1. `terraform init`:
- Initializes terraform. As this is utilizing the provider `telmate/proxmox` it will begin downloading

2. `terraform plan`:
- This shows what actions terraform will apply before actually actioning.

3. `terraform apply`:
- This will require user interaction to run. If you want to auto confirm you can with the argument `-auto-approve`.


### Additional Terraform Commands
1. `terraform fmt`:
- Formats code for readability and consistency

2. `terraform verify`:
- Checks the syntax and consistency of configuration

3. `terraform destroy`:
- This will delete the infrastructure on proxmox.

4. `terraform output`:
- This will display the data outlines in the `outputs.tf` after VM creation.

