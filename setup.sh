#!/bin/bash
# 🚀 Rocky Linux 10 Cloud-Init Template Setup for Proxmox
# Author: Shibnath Das
# GitHub: https://github.com/Shibnath27/rocky10-proxmox-cloudinit

set -e

# ==============================
# CONFIGURATION (edit as needed)
# ==============================
VMID=9000
VMNAME="rocky10-cloudinit"
STORAGE="Data"        # Change to your storage (e.g. local-lvm, local, Data)
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
IMAGE_URL="https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud.latest.x86_64.qcow2"
IMAGE_NAME="Rocky-10-GenericCloud.latest.x86_64.qcow2"

# ==============================
# SCRIPT START
# ==============================
echo ">>> Downloading Rocky Linux 10 cloud image..."
cd /var/lib/vz/template/iso
if [ ! -f "$IMAGE_NAME" ]; then
    wget -O "$IMAGE_NAME" "$IMAGE_URL"
else
    echo "Image already exists, skipping download."
fi

echo ">>> Creating VM $VMID ($VMNAME)..."
qm create $VMID --name $VMNAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

echo ">>> Importing disk into Proxmox storage ($STORAGE)..."
qm importdisk $VMID $IMAGE_NAME $STORAGE

echo ">>> Attaching disk..."
qm set $VMID --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${VMID}-disk-0

echo ">>> Adding Cloud-Init drive..."
qm set $VMID --ide2 ${STORAGE}:cloudinit

echo ">>> Configuring boot options..."
qm set $VMID --boot c --bootdisk scsi0
qm set $VMID --serial0 socket --vga serial0

echo ">>> Converting VM to template..."
qm template $VMID

echo "✅ Rocky Linux 10 Cloud-Init template is ready! (VMID: $VMID)"
echo ">>> You can now clone it using:"
echo "    qm clone $VMID 101 --name rocky10-test --full"
