#!/bin/bash

# ... (Header remains the same) ...

echo -ne "
-------------------------------------------------------------------------
                    Automated Fedora Linux Installer (Minimal)
-------------------------------------------------------------------------
"

# Load configuration
source $CONFIGS_DIR/setup.conf

# --- Disk Selection ---
echo -ne "
------------------------------------------------------------------------
    THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK
    Please make sure you know what you are doing because
    after formatting your disk, there is no way to get data back
------------------------------------------------------------------------
"
PS3='
Select the disk to install on: '
options=($(lsblk -n --output TYPE,KNAME,SIZE | awk '\$1=="disk"{print "/dev/"\$2"|"\$3}'))
select opt in "${options[@]}" "Quit"; do
    case $opt in
        Quit) exit 0 ;;
        *)
            DISK=${opt%|*}
            echo -e "\n${DISK} selected\n"
            set_option DISK ${DISK}
            break
            ;;
    esac
done

# --- Partitioning ---
echo -ne "
-------------------------------------------------------------------------
                    Partitioning Disk
-------------------------------------------------------------------------
"
# Use parted for partitioning
parted -s ${DISK} -- mklabel gpt
parted -s ${DISK} -- mkpart EFI fat32 1MiB 101MiB  # 100 MB EFI
parted -s ${DISK} -- set 1 boot on
parted -s ${DISK} -- mkpart primary ext4 101MiB 5243MiB # 5 GB root
parted -s ${DISK} -- mkpart primary ext4 5243MiB 7268MiB # 2 GB home
parted -s ${DISK} -- mkpart primary ext4 7268MiB 10291MiB # 3 GB VM
parted -s ${DISK} -- mkpart primary ext4 10291MiB 100% # rest for data


# --- Formatting Partitions ---
echo -ne "
-------------------------------------------------------------------------
                    Formatting Partitions
-------------------------------------------------------------------------
"
mkfs.fat -F32 ${DISK}1
mkfs.ext4 ${DISK}2
mkfs.ext4 ${DISK}3
mkfs.ext4 ${DISK}4
mkfs.ext4 ${DISK}5

# --- Mounting Partitions ---
echo -ne "
-------------------------------------------------------------------------
                    Mounting Partitions
-------------------------------------------------------------------------
"
mount ${DISK}3 /mnt
mkdir -p /mnt/boot
mount ${DISK}2 /mnt/boot
mkdir -p /mnt/boot/efi
mount ${DISK}1 /mnt/boot/efi
mkdir -p /mnt/home
mount ${DISK}4 /mnt/home
mkdir -p /mnt/vms 
mount ${DISK}5 /mnt/vms 

# --- Fedora Installation ---
echo -ne "
-------------------------------------------------------------------------
                    Installing Fedora (Minimal)
-------------------------------------------------------------------------
"
# Install Fedora using dnf groupinstall
dnf install -y @core --installroot=/mnt --releasever=38 --setopt=install_weak_deps=False --exclude=PackageKit-glib
dnf install -y @standard --installroot=/mnt --releasever=38 --setopt=install_weak_deps=False --exclude=PackageKit-glib

# --- Generate fstab ---
genfstab -U /mnt >> /mnt/etc/fstab

# --- Chroot into the new system ---
arch-chroot /mnt <<EOF

# ... (Continue with basic system configuration in 1-setup.sh) ...

EOF

# ... (Unmount partitions and reboot in fedorahul.sh) ...
