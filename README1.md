# 🚀 Rocky Linux 10 Cloud-Init Template for Proxmox

This repository provides a ready-to-use **Rocky Linux 10 Cloud-Init image** for Proxmox VE.
It automates everything — downloading the official image, creating a VM, attaching the disk, and enabling Cloud-Init.

---

## 📦 Features

* ✅ Downloads the latest **Rocky Linux 10 Generic Cloud Image**
* ✅ Creates a Proxmox VM with Cloud-Init support
* ✅ Sets up boot configuration & serial console
* ✅ Converts VM to a reusable template

---

## ⚡ Quick Start

### 1️⃣ Clone this repo on your Proxmox node

```bash
git clone https://github.com/Shibnath27/rocky10-proxmox-cloudinit.git
cd rocky10-proxmox-cloudinit
```

### 2️⃣ Run the setup script

```bash
chmod +x setup.sh
./setup.sh
```

This will:

* Download the Rocky 10 cloud image
* Create a Proxmox VM (default **VMID=9000**)
* Import the disk into your storage
* Add Cloud-Init drive
* Convert VM into a template

---

## ⚙️ Usage

Once the template is created, you can **clone new VMs**:

```bash
qm clone 9000 101 --name rocky10-test --full
qm set 101 --sshkey ~/.ssh/id_rsa.pub --ciuser rocky --cipassword mypassword
qm start 101
```

---

## 🛠️ Configuration

You can edit `setup.sh` to customize:

| Variable  | Description                            | Default             |
| --------- | -------------------------------------- | ------------------- |
| `VMID`    | Template VMID                          | `9000`              |
| `VMNAME`  | Template name                          | `rocky10-cloudinit` |
| `STORAGE` | Proxmox storage (local/local-lvm/Data) | `Data`              |
| `MEMORY`  | RAM in MB                              | `2048`              |
| `CORES`   | CPU cores                              | `2`                 |
| `BRIDGE`  | Network bridge                         | `vmbr0`             |

---

## ✅ Requirements

* Proxmox VE 7.x or 8.x
* Internet access to download Rocky Linux image
* At least 2GB RAM and \~10GB disk space

---

## 📜 License

MIT License © 2025 Shibnath Das

---

