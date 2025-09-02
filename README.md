# 🚀 Rocky Linux 10 Cloud-Init Template for Proxmox

[![Proxmox](https://img.shields.io/badge/Proxmox-VE-blue?logo=proxmox)](https://www.proxmox.com)
[![Rocky Linux](https://img.shields.io/badge/Rocky%20Linux-10-green?logo=rockylinux)](https://rockylinux.org)
[![Cloud-Init](https://img.shields.io/badge/Cloud--Init-Automation-orange)](https://cloudinit.readthedocs.io)

This repository provides a simple guide to build a **Rocky Linux 10 Cloud-Init ready template** in Proxmox VE.  
With Cloud-Init enabled templates, you can quickly deploy VMs with automatic SSH keys, user data, and networking.

---

## 📋 Prerequisites

- Proxmox VE 7.x or 8.x
- Storage configured in Proxmox (example: `local-lvm` or `Data`)
- Internet access from Proxmox node
- A downloaded **Rocky Linux 10 Cloud image**

---

## ⚡ Steps

### 1️⃣ Download Rocky Linux 10 Cloud Image
```bash
cd /var/lib/vz/template/iso
wget https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud.latest.x86_64.qcow2
````

---

### 2️⃣ Create a New VM

```bash
qm create 9000 --name rocky10-cloudinit --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
```

---

### 3️⃣ Import Disk into Proxmox Storage

```bash
qm importdisk 9000 Rocky-10-GenericCloud.latest.x86_64.qcow2 Data
```

---

### 4️⃣ Attach Imported Disk

```bash
qm set 9000 --scsihw virtio-scsi-pci --scsi0 Data:vm-9000-disk-0
```

---

### 5️⃣ Add Cloud-Init Drive

```bash
qm set 9000 --ide2 Data:cloudinit
```

---

### 6️⃣ Configure Boot & Serial Console

```bash
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --serial0 socket --vga serial0
```

---

### 7️⃣ Convert to Template

```bash
qm template 9000
```

---

## 🚀 Usage

Now you can **deploy new Rocky Linux 10 VMs** from the template:

```bash
qm clone 9000 101 --name rocky10-test --full
qm set 101 --sshkey ~/.ssh/id_rsa.pub --ciuser rocky --cipassword mypassword
qm start 101
```

---

## 📂 Repo Structure

```
rocky10-proxmox-cloudinit/
 ├─ README.md       # This guide
 ├─ scripts/        # Optional helper scripts
 └─ docs/           # Documentation (if needed)
```

---

## 🤝 Contributing

Pull requests are welcome!
If you find issues or want to improve automation (like adding a full `setup.sh`), feel free to open a PR.

---

## 📜 License

MIT License – free to use and modify.

```

---

👉 Just copy this content into a file named `README.md` in your repo folder.  
After pushing to GitHub, your project will look **professional & ready-to-use** ✅  

Do you also want me to make a **`setup.sh` script** that automates all the `qm` steps (so users only run `bash setup.sh`)?
```
