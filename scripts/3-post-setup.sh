#!/bin/bash
# ... (Header remains the same) ...

source ${HOME}/FedoraRahul/configs/setup.conf

# --- GRUB2 Configuration ---
grub2-install ${DISK}
grub2-mkconfig -o /boot/grub2/grub.cfg

# --- Virtual Machine Setup (Windows with Passthrough) ---
echo -ne "
-------------------------------------------------------------------------
                    Setting Up Virtual Machine
-------------------------------------------------------------------------
"
# Install KVM and related packages
dnf install -y qemu-kvm qemu-img virt-manager libvirt  bridge-utils

# Add your user to the libvirt group
usermod -a -G libvirt $USERNAME 

# Configure libvirt to start on boot
systemctl enable --now libvirtd

# Configure a bridge network interface (for network passthrough)
# (You'll need to customize the bridge interface name and network settings)
echo -e "
# Virtual machine bridge
auto br0
iface br0 inet dhcp
    bridge_ports eth0
    bridge_stp off
    bridge_fd 0
    bridge_maxwait 0
" > /etc/network/interfaces.d/br0.cfg

# Start or restart networking
systemctl restart networking

# --- USB Passthrough ---
# You'll need to identify the Vendor ID and Product ID of your USB devices
# and create udev rules to allow passthrough. 
# Example:
# echo 'SUBSYSTEM=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", GROUP="libvirt", MODE="0660"' > /etc/udev/rules.d/70-usb-passthrough.rules

# --- CPU Passthrough (Advanced) ---
# This requires careful BIOS configuration and additional steps. 
# Refer to the Fedora documentation and resources on CPU passthrough.

# ... (Clean up temporary files and scripts) ...
