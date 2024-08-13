#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

# Source configuration file (if it exists)
[ -f configs/setup.conf ] && source configs/setup.conf

# Define script directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Source other scripts
source "$SCRIPT_DIR/scripts/startup.sh"
source "$SCRIPT_DIR/scripts/0-preinstall.sh"
source "$SCRIPT_DIR/scripts/1-setup.sh"
source "$SCRIPT_DIR/scripts/3-post-setup.sh"

# Reboot after installation
echo "Installation complete. Rebooting..."
reboot
