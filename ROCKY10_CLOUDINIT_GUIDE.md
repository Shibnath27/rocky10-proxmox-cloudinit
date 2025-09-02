Here’s how you can set up cloud-init with Rocky Linux 10 in Proxmox, step by step, updated for the new version:
________________________________________
Step 1: Download the Rocky Linux 10 GenericCloud Image
Rocky Linux 10 offers cloud-ready images, perfect for automated deployment via cloud-init:
•	Look for files named like Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 or the dated equivalent (e.g., Rocky-10-GenericCloud-Base-10.0-20250609.1.x86_64.qcow2) (mirrors.aliyun.com).
•	These cloud images already include cloud-init.
For example, from a Chinese mirror (Aliyun CDN), you can grab:
wget https://mirrors.aliyun.com/rockylinux/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2
________________________________________
Step 2: Create and Import the VM into Proxmox
On your Proxmox host:
# Replace 9000 with your intended VMID
qm create 9000 --name rocky10-cloud --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0

# Import the downloaded qcow2 image to your storage (e.g., local-lvm)
qm importdisk 9000 Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 local-lvm

# Attach the imported disk as SCSI
qm set 9000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-9000-disk-0

# Add a CloudInit drive (IDE interface)
qm set 9000 --ide2 local-lvm:cloudinit

# Set the VM to boot from the cloud-init disk as default
qm set 9000 --boot c --bootdisk scsi0

# Enable serial console (useful for cloud images)
qm set 9000 --serial0 socket --vga serial0
________________________________________
Step 3: Configure Cloud-Init in the Proxmox GUI
Navigate to VM → Cloud-Init in the Proxmox web interface and set:
•	User: rocky (default for Rocky cloud images)
•	Password: choose a secure one—or leave blank if only using SSH keys
•	SSH Key: paste your ~/.ssh/id_rsa.pub or equivalent public key
•	IP Configuration: DHCP or manually set static IP (e.g., ip=192.168.1.50/24,gw=192.168.1.1)
•	DNS Server: e.g., 8.8.8.8
•	Click Regenerate Image to apply your configuration.
________________________________________
Step 4: Boot the VM and Validate Cloud-Init
•	Start the VM via the Proxmox GUI or qm start 9000.
•	Connect via console or SSH (using the rocky user, depending on your setup).
•	Confirm settings like hostname, network configuration, and SSH key were applied as intended. If ssh isn't accessible, check the serial console via Proxmox UI.
________________________________________
Step 5: Turn the VM into a Template for Future Deployments
Once everything boots and works properly:
qm template 9000
Now you can clone from this template any time:
qm clone 9000 100 --name rocky10-new --full
In the clone’s Cloud-Init tab, adjust hostname, IP, SSH key, etc., then boot—cloud-init will handle the rest automatically.
________________________________________
Summary Table
Task	Rocky Linux 10 Instructions
Download Image	Rocky-10-GenericCloud-Base.latest.x86_64.qcow2 (mirrors.aliyun.com)

Import & Setup VM	Use qm create, importdisk, attach disk & cloud-init drive
Cloud-Init Configuration	Set user, SSH key, IP settings via Proxmox GUI
Validation	Boot VM, ensure settings are applied properly
Template Creation	qm template 9000, then clone for fast future deployments
________________________________________
Extra Notes
•	Rocky Linux 10 images are supported until May 2035 (Wikipedia).
•	Ensure you choose the correct image variant (Base vs LVM) depending on your storage preferences.
•	You can edit cloud.cfg inside the image using tools like virt-edit or virt-customize if you want to default-disable root, tweak users, or change modules before templating (similar to Rocky 9 guidance) (Toad39, sysblob.com).
________________________________________

