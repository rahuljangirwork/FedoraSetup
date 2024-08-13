#!/bin/bash
# ... (Header remains the same) ...

source $HOME/FedoraRahul/configs/setup.conf

# --- Timezone ---
timedatectl set-timezone "${TIMEZONE}"

# --- Keyboard Layout ---
localectl set-x11-keymap "${KEYMAP}"

# --- Network Configuration ---
# (Assumes NetworkManager is used)
systemctl enable --now NetworkManager
nmcli connection modify 'Wired connection 1' ipv4.method auto
nmcli connection modify 'Wired connection 1' ipv6.method auto
nmcli connection up 'Wired connection 1'

# --- Disable Root Login ---
# (Modify as needed based on your security preferences)
sed -i 's/^\(PermitRootLogin\)\s*.*/\1 no/' /etc/ssh/sshd_config
systemctl restart sshd

# --- Set Hostname ---
hostnamectl set-hostname "${NAME_OF_MACHINE}"

# --- Add User ---
useradd -m -G wheel -s /bin/bash "${USERNAME}"
echo "${USERNAME}:${PASSWORD}" | chpasswd
# You can set a user's default shell to zsh here if you installed it
# chsh -s /bin/zsh $USERNAME 

# --- Install Essential Packages (Minimal) ---
dnf -y install sudo vim bash-completion wget curl git nano 

# ... (Virtual machine setup will be handled later) ...
